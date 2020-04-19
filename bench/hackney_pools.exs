# Esse teste força 200 requisições com concorrência variando entre 50 e 150

# Se a concorrencia for limitada até 50 (default da hackney), usar ou não usar pools diferentes
# não deveria fazer diferença

# Se a concorrência for mais que 50, usar pools diferentes deve
# trazer bons ganhos no tempo throughput

defmodule TeslaClient do
  use Tesla, docs: false, only: [:get]
  adapter(Tesla.Adapter.Hackney)
end

urls_with_pool =
  [
    Enum.map(1..50, fn _ -> {"http://localhost:8000", :pool_1} end),
    Enum.map(1..50, fn _ -> {"http://localhost:8000", :pool_2} end),
    Enum.map(1..50, fn _ -> {"http://localhost:8000", :pool_3} end)
  ]
  |> List.flatten()

benchee_opts = [
  inputs: %{
    "concurrency 50" => {urls_with_pool, 50},
    "concurrency 75" => {urls_with_pool, 75},
    "concurrency 100" => {urls_with_pool, 100},
    "concurrency 125" => {urls_with_pool, 125},
    "concurrency 150" => {urls_with_pool, 150}
  },
  warmup: 5,
  time: 10,
  before_each: fn input ->
    # Dando uma folga pro HTTP Server
    Process.sleep(5_000)
    input
  end,
  after_each: fn result ->
    # Dando uma folga pro HTTP Server
    Process.sleep(5_000)
    result
  end
]

:ok = Application.ensure_started(:hackney)
:ok = :hackney_pool.start_pool(:pool_1, timeout: 90_000, max_connections: 100)
:ok = :hackney_pool.start_pool(:pool_2, timeout: 90_000, max_connections: 100)
:ok = :hackney_pool.start_pool(:pool_3, timeout: 90_000, max_connections: 100)

HTTPoison.start()

Benchee.run(
  %{
    "default_pool" => fn {urls_with_pool, concurrency} ->
      urls_with_pool
      |> Task.async_stream(
        fn {url, _pool} ->
          HTTPoison.get!(url, [])
        end,
        timeout: 30_000,
        max_concurrency: concurrency
      )
      |> Stream.run()
    end,
    "httpoison_custom_pool" => fn {urls_with_pool, concurrency} ->
      urls_with_pool
      |> Task.async_stream(
        fn {url, pool} ->
          HTTPoison.get!(url, [], hackney: [pool: pool])
        end,
        timeout: 30_000,
        max_concurrency: concurrency
      )
      |> Stream.run()
    end,
    "httpoison_default_pool" => fn {urls_with_pool, concurrency} ->
      urls_with_pool
      |> Task.async_stream(
        fn {url, _pool} ->
          HTTPoison.get!(url, [], hackney: [pool: :default])
        end,
        timeout: 30_000,
        max_concurrency: concurrency
      )
      |> Stream.run()
    end,
    "tesla_custom_pool" => fn {urls_with_pool, concurrency} ->
      urls_with_pool
      |> Task.async_stream(
        fn {url, pool} ->
          TeslaClient.get!(url, opts: [adapter: [pool: pool]])
        end,
        timeout: 30_000,
        max_concurrency: concurrency
      )
      |> Stream.run()
    end,
    "tesla_default_pool" => fn {urls_with_pool, concurrency} ->
      urls_with_pool
      |> Task.async_stream(
        fn {url, _pool} ->
          TeslaClient.get!(url, opts: [adapter: [pool: :default]])
        end,
        timeout: 30_000,
        max_concurrency: concurrency
      )
      |> Stream.run()
    end
  },
  benchee_opts
)

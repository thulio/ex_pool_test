# ExPoolTest

Repo com teste de performance ao usar múltiplos pools de conexões na lib `hackney`


### Testando

```shell
# Terminal 1

cd pool-test

poetry install

poetry run uvicorn pool_test.app:app --no-access-log
```

```shell
# Terminal 2

mix do deps.get, compile

mix run bench/hackney_pools.exs
```

Exemplo de output:

```shell
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-4750HQ CPU @ 2.00GHz
Number of Available Cores: 8
Available memory: 8 GB
Elixir 1.10.2
Erlang 22.2.6

Benchmark suite executing with the following configuration:
warmup: 5 s
time: 10 s
memory time: 0 ns
parallel: 1
inputs: concurrency 100, concurrency 125, concurrency 150, concurrency 50, concurrency 75
Estimated total run time: 6.25 min

Benchmarking default_pool with input concurrency 100...
Benchmarking default_pool with input concurrency 125...
Benchmarking default_pool with input concurrency 150...
Benchmarking default_pool with input concurrency 50...
Benchmarking default_pool with input concurrency 75...
Benchmarking httpoison_custom_pool with input concurrency 100...
Benchmarking httpoison_custom_pool with input concurrency 125...
Benchmarking httpoison_custom_pool with input concurrency 150...
Benchmarking httpoison_custom_pool with input concurrency 50...
Benchmarking httpoison_custom_pool with input concurrency 75...
Benchmarking httpoison_default_pool with input concurrency 100...
Benchmarking httpoison_default_pool with input concurrency 125...
Benchmarking httpoison_default_pool with input concurrency 150...
Benchmarking httpoison_default_pool with input concurrency 50...
Benchmarking httpoison_default_pool with input concurrency 75...
Benchmarking tesla_custom_pool with input concurrency 100...
Benchmarking tesla_custom_pool with input concurrency 125...
Benchmarking tesla_custom_pool with input concurrency 150...
Benchmarking tesla_custom_pool with input concurrency 50...
Benchmarking tesla_custom_pool with input concurrency 75...
Benchmarking tesla_default_pool with input concurrency 100...
Benchmarking tesla_default_pool with input concurrency 125...
Benchmarking tesla_default_pool with input concurrency 150...
Benchmarking tesla_default_pool with input concurrency 50...
Benchmarking tesla_default_pool with input concurrency 75...

##### With input concurrency 100 #####
Name                             ips        average  deviation         median         99th %
tesla_custom_pool               7.20      138.98 ms     ±0.00%      138.98 ms      138.98 ms
httpoison_custom_pool           7.03      142.25 ms     ±0.00%      142.25 ms      142.25 ms
httpoison_default_pool          5.54      180.65 ms     ±0.00%      180.65 ms      180.65 ms
default_pool                    5.39      185.65 ms     ±0.00%      185.65 ms      185.65 ms
tesla_default_pool              4.92      203.21 ms     ±0.00%      203.21 ms      203.21 ms

Comparison:
tesla_custom_pool               7.20
httpoison_custom_pool           7.03 - 1.02x slower +3.27 ms
httpoison_default_pool          5.54 - 1.30x slower +41.67 ms
default_pool                    5.39 - 1.34x slower +46.66 ms
tesla_default_pool              4.92 - 1.46x slower +64.23 ms

##### With input concurrency 125 #####
Name                             ips        average  deviation         median         99th %
httpoison_custom_pool           6.99      142.98 ms     ±0.00%      142.98 ms      142.98 ms
tesla_custom_pool               6.42      155.68 ms     ±0.00%      155.68 ms      155.68 ms
httpoison_default_pool          5.23      191.12 ms     ±0.00%      191.12 ms      191.12 ms
default_pool                    5.04      198.25 ms     ±0.00%      198.25 ms      198.25 ms
tesla_default_pool              4.65      215.22 ms     ±0.00%      215.22 ms      215.22 ms

Comparison:
httpoison_custom_pool           6.99
tesla_custom_pool               6.42 - 1.09x slower +12.69 ms
httpoison_default_pool          5.23 - 1.34x slower +48.14 ms
default_pool                    5.04 - 1.39x slower +55.27 ms
tesla_default_pool              4.65 - 1.51x slower +72.24 ms

##### With input concurrency 150 #####
Name                             ips        average  deviation         median         99th %
tesla_custom_pool              11.48       87.11 ms     ±0.00%       87.11 ms       87.11 ms
httpoison_custom_pool          11.25       88.87 ms     ±0.00%       88.87 ms       88.87 ms
httpoison_default_pool          5.41      184.98 ms     ±0.00%      184.98 ms      184.98 ms
default_pool                    5.30      188.85 ms     ±0.00%      188.85 ms      188.85 ms
tesla_default_pool              5.10      195.98 ms     ±0.00%      195.98 ms      195.98 ms

Comparison:
tesla_custom_pool              11.48
httpoison_custom_pool          11.25 - 1.02x slower +1.76 ms
httpoison_default_pool          5.41 - 2.12x slower +97.88 ms
default_pool                    5.30 - 2.17x slower +101.75 ms
tesla_default_pool              5.10 - 2.25x slower +108.87 ms

##### With input concurrency 50 #####
Name                             ips        average  deviation         median         99th %
default_pool                    5.45      183.58 ms     ±0.00%      183.58 ms      183.58 ms
httpoison_default_pool          5.40      185.12 ms     ±0.00%      185.12 ms      185.12 ms
httpoison_custom_pool           5.06      197.56 ms     ±0.00%      197.56 ms      197.56 ms
tesla_default_pool              4.74      210.92 ms     ±0.00%      210.92 ms      210.92 ms
tesla_custom_pool               4.70      212.96 ms     ±0.00%      212.96 ms      212.96 ms

Comparison:
default_pool                    5.45
httpoison_default_pool          5.40 - 1.01x slower +1.55 ms
httpoison_custom_pool           5.06 - 1.08x slower +13.98 ms
tesla_default_pool              4.74 - 1.15x slower +27.34 ms
tesla_custom_pool               4.70 - 1.16x slower +29.39 ms

##### With input concurrency 75 #####
Name                             ips        average  deviation         median         99th %
httpoison_custom_pool           6.88      145.33 ms     ±0.00%      145.33 ms      145.33 ms
tesla_custom_pool               6.83      146.31 ms     ±0.00%      146.31 ms      146.31 ms
default_pool                    5.54      180.44 ms     ±0.00%      180.44 ms      180.44 ms
httpoison_default_pool          5.47      182.78 ms     ±0.00%      182.78 ms      182.78 ms
tesla_default_pool              4.74      210.88 ms     ±0.00%      210.88 ms      210.88 ms

Comparison:
httpoison_custom_pool           6.88
tesla_custom_pool               6.83 - 1.01x slower +0.99 ms
default_pool                    5.54 - 1.24x slower +35.12 ms
httpoison_default_pool          5.47 - 1.26x slower +37.45 ms
tesla_default_pool              4.74 - 1.45x slower +65.56 ms
```

from asyncio import sleep

from fastapi import FastAPI

LATENCY = 50 / 1000

app = FastAPI()


@app.get("/")
async def index():
    # Simulando uma latência de 50ms
    await sleep(LATENCY)

    return dict(ok=True)

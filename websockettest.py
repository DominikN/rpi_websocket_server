#!/usr/bin/env python

# WS server example

import asyncio
import websockets
import json

from gpiozero import LED
from time import sleep

led = LED(16)

tx_msg = {"counter": 0, "button":0}

async def hello(websocket, path):
    cnt = 0
    while True:
        cnt = cnt + 1
        tx_msg["counter"] = cnt
        tx_msg["button"] = 1
        await websocket.send(json.dumps(tx_msg))
        print(tx_msg)
        await asyncio.sleep(1)
        led.toggle()

start_server = websockets.serve(hello, "myrpi", 8001)

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()

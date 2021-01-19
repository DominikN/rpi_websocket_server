#!/usr/bin/env python

import asyncio
import websockets
import json
import argparse

from gpiozero import LED
from gpiozero import Button

from time import sleep

parser = argparse.ArgumentParser()
parser.add_argument("button_nr", nargs='?', default=23, type=int, help="Button pin number")
parser.add_argument("led_nr", nargs='?', default=16, type=int, help="LED pin number")
args = parser.parse_args()

btn = Button(args.button_nr)
led = LED(args.led_nr)

event = asyncio.Event()
loop = asyncio.get_event_loop() 

def __execute_btn_changed():
    event.set()
    
def btn_changed(self):
    loop.call_soon_threadsafe(__execute_btn_changed)

async def rx_handler(websocket):
    async for rx_msg in websocket:
        print(rx_msg)
        rx_json = json.loads(rx_msg)
        
        if rx_json["led"] == 1:
            led.on()
        else:
            led.off()

async def tx_handler(websocket):
    tx_msg = {"counter": 0, "button":0}
    cnt = 0
    
    while True:
        await event.wait()
        event.clear()
        
        cnt = cnt + 1
        tx_msg["counter"] = cnt
        tx_msg["button"] = int(btn.is_pressed == True)
        print(tx_msg)
        await websocket.send(json.dumps(tx_msg))

async def ws_handler(websocket, path):
    rx_task = asyncio.ensure_future(rx_handler(websocket))
    tx_task = asyncio.ensure_future(tx_handler(websocket))
    
    done, pending = await asyncio.wait(
        [rx_task, tx_task],
        return_when=asyncio.FIRST_COMPLETED,
    )

    for task in pending:
        task.cancel()


btn.when_pressed = btn_changed
btn.when_released = btn_changed

start_server = websockets.serve(ws_handler, port=8001)

loop.run_until_complete(start_server)
loop.run_forever()

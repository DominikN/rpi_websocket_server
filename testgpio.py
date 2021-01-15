from gpiozero import LED
from gpiozero import Button

from time import sleep

btn = Button(23)
led = LED(16)

while True:
    print ("GPIO : %d" % int(btn.is_pressed == True))
    if btn.is_pressed == True:
        led.on()
    else:
        led.off()
    sleep( 0.1 )
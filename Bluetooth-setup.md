![](https://images-na.ssl-images-amazon.com/images/I/71D9in9pJZL._SL1398_.jpg)
To extend your USB lifetime or to be cool on the field, you may want to whip up your phone and connect via bluetooth to your Flight Controller. This guide is for you.
# Equipment
* Flight Controller with a 3V3 pin and one free UART. 
* (https://www.amazon.com/gp/product/B07BRM9752/ref=oh_aui_search_asin_title?ie=UTF8&psc=1)[Bluetooth chips, 2 pieces for $8] this module is great because it's already setup optimally, baudrate at 115200 and needs no FTDI to send AT code at.
The manual for this module is (https://fccid.io/2AM2YJDY-08/User-Manual/User-Manual-3511895)[here] 
# Procedure
Determine TX and RX of a free UART on your FC 
Connect pin 03 (TX) of the module to RX on your FC
Connect pin 02 (RX) of the module to TX of your FC
Connect VCC to a 3V3 pin on your FC
Connect GND to any ground on your FC
In iNav configurator set the free UART that you connected the bluetooth module to as MSP, baudrate 115200
Save and reboot.
Now you can connect to your flight controller with the excellent Speedybee app.
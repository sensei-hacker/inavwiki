# Introduction

You install an RC Receiver (Rx) into your aircraft in order to receive radio control (RC) commands from your RC Transmitter where the Rx then sends them to your flight controller over a wire connection to a Serial UART Port using a particular protocol. This guide assumes you have [connected your Rx to a Serial UART Port on your flight controller and have set the correct port on the ports tab](https://github.com/iNavFlight/inav/wiki/Ports-Tab).

**Binding**

Before you can know if you have configured INAV to talk to your Rx, you need to be sure your Rx has a bind to your RC transmitter. There may be a blinking light pattern or some way as outlined by the documentation of your radio to know that the two have a bind and are talking to each other.

## Receiver Mode
This is where you tell the FC what type of Rx you have and what protocol it speaks.

**Receiver Type**
- Serial Receivers - your Rx is 99% likely to be a serial receiver. These can be TBS Crossfire / Tracer, ExpressLRS, Ghost, FrSky, Spektrum, FlySky, etc.
- _MSP RX (very rare)_
- _SIM SITL (for computer simulator use only)_
- _PPM Receivers (obsolete INAV 3.x and below)_

*Warning: Do not connect an Rx to a Soft Serial Ports as these ports often drop data which can cause unintentional failsafes and other unexpected behaviors.*

**Serial Receiver Provider** (Receiver Protocol)
- **CRSF:** TBS Crossfire / Tracer, ExpressLRS (all frequencies) | ?? Channel Limit
- **FBUS:**
- **FPORT2:** FrSky | 16 channels | RC Control and Telemetry over one-wire connected to a TX UART
- **GHST:** 
- **IBUS:** FlySky | 10 channels 
- **JETIEXBUS:**
- **MAVLINK:** 
- **SBUS:** FrSky, Futaba, ExpressLRS (all frequencies) | 16 channels | See SBUS labeled pad on your FC (an inverted RX UART)
- **SBUS_FAST:** 
- **SPEK1024:** Spektrum** Spektrum DSM
- **SPEK2048:** Spektrum** Spektrum DSM2 / DSMX
- **SRXL2:** Spektrum** Spektrum | newer Spektrum protocol
- **SUMD:** Graupner | 16 channels 

*Depending on the receiver specs, protocol used, radio limits, etc. there may be a limited number of channels available for your use.*

*Some Rx can be configured to export a talk a protocol or use different protocol options. This is not common. The extreme case is where ExpressLRS Rx can talk many protocols with many options such as CRSF, inverted CRSF, SBUS, inverted SBUS, etc. Some old FrSKY receivers can be changed by flashing a different firmware while the ACCESS Rx can be either SBUS and FPort in the transmitter model setup page.* 

*IBUS RX and IBUS telemetry can be configured to both be on the same Serial UART - see [Telemetry.md](https://github.com/iNavFlight/inav/blob/master/docs/Telemetry.md)*

*SRXL2 provides both RC control and telemetry over a two-wire connection to UART but requires [special cli settings](https://github.com/iNavFlight/inav/blob/master/docs/Rx.md#configuration-1).*

### RC Smoothing

### Channel Map

After configuring channel ranges use the sub-trim on your transmitter to set the middle point of pitch, roll, yaw and throttle.


### Advanced: RxRange
INAV expects your transmitter/receiver to send RC values (called end-points) with a range of 1000-2000. But some transmitters/receivers have a non-standard end-points (i.e. 1070-1930 as some Spektrum receivers) which can be a problem in INAV. To adjust for this, go into your transmitter settings and try to set the output end-points as close as you can to 1000-2000. If you still can't get end-points to 1000-2000 then you can go to the cli and use the command rxrange to map your non-standard range to the standard 1000-2000 in INAV.
1. If you used rxrange in the past, reset it by entering the following command into the CLI:
```
rxrange reset
save
```
2. Reconnect INAV Configurator, go to the `Receiver` tab, move one stick at a time on your transmitter to the min and max values (first 4 channels) and write these values down. *Always take care to avoid accidentally arming your craft*. Go to CLI and set the min and max values with the following cli command `rxrange <channel_number> <min> <max>` and note that Channel 1 is 0 in the cli, and 2 is 1, and 3 is 2, and 4 is 3. Here is an example.
```
rxrange 0 1070 1930
rxrange 1 1070 1930
rxrange 2 1070 1930
rxrange 3 1070 1930
save
```
You can also use rxrange to reverse the direction of an input channel, e.g. `rxrange 0 2000 1000`. But be sure to know what you are doing whenever usinf the cli.


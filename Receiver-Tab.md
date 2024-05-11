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





### RX signal-loss detection

The software has signal loss detection which is always enabled.  Signal loss detection is used for safety and failsafe reasons.

The `rx_min_usec` and `rx_max_usec` settings helps detect when your RX stops sending any data, enters failsafe mode or when the RX loses signal.

By default, when the signal loss is detected the FC will set pitch/roll/yaw to the value configured for `mid_rc`. The throttle will be set to the value configured for `rx_min_usec` or `mid_rc` if using 3D feature.

Signal loss can be detected when:

1. no rx data is received (due to radio reception, recevier configuration or cabling issues).
2. using Serial RX and receiver indicates failsafe condition.
3. using any of the first 4 stick channels do not have a value in the range specified by `rx_min_usec` and `rx_max_usec`.

#### `rx_min_usec`

The lowest channel value considered valid.  e.g. PWM/PPM pulse length

#### `rx_max_usec`

The highest channel value considered valid.  e.g. PWM/PPM pulse length

### Serial RX

See the Serial chapter for some some RX configuration examples.

To setup spectrum in the GUI:
1. Start on the "Ports" tab make sure that teh required has serial RX.  If not set the checkbox, save and reboot.
2. Move to the "Configuration" page and in the upper lefthand corner choose Serial RX as the receiver type.
3. Below that choose the type of serial receiver that you are using.  Save and reboot.

#### Using CLI:

For Serial RX set the `receiver_type` and `serialrx_provider` setting as appropriate for your RX.

```
# get rec
receiver_type = SERIAL
Allowed values: NONE, SERIAL, MSP, SIM (SITL)

# get serialrx
serialrx_provider = SBUS
Allowed values: SPEK1024, SPEK2048, SBUS, SUMD, IBUS, JETIEXBUS, CRSF, FPORT, SBUS_FAST, FPORT2, SRXL2, GHST, MAVLINK, FBUS

```

## Receiver configuration.

### FrSky D4R-II

Set the RX for 'No Pulses'.  Turn OFF TX and RX, Turn ON RX.  Press and release F/S button on RX.  Turn off RX.

### Graupner GR-24 PWM

Set failsafe on the throttle channel in the receiver settings (via transmitter menu) to a value below `rx_min_usec` using channel mode FAILSAFE.
This is the prefered way, since this is *much faster* detected by the FC then a channel that sends no pulses (OFF).

__NOTE:__
One or more control channels may be set to OFF to signal a failsafe condition to the FC, all other channels *must* be set to either HOLD or OFF.
Do __NOT USE__ the mode indicated with FAILSAFE instead, as this combination is NOT handled correctly by the FC.

## Receiver Channel Range Configuration.

If you have a transmitter/receiver, that output a non-standard pulse range (i.e. 1070-1930 as some Spektrum receivers)
you could use rx channel range configuration to map actual range of your transmitter to 1000-2000 as expected by INAV.

The low and high value of a channel range are often referred to as 'End-points'.  e.g. 'End-point adjustments / EPA'.

All attempts should be made to configure your transmitter/receiver to use the range 1000-2000 *before* using this feature
as you will have less preceise control if it is used.

To do this you should figure out what range your transmitter outputs and use these values for rx range configuration.
You can do this in a few simple steps:

If you have used rc range configuration previously you should reset it to prevent it from altering rc input. Do so
by entering the following command in CLI:
```
rxrange reset
save
```

Now reboot your FC, connect the configurator, go to the `Receiver` tab move sticks on your transmitter and note min and
max values of first 4 channels. Take caution as you can accidentally arm your craft. Best way is to move one channel at
a time.

Go to CLI and set the min and max values with the following command:
```
rxrange <channel_number> <min> <max>
```

For example, if you have the range 1070-1930 for the first channel you should use `rxrange 0 1070 1930` in
the CLI. Be sure to enter the `save` command to save the settings.

After configuring channel ranges use the sub-trim on your transmitter to set the middle point of pitch, roll, yaw and throttle.


You can also use rxrange to reverse the direction of an input channel, e.g. `rxrange 0 2000 1000`.


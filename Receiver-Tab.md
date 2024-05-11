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
- **SRXL2:** Spektrum** Spektrum DSMX
- **SUMD:** Graupner | 16 channels 

*Depending on the receiver specs, protocol used, radio limits, etc. there may be a limited number of channels available for your use.*

*Some Rx can be configured to export a talk a protocol or use different protocol options. This is not common. The extreme case is where ExpressLRS Rx can talk many protocols with many options such as CRSF, inverted CRSF, SBUS, inverted SBUS, etc. Some old FrSKY receivers can be changed by flashing a different firmware while the ACCESS Rx can be either SBUS and FPort in the transmitter model setup page.* 

*IBUS RX and IBUS telemetry can be configured to both be on the same Serial UART - see [Telemetry.md](https://github.com/iNavFlight/inav/blob/master/docs/Telemetry.md)*

### RC Smoothing

### Channel Map





### SRXL2

SRXL2 is a newer Spektrum protocol that provides a bidirectional link between the FC and the receiver, allowing the user to get FC telemetry data and basic settings on Spektrum Gen 2 airware TX. SRXL2 is supported in INAV 2.6 and later. It offers improved performance and features compared to earlier Spektrum RX.

#### Wiring

Signal pin on receiver (labeled "S") must be wired to a **UART TX** pin on the FC. Voltage can be 3.3V (4.0V for SPM4651T) to 8.4V. On some F4 FCs, the TX pin may have a signal inverter (such as for S.Port). Make sure this isn't the case for the pin you intend to use.

#### Configuration

Selection of SXRL2 is provided in the INAV 2.6 and later configurators. It is necessary to complete the configuration via the CLI; the following settings are recommended:

```
feature TELEMETRY
feature -RSSI_ADC
map TAER
set receiver_type = SERIAL
set serialrx_provider = SRXL2
set serialrx_inverted = OFF
set srxl2_unit_id = 1
set srxl2_baud_fast = ON
set rssi_source = PROTOCOL
set rssi_channel = 0
```

#### Notes:

* RSSI_ADC is disabled, as this would override the value provided through SRXL2
* `rssi_channel = 0` is required, unlike earlier Spektrum devices (e.g. SPM4649T).

Setting these values differently may have an adverse effects on RSSI readings.

#### CLI Bind Command

This command will put the receiver into bind mode without the need to reboot the FC as it was required with the older `spektrum_sat_bind` command.

```
bind_rx
```

## MultiWii serial protocol (MSP RX)

Allows you to use MSP commands as the RC input. Up to 18 channels are supported.
Note:
* It is necessary to update `MSP_SET_RAW_RC` at 5Hz or faster.
* `MSP_SET_RAW_RC` uses the defined RC channel map
* `MSP_RC` returns `AERT` regardless of channel map
* You can combine "real" RC radio and MSP RX by compiling custom firmware with `USE_MSP_RC_OVERRIDE` defined. Then use `msp_override_channels` to set the channels to be overridden.
* The [wiki Remote Control and Management article](https://github.com/iNavFlight/inav/wiki/INAV-Remote-Management,-Control-and-Telemetry) provides more information, including links to 3rd party projects that exercise `MSP_SET_RAW_RC` and `USE_MSP_RC_OVERRIDE`

## SIM (SITL) Joystick

Enables the use of a joystick in the INAV SITL with a flight simulator. See the [SITL documentation](SITL/SITL).

## Configuration

The receiver type can be set from the configurator or CLI.

```
# get receiver_type
receiver_type = NONE
Allowed values: NONE, SERIAL, MSP, SIM (SITL)
```

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


iNav supports Ublox, DJI NAZA, NMEA, multiwii's i2c-nav board and MultiWiiCopter's i2c-gps modules

Tested and confirming working protocols are Ublox and DJI NAZA

Recommended GPS are M8N versions. 

Modules known to work reasonably well:
* [Beitian BN-880](https://inavflight.com/shop/p/BN880)
* [Ublox NEO-M8N APM version (Galileo compatible)](https://inavflight.com/shop/s/bg/1035454)

Older versions as M6N and M7N also work, but the new M8N is far superior. 
Most GPS modules have a built in magnetometer (compass), but there are also some available without e.g. [Beitian BN-180](https://inavflight.com/shop/p/BN180) or [Beitian BN-220](https://inavflight.com/shop/p/BN220) which are perfect for planes and flying wings.

With default settings iNav will configure the GPS automatically, **there is no need for configuring it manually** using software like u-center. Nevertheless you have to configure your FC with iNav to receive the GPS signals.

For iNav before 1.9, it is also necessary to perform some [manual configuration of UBLOX 3.01 firmware GPS](https://github.com/iNavFlight/inav/wiki/Ublox-3.01-firmware-and-Galileo) to use Galileo satellites. 

With iNav 1.9 and later, Galileo can be enabled with the CLI setting `set gps_ublox_use_galileo = ON` (the default is off).

If you want to use the external magnetometer (built in in your GPS) and you have a FC with the same magnetometer (HMC5883L is very common), you have to disable it physically on your FC: remove chip from board or cut a trace. You can't use two identical chips/magnetometers on the same I2C bus. 
  * When using DJI NAZA gps this is not true, DJI NAZA sends compass over serial and does not use the I2C bus)
  * On MPU9250 board internal magnetometer is an AK8963, most GPS pucks are HMC5883L. So no need to remove hardware, only choose which one to use with cli command `mag_hardware`

If  you elect to use the internal FC magnetometer you are highly likely to have poor results due to magnetic interference (not recommended).

Just to avoid the mistake many people do while installing a GPS unit: _(thanks to quadmeup.com for the images)_

<table>
  <tbody>
    <tr>
      <td><img src="https://quadmeup.com/wp-content/uploads/2016/03/beitian-bn-880-antenna-1024x666.jpg" width="300"></td>
      <td>This side has to point towards the sky</a></td>
    </tr>
    <tr>
      <td><img src="https://quadmeup.com/wp-content/uploads/2016/03/beitian-bn-880-top.jpg" width="300"></td>
      <td>This side has to point towards the ground</a></td>
    </tr>
  </tbody>
</table>



## Setting up the compass alignment

Before attempting any navigation modes, you should verify that the compass alignment is correct (Configurator or CLI `set align_mag`)
* Perform any tests away of sources of magnetic interference. Domestic applicances or even audio speakers can cause erroneous affects.
* Use an analogue compass in preference to a digital (mobile phone) compass. The compass in your phone is likely to be a similar chip to that on your aircraft, and is as susceptible to errors of interference and calibration
* Alternatively, if you know the orientation of surrounding landmarks (e.g. my house is pretty much N/S), then you can do  static tests against land orientation.

Check your machine at cardinal points (North (0°), East (90°), South (180°), West (270°)). Degree perfect alignment is not necessary (and probably not measurable), but you should aim for +/- 5° of known magnetic direction.

* If the values are incorrect by a multiple of 90°, then the numeric alignment needs to be changed
* If the values are just randomly wrong across the cardinal points, then FLIP is probably wrong (as well).

## Initial flight tests

Once  you're content that the static configuration of the compass is correct, it's time to go flying. There is still no guarantee that the machine will not generate interference, so it's advisable to do some controlled testing before attempting more advanced navigation modes:

* In a clear space (no trees!) attempt a simple line of slight POSHOLD. If the craft fails to hold (toilet bowling, or ever increasing circles (in range and speed)), be prepared to disengage PH and take manual control.

To confirm magnetic interference, blackbox logging is most useful:

* Fly at a reasonable speed (> 5m/s) in straight lines, as close as possible to a 90° crossing paths, or a square / rectangular pattern.

* The blackbox can be analysed to compare the course over the ground (from GPS) with the compass readings.

* If you need help doing this, post the log in the iNav RC Groups forum (or Slack channel) and ask for help. There are a number of users familiar with this type of analysis who will assist.

* It is necessary to fly at a reasonable speed in order to get useful GPS data. Just hovering is not useful as the GPS cannot detect direction without movement.

* If you use mwp as a ground station with telemetry, then mwp logs can also provide useful analysis, but blackbox is preferred, as there is more data and it is also possible to analyse throttle affects.

Only when you're content that the compass reads correctly for all throttle settings and directions should you progress to more advanced navigation feature (way points, return to home). The majority of navigation failures are due to poorly performing compasses. 

## Getting started with Ublox GPS
- Physically connect your GPS to your FC using UART or softserial. Connect RX from GPS to TX on FC, TX from GPS to RX on FC
- Activate GPS in the ports tab in cleanflight/iNav configurator and set it to 57600 using UART or 19200 using softserial (on your chosen port)
- Activate GPS in the configuration tab, set it to ublox.

- Using external compass:
 * Connect the magnetometer to I2C ports (SCL/SDA) Be aware that with SDA/SLC lines connected the flight battery must often be connected to access configurator and power up the magnetometer. 
 * Select your newly connected magnetometer by using `mag_hardware` CLI command. Example `set mag_hardware = auto` if you only have one magnetometer connected.
 * Most built in magnetometers are on the underside and rotated 180 degrees, use example `set align_mag = CW180FLIP`. If compass is not working properly in all directions then either think and figure out the direction of your mag, or go through them all until it works as expected.
 * F3 based board and newer uses default automatic magnetic declination, if your on F1 board or want to change magnetic declination manually you have to set correct declination of your spesific location, which can be found here: www.magnetic-declination.com. If your magnetic declination readings are e.g. +3° 34' , the value entered in the iNav configurator is 3.34 (3,34 in some locales). In the CLI, the same effect would be `set mag_declination = 334`. For west declination, use a minus value, e.g. for 1° 32' W, `set mag_declination = -132`. In all cases (both CLI and GUI), the least significant digits are **minutes**, not decimal degrees.
 * Calibrate your compass according to [compass calibration](https://github.com/iNavFlight/inav/wiki/Sensor-calibration#compass-calibration)


Note to change magnetic declination manually on F3 or newer board you have to turn off automatic function. `set inav_auto_mag_decl = OFF`.

## NEO-M8N PixHawk GPS Unit

A readily available GPS unit is the "NEO-M8N" unit that is available from eBay, Amazon, Banggood & so on... 

They are cheap and because they use the Russian satellite network called GLONASS, obtaining a GPS fix is quicker and you can be flying around with anywhere between 9 to 20 satellites.

Also as a bonus with such units they have a magnetometer (a compass) on the underside of the board too! 

<img src="https://img2.banggood.com/thumb/large/upload/2015/09/SKU287158/SKU287158-1.jpg">

An important note is that on top of the protective shell there is an arrow, this needs to point towards the front of your model.

**Important**: 
You need to switch the Rx and Tx wires around. So you connect your GPS Tx wire (yellow) to your desired Rx pin and the GPS Rx wire (White) to your Tx pin on your flight controller.

A video showing you how to do this for a Omnibus F4 V2 board is in [this video on YouTube](https://www.youtube.com/watch?v=nQCQXuqQSd8)

Once you have connected the GPS to your flight control board

- Open the iNav Configurator 
- Enable GPS on your desired UART port
- Set the the baud rate to 115200
- Press "Save & Reboot"
- Then go to the "Configuration" tab in the iNav Configurator 
- Enable GPS
- Set the "Protocol" to UBLOX
- Set the "Ground Assistance Type" to "Auto Detect"
- set CW270FLIP
- Press "Set & Reboot"
 You can confirm the GPS unit is working by going to the GPS tab in the iNav Configurator and if it is working you will see the "Total Messages" count on the left incrementing in numbers.

If it is the first time you have connected the GPS unit, then it can take several minutes for a GPS fix to be obtained. This is perfectly normal. 

**Note:** For the GPS unit to work & pick up satellites it needs an unobstructed view to the sky (so if using indoors, don't expect any satellites to be picked up!)


## Getting started with DJI NAZA GPS
NOTE: By default F1 processors do not support DJI GPS. Most F3 processors do - check hardware support map.
F1 can support DJI if you compile your own build with unused features removed.

- Physically connect your GPS to your FC using UART. Connect RX from GPS to TX on FC, TX from GPS to RX on FC
- Activate GPS in the ports tab in cleanflight/iNav configurator and set it to 115 200 on correct UART
- Type this in CLI

`feature GPS`

`set gps_provider = NAZA`

`set mag_hardware = GPSMAG`

`set align_mag = CW180FLIP`

Default DJI GPS puck pointing forward is set with CW180FLIP, but can be changed with CW0FLIP, CW90FLIP, CW180FLIP or CW270FLIP

 * F3 based board and newer uses default automatic magnetic declination, if your on F1 board or want to change magnetic declination manually you have to set correct declination of your spesific location, which can be found here: www.magnetic-declination.com. If your magnetic declination readings are e.g. +3° 34' , the value entered in the iNav configurator is 3.34 (3,34 in some locales). In the CLI, the same effect would be `set mag_declination = 334`. For west declination, use a minus value, e.g. for 1° 32' W, `set mag_declination = -132`. In all cases (both CLI and GUI), the least significant digits are **minutes**, not decimal degrees.
 * Calibrate your compass according to [compass calibration](https://github.com/iNavFlight/inav/wiki/Sensor-calibration#compass-calibration)

Note to change magnetic declination manually on F3 or newer board you have to turn off automatic function. `set inav_auto_mag_decl = OFF`.


Thats it!


## SBAS

When using a UBLOX GPS the SBAS mode can be configured using `gps_sbas_mode`.

The default is AUTO.

| Value    | Region        |
| -------- | ------------- |
| AUTO     | Global        |
| EGNOS    | Europe        |
| WAAS     | North America |
| MSAS     | Asia          |
| GAGAN    | India         |
| NONE     | NONE         |

If you use a regional specific setting you may achieve a faster GPS lock than using AUTO, but keep in mind to change it if you change your location for holidays etc.

This setting only works when `gps_auto_config= ON`


## Issues
- No GPS lock: often due to electric noise from flight controller or other equipment such as 1.2ghz video TX. Try getting the GPS as far away as possible from electric noise emitting parts as the FC, ESC´s or power cables. Placing the GPS on a mast is also a common way, you can further try shielding with aluminum or copper foil. Don´t place the GPS inside the frame.
- "Toilet bowling": in the beginning the copter holds its position and then starts to make bigger and bigger circles, you probably have your magnetometer not calibrated correctly or it’s interfered from the magnetic field of your power lines or the beeper.
If you are using your FC onboard mag, try to place the the FC as far away as possible from the magnetic interference causing parts e.g. mounting it on/under the top plate on small racers.
- 3.3V GPS units, such as the GPS from 3DR should not be powered by the flight controller's 3.3V pin along with a Spektrum (or other DSM) receiver. The current draw can cause the Spektrum receiver to brownout. Instead use a 3.3V regulator and power the GPS from the BEC or separate battery. 
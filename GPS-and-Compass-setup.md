In the 7.0 release and later. INAV only supports Ublox and Ublox7 protocols.

Recommended GNSS units are M8, M9 or M10 models for best navigation performance.

Modules known to work reasonably well:
* [Beitian BN-880](https://inavflight.com/shop/p/BN880)
* [Matek M10Q-5883](http://www.mateksys.com/?portfolio=m10q-5883)


Older versions as M6N and M7N also work, but the newer M9/M10 versions are far superior.
Most GPS modules have a built in magnetometer (compass), but there are also some available without e.g. [Matek M10Q](http://www.mateksys.com/?portfolio=sam-m10q) or [Beitian BN-220](https://inavflight.com/shop/p/BN220) which are perfect for planes and flying wings.

With default settings INAV will configure the GPS automatically, **there is no need for configuring it manually** using software like `u-center`. Nevertheless you have to configure your FC with INAV to receive the GPS signals.

For INAV before 1.9, it is also necessary to perform some [manual configuration of UBLOX 3.01 firmware GPS](https://github.com/iNavFlight/inav/wiki/Ublox-3.01-firmware-and-Galileo) to use Galileo satellites.

With INAV 7.0 and later, `GPS`, `Galileo` and `BeiDou` or `Glonass`  can be enabled in the GPS configuration tab (the `GPS` constellation is enabled by default). **Always enable as many constellation as your hardware will allow.**

The magnetometer / compass is normally included as part of the GNSS (GPS) module. 
If you want to use an external magnetometer other than the one on your GNSS module do not use both together. You can't use two identical chips/magnetometers on the same I2C bus.

If your flight controller has an internal magnetometer on the FC, using it will likely to have poor results due to magnetic interference (not recommended).

 ## INAV 7.1 changes

**From the release of INAV 7.1 the use of a compass is no longer mandatory for multirotor navigation as it once was. BUT it is still recommended for the best navigation performance, when it comes to maintaining a fixed position for an _extended period of time_, without heading drift.** e.g. in Poshold. Or taking off and immediately starting a Waypoint mission.
* Compass-less navigation performance is heavily dependent on a clean build, that has minimal levels of Gyro/Acc noise. It **will not** work correctly if your multirotor is producing excessive vibrations, caused by unbalanced motors, propellers or frame resonance. Also, always enable the maximum number of GNSS constellations your hardware will allow. EPV and EPH (Standard deviation of position error) will greatly effect navigation precision. Regardless of having a 3D fix, or what you think is an acceptable HDOP or number of satellites.

If the user does decide to omit the use of a compass for a multirotor for reasons like the model size or magnetic interference that can not be overcome, be mindful that navigation modes will not be operational until a GPS heading is obtained.  To enable navigation modes (_RTH, Failsafe, Poshold, Cruise or a Waypoint mission_) fly in a straight line until **-**
* the OSD _Heading_ and _Course over Ground_ indicators display a valid heading.
* keep both headings closely aligned for a time
* the OSD Home arrow appears, showing a valid home direction

Example [Video](https://www.youtube.com/watch?v=iopZfH-DdTI)

Only then can the IMU heading data be trusted for fixed position or slow speed navigation. Do not omit any of the above steps or your multirotor can experience toilet bowling, just as surely as it would with a poorly setup compass.  Also conduct some tests to be sure everything is working correctly when you first setup a multirotor without a compass, just as you would with a compass.

* **Note** : _Presently multirotor navigation flight modes (RTH, POSHOLD etc) are required to be set **before** the magnetometer is turned off in the Configuration tab. Otherwise the navigation modes will not appear in the modes tab. Magnetometer type FAKE can be used if no device is installed.

INAV 7.1 will also offer better compass interference rejection. But this is not an excuse to be tardy on your install, or shortcut the calibration process.

INAV 7.1 and later will also benefit fixed-wing models by the use of a compass, in providing better heading estimation. While in previous releases a compass provided no extra benefit.

## INAV GPS Configuration

INAV will attempt to provide GPS configuration. This is controlled by a number of CLI settings

* `gps_auto_config`
* `gps_auto_baud`

INAV only requires a few UBLOX messages and it is recommended that you leave auto-config enabled to ensure the GPS is configured to INAV's requirements.

In particular, if you enable messages that INAV does not require, it is possible to seriously downgrade or even disable GPS functionality. This is typically indicated by a high error count being reported. In this case, it is recommended that you use "u-center" to reset the GPS to factory settings and let INAV perform auto-configuration.

### INAV runtime Configuration steps

When the GPS port is enabled, INAV will:

* Auto-baud if set, to the limit set by `gps_auto_baud_max_supported`. Do not set this too high on older models
* Disable "standard" NMEA periodic sentences
* Set UBLOX parameters
* Enable the required UBLOX periodic messages

Note that GPS is a push protocol; if your GPS has pre-configured messages enabled for transmission, then they will be sent; it is not practical for INAV to disable the whole of the large UBLOX message catalogue. If in doubt, perform a factory reset.

### INAV Required Messages

INAV will enable UBLOX periodic messages according to the UBLOX version:

| Class | Id   | Usage                                                  | UBLOX Versions |
|-------|------|--------------------------------------------------------|----------------|
| 0x01  | 0x02 | UBX-NAV-POSLLH Geodetic Position Solution              | 5,6            |
| 0x01  | 0x03 | UBX-NAV-STATUS Receiver Navigation status              | 5,6            |
| 0x01  | 0x12 | UBX-NAV-VELNED Velocity Solution in NED                | 5,6            |
| 0x01  | 0x21 | UBX-NAV-TIMEUTC GPS Time Solution                      | 5,6            |
| 0x01  | 0x35 | UBX=NAV-SOL Navigation Solution Information            | 5,6,7,8        |
| 0x01  | 0x07 | UBX-NAV-PVT Navigation Position Velocity Time Solution | 7,8,9,10       |

As of March 2024 / INAV 7.1.

## Installing the GNSS unit - Antenna orientation

Ensure the ceramic antenna (light brown or beige in color) faces skywards. To provide the strongest signal and best hemispherical satellite coverage. And be sure its mounted a minimum of 5cm away from any source of Radio Frequency or (Electro) Magnetic interference. **e.g.** Digital or Analogue video transmitters. A radio receiver that has telemetry. Or for the sake of the magnetometer/compass. Any source of magnetic field, like high current power wires, motors or a beeper.

 ![TOP_Matek GNSS](http://www.mateksys.com/wp-content/uploads/2023/03/M10Q-5883_4.jpg)


## Setting up the compass alignment

INAV's default Orientation Preset is `CW270FLIP`. This value is based on the PCB mounting position of the magnetometer chip by the individual manufacturer. With respect to the Arrow direction they provide on their GNSS module.

Note : The QMC5883 magnetometer chip circled in _red_ on the base of the GNSS module. And the orientation Arrow circled in _orange_. Showing the direction the compass should **ideally** be mounted, with the Arrow facing the front of the model, and its direction of travel, based on `CW270FLIP`for more reputable manufacturers.


![M10Q-5883_2](https://github.com/iNavFlight/inav/assets/47995726/4183e4af-a043-49d1-9733-5b1515b7de05)

However, there are many manufactures that have released GNSS/compass modules onto the market without any thought of adding an orientation arrow to assist installation.
In this case you maybe required to work out the orientation preset required for your hardware based on the magnetometer chips position, on your specific installation. You may use the Alignment Tool in the configurator, for _basic_ compass/flight controller orientations.

![M181](https://github.com/iNavFlight/inav/assets/47995726/cd8f6567-c142-400f-885a-5e5c708ad716)

**NOTE :** Compass orientation preset is solely based on the Flight controller having its _mounting arrow facing the direction the model will travel_. If you invert the flight controller, or rotate it on the Yaw axis this will effect the compass alignment settings.
Before attempting use any navigation modes, you should verify that the compass alignment is working in unity with the flight controllers alignment, by using the Configurator SETUP Tab, and moving the model on all axis's with your hand, to ensure the graphical model moves identical to your motions, without any axis drift.


## Compass calibration and testing

The general rule behind compass calibration is to ensure the magnetometer reports the earths magnetic field strength equally on all axis's, regardless of weak localized magnetic perturbations. Therfore calibration of the compass should be done _in_ the aircraft.

Ideally, its not good enough to rotate the compass or aircraft, so that each axis faces skyward or towards the ground. Because this can leave areas where _complete_ calibration is missed. Which will provide poor results and navigation performance.

To acquire the best 3 axis calibration results, **your wrist should move the aircraft in an infinity [∞](https://www.google.com.au/search?sca_esv=c7d05ac6ad01166f&sca_upv=1&q=3D+compass++calibration+motion&tbm=vid&source=lnms&sa=X&ved=2ahUKEwiThc-btLGEAxVEa2wGHaZaAO8Q0pQJegQIDBAB&biw=1366&bih=615&dpr=1#fpstate=ive&vld=cid:8bdfdcb6,vid:J_cZnPcW-Yw,st:0) symbol motion in the air, while ensuring every axis faces skywards in the process**. Do this several times (not too quickly) within the allotted 30secs.
* Use a long USB extension lead if its done via connection to the configurator.

The end result should be the `maggain_x` `maggain_y` `maggain_z` calibrated settings should not be greater that 100 points of each other, and as close to 1500 as possible. While `magzero_x`  `magzero_y` `magzero_z` can vary. But should never exceed +- 1000 on any axis.  Any dramatic difference indicates a poor calibration. Or too much localized magnetic or electromagnetic interference.
**Note**: A good calibration may take several attempts.


* Perform any tests away of sources of magnetic interference. Domestic appliances or even audio speakers can cause erroneous affects.  COmputer monitors may also interfere.
* Use an analogue compass in preference to a digital (mobile phone) compass. The compass in your phone is likely to be a similar chip to that on your aircraft, and is as susceptible to the same errors of interference and calibration
* Alternatively, if you know the orientation of surrounding landmarks (e.g. my house is pretty much N/S), then you can do  static tests against land orientation.

Check your machine at cardinal points (North (0°), East (90°), South (180°), West (270°)). Degree perfect alignment is not necessary (and probably not measurable), but you should aim for +/- 5° of known magnetic direction.

* If the values are incorrect by a multiple of 90°, then the numeric alignment needs to be changed
* If the values are just randomly wrong across the cardinal points, then FLIP is probably wrong (as well).

* If external Compass module is mounted at 30 degree.
For example at top of a Cam mount,
free alignment is possible by Cli commands.
Cli setting Align_mag must be set to
 `Align_mag = default`
 `save`

For example CW270flip, this value is to ADD manually.
For free Alignment, all three axis need to set manually.
A sensor flip is always to realize
over the pitch axis.
For example cw270flip:

    set align_mag_pitch = 1800
    set align_mag_roll = 0
    set align_mag_yaw = 2700
    save

* For 30 Degree Backwards tilted GPS/Compass Module, reduce align_mag_roll about 300

    set align_mag_roll = -300
    save

* Because Magnetometer with CW270° has its roll axis in relation to the Pitch Axis of the FC

The terminology of the setting FLIP. Is based on the magnetometer chip being upside down, on the under side of the GNSS unit.
If the chip could be mounted with it top facing the sky. FLIP would not be required. The only other exception is if your Flight Controller is mounted inverted in you model. Because the Compass and FC work together to provide the correct heading. FLIP is not required in that case.

Enhanced Explanation in #6232
[How to Align and Check if your readings are Correct ](https://github.com/iNavFlight/inav/issues/6232#issuecomment-727636397)

Painless360 done a video on this
(https://www.youtube.com/watch?v=kVVJ-DjUjsc)

There is an online (web based) software tool to help with alignment [Alignment Tool](https://kernel-machine.github.io/INavMagAlignHelper/); this tool is built into the INAV configurator for INAV 5.0 and later.


## Initial flight tests

Once  you're content that the static configuration of the compass is correct, it's time to go flying. There is still no guarantee that the machine will not generate interference, so it's advisable to do some controlled testing before attempting more advanced navigation modes:

* In a clear space (no trees!) attempt a simple line of sight POSHOLD. If the craft fails to hold (toilet bowling, or ever increasing circles (in range and speed)), be prepared to disengage PH and take manual control.

To confirm magnetic interference, blackbox logging is most useful:

* Fly at a reasonable speed (> 5m/s) in straight lines, as close as possible to a 90° crossing paths, or a square / rectangular pattern.

* The blackbox can be analysed to compare the course over the ground (from GPS) with the compass readings (`GPS_ground_course` v. `attitude[2]/10`). Run `blackbox_decode` with the `--merge-gps` option to get GPS fields in the log.

* If you need help doing this, post the log in the INAV RC Groups forum (or Discord / Telegram channel) and ask for help. There are a number of users familiar with this type of analysis who can assist.

* It is necessary to fly at a reasonable speed in order to get useful GPS data. Just hovering is not useful as the GPS cannot detect direction without movement.

* If you use mwp as a ground station with telemetry, then mwp logs can also provide useful analysis, but blackbox is preferred, as there is more data and it is also possible to analyse throttle affects.

Only when you're content that the compass reads correctly for all throttle settings and directions should you progress to more advanced navigation feature (way points, return to home). The majority of navigation failures are due to poorly performing compasses.

## Getting started with Ublox GPS

- Physically connect your GPS to your FC using UART (preferred) or softserial (not recommended). Connect RX from GPS to TX on FC, TX from GPS to RX on FC

- Activate GPS in the ports tab in INAV configurator and set it to `57600`, `115200` using UART. Or `19200` using softserial (on your chosen port)

- The baud rate can be set to `230400` when using an M10 device. Which can be beneficial. BUT higher baud rates are also susceptible to interference if the GNSS UART leads run close to a source of RF/EM interference. If you choose to use a higher baud rate, be sure to twist the `TX/RX/5v/G` leads together. Especially if the cable length between the GNSS module and FC is more than 5cm or so.

- Activate GPS in the configuration tab, set it to Ublox7.

- Using external compass:

 * Connect the magnetometer to I2C ports (SCL/SDA) Be aware that with SDA/SLC lines connected the flight battery must often be connected to access configurator and power up the magnetometer.

 * Select your newly connected magnetometer by using `mag_hardware` CLI command. Example `set mag_hardware = auto` if you only have one magnetometer connected.

* Most built in magnetometers are on the underside and rotated 180 degrees, use example `set align_mag = CW180FLIP`. If compass is not working properly in all directions then either think and figure out the direction of your mag, or go through them all until it works as expected.

 * INAV does provide an automatic declination setting, based on GNSS coordinates, which is enabled by default `inav_auto_mag_decl = ON`. But if you want to change magnetic declination manually `set inav_auto_mag_decl = OFF`. You have to set correct declination of your specific location, which can be found here: www.magnetic-declination.com. If your magnetic declination readings are e.g. +3° 34' , the value entered in the INAV configurator is 3.34 (3,34 in some locales). In the CLI, the same effect would be `set mag_declination = 334`. For west declination, use a minus value, e.g. for 1° 32' W, `set mag_declination = -132`. In all cases (both CLI and GUI), the least significant digits are **minutes**, not decimal degrees.

* Calibrate your compass according to [compass calibration](https://github.com/iNavFlight/inav/wiki/Sensor-calibration#compass-calibration)


Some FC boards may not provide 4.5V power on USB supply. In order to power the GPS it is necessary to connect the battery or use another power source (a 4.5V source may be powered by USB). The onboard 3.3V will be powered by USB, but may not provide adequate voltage, as the GPS regulator typically requires 3.6V minimum.

Once you have connected the GPS to your flight control board

- Open the INAV Configurator
- Enable GPS on your desired UART port
- Set the baud rate
- Press "Save & Reboot"
- Then go to the "Configuration" tab in the INAV Configurator
- Enable GPS
- Set the "Protocol" to UBLOX7
- Set the "Ground Assistance Type" to "Auto Detect"
- set MAG Alignment to CW270FLIP
- Press "Set & Reboot"
 You can confirm the GPS unit is working by going to the GPS tab in the INAV Configurator and if it is working you will see the "Total Messages" count on the left incrementing in numbers.

## GNSS Ublox update rate

INAV 7.0 and later supports a higher GNSS update rate for Ublox receivers.  `gps_ublox_nav_hz`. With M10 (now) supporting up to 25Hz.
If you wish to increase navigation precision. And you have a low noise build, good fix and with EPH/EPV data being acceptable. You may wish to alter this setting. But only do so according to the table below. Note how the maximum update rate can only be achieved with lower concurrent constellations.
_And a trade off will also be noticed. The satellite count will generally be a little lower, the higher the update rate. But this isn't a draw back. Because higher precision can still be achieved._

![update rate](https://github.com/iNavFlight/inav/assets/47995726/a541d4bb-3dca-4813-a3ce-60a067ae67a1)


If it is the first time you have connected the GNSS unit, then it can take several minutes for a satellite fix to be obtained. This is the time required to download the Almanac and Ephemeris data. This is perfectly normal. But if it takes longer than 10 minutes. You likely have GNSS RF band interference coming from a hardware source in your model.

**Note:** For the GPS unit to work & pick up satellites it needs an unobstructed view to the sky (so if using indoors, don't expect any satellites to be picked up!)


 * Inav since 1.5 version and newer uses default automatic magnetic declination, if your on old verion or want to change magnetic declination manually you have to set correct declination of your specific location, which can be found here: www.magnetic-declination.com. If your magnetic declination readings are e.g. +3° 34' , the value entered in the INAV configurator is 3.34 (3,34 in some locales). In the CLI, the same effect would be `set mag_declination = 334`. For west declination, use a minus value, e.g. for 1° 32' W, `set mag_declination = -132`. In all cases (both CLI and GUI), the least significant digits are **minutes**, not decimal degrees.
 * Calibrate your compass according to [compass calibration](https://github.com/iNavFlight/inav/wiki/Sensor-calibration#compass-calibration)


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
| SOUTHPAN | Australia NZ  |
| NONE     | NONE         |

If you use a regional specific setting you may achieve a faster GPS lock than using AUTO, but keep in mind to change it if you change your location for holidays etc.

This setting only works when `gps_auto_config= ON`


## Issues
- **`X!`** in the OSD `GPS Satellites` field indicates the flight controller isn't receiving a valid data signal from the GPS.
- No GPS lock: often due to electric noise from flight controller or other equipment such as 1.2ghz video TX. Try getting the GPS as far away as possible from electric noise emitting parts as the FC, ESCs or power cables. Placing the GPS on a mast is also a common way, you can further try shielding with aluminum or copper foil. Don´t place the GPS inside the frame.
- "Toilet bowling": in the beginning the copter holds its position and then starts to make bigger and bigger circles, you probably have your magnetometer not calibrated correctly or it’s interfered from the magnetic field of your power lines or the beeper.
If you are using your FC onboard mag, try to place the the FC as far away as possible from the magnetic interference causing parts e.g. mounting it on/under the top plate on small racers.
- 3.3V GPS units, such as the GPS from 3DR should not be powered by the flight controller's 3.3V pin along with a Spektrum (or other DSM) receiver. The current draw can cause the Spektrum receiver to brownout. Instead use a 3.3V regulator and power the GPS from the BEC or separate battery.

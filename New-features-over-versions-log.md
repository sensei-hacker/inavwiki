![](http://static.rcgroups.net/forums/attachments/6/1/0/3/7/6/a9088858-102-inav.png)

This document is intended to show the most relevant new features of each version of INAV.

Every released version of INAV brings some changes on funcionality that is already working, bug fixes and new funcionalities. This document will focus only on the major changes and will not go deep on smaller ones. To check a detailed list of changes for each version, check the release notes on that version release download page.

## New on version 1.5
* **OSD support** - Targets with onboard OSD now work properly.
* [INAV 1.5 Release notes](/iNavFlight/inav/releases/tag/1.5.0)

## New on version 1.6
* **New PIFF controller for fixed-wing aircraft** - Introducing new Proportional + Integral + Feed Forward controller for airplanes. It's more suitable for airplanes due to the nature of control they are using. It also puts less stress on servos.
* **RTH sanity checking** - RTH sanity checking feature will notice if distance to home is increasing during RTH and once amount of increase exceeds a certain threshold defined by nav_rth_abort_threshold CLI parameter instead of continuing RTH machine will enter emergency landing, self-level and go down safely. Default threshold is set to 500m which is safe enough for both multirotor machines and airplanes.
* [INAV 1.6 Release notes](/iNavFlight/inav/releases/tag/1.6.0)

## New on version 1.7
* **Turn assistant** - INAV will automatically do a coordinated balanced turn with ailerons, elevator and rudder.
* **Airplane Autotune mode** - Uses changes in flight attitude input by the pilot to learn the tuning values for roll, pitch and yaw tuning.
* [INAV 1.7 Release notes](/iNavFlight/inav/releases/tag/1.7.0)

## New on versions 1.8 to 1.9
* Lots of small improvements on things what already existed, but fewer new features.
* [INAV 1.8 Release notes](/iNavFlight/inav/releases/tag/1.8.0)
* [INAV 1.9 Release notes](/iNavFlight/inav/releases/tag/1.9.0)

## New on version 2.0
* **New mixer and mixer GUI** - There are no predefined mixers on the firmware side. Mixers now are fully configurable.
* **Added NAV CRUISE flight mode for fixed wing** - When enabled the machine will try to maintain the current heading and compensate for any external disturbances.
* **OSD improvements** - Now it is possible to have three OSD layouts and switch between them via a RC channel. Furthermore new two modes have been added: map and radar.
* **Full VTX control via Smart Audio / TRAMP** - User can now select VTX settings from the configurator or via the OSD CMS. 
* **Wind Estimation for Fixed Wing**
* [INAV 2.0 Release notes](/iNavFlight/inav/wiki/2.0.0-Release-Notes)

## New on version 2.1
* **DSHOT Support** - A digital protocol, like what DSHOT is, can substain a certain amount of noise with no performance degradation and allows a very smooth motor output.
* **Multirotor braking mode**
* **PINIO support**
* [INAV 2.1 Release notes](/iNavFlight/inav/wiki/2.1.0-Release-Notes)

## New on version 2.2
* **Logic Conditions** - It's a new function framework that allows to activate and deactivate specific servo mixer rules.
* **Cellular telemetry via text messages** - Uses a SimCom SIM800 series cellular module to provide telemetry via text messages.
* **Support for INAV Radar** - Introduces the support for Radar ESP32 boards. They can be used to share information (including position) between multiple machines.
* **Added option to continue mission out of radio range**
* [INAV 2.2 Release notes](/iNavFlight/inav/wiki/2.2.0-Release-Notes)

## New on version 2.3
* **ESC Telemetry** - It's a feature of DSHOT ESCs to send some data back to the flight controller - voltage, current, temperature, motor RPM.
* **Dynamic Filters** - Port of Betaflight dynamic filtering.
* **Global Functions** - Global Functions (abbr. GF) are a mechanism allowing to override certain flight parameters (during flight). Global Functions are activated by Logic Conditions.
* **Pixel based OSD** - INAV now supports pixel based OSDs and includes a driver for FrSky's OSD.
* [INAV 2.3 Release notes](/iNavFlight/inav/wiki/2.3.0-Release-Notes)

## New on version 2.4

* **RPM Filters** - INAV can now take determine where to place notch filters based on the rotation speed of the motors to attenuate noise being fed into PID. You need to connect BlHeli telemetry on a serial port and then enable RPM Filters.
* **USB Mass Storage** - USB MSC (mass storage device class) SD card and internal flash access is enabled for F4 and F7 targets with suitable hardware. This means you can mount the FC (SD card / internal flash) as a host computer file system via USB to read BB logs (and delete them from a SD card).
* **RTH Home Offset** - Allows INAV RTH and failsafe RTH to not return the launch point but in a nearby area allowing not to violate a protected space which might be active in some flying fields.
* **Linear Climb and Dive on Waypoint Missions** - INAV will try to climb or dive to the next waypoint altitude in a linearly manner, so it'll reach the next waypoint altitude only when it's almost reaching the waypoint itself. This way aircraft will consume less energy to climb since it'll be a less steep climb or will save energy by trading altitude for speed for more time when diving.
* **Support for DJI HD FPV** - NAV is now ready to embrace HD FPV with support for the DJI HD FPV system.

## Enjoy the newer features!

If you have an older version of INAV on your aircraft, upgrade now and enjoy the newer features! We have a guide to help you to do that. [Check it out now](/iNavFlight/inav/wiki/Upgrading-from-an-older-version-of-INAV-to-the-current-version)!
This document is intended to show the most relevant new features of each version of INAV.

Every released version of INAV brings some changes on funcionality that is already working, bug fixes and new funcionalities. This document will focus only on the major changes and will not go deep on smaller ones. To check a detailed list of changes for each version, check the release notes on that version release download page.

## New on version 2.3
* **ESC Telemetry** - It's a feature of DSHOT ESCs to send some data back to the flight controller - voltage, current, temperature, motor RPM.
* **Dynamic Filters** - Port of Betaflight dynamic filtering.
* **Global Functions** - Global Functions (abbr. GF) are a mechanism allowing to override certain flight parameters (during flight). Global Functions are activated by Logic Conditions.
* **Pixel based OSD** - INAV now supports pixel based OSDs and includes a driver for FrSky's OSD.

## New on version 2.4

* **RPM Filters** - INAV can now take determine where to place notch filters based on the rotation speed of the motors to attenuate noise being fed into PID. You need to connect BlHeli telemetry on a serial port and then enable RPM Filters.
* **USB Mass Storage** - USB MSC (mass storage device class) SD card and internal flash access is enabled for F4 and F7 targets with suitable hardware. This means you can mount the FC (SD card / internal flash) as a host computer file system via USB to read BB logs (and delete them from an SD card).
* **RTH Home Offset** - Allows INAV RTH and failsafe RTH to not return the launch point but in a nearby area allowing not to violate a protected space which might be active in some flying fields.
* **Linear Climb and Dive on Waypoint Missions** - INAV will try to climb or dive to the next waypoint altitude in a linearly manner, so it'll reach the next waypoint altitude only when it's almost reaching the waypoint itself. This way aircraft will consume less energy to climb since it'll be a less steep climb or will save energy by trading altitude for speed for more time when diving.
* **Support for DJI HD FPV** - NAV is now ready to embrace HD FPV with support for the DJI HD FPV system.

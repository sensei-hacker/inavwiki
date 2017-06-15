### Getting started

## Where to download?!
Install the latest chrome app [iNav Configurator](https://chrome.google.com/webstore/detail/inav-configurator/fmaidjmgkdkpafmbnmigkpdnpdhopgel) and use that tool to download and flash firmware. 

Be aware that on first boot after an reflash / Clean erase INAV tries to auto detect MAG, BARO and SPEED ( Pitot-tube ), if not any detected it will give indicate it with red icons on the sensor bar, also it will give fail on `Hardware health` on the Pre-arming checks, just do new reboot and its fine.

Go through the index on the right side to find useful information.

### Hardware needed for GPS assisted modes.

* Multirotors: GPS, magnetometer, barometer.
* Fixed wings: GPS. (Can also use magnetometer and barometer but not needed.)

### Naze32, CC3D and other F1 cpu targets restrictions. 

* Dropped all other telemetry than LTM.
* Dropped all GPS protocols expect Ublox
* Dropped sonar support
* Dropped automatic magnetic declination. 
* Dropped Led strip
* Support only S.Bus, Spektrum and IBus SerialRX protocols
* For more complete list see this [Link](https://github.com/iNavFlight/inav/wiki/Hardware-and-feature-support-map)

These features can be enabled if you download and compile your own, (Required to take out other features due to size limitations) Read [Building in windows ](https://github.com/iNavFlight/inav/blob/master/docs/development/Building%20in%20Windows.md) or setup your own [Virtualbox](https://github.com/iNavFlight/inav/wiki/Making-a-new-Virtualbox-to-make-your-own-INAV) with INAV build enverioment  and [Features safe to add and remove ](https://github.com/iNavFlight/inav/blob/master/docs/Features%20safe%20to%20remove%20and%20add.md) (This list is incomplete, still more that can be disabled. Feel free to add to the list showing)  


[Video showing how to edit and tailor iNav for you needs.](https://youtu.be/n3Z1fOQJAg8)

## GPS
iNav supports  Ublox, DJI NAZA, NMEA, multiwii's i2c-nav board and MultiWiiCopter's i2c-gps modules

Tested and recommend GPS are M8N versions ( example [Ublox NEO-M8N](http://m.banggood.com/Ublox-NEO-M8N-Flight-Controller-GPS-with-Protective-Shell-for-PIX-PX4-Pixhawk-p-1005394.html?AID=12202217&PID=3836173&SID=ikzicawnsk0004o402ecu&source=affiliate&utm_source=Banggood_CJ&utm_medium=commission_junction&utm_campaign=OpenPilot&utm_content=sandy) and [Beitian BN-880](http://m.banggood.com/UBLOX-NEO-M8N-BN-880-Flight-Control-GPS-Module-Dual-Module-Compass-p-971082.html) )
But both M6N and M7N should work.

With default iNav settings iNav will configure ublox GPS for you, no need to use software like u-center.

Also be aware that some of our flight controllers can cause interference with the GPS causing low satellites or even no satellites at all, keep GPS as far as possible away and think of either shield your GPS or flight controller and other equipment that can cause interference.

You can learn how to setup your GPS unit for use with iNav on [on this page](https://github.com/iNavFlight/inav/wiki/GPS--and-Compass-setup).

## Notes / Common issues

* Old version of iNav configurator, verify that your on the latest version see [link](https://chrome.google.com/webstore/detail/inav-configurator/fmaidjmgkdkpafmbnmigkpdnpdhopgel). If it has failed to update, simple uninstall configurator and install it again.

* Unable to enable NAV related modes, See [Link](https://github.com/iNavFlight/inav/wiki/Navigation-modes) for possible reasons for why.

* iNav does not show "GPS Signal Strength" for each satellite in the Cleanflight configurator, instead only the first one is used to show [HDOP](https://en.wikipedia.org/wiki/Dilution_of_precision_%28GPS%29)

* iNav has only one PID controller called fp-pid.

* iNav has extra safety feature that prevents you from arming your aircraft if certain condition are met, or not met. This is controlled by CLI variable "Nav_extra_arming_safety" which is default turned on.

1. No valid GPS lock. (Needs 3d lock and more satelites than inav_gps_min_sats)
1. Navigation modes are turned on while trying to arm.


* iNav has other GPS modes than cleanflight, or names them differently. Read [this wiki page](https://github.com/iNavFlight/inav/wiki/Navigation-modes) for how to use them, and combine them to get wanted position hold.

* If your copter is toilet-bowling, which means, in the beginning it holds its position and then starts to make bigger and bigger circles, you probably have your magnetometer not calibrated correctly or it’s seeing the magnetic field of you power lines or the beeper.  
If you are using your FC onboard mag, try to place the the FC as far away as possible from the magnetic interference causing parts e.g. mounting it on/under the top plate on small racers.

* No GPS lock after setting it up and the GPS icon lights up green are often due to electric noise from flight controller or other equipment such as 1.2ghz video TX. Try getting the GPS on a mast and also you can shield using alufoil or copper foil.

* Barometer is held at 0 meter until first arm, this is to ensure that it starts at 0 meter instead of 10 meters because of temperatur drift. ( This is why raising your flightcontroller while connected to configurator it shows increasing altitude but then is dragged to 0 meter )

**Checklist if you're having issue with something:**

1. Try and look through the wiki regarding the issue you have. You can also search the Wiki.
1. Read the first post [rcgroups Cleanflight iNav thread](http://www.rcgroups.com/forums/showthread.php?t=2495732). Also read the last 5 pages in the thread to see if someone else has already mentioned it. Also try and search in the thread.
1. Explain your issue, include CLI dump and blackbox log if you have a logger. Mention what you have tried, and also if it's working as intended in stock Cleanflight / Earlier versions of iNav
1. [Template for asking for help](http://www.rcgroups.com/forums/showpost.php?p=35637535&postcount=7930)
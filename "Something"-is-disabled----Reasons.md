## Something is disabled

iNav may fail to perform some action as expected, typically arming or engaging waypoints. This articles documents the reasons for some of these events. 

## Arming disabled reasons

iNav will refuse to arm for the following reasons:

| Reason  (enum) | Explanation |
| ------ | ----------- |
|  `FAILSAFE_SYSTEM` | The RX is not recognised as providing a valid signal |
| `NOT_LEVEL` | The vehicle is not level as defined by the CLI `small_angle` setting |
| `SENSORS_CALIBRATING` | The pre-arm sensor calibration has not completed |
| `SYSTEM_OVERLOADED` | The CPU load is excessive. May be caused by too an aggressive loop time setting. |
| `NAVIGATION_UNSAFE` | Where the CLI setting `nav_extra_arming_safety = ON` is used, this may caused reasons shown in the [table below](#navigation-unsafe-reasons) |
| `COMPASS_NOT_CALIBRATED` | The compass is not calibrated. Perform the calibration procedure |
| `ACCELEROMETER_NOT_CALIBRATED` | The accelerometer is not calibrated. Perform the 6 point calibration procedure |
| `ARM_SWITCH` | The arm switch was engaged as the FC booted |
| `HARDWARE_FAILURE` | A required hardware device has failed / is not recognised (e.g. GPS, Compass, Baro) |
| `BOXFAILSAFE` | A failsafe switch is engaged |
| `BOXKILLSWITCH` | A kill switch is engaged |
| `RC_LINK` | The RC link is not detected (RX not detected) |
| `THROTTLE` | The throttle setting is not a minimum |
| `CLI` | The CLI is active |
| `CMS_MENU` | The CMS menu is active |
| `OSD_MENU` | The OSD menu is active |

### Navigation Unsafe reasons

| Navigation Unsafe |
| ------------------ |
| The GPS has insufficient satellites |
| A navigation switch is engaged (e.g.PH, WP, RTH) |

## Waypoints will not execute

The pilot *thinks* that they have loaded a waypoint mission, but the mission will not execute when the assigned switch is engaged.

* No mission is actually loaded into the FC. Note that waypints have to be in volatile memory (that is cleared on powercycle), not in EEPROM. If waypoints have been saved to EEPROM it is necessary to restore the WPs to volatile memory before the mission can be executed. 

* The first waypoint is beyond the distance defined by the CLI setting `nav_wp_safe_distance`. The default is 100m (10000cm, as the value is entered in cm).

	```
	# get nav_wp_safe_distance
	nav_wp_safe_distance = 10000
	Allowed range: 0 - 65000
	``` 

## Diagnostics

Diagnosing arming failure and WP execution failure often requires the use of a tool external the FC, the following may help:

* The iNav configurator displays reasons for arming failure
* The iNav CLI (available from a terminal, the configurator and many ground-stations) displays arming disabled reasons:

	```
	# status
	...
	Arming disabled flags: NAV HWFAIL RX CLI
	```
* A ground station may provide diagnostics, for example [mwp](https://github.com/stronnag/mwptools) provides an 'Arming Disabled' alert icon with 'popover' description / explanation, mission upload validation checks and 'first WP distance' exceeded warnings.
* **Your favourite diagnostic tool / technique goes here**
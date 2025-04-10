**This page is a work in progress until this message is removed**

The aim of this page is to separate the tuning of the FW Navigation PIDs from the [Navigation modes](https://github.com/iNavFlight/inav/wiki/Navigation-modes) page. Its goal is also to have FW Nav PID tuning separate from MC Nav PID tuning. To de-clutter and make for easier reading.

>[!Note]
>There is also a companion wiki page [GPS and Compass setup](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup), that is essential reading beforehand. The _Installation location_, _Setup_ and _Calibration_ of the GNSS/Magnetometer module, to providing the best navigation performance achievable, is of absolute importance.
Accounting for this detail can make your build a greater success, especially when using a magnetometer.

- [ALTITUDE PID TUNING](#Tuning-Altitude-Controller---Z-axis)
- [POSITION PID TUNING](#Tuning-Position-Controller---XY-axis)
- [RANGE-FINDER TUNING](#Tuning-Rangefinder)

>[!Caution]
> When tuning all navigation PID's. Bear in mind, over-tuning their gains will not react as abruptly as over-tuning the main stabilization PID's, which will lead to oscillations on that axis. Instead, over-tune and saturating the navigation `POS_XY` PID gains, will in-effect provide a poorer control response, equivalent to under-tuning those same gains. While over-tuning `VEL_Z` and `Heading` PID gains can lead to slower control oscillations. Log data should be used to assess flight performance.  
>**The Main Stabilization _PID_FF_ and _LEVEL_ controllers MUST be tuned before attempting to tune the navigation controllers. This is because the output from the navigation controllers are place into action through the main stabilization PID controllers. With incorrect or over-tuned FeedForward, noticeable impacting navigation performance.**


## Tuning Altitude Controller - Z axis:
**Inability to obtain an accurate target altitude or climb rate can be caused by a number of reasons:**
- Poor GNSS satellite accuracy and EPH position data - _Ensure you have a HDOP less than 1.2 for best precision. And never above 1.8._
- Main stabilization **PID_FF** and **LEVEL** is poorly tuned. Or incorrectly set control surface throws or C.G. - _Setup hardware and Tune main PID's first._
- Insufficient motor thrust - The airplanes thrust to weight ratio is too low.
- Insufficient POS_Z_P, POS_Z_I or too much POS_Z_D and/or FW_FF_PITCH - _Only if all the previous conditions are satisfied._


**Keep in mind that tuning cannot fix:**
- Poor GNSS precision - [See here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#installing-the-gnss-unit---antenna-orientation) 
- High accelerometer vibrations from the motor(s) or prop(s).

**Make sure these hardware conditions are addressed first, before you even attempt to tune the navigation VEL PID's and climb rate settings.**

### ALTITUDE VEL (pos) PID Tuning:
**Altitude is always referred too as the vertical or (Z) axis.**

Tuning of an airplanes Z axis is best performed on a days no colder than 5°C, for the best outcome. Due to the effect temperature has on the Baro and IMU.

_The following settings can be accessed using the Configurator **Tuning tab** and **Advanced Tuning tab**. Or the CLI and CMS OSD stick menu's._
- `nav_fw_pos_z_p`
- `nav_fw_pos_z_i`
- `nav_fw_pos_z_d`
-  `nav_fw_pos_z_ff`
- `nav_fw_alt_control_response`
- `fw_ff_pitch`
- `nav_fw_auto_climb_rate`

**These settings should also be configured or tweaked to suit your aircraft. This will assist the Velocity Z controller.** 

- `nav_fw_climb_angle`
- `nav_fw_dive_angle`
- `nav_fw_pitch2thr_smoothing`
- `nav_fw_pitch2thr_threshold`
- `nav_fw_manual_climb_rate`
- `nav_fw_min_thr` 
- `nav_fw_cruise_thr`
- `nav_fw_max_thr` 
- `fw_level_pitch_trim`

## Tuning Position Controller - XY axis:

**Inability to obtain an accurate horizontal position can be caused by a number of reasons:**
- Poor GNSS satellite accuracy and EPH position data - _Ensure you have a HDOP less than 1.2 for best precision. And never above 1.8._
- Main stabilization **PID_FF** and **LEVEL** is poorly tuned. Or incorrectly set control surface throws or C.G.- _Setup hardware and Tune main PID's first._
- Poorly Installed, Aligned or Calibrated magnetometer (compass) - _If a magnetometer is used, read [here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#setting-up-the-compass-alignment) to provide the best results._
- Insufficient POS_XY_P, POS_XY_I or POS_HDG_P if [nav_use_fw_yaw_control ](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_use_fw_yaw_control) = ON - _Only if all the previous conditions are satisfied._
- These [settings](https://github.com/iNavFlight/inav/wiki/Navigation-modes#fixed-wing-waypoint-tracking-accuracy-and-turn-smoothing) can also influence fixed position tracking.

**Keep in mind that tuning cannot fix:**
- Poor GNSS precision - [See here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#installing-the-gnss-unit---antenna-orientation) 
- High accelerometer vibrations from the motor(s) or prop(s). Or a poorly aligned or calibrated Magnetometer, if installed.

**Make sure these hardware conditions are addressed first, before you even attempt to tune the navigation POS, VEL and HEADING PID's.**

Tuning of copter XY axis is best performed on a day no colder than 5°C. This is due to the effect temperature has on the IMU.

### Horizontal POS + HEADING PID Tuning: 
 _The following settings can be accessed using the Configurator **Tuning tab** and **Advanced Tuning tab**. Or the CLI and CMS OSD stick menu's._


**Position XY gains:**
- `nav_fw_pos_xy_p` - Controls how fast the airplane will attempt to use the roll and yaw axis to align its trajectory with the target position. 
- `nav_fw_pos_xy_i` - Increasing this gain can compensation for trajectory drift, caused by the wind. But should be used sparingly.
- `nav_fw_pos_xy_d` - Increasing this gain can help smooth the P gain response. But if increased too much, it can cause over-shooting of the position trajectory alignment. Should also be used sparingly.
- `nav_fw_cruise_thr` - Should be set to the airplanes optimal cruise speed. While keeping the average airspeed less than 75km/h, to obtain the highest target position accuracy. 


**Heading gains:**
- `nav_mc_heading_p` - Controls the strength of which the yaw axis will track the IMU's Compass derived heading target. 
- `nav_use_fw_yaw_control`- When enabled, allows the use of the heading controller settings below, for a fixedwing.
- `nav_fw_pos_hdg_p` - Sets the strength of which the heading trajectory target is tracked.
- `nav_fw_pos_hdg_i` - When used sparingly, it can filter-out heading target drift.
- `nav_fw_pos_hdg_d` - Can smooth abrupt heading irregularity. But better suited to aircraft that have a means of yaw control.
- `heading_hold_rate_limit` - Limits the yaw induced rotation rate that HEADING_HOLD controller can request from PID controller inner
loop. It's independent from manual yaw rate and used only when HEADING_HOLD NAV flight modes are in use.


## Tuning Rangefinder:

**The Rangefinder (surface) gains should only be tuned after the XYZ navigation PID's are optimally tuned.**

**Rangefinder** - Lidar or Sonar altitude terrain settings and sensor weights:
- `rangefinder_median_filter` - Enables a 3-point median filter to helps smooth out altitude variations in the readout.
- `inav_max_surface_altitude` - Maximum allowed distance in [CM] above the surface of the ground, for altitude tracking.
- `inav_w_z_surface_p` - Weight applied to the Rangefinders estimated _altitude_. When a rangefinder is present, within its operational distance above the ground. 
- `inav_w_z_surface_v` - Weight applied to the Rangefinders estimated _climb rate_. When a rangefinder is present, within its operational distance above the ground.

**Optical-flow is not recommended for fixedwing use, due to the speed airplanes travel across the ground. And the inherent inaccuracy of Optical Flow under such conditions and diverse terrain.**



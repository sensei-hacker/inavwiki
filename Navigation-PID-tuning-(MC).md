 **This page is a work in progress until this message is removed**

The aim of this page is to separate the tuning of the MC Navigation PIDs from the [Navigation modes](https://github.com/iNavFlight/inav/wiki/Navigation-modes) page. Its goal is also to have MC Nav PID tuning separate from FW Nav PID tuning. To de-clutter and make for easier reading.

>[!Note]
>There is also a companion wiki page [GPS and Compass setup](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup), that is essential reading beforehand. The _Installation location_, _Setup_ and _Calibration_ of the GNSS/Magnetometer module, to providing the best navigation performance achievable, is of absolute importance.
Accounting for this detail can make your build a great success, or a disappointment if not done correctly.

- [ALTITUDE PID TUNING](#Tuning-Altitude-Controller---Z-axis)
- [RANGE-FINDER OPTICAL-FLOW TUNING](#Tuning-Altitude-Controller-Rangefinder)
- [POSITION PID TUNING](#Tuning-Position-Controller---XY-axis)


## Tuning Altitude Controller - Z axis:

**Inability to maintain altitude can be caused by a number of reasons:**
- Insufficient ALT_P, ALT_I and/or VEL_P, VEL_I
- Non-functional barometer - _Go to the Configurator "_Sensors_" tab and verify that barometer graph changes as you move the copter up and down._
- Poor GNSS satellite accuracy and EPV altitude data - _Ensure you have a HDOP less than 1.2 for best precision. And never above 1.8._
- Seriously under-powered copter - _ALTHOLD is only able to compensate to some degree. If your copter hovers at 1700 linear throttle without any expo, ALTHOLD might fail to compensate._
- Gaining altitude during fast flight - _Can be caused by increased air pressure being applied to the barometer. This is measured as a reduction in altitude - Try covering your barometer with open-cell foam._

**Keep in mind that tuning cannot fix:**
- Bad barometer isolation 
- Poor GNSS precision - [See here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#installing-the-gnss-unit---antenna-orientation) 
- High accelerometer vibrations from the motors or props.

**Make sure these hardware conditions are addressed first, before you even attempt to tune the nav Altitude POS and VEL PID's.**

_The following values can be accessed using the Configurator CLI or PID  Tuning tab. Or by the CMS OSD stick menu's._

**Altitude is always referred too as the vertical or (Z) axis**

- ALT P `nav_mc_pos_z_p` - defines how fast copter will attempt to compensate for altitude error (converts alt error to desired climb rate)
- ALT I `nav_mc_auto_climb_rate` - defines how fast copter will accelerate to reach desired climb rate 
- VEL P `nav_mc_vel_z_p` - defines how much throttle copter will add to achieve desired acceleration
- VEL I  `nav_mc_vel_z_i` - controls compensation for hover throttle (and vertical air movement, thermals). This can essentially be zero if hover throttle is precisely 1500us. Too much VEL I will lead to vertical oscillations, too low VEL I will cause drops or jumps when ALTHOLD is switched on.
- VEL D `nav_mc_vel_z_d` - acts as a dampener for VEL P and VEL I, will slower the response and reduce oscillations from too high VEL P and VEL I

If ALT P `nav_mc_pos_z_p` and ALT I `nav_mc_auto_climb_rate` have been set to zero (0) during the PID adjustments, setting ALT P `nav_mc_pos_z_p` to a non-zero value (>100), will have the effect of changing the ALTHOLD altitude using the throttle. Once again, the easiest trial and error testing is done through the INAV OSD while in the field. Or inflight tuning while in the air.


### ALTITUDE POS + VEL PID Tuning

Try a small experiment: Make sure the barometer is well isolated. You may also want to reduce baro weight. 

INAV copter tuning is best performed on a day no colder than 10°C. Due to the effect temperature has on the Baro and IMU.

- set `inav_w_z_baro_p = 0.5` and  ALT P `nav_mc_pos_z_p = 0` and try flying. This way the controller will attempt to keep zero climb rate without any reference to altitude. The quad should slowly drift either up or down. If it would be jumping up and down, your VEL `nav_mc_vel_z` gains are too high.

- As a second step you can try zeroing out VEL P `nav_mc_vel_z_p` and VEL I `nav_mc_vel_z_i` and set VEL D `nav_mc_vel_z_d = 100`. Now the quad should be drifting up/down even slower. Raise VEL D `nav_mc_vel_z_d` to the edge of oscillations.

- Now raise VEL P `nav_mc_vel_z_p` to the edge of oscillations. Now ALTHOLD should be almost perfect

- And finally set `nav_mc_hover_thr` slightly higher/lower (50 - 100uS) than your actual hover throttle and tune VEL I `nav_mc_vel_z_i`. The copter should be able to compensate. 

If copter is buzzing or slightly oscillating while ALTHOLD is active in any navigation mode, try lowering VEL P `nav_mc_vel_z_p` a bit.

What is the trick with VEL I `nav_mc_vel_z_i` ?
It is used to compensate for `nav_mc_hover_thr` (hover throttle) being set to a slightly incorrect value. You can't set hover throttle to an exact value, there is always influence from thermals, battery charge level etc. Too much VEL I `nav_mc_vel_z_i` will lead to vertical oscillations, if its too low  will cause drops or jumps when ALTHOLD is enabled. Very low VEL I `nav_mc_vel_z_i` can result in total inability to maintain altitude.

To deal with oscillations you can try lowering your ALT P `nav_mc_pos_z_p`, VEL P `nav_mc_vel_z_p`, and/or "ALT I `nav_mc_auto_climb_rate`, and `nav_mc_manual_climb_rate`.

Climb rate is calculated from the readings of the accelerometer, barometer and from GNSS velocity NED. The average strength of these noisy signals are taken into account, to estimate the mean altitude. Fusion filter weights in INAV are set by:
- `inav_w_z_baro_p = 0.350`
- `inav_w_z_gps_p = 0.200`
- `inav_w_z_gps_v = 0.100` for vertical (z) position and velocity. 

Too high `inav_w_z_baro_p` will make ALTHOLD nervous, and setting it too low will make it drift, so you risk running into the ground when cruising around. Using GNSS data for vertical velocity allows for a lower barometer weight to make ALTHOLD smoother without making it less accurate.
These weights should only be adjusted if you have a firm grasp of their relationship. Small adjustment can cause a large changes. Which can make things worse, if not tested under many atmospheric condition.


### Tuning Altitude Controller Rangefinder:

**Rangefinder** - Lidar or Sonar altitude terrain settings and sensor weights:
- [nav_max_terrain_follow_alt](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_max_terrain_follow_alt)
- [rangefinder_median_filter](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#rangefinder_median_filter)
- [inav_max_surface_altitude](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#inav_max_surface_altitude)
- [inav_w_z_surface_p](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#inav_w_z_surface_p)
- [inav_w_z_surface_v](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#inav_w_z_surface_v)

**Optical-flow** - Terrain motion sensor weights:
- [inav_w_xy_flow_p](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#inav_w_xy_flow_p)
- [inav_w_xy_flow_v](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#inav_w_xy_flow_v)


## Tuning Position Controller - XY axis:

**Inability to obtain an accurate horizon position can be caused by a number of reasons:**
- Poor GNSS satellite accuracy and EPH Position data - _Ensure you have a HDOP less than 1.2 for best precision. And never above 1.8._
- Main stabilization **PID_CD** and **LEVEL** is poorly tuned. Or the Copter has a low thrust to weight ratio - **The main PID's should be optimally tune first**
- Poorly Installed, Aligned or Calibrated magnetometer (compass) - _If a magnetometer is used, read [here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#setting-up-the-compass-alignment) to provide the best results._
- Insufficient POS_P and/or VEL_P, VEL_I, VEL_D- _Only if all the previous conditions are satisfied._
- Multicopters velocity or bank angle is too high - _Lowering the `nav_mc_bank_angle` and `nav_auto_speed` will help to acquire the target position, especially when windy._

**Keep in mind that tuning cannot fix:**
- Poor GNSS precision - [See here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#installing-the-gnss-unit---antenna-orientation) 
- High accelerometer vibrations from the motors, props or frame-resonance.

**Make sure these hardware conditions are addressed first, before you even attempt to tune the navigation POS, VEL and HEADING PID's.**

INAV copter tuning is best performed on a day no colder than 10°C. This is due to the effect temperature has on the IMU.

**Position PID's:**
- [nav_mc_pos_xy_p](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_pos_xy_p) 

**Velocity PID's:**
- [nav_mc_vel_xy_p](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_vel_xy_p)
- [nav_mc_vel_xy_i](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_vel_xy_i)
- [nav_mc_vel_xy_d](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_vel_xy_d)
- [nav_mc_vel_xy_ff](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_vel_xy_ff)
- [nav_mc_vel_xy_dterm_attenuation](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_vel_xy_dterm_attenuation)
- [nav_mc_vel_xy_dterm_attenuation_start](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_vel_xy_dterm_attenuation_start)
- [nav_mc_vel_xy_dterm_attenuation_end](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_vel_xy_dterm_attenuation_end)
- [nav_mc_vel_xy_dterm_lpf_hz](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_vel_xy_dterm_lpf_hz)

**Heading:**
- [nav_mc_heading_p](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_heading_p)

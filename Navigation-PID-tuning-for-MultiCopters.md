 **This page is a work in progress until this message is removed**

The aim of this page is to separate the tuning of the MC Navigation PIDs from the [Navigation modes](https://github.com/iNavFlight/inav/wiki/Navigation-modes) page. Its goal is also to have MC Nav PID tuning separate from FW Nav PID tuning. To de-clutter and make for easier reading.

>[!Note]
>There is also a companion wiki page, that is essential reading beforehand. The Installation location, Setup and Calibration of the GNSS/Magnetometer module, to providing the best navigation performance achievable, is absolutely essential [GPS and Compass setup](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup).
Accounting for this detail can make your build a great success, or not so much.

**Inability to maintain altitude can be caused by a number of reasons:**
- Insufficient ALT_P and/or ALT_I
- Non-functional barometer - _Go to the Configurator "_Sensors_" tab and verify that barometer graph changes as you move the copter up and down._
- Poor GNSS satellite accuracy and EPV altitude data - _Ensure you have a HDOP less than 1.2 for best precision. And never above 1.8._
- Seriously under-powered copter - _ALTHOLD is only able to compensate to some degree. If your copter hovers at 1700 linear throttle without any expo, ALTHOLD might fail to compensate._
- Gaining altitude during fast flight - _Can be caused by increased air pressure being applied to the barometer. This is measured as a reduction in altitude - Try covering your barometer with open-cell foam._

**Keep in mind that tuning cannot fix:**
- Bad barometer isolation 
- Poor GNSS precision - [See here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#installing-the-gnss-unit---antenna-orientation) 
- High accelerometer vibrations from the motors or props.

Make sure these hardware conditions are addressed first, before you even attempt to tune the nav PID's.

### Tuning Altitude Controller (Z) PID's :

_The following values can be accessed using the Configurator CLI or PID  Tuning tab. Or by the CMS OSD stick menu's._

**Altitude is always referred too as the vertical or (Z) axis**

- ALT P `nav_mc_pos_z_p` - defines how fast copter will attempt to compensate for altitude error (converts alt error to desired climb rate)
- ALT I `nav_mc_auto_climb_rate` - defines how fast copter will accelerate to reach desired climb rate
- VEL P `nav_mc_vel_z_p` - defines how much throttle copter will add to achieve desired acceleration
- VEL I  `nav_mc_vel_z_i` - controls compensation for hover throttle (and vertical air movement, thermals). This can essentially be zero if hover throttle is precisely 1500us. Too much VEL I will lead to vertical oscillations, too low VEL I will cause drops or jumps when ALTHOLD is switched on.
- VEL D `nav_mc_vel_z_d` - acts as a dampener for VEL P and VEL I, will slower the response and reduce oscillations from too high VEL P and VEL I

If ALT P `nav_mc_pos_z_p` and ALT I `nav_mc_auto_climb_rate` have been set to zero (0) during the PID adjustments, setting ALT P `nav_mc_pos_z_p` to a non-zero value (>100), will have the effect of changing the ALTHOLD altitude using the throttle. Once again, the easiest trial and error testing is done through the INAV OSD while in the field. Or inflight tuning while in the air.


### ALTITUDE POS + VEL PID Tuning

Try a small experiment: Make sure the barometer is well isolated. You may also want to reduce baro weight. With this ideally being performed on a day no colder than 10°C.
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


### Tuning Altitude Controller Rangefinder (Z) PID's :
 Still to come.


### Tuning Position Controller (XY) PID's :
 Still to come.
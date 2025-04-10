 **This page is a work in progress until this message is removed**

The aim of this page is to separate the tuning of the MC Navigation PIDs from the [Navigation modes](https://github.com/iNavFlight/inav/wiki/Navigation-modes) page. Its goal is also to have MC Nav PID tuning separate from FW Nav PID tuning. To de-clutter and make for easier reading.

>[!Note]
>There is also a companion wiki page [GPS and Compass setup](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup), that is essential reading beforehand. The _Installation location_, _Setup_ and _Calibration_ of the GNSS/Magnetometer module, to providing the best navigation performance achievable, is of absolute importance.
Accounting for this detail can make your build a great success, or a disappointment if not done correctly.

- [ALTITUDE PID TUNING](#Tuning-Altitude-Controller---Z-axis)
- [POSITION PID TUNING](#Tuning-Position-Controller---XY-axis)
- [RANGE-FINDER OPTICAL-FLOW TUNING](#Tuning-Rangefinder-Flow)

>[!Caution]
> When tuning all navigation PID's. Bear in mind, over-tuning their gains will not react in the same way as over-tuning the main stabilization PID's, which will lead to oscillations on that axis. Instead, over-tune and saturating the navigation PID gains, will in effect provide a poorer control response, equivalent to under-tuning those same gains. Log data must be used.  
>**The Main Stabilization _PID_CD_ and _LEVEL_ controllers MUST be tuned before attempting to tune the navigation controllers. This is because the output from the navigation controllers are place into action through the main stabilization PID controllers.**


## Tuning Altitude Controller - Z axis:

**Inability to maintain altitude can be caused by a number of reasons:**
- Insufficient ALT_P, ALT_I and/or VEL_P, VEL_I
- Non-functional barometer - _Go to the Configurator "_Sensors tab_" and verify that barometer graph changes as you move the copter up and down._
- Poor GNSS satellite accuracy and EPV altitude data - _Ensure you have a HDOP less than 1.2 for best precision. And never above 1.8._
- Seriously under-powered copter - _ALTHOLD is only able to compensate to some degree. If your copter hovers at 1700 linear throttle without any expo, ALTHOLD might fail to compensate._
- Gaining altitude during fast flight - _Can be caused by increased air pressure being applied to the barometer. This is measured as a reduction in altitude - Try covering your barometer with open-cell foam._

**Keep in mind that tuning cannot fix:**
- Bad barometer isolation 
- Poor GNSS precision - [See here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#installing-the-gnss-unit---antenna-orientation) 
- High accelerometer vibrations from the motors or props.

**Make sure these hardware conditions are addressed first, before you even attempt to tune the nav Altitude POS and VEL PID's.**

_The following settings can be accessed using the Configurator CLI or **Tuning tab** under **Additional PID Gains**. Or by the CMS OSD stick menu's._

**Altitude is always referred too as the vertical or (Z) axis.**

- ALT P `nav_mc_pos_z_p` - defines how fast copter will attempt to compensate for altitude error (converts alt error to desired climb rate)
- ALT I `nav_mc_auto_climb_rate` - defines how fast copter will accelerate to reach desired climb rate 
- VEL P `nav_mc_vel_z_p` - defines how much throttle the copter will add to achieve desired acceleration
- VEL I  `nav_mc_vel_z_i` - controls compensation for hover throttle (and vertical air movement, thermals). This can essentially be zero if hover throttle is precisely 1500us. Too much VEL I will lead to vertical oscillations, too low VEL I will cause drops or jumps when ALTHOLD is switched on.
- VEL D `nav_mc_vel_z_d` - acts as a dampener for VEL P and VEL I, will slower the response and reduce oscillations from too high VEL P and VEL I

If ALT P `nav_mc_pos_z_p` and ALT I `nav_mc_auto_climb_rate` have been set to zero (0) during the PID adjustments, setting ALT P `nav_mc_pos_z_p` to a non-zero value (>100), will have the effect of changing the ALTHOLD altitude using the throttle. Once again, the easiest trial and error testing is done through the INAV OSD while in the field. Or inflight tuning while in the air.


### ALTITUDE POS + VEL PID Tuning:

Try a small experiment: Make sure the barometer is well isolated. You may also want to reduce baro weight. 

Tuning of copter z axis is best performed on a day no colder than 10°C. Due to the effect temperature has on the Baro and IMU.

- set `inav_w_z_baro_p = 0.5` and  ALT P `nav_mc_pos_z_p = 0` and try flying. This way the controller will attempt to keep zero climb rate without any reference to altitude. The quad should slowly drift either up or down. If it would be jumping up and down, your VEL `nav_mc_vel_z` gains are too high.

- As a second step you can try zeroing out VEL P `nav_mc_vel_z_p` and VEL I `nav_mc_vel_z_i` and set VEL D `nav_mc_vel_z_d = 100`. Now the quad should be drifting up/down even slower. Raise VEL D `nav_mc_vel_z_d` to the edge of oscillations.

- Now raise VEL P `nav_mc_vel_z_p` to the edge of oscillations. Now ALTHOLD should be almost perfect

- And finally set `nav_mc_hover_thr` slightly higher/lower (50 - 100uS) than your actual hover throttle and tune VEL I `nav_mc_vel_z_i`. The copter should be able to compensate. 

If the copter is buzzing or slightly oscillating while ALTHOLD is active, or in any navigation mode, try lowering VEL P `nav_mc_vel_z_p` a little.

What is the trick with VEL I `nav_mc_vel_z_i` ?
It is used to compensate for `nav_mc_hover_thr` (hover throttle) being set to a slightly incorrect value. You can't set hover throttle to an exact value, there is always influence from thermals, battery charge level etc. Too much VEL I `nav_mc_vel_z_i` will lead to vertical oscillations, if its too low  will cause drops or jumps when ALTHOLD is enabled. Very low VEL I `nav_mc_vel_z_i` can result in total inability to maintain altitude.

To deal with oscillations you can try lowering your ALT P `nav_mc_pos_z_p`, VEL P `nav_mc_vel_z_p`, and/or "ALT I `nav_mc_auto_climb_rate`, and `nav_mc_manual_climb_rate`.

Climb rate is calculated using sensor data from the Accelerometer, Barometer and GNSS velocity NED. The average strength of these noisy signals are taken into account, to estimate the mean altitude. INAV sensor fusion weights are set by:
- `inav_w_z_baro_p = 0.350`
- `inav_w_z_gps_p = 0.200`
- `inav_w_z_gps_v = 0.100` for vertical (z) position and velocity. 

Too high `inav_w_z_baro_p` will make ALTHOLD nervous, and setting it too low will make it drift, so you risk running into the ground when cruising around. Using GNSS data for vertical velocity can allow you to lower the barometer weight to make ALTHOLD smoother without making it less accurate. But ONLY if your build consistently provides high GNSS sensor accuracy on every power-up.
These weights should only be adjusted if you have a firm grasp of their relationship. Small adjustments can make a significant difference, and has the potential to make things worse, if not tested under different atmospheric conditions.


## Tuning Position Controller - XY axis:

**Inability to obtain an accurate horizontal position can be caused by a number of reasons:**
- Poor GNSS satellite accuracy and EPH position data - _Ensure you have a HDOP less than 1.2 for best precision. And never above 1.8._
- Main stabilization **PID_CD** and **LEVEL** is poorly tuned. Or the Copter has a low thrust to weight ratio - _Tune main PID's first._
- Poorly Installed, Aligned or Calibrated magnetometer (compass) - _If a magnetometer is used, read [here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#setting-up-the-compass-alignment) to provide the best results._
- Insufficient POS_P and/or VEL_P, VEL_I, VEL_D- _Only if all the previous conditions are satisfied._
- Multicopters velocity or bank angle is too high - _Lowering the `nav_mc_bank_angle` and `nav_auto_speed` will help to acquire the target position, especially when windy._

**Keep in mind that tuning cannot fix:**
- Poor GNSS precision - [See here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#installing-the-gnss-unit---antenna-orientation) 
- High accelerometer vibrations from the motors, props or frame-resonance.

**Make sure these hardware conditions are addressed first, before you even attempt to tune the navigation POS, VEL and HEADING PID's.**

Tuning of copter XY axis is best performed on a day no colder than 10°C. This is due to the effect temperature has on the IMU.

### Horizontal POS + VEL + HEADING PID Tuning: 
 _The following settings can be accessed using the Configurator CLI or **Tuning tab** under **Additional PID Gains**. Or by the CMS OSD stick menu's._



**Position XY:**
- `nav_mc_pos_xy_p` - Controls how fast the copter will fly towards the target position. This is a multiplier to convert the distance to the target velocity.

**Velocity XY:**
- `nav_mc_vel_xy_p` - Controls velocity to acceleration. Increasing the gain will provide a stronger response when position error occurs. 
- `nav_mc_vel_xy_i` - Increasing this gain can compensation for position drift, caused by the wind. 
- `nav_mc_vel_xy_d` - Increasing this gain can help smooth the P gain response, and lower the chance of target overshoot.
- `nav_mc_vel_xy_ff `- Attempts to predict velocity to acceleration disturbances from sensory input, to actively reduce the controllers response time.
- `nav_mc_vel_xy_dterm_attenuation` - Attenuation of VEL_XY_D controller in %. Providing a smoother control response when the copter is navigating at speed. VEL_XY_D  is not attenuated at low speeds, braking or accelerating.
- `nav_mc_vel_xy_dterm_attenuation_start` - A point in percentage between the current horizontal velocity and the target, when VEL_XY_D attenuation begins.
- `nav_mc_vel_xy_dterm_attenuation_end`- A point in percentage between the current horizontal velocity and the target, when VEL_XY_D attenuation reaches the `nav_mc_vel_xy_dterm_attenuation` value.
- `nav_mc_vel_xy_dterm_lpf_hz` - 
Low pass filter cutoff frequency for the VEL_XY_D controller. To allow for a smoother target response when traveling at max nav speed. 

**Heading:**
- `nav_mc_heading_p` - Controls the strength of which the yaw axis will track the IMU and Compass heading target. 


## Tuning Rangefinder Flow:

**The Rangefinder (surface) and Optical-flow (flow) gains should only be tuned after the XYZ navigation PID's are optimally tuned.**

**Rangefinder** - Lidar or Sonar altitude terrain settings and sensor weights:
- `rangefinder_median_filter` - Enables a 3-point median filter to helps smooth out altitude variations in the readout.
- `inav_max_surface_altitude` - Maximum allowed distance in [CM] above the surface of the ground, for altitude tracking.
- `inav_w_z_surface_p` - Weight applied to the Rangefinders estimated altitude. Setting is used on both airplanes and multicopters when rangefinder is present, within its working distance above the ground. And/or _Surface mode_ is enabled.
- `inav_w_z_surface_v` - Weight applied to the Rangefinders estimated climb rate. Setting is used on both airplanes and multicopter when rangefinder is present, within its working distance above the ground. And/or _Surface mode_ is enabled.

**Optical-flow** - Terrain motion sensor weights:
- `nav_max_terrain_follow_alt` - Maximum allowed altitude above the ground in [CM], when tracking terrain motion.
- `inav_w_xy_flow_p` - Optical flow sensor weight measurement for XY position. Also effected by light intensity.
- `inav_w_xy_flow_v `- Optical flow sensor weight measurement for XY velocity. Also effected by light intensity and the texture of the terrain.


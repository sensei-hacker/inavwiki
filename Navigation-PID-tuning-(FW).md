**This page is a work in progress until this message is removed**

The aim of this page is to separate the tuning of the FW Navigation PIDs from the [Navigation modes](https://github.com/iNavFlight/inav/wiki/Navigation-modes) page. Its goal is also to have FW Nav PID tuning separate from MC Nav PID tuning. To de-clutter and make for easier reading.

>[!Tip]
>There is also a companion wiki page [GPS and Compass setup](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup), that is essential reading beforehand. The _Installation location_, _Setup_ and _Calibration_ of the GNSS/Magnetometer module, to providing the best navigation performance achievable, is of absolute importance.
Accounting for this detail can make your build a greater success, especially when using a magnetometer.

- [ALTITUDE PID TUNING](#Tuning-Altitude-Controller---Z-axis)
- [POSITION PID TUNING](#Tuning-Position-Controller---XY-axis)
- [RANGE-FINDER TUNING](#Tuning-Rangefinder)

>[!Caution] 
>**The Main Stabilization _PID_FF_ and _LEVEL_ controllers MUST be tuned well before attempting to tune the navigation controllers. This is because the output from the navigation controllers are place into action through the main stabilization PID controllers. With incorrect or over-tuned FeedForward, noticeable impacting navigation performance.**


## Tuning Altitude Controller - Z axis:
**Inability to obtain an accurate target altitude or climb rate can be caused by a number of reasons:**
- Poor GNSS satellite accuracy and EPV position data - _Ensure you have a HDOP less than 1.2 for best precision. And never above 1.8. [See here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#installing-the-gnss-unit---antenna-orientation)_ 
- Main stabilization **PID_FF** and **LEVEL** is poorly tuned. Or incorrectly set control surface throws or C.G. - _Setup hardware and Tune main PID's first._
- Insufficient motor thrust - _The airplanes thrust to weight ratio is too low._
- High accelerometer vibrations from the motor(s) or prop(s).
- Insufficient POS_Z_P, POS_Z_I or too much POS_Z_D and/or FW_FF_PITCH - _Only if all the previous conditions are satisfied._

**Make sure these hardware conditions are addressed first, before you even attempt to tune the navigation VEL PID's and climb rate settings.**

### ALTITUDE POS(`VEL`) PID Tuning:
**Altitude is always referred too as the vertical or (Z) axis.**

Tuning of an airplanes Z axis controller should be done on a day no colder than 5°C, for the best outcome. Due to the effect temperature has on the Baro and IMU.

_The following settings can be accessed using the Configurator **Tuning tab** and **Advanced Tuning tab**. Or the CLI and CMS OSD stick menu's._
- `nav_fw_pos_z_p` - Controls velocity to acceleration. Increasing the gain will provide a stronger elevator/pitch2throttle response to reach the required altitude target.
- `nav_fw_pos_z_i` - Attempts to compensate for climb rate fluctuations cause by turbulence, thermals etc. Use sparingly. It can only do so much on a fixedwing platform.
- `nav_fw_pos_z_d` - Attempts to smooth the POS(`VEL`)_Z_P and POS(`VEL`)_Z_I rate of response. Too much damping can weaken the response, leading to oscillations around the altitude target. Even becoming more exaggerated by an over-tuned `fw_ff_pitch` response.
- `nav_fw_pos_z_ff` - Attempts to provide a faster control response to the require target, based on altitude and gyro rate data. Depending on the aircraft's build specifics. Lowering POS_Z_D and increasing POS_Z_FF can help.
- `nav_fw_alt_control_response` - Alters the altitude control response as the airplane gets closer to reaching the altitude target.
- `fw_ff_pitch` - Passes the angular rate target directly to the servo mixer, bypassing the gyro PID loop stabilization.
- `nav_fw_auto_climb_rate`- Maximum climb/descent rate in [cm/s], the airplane is allowed to reach in modes that control altitude.

**These settings should also be configured or tweaked to suit your aircraft. This will assist the Velocity Z controller.** 

- [nav_fw_climb_angle](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_climb_angle)
- [nav_fw_dive_angle](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_dive_angle)
- [nav_fw_pitch2thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_pitch2thr)
- [nav_fw_pitch2thr_smoothing](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_pitch2thr_smoothing)
- [nav_fw_pitch2thr_threshold](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_pitch2thr_threshold)
- [nav_fw_manual_climb_rate](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_manual_climb_rate)
- [nav_fw_min_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_min_thr) 
- [nav_fw_cruise_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_cruise_thr)
- [nav_fw_max_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_max_thr) 
- [fw_level_pitch_trim](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#fw_level_pitch_trim)

## Tuning Position Controller - XY axis:

**Inability to obtain an accurate horizontal position can be caused by a number of reasons:**
- Poor GNSS satellite accuracy and EPH position data - _Ensure you have a HDOP less than 1.2 for best precision. And never above 1.8._  [See here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#installing-the-gnss-unit---antenna-orientation) 
- Main stabilization **PID_FF** and **LEVEL** is poorly tuned. Or incorrectly set control surface throws or C.G.- _Setup hardware and Tune main PID's first._
- Poorly Installed, Aligned or Calibrated magnetometer (compass) - _If a magnetometer is used, read [here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#setting-up-the-compass-alignment) to provide the best results._
- Insufficient POS_XY_P, POS_XY_I or POS_HDG_P if [nav_use_fw_yaw_control ](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_use_fw_yaw_control) = ON - _Only if all the previous conditions are satisfied._
- These [settings](https://github.com/iNavFlight/inav/wiki/Navigation-modes#fixed-wing-waypoint-tracking-accuracy-and-turn-smoothing) can also influence fixed position tracking.
- High accelerometer vibrations from the motor(s) or prop(s). - _Can lead to attitude and heading reference drift._

**Make sure these hardware conditions are addressed first, before you even attempt to tune the navigation POS, VEL and HEADING PID's.**

Tuning of an airplanes XY axis controllers should be done on a day no colder than 5°C, for the best outcome. This is due to the effect temperature has on the IMU.

### Horizontal POS + HEADING PID Tuning: 
 _The following settings can be accessed using the Configurator **Tuning tab** and **Advanced Tuning tab**. Or the CLI and CMS OSD stick menu's._


**Position XY gains:**
- `nav_fw_pos_xy_p` - Controls how fast the airplane will attempt to use the roll and yaw axis to align its trajectory with the target position. 
- `nav_fw_pos_xy_i` - Increasing this gain can compensation for trajectory drift, caused by the wind. But should be used sparingly.
- `nav_fw_pos_xy_d` - Increasing this gain can help smooth the P gain response. But if increased too much, it can cause over-shooting of the position trajectory alignment. 
- `nav_fw_cruise_thr` - Should be set to the airplanes optimal cruise speed. While keeping the average airspeed less than 75km/h, to obtain the highest target position accuracy. 


**Heading gains:**
- `nav_use_fw_yaw_control`- When enabled, it allows the use of the heading controller settings below, for a fixedwing.
- `nav_fw_pos_hdg_p` - Sets the strength that the heading trajectory target is tracked.
- `nav_fw_pos_hdg_i` - When used sparingly, it can filter-out heading target drift.
- `nav_fw_pos_hdg_d` - Can smooth abrupt heading irregularity. But better suited to aircraft that have a means of yaw control.
- `heading_hold_rate_limit` - Limits the yaw induced rotation rate that HEADING_HOLD controller can request from PID controller inner
loop. It's independent from manual yaw rate and used only when HEADING_HOLD NAV flight modes are in use.

_In my experience. Enabling the above heading controller combined with an airplane that has yaw control. i.e. A Rudder, Differential thrust or Vectored thrust, **when those yaw gains are tuned**. Will always provide the smoothest and most accurate turn response in a waypoint mission._

## Tuning Rangefinder:

**The Rangefinder (surface) gains should only be tuned after the XYZ navigation PID's are optimally tuned.**

**Rangefinder** - Lidar or Sonar altitude terrain settings and sensor weights:
- `rangefinder_median_filter` - Enables a 3-point median filter to helps smooth out altitude variations in the readout.
- `nav_max_terrain_follow_alt` - Maximum allowable distance above the ground for altitude tracking in [CM], that directly maps throttle to altitude.
- `inav_max_surface_altitude` - Maximum allowable altitude [CM] for the vertical position estimators validity check over a set time period.
- `inav_w_z_surface_p` - Weight applied to the Rangefinders estimated _altitude_. When a rangefinder is present, within its operational distance above the ground. 
- `inav_w_z_surface_v` - Weight applied to the Rangefinders estimated _climb rate_. When a rangefinder is present, within its operational distance above the ground.

**Optical-flow is not recommended or enabled for fixedwing use, due to the speed airplanes travel across the ground. And the inherent inaccuracy of Optical Flow under such conditions.**



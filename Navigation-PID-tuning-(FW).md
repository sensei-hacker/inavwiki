**This page is a work in progress until this message is removed**

The aim of this page is to separate the tuning of the FW Navigation PIDs from the [Navigation modes](https://github.com/iNavFlight/inav/wiki/Navigation-modes) page. Its goal is also to have FW Nav PID tuning separate from MC Nav PID tuning. To de-clutter and make for easier reading.

>[!Tip]
>There is also a companion wiki page [GPS and Compass setup](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup), that is essential reading beforehand. The _Installation location_, _Setup_ and _Calibration_ of the GNSS/Magnetometer module, to provide the best navigation performance achievable, is of absolute importance.  
Accounting for this detail can make your build a greater success. 

- [ALTITUDE PID TUNING](#Tuning-Altitude-Controller---Z-axis)
- [PITCH2THROTTLE TUNING](#Pitch2throttle-Tuning)
- [POSITION PID TUNING](#Tuning-Position-Controller---XY-axis)
- [HEADING YAW](#Heading-Yaw-Tuning---XY-axis)
- [RANGE-FINDER TUNING](#Tuning-Rangefinder)

>[!Caution] 
>**The Main Stabilization _PID_FF_, _RATES_ and _LEVEL_ controller MUST be tuned well before attempting to tune the navigation controllers.   
With incorrectly tuned FeedForward, noticeable impacting navigation performance.   
Take note of how the Rate/FF [Auto-tune](https://github.com/iNavFlight/inav/wiki/Modes#autotune-fw) process is performed.**


## Tuning Altitude Controller - Z axis:
**Inability to obtain an accurate target altitude or climb rate can be caused by a number of reasons:**
- Poor GNSS satellite accuracy and EPV position data - _Ensure you have a HDOP less than 1.2 for best precision. And never above 1.8. [See here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#installing-the-gnss-unit---antenna-orientation)_ 
- Main stabilization **PID_FF**, **RATES** and **LEVEL** is poorly tuned. Or you have incorrectly setup control surface throws and/or C.G. - _Setup hardware and Tune main PID's first._
- Insufficient motor thrust - _The airplanes thrust to weight ratio is too low._
- High accelerometer vibrations from the motor(s) or prop(s).
- If all the previous conditions are satisfied - Incorrectly tuned POS_Z_P, POS_Z_I or too much POS_Z_D and/or FW_FF_PITCH / PITCH_RATE. 

**Make sure these hardware conditions are addressed first, before you attempt to tune the navigation VEL PID's and climb rate settings.**

### ALTITUDE POS(`VEL`) PID Tuning:
**Altitude is always referred too as the vertical or (Z) axis.**

Tuning of an airplanes Z axis controller should be done on a day no colder than 5°C, for the best outcome. Due to the effect temperature has on the Baro and IMU.

_The following settings can be accessed using the Configurator **Tuning tab** and **Advanced Tuning tab**. Or the CLI and CMS OSD stick menu's._
- `nav_fw_pos_z_p` - Controls velocity to acceleration. Increasing the gain will provide a stronger elevator/pitch2throttle response to reach the required altitude target.
- `nav_fw_pos_z_i` - Attempts to compensate for climb rate fluctuations cause by turbulence, thermals etc. Use sparingly. It can only do so much on a fixedwing platform.
- `nav_fw_pos_z_d` - Attempts to anticipate the magnitude of the error and dampen the POS_Z_P and POS_Z_I response to the process variables rate of change. Too much damping can lead to the climb rate error becoming incorrectly predicted, causing oscillations when the initial climb is commanded, or when holding the target altitude. Even becoming more exaggerated by an incorrectly tuned `fw_ff_pitch` response.  
**NOTE**: _This has been altered for INAV 9.0. To use a measurement snap-shot of the process variable, instead of the variables rate of change. Which smooths the operation of the altitude Velocity and Position controllers, on a broader range of airframes and setups._
- `nav_fw_pos_z_ff` - Attempts to provide a faster control response to meet the require target, based on altitude and gyro rate data. Depending on the aircraft's build specifics, lowering POS_Z_D and increasing POS_Z_FF may help. _* Not used with the altitude POSITION controller in INAV 9.0._
- `nav_fw_alt_control_response` - Alters the altitude control response as the airplane gets closer to reaching the altitude target. Should be tuned together with POS_Z_D to get the best performance and trouble free use.
- `fw_ff_pitch` - Passes the angular rate target directly to the servo mixer, bypassing the gyro PID loop stabilization.
- `nav_fw_auto_climb_rate`- Maximum climb/descent rate in [cm/s], the airplane is allowed to reach in modes that control altitude.

### Altitude control methods:

The settings for both altitude control methods where derived from multiple testers.
This first group of settings should also work reasonably well with the 8.0 implementation of the altitude VELOCITY controller.     
When used in 9.0. The altitude VELOCITY controller is active by default. i.e. `nav_fw_alt_use_position = OFF`.   
The accuracy of both controllers are similar. With little deviation observed from a fixed altitude target.

_Functionally, the altitude VELOCITY controller is more responsive. It will push the throttle and elevator considerably harder to reach the altitude target. This makes it less power efficient. However this method can be desirable if your airplane is flying a tight WP mission or RTH trackback. When it is important to reach the altitude target quickly to clear an object._

**VELOCITY:**  
`nav_fw_pos_z_p = 22`  
`nav_fw_pos_z_i = 6`  
`nav_fw_pos_z_d = 2`  
`nav_fw_pos_z_ff = 25`   
`nav_fw_alt_control_response = 45`  

When setting `nav_fw_alt_use_position = ON` in 9.0 and later. It provides a slightly more refined version of the old altitude POSITION controller used before INAV 8.0.   

_Functionally, the altitude POSITION controller is little less responsive than the altitude Velocity controller. Which makes it more efficient when a climb is commanded. This maybe beneficial if extended flight time and power management is of importance to you._

**POSITION:**  
`nav_fw_pos_z_p = 30`  
`nav_fw_pos_z_i = 5`  
`nav_fw_pos_z_d = 11`  
`nav_fw_alt_control_response = 40`  

## Pitch2Throttle Tuning:

All the settings below work in conjunction with the [nav_fw_pitch2thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_pitch2thr) command. And effect fixedwing altitude control response.

It basically multiplies the `nav_fw_pitch2thr` by [nav_fw_climb_angle](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_climb_angle) or [nav_fw_dive_angle](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_dive_angle). To provide how many microSeconds **Auto-Throttle** will _increase_, as a result of each degree of _positive pitch angle_. Or _decrease_, as a result of each degree of _negative pitch angle_.  

[nav_fw_cruise_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_cruise_thr) is the throttle value used when the airplane is flying level, when no `nav_fw_pitch2thr` is being applied.  
`nav_fw_pitch2thr` should be tuned to works within the uS throttle constraints of [nav_fw_min_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_min_thr) and [nav_fw_max_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_max_thr).

**e.g.** If `nav_fw_pitch2thr` = 12uS **x** `nav_fw_climb_angle` = 25° = 300uS. (The same will apply to `nav_fw_dive_angle` degrees.)  
So if you have `nav_fw_cruise_thr` = 1450uS. Then you add 300uS to 1450uS = 1750uS. This means 1750uS is the maximum value `nav_fw_max_thr` will output to the motor, at a pitch climb angle of 25°.  
However, in the above example, if `nav_fw_pitch2thr` was set lower. Auto-Throttle would fall short of reaching `nav_fw_max_thr`. This is why it has to be adjusted to suit your required Dive / Climb angle and Min / Max cruise throttle range.

To reduce the likelihood of pitch bobbing or porpoising, while in modes that hold altitude. [nav_fw_pitch2thr_smoothing](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_pitch2thr_smoothing) reduces harsh Auto-Throttle response, when flying close to level.  
While [nav_fw_pitch2thr_threshold](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_pitch2thr_threshold) sets a deadband region this many decidegrees above or below level flight, for the `nav_fw_pitch2thr_smoothing` to work within.


**The settings below can also be tweaked to suit your desired rate of climb or dive. They too will alter the altitude controllers responsiveness.** 

- [nav_fw_auto_climb_rate](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_auto_climb_rate)
- [nav_fw_manual_climb_rate](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_manual_climb_rate)

## Tuning Position Controller - XY axis:

**Inability to obtain an accurate horizontal position can be caused by a number of reasons:**
- Poor GNSS satellite accuracy and EPH position data - _Ensure you have a HDOP less than 1.2 for best precision. And never above 1.8._  [See here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#installing-the-gnss-unit---antenna-orientation) 
- Main stabilization **PID_FF** and **RATES** are poorly tuned. Or incorrectly setup control surface throws and/or C.G.
- Poorly Installed, Aligned or Calibrated magnetometer (compass) - _If a magnetometer is used, read [here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#setting-up-the-compass-alignment) to provide the best results._
- High accelerometer vibrations from the motor(s) or prop(s). - _Can lead to attitude and heading inaccuracy or drift._
- If all the previous conditions are satisfied - _Incorrectly tuned POS_XY_P, POS_XY_I or POS_HDG_P if [nav_use_fw_yaw_control ](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_use_fw_yaw_control) = ON_

**Make sure these hardware conditions are addressed first, before you attempt to tune the navigation POS, VEL and HEADING PID's.**

### Horizontal POS PID Tuning: 

Tuning of an airplanes XY axis controllers should be done on a day no colder than 5°C, for the best outcome. This is due to the effect temperature has on the IMU.

_When tuning the Nav XY controllers, you require a means to reference the WP markers, to _real-time_ heading and turning positions.    
This is best done by logging the flight data. And gauging the changes with one or all of the following software's: [MWP Tools](https://github.com/stronnag/mwptools/releases) , [INAV Blackbox Explorer](https://github.com/iNavFlight/blackbox-log-viewer/releases) or [Blackbox Tools](https://github.com/iNavFlight/blackbox-tools/releases/tag/v8.0.0)_

 _The following settings can be accessed using the Configurator **Tuning tab** and **Advanced Tuning tab**. Or the CLI and CMS OSD stick menu's._


**Position XY gains:**
- `nav_fw_pos_xy_p` - Controls how fast the airplane will attempt to use the roll and yaw axis to align its trajectory with the target position. This includes the strength it will apply to turning and re-aligning with the track after a turn.
- `nav_fw_pos_xy_i` - Increasing this gain can compensate for trajectory drift caused by the wind. But should be used sparingly on elevon aircraft.
- `nav_fw_pos_xy_d` - Increasing this gain can help smooth the P gain response. But if increased too much, it can cause over-shooting of the target trajectory alignment. 
- `nav_fw_cruise_thr` - Should be set to the airplanes optimal cruise speed. Keeping the average airspeed less than 75km/h, will obtain the highest accuracy. 


## Heading Yaw Tuning - XY axis:

The first step towards the use of fixedwing yaw control is to load the appropriate Servo or Motor mixer, to suit your airframes yaw stabilization and control method. This can be found in the MIXER Tab under MIXER PRESETS.   
When the preset is selected, it will either add a Servo (**smix**)- `Stabilized Yaw` for rudder control. Or it will add two Motors (**mmix**) for differential thrust yaw control.

Fixedwing stabilization uses the [TURN ASSIST](https://github.com/iNavFlight/inav/wiki/Modes#turn-assist) feature to help maintain control over the aircraft. It is active in all navigation modes. But can be disabled in the modes tab if desired.

Fixedwing AutoTune does not operate on the yaw axis. This means the tuning has to be done [manually](https://github.com/iNavFlight/inav/wiki/Tune-INAV-PID%E2%80%90FF-controller-for-fixedwing#manually-tuning-rates-and-feedforward---how-it-works).  
The gains you derive when tuning the PID Yaw controller will differ, depending on the control method. With a Rudder inducing yaw rotation from control surface area and deflection. While Differential thrust or Vectored thrust does so actively. However a large rudder on an aerobatic 3D style airplane can also produce a considerable rotation rate.

The default `fw_p_yaw`, `fw_i_yaw`, `fw_d_yaw`, `fw_ff_yaw` and `yaw_rate` are safe values to start tuning from.  
Keep in mind that the **smix** weight and/or Servo min/max output travels will work with `fw_ff_yaw` to achieve the desired yaw rate from a Rudder.  
While the **mmix** motor yaw weight works together with `fw_ff_yaw` to achieve the desired yaw rate from Differential thrust. The default motor mixer weight for yaw is [`0.3 -0.3`]. When increasing the yaw motor mixer weight, it should be done in harmony with the setting mentioned hereafter.   
More mixer related information can be found [here](https://github.com/iNavFlight/inav/blob/master/docs/Mixer.md).

_Yaw axis tuning should only be attempted after you have first successfully tuned the airplane on the roll and pitch axis._ 

Tuning the yaw axis in ANGLE or ACRO can be made easier if you setup [inflight tuning](https://www.youtube.com/watch?v=A5i0gs9LfE8).  
Once the tuning in those modes is completed. It is important to test its operation in Navigation modes, which includes RTH. The navigation controllers can cause undesirable yaw-roll coupling if too much yaw and roll are called for at the same time. For this reason it is important to tone-down the way yaw and roll work together in turns, by altering the settings below for safer tuning -   

 `nav_fw_bank_angle = 30`  
 `nav_fw_control_smoothness = 9`    
 `heading_hold_rate_limit = 60`          
 `nav_use_fw_yaw_control = ON`  
  
Once tuned, these values may be increased incrementally if you find the airplane turns smoothly with no undesirable results.


**Heading and related gains:**
- `nav_fw_heading_p` - Sets the strength the IMU heading target will be held. Heading data is updated from the GNSS course and/or mag bearing. 
- `nav_use_fw_yaw_control`- When enabled, it will activate the fixedwing _yaw heading controller_ settings below. TURN ASSIST will allow it to be used with elevon aircraft. But it will not experience the full benefits of an airplane that has yaw control.
- `nav_fw_pos_hdg_p` - Sets the strength the heading trajectory target is tracking. 
- `nav_fw_pos_hdg_i` - When used sparingly, it can filter-out heading target drift.
- `nav_fw_pos_hdg_d` - Can smooth abrupt heading irregularity. But better suited to aircraft that have a means of yaw control.
- `heading_hold_rate_limit` - Limits the yaw induced rotation rate the HEADING_HOLD controller can request from PID controller inner
loop. It's independent from manual yaw rate and only active when HEADING_HOLD NAV flight modes are in use. _The default value is more suited to copters, and should be used cautiously on planes that have yaw control, if `nav_fw_control_smoothness` is default or set below 7._
- `nav_cruise_yaw_rate` - Sets the yaw rotation rate in degrees that the airplane can be commanded via stick input, while in _Cruise/CourseHold_ modes.
- `fw_yaw_iterm_freeze_bank_angle` - When enabled, it can help reduce the effect of the rudder counteracting aileron bank turns, by reducing yaw i-term error accumulation. It is only used for ANGLE, HORIZON or ACRO modes. It is not active in navigation modes, unless TURN ASSIST is disabled. 


_In my experience. Enabling the `nav_fw_pos_hdg` controller combined with an airplane that has yaw control. i.e. A Rudder, Differential thrust or Vectored thrust, **when those yaw gains are tuned**. Will provide the most accurate turn/track response in a waypoint mission or RTH Trackback._

_The use of a magnetometer can help argument the GNSS heading and wind estimation, to provide faster correction in turns. But it must be [setup](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#note-) and calibrated correctly. Or it will make performance even worse._

## Tuning Rangefinder:

**The Rangefinder (surface) gains should only be tuned after the Z navigation PID's are optimally tuned.**

_When a Lidar/Sonar sensor is selected via its Type or MSP. That sensor will actively feed the altitude estimator, regardless of the sensors operational range._
_However, over certain types of terrain, the sensor can occasionally read a false altitude spike. This has been known to cause a temporary ghost climbing action. If you experience this, it may be beneficial to disable the sensor in the Configuration tab._  
_**NOTE:** This issue has been resolved for INAV 9.0._

**Rangefinder** - Lidar or Sonar altitude terrain settings and sensor weights:
- `rangefinder_median_filter` - Enables a 3-point median filter to helps smooth out altitude variations in the readout.
- `nav_max_terrain_follow_alt` - Maximum allowable distance above the ground for altitude tracking in [CM], that directly maps throttle to altitude.
- `inav_max_surface_altitude` - Maximum allowable altitude [CM] for the vertical position estimators validity check over a set time period.
- `inav_w_z_surface_p` - Weight applied to the Rangefinders estimated _altitude_. When a rangefinder is present, within its operational distance above the ground. 
- `inav_w_z_surface_v` - Weight applied to the Rangefinders estimated _climb rate_. When a rangefinder is present, within its operational distance above the ground.

>[!Tip]
> When choosing a [Lidar rangefinder](https://github.com/iNavFlight/inav/blob/master/docs/Rangefinder.md) for fixedwing landing assistance. Ensure you do not purchased a cheaper unit with minimal range. e.g. 2meters or less. Such Lidar sensors have great difficulty working at even one quarter of their recommended range in direct sun light. Always select a higher quality unit with a stronger laser diode and lens, to provide more operational range.

**Optical-flow is not available for fixedwing use, due to the speed airplanes travel across the ground. And the inherent range limitation of these sensors.**
 **This page is a work in progress until this message is removed**

The aim of this page is to separate the tuning of the MC Navigation PIDs from the [Navigation modes](https://github.com/iNavFlight/inav/wiki/Navigation-modes) page. Its goal is also to have MC Nav PID tuning separate from FW Nav PID tuning. To de-clutter and make for easier reading.

>[!Tip]
>There is also a companion wiki page [GPS and Compass setup](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup), that is essential reading beforehand. The _Installation location_, _Setup_ and _Calibration_ of the GNSS/Magnetometer module, to providing the best navigation performance achievable, is of absolute importance.
Accounting for this detail can make your build a great success, or a disappointment if not done correctly.

- [ALTITUDE PID TUNING](#Tuning-Altitude-Controller---Z-axis)
- [POSITION PID TUNING](#Tuning-Position-Controller---XY-axis)
- [SETUP and TUNING - RANGE FINDER - OPTICAL FLOW](#Setup-Tuning-Rangefinder-Flow)

>[!Caution]
> When tuning all navigation PID's. Bear in mind, over-tuning their gains will not react in the same way as over-tuning the main stabilization PID's, which will lead to oscillations on that axis. Instead, over-tune and saturating the navigation PID gains, will in effect provide a poorer control response, equivalent to under-tuning those same gains. Log data must be used.  
>**The Main Stabilization _PID_CD_ and _LEVEL_ controllers MUST be tuned before attempting to tune the navigation controllers. This is because the output from the navigation controllers are place into action through the main stabilization PID controllers.**


## Tuning Altitude Controller - Z axis:

**Inability to maintain altitude can be caused by a number of reasons:**
- Insufficient ALT_P, ALT_I and/or VEL_P, VEL_I - _The default multicopter Altitude PID gains are set conservative, for safety on larger copters._
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
- VEL P `nav_mc_vel_z_p` - defines how much throttle the copter will add to achieve the desired acceleration/deceleration required to meet the ALT_P and ALT_I targets.
- VEL I  `nav_mc_vel_z_i` - controls compensation for hover throttle, based on vertical air movement, thermals or ground-effect. Too much VEL I will lead to vertical oscillations, too low VEL I will cause drops or jumps when ALTHOLD is switched on.
- VEL D `nav_mc_vel_z_d` - Acts as a dampener for VEL P and VEL I, to smooth their response and reduce oscillations caused by sensor variations.


### ALTITUDE POS + VEL PID Tuning:

Try a small experiment: Make sure the barometer is well isolated. You may also want to reduce baro weight. 

Tuning of copter z axis is best performed on a day no colder than 10°C. Due to the effect temperature has on the Baro and IMU.

- set `inav_w_z_baro_p = 0.5` and  ALT P `nav_mc_pos_z_p = 0` and try flying. This way the controller will attempt to keep zero climb rate without any reference to altitude. The quad should slowly drift either up or down. If it would be jumping up and down, your VEL `nav_mc_vel_z` gains are too high.

- As a second step you can try zeroing out VEL P `nav_mc_vel_z_p` and VEL I `nav_mc_vel_z_i` and set VEL D `nav_mc_vel_z_d = 100`. Now the quad should be drifting up/down even slower. Raise VEL D `nav_mc_vel_z_d` to the edge of oscillations.

- Now raise VEL P `nav_mc_vel_z_p` to the edge of oscillations. Now ALTHOLD should be almost perfect. But if the copter is buzzing or slightly oscillating while ALTHOLD is active. You have the ALT_P `nav_mc_pos_z_p` set too high and/or VEL P `nav_mc_vel_z_p` is pushing too hard to reach the altitude target, which is causing some over-shoot. Start lower VEL P `nav_mc_vel_z_p` first. Then lower ALT_P if there is no change after a reduction of 20 points.

- And finally set `nav_mc_hover_thr` slightly higher/lower (50 - 100uS) than your actual hover throttle and tune VEL I `nav_mc_vel_z_i`. The copter should be able to compensate. 


What is the trick with VEL I `nav_mc_vel_z_i` ?
It is used to compensate for `nav_mc_hover_thr` (hover throttle) being set to a slightly incorrect value. You can't set hover throttle to an exact value, there is always influence from thermals, battery charge level etc. Too much VEL I `nav_mc_vel_z_i` will lead to vertical oscillations.   
If its too low it can cause drops or jumps when ALTHOLD is enabled. Very low VEL I `nav_mc_vel_z_i` can result in total inability to maintain altitude.

The easiest trial and error testing method is done through the INAV OSD while in the field. Or by the _Adjustments_ inflight tuning while in the air.


Climb rate is calculated using sensor data from the Accelerometer, Barometer and GNSS velocity NED. The average strength of these noisy signals are taken into account, to estimate the mean altitude. INAV sensor fusion weights are set by:
- `inav_w_z_baro_p = 0.350` - Weight/cutoff frequency for barometer estimated altitude and climb rate.
- `inav_w_z_baro_v = 0.100` - Weight/cutoff frequency for barometer estimated climb rate measurement.
- `inav_w_z_gps_p = 0.200` - Weight/cutoff frequency for GPS altitude position. Vertical data is noisy and works better for airplanes than copter.
- `inav_w_z_gps_v = 0.100` - Weight/cutoff frequency for GPS climb rate velocity measurement.

Too high `inav_w_z_baro_p` will make ALTHOLD nervous, and setting it too low will make it drift, so you risk running into the ground when cruising around. Using GNSS data for vertical velocity can allow you to lower the barometer weight to make ALTHOLD smoother without making it less accurate. But ONLY if your build consistently provides high GNSS sensor accuracy on every power-up.
These weights should only be adjusted if you have a firm grasp of their relationship. Small adjustments can make a significant difference, and has the potential to make things worse, if not tested under different atmospheric conditions.


## Tuning Position Controller - XY axis:

**Inability to obtain an accurate horizontal position can be caused by a number of reasons. These prerequisites below, MUST be resolved or achieved before attempting to tune the navigation POS, VEL and HEADING PID controller.**
 
- Poor GNSS satellite accuracy and EPH position data - _Ensure you have a HDOP less than 1.2 for best precision and never above 1.8. [Possible causes](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#installing-the-gnss-unit---antenna-orientation)_
- Main stabilization **PID_CD** and **LEVEL** is poorly tuned. Or the Copter has a low thrust to weight ratio - _Tune main stabilization PID's first._
- Poorly _Installed_, _Aligned_ or _Calibrated_ magnetometer (compass) - _If a magnetometer is used, read [here](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#setting-up-the-compass-alignment) to provide the best results._
- High accelerometer vibrations from the motors, props or frame-resonance.

Tuning of copter XY axis is best performed on a day no colder than 10°C. This is due to the effect temperature has on the IMU.

_When tuning the Nav XY controllers, you require a means to reference the copters target position, to its _real-time_ turning or stopping position. Otherwise you are just guessing.   
This is best done by logging flight controller data. And gauging the changes with one or all of the following software: [INAV Blackbox Explorer](https://github.com/iNavFlight/blackbox-log-viewer/releases), [Blackbox Tools](https://github.com/iNavFlight/blackbox-tools/releases/tag/v8.0.0) or [MWP Tools](https://github.com/stronnag/mwptools/releases)._



### Horizontal POS + VEL + HEADING PID Tuning: 
 _The following settings can be accessed using the Configurator CLI or **Tuning tab** under **Additional PID Gains**. Or by the CMS OSD stick menu's._

- Multicopters velocity or bank angle is too high - _Lowering the `nav_mc_bank_angle` and `nav_auto_speed` will help to acquire the target position, especially when windy._

**Position XY:**
- `nav_mc_pos_xy_p` - Controls how fast the copter will fly towards the target position. This is a multiplier to convert the distance to the target velocity.

**Velocity XY:**
- `nav_mc_vel_xy_p` - Controls velocity to acceleration. Increasing the gain will provide a stronger response when position error occurs. 
- `nav_mc_vel_xy_i` - Increasing this gain can compensation for position drift, caused by the wind. 
- `nav_mc_vel_xy_d` - Increasing this gain can help smooth the P gain response, and lower the chance of target overshoot, up to a point.
- `nav_mc_vel_xy_ff` - Attempts to predict velocity to acceleration disturbances via sensory input, to actively reduce the controllers response time.
- `nav_mc_vel_xy_dterm_attenuation` - Attenuation of VEL_XY_D controller in %. Providing a smoother control response when the copter is navigating at speed. VEL_XY_D  is not attenuated at low speeds, braking or accelerating.
- `nav_mc_vel_xy_dterm_attenuation_start` - A point in percentage between the current horizontal velocity and the target, when VEL_XY_D attenuation begins.
- `nav_mc_vel_xy_dterm_attenuation_end`- A point in percentage between the current horizontal velocity and the target, when VEL_XY_D attenuation reaches the `nav_mc_vel_xy_dterm_attenuation` value.
- `nav_mc_vel_xy_dterm_lpf_hz` - 
Low pass filter cutoff frequency for the VEL_XY_D controller. To allow for a smoother target response when traveling at `nav_auto_speed` or `nav_max_auto_speed`. 

**Heading:**
- `nav_mc_heading_p` - Controls the strength that the yaw axis will track the IMU's Compass derived heading target. 


## Setup Tuning Rangefinder Flow:

**Hardware requirements:**

To use the rangefinder capabilities of INAV you require two sensors - _Lidar_ / _Sonar_, to measure distance to the surface. And _Optical flow_, to measure motion or flow across the terrain.

**Tested sensors:**

- Matek 3901-L0X Lidar & Optical-Flow board
- MicoAir MTF-01 Optical Flow & Lidar Sensor (prior to INAV 7.1.0)

**Note:** When powering-up and initializing the rangefinder hardware. Ensure the Lidar sensor has a distance between it and the ground, equivalent to 1/4 of the sensors minimum operation range, based on sensor specs.

**Connecting and configuring the hardware:**

The combination sensor boards are the easiest to setup. You only require one serial port to get all the data from the board, from both Optical flow and Lidar sensors. 

Prerequisites.
- The copter has been flight tested in ANGLE and ALTHOLD, just using the barometer and GNSS module. Before you enable the Lidar & Optical flow sensors.
- You must align the arrow on the rangefinder board, so the optical flow sensor works in unity with the flight controllers accelerometer arrow. This step is equally as critical as getting the magnetometer alignment correct, for GNSS enabled flight. 

**Software configuration:**

Once you have decided which serial port you will wire the sensors to. Go to the Configurator _Ports Tab_ and select the **MSP** protocol at 115200 baud.

![MSP](https://github.com/user-attachments/assets/9c5001b8-5451-46f8-88f0-0549ddeb43de)
 
Then go to the _Configuration Tab_ under _Sensors & Buses_ and select **MSP** for RangeFinder and **MSP** for Optical-Flow

![Sensors and bus](https://github.com/user-attachments/assets/ac9a7bee-ff4f-428b-8812-39143163fca8)

If you've connected and configured everything correctly. you should see the Sonar & Opflow sensors active
and ready (blue). If they have appeared in red. They will require the flight battery to be plugged-in to power them via the FC.  
At the bear minimum, you should have Gyro, Accelerometer, Barometer, Flow and Sonar active for the rangefinder to operate.

![Sensors highlight Opflow and Lidar](https://github.com/user-attachments/assets/bb2ad15b-f8fc-42b8-9365-9e6d037fc3f1)

**Aligning the hardware:**

There isn't a GUI to align the optical flow sensor. However, you can use the Configurator _Alignment Tool_ and make like the Optical flow sensor is a magnetometer, with some success. But it's still more beneficial to use the sensor output method to ensure the Optical flow is aligned correctly with the FC's accelerometer.  

Go into CLI and set `debug mode = FLOW_RAW`
 
**Find a spot that is well-lit, preferably by natural light. With the ground surface providing good contrasting terrain:**

1. Optical flow requires contrast and a textured surface, so it can measure motion. It will not work on
solid colors, low contract surface or in low light condition.

2. A Laser rangefinder needs a relatively reflective surface for best operation - Its operation distance will be reduced over dark surface.

Open the Configurator _Sensors tab_. Then lift the copter 40-70cm over the surface, and tilt the copter side to side on the roll, then fore and aft on the by pitch axis. The max tilt should be around 30-40 degrees. The Optical flow len should always be looking down at the surface. Make sure that you only tilt the copter on its central axis, without moving it across the terrain.   
Observe the graphs and make sure `Debug 0` looks similar to `Debug 2` and `Debug 1` is similar to `Debug 3`.

![Debug OpFlow sensor-](https://github.com/user-attachments/assets/e746042f-32b5-451a-bcf4-a240d92145cf)

If it doesn't look correct. Change the `align_opflow` setting in CLI, then retry the procedure until your `Debug 0` looks
similar to `Debug 2` and `Debug 1` is similar to `Debug 3`.  
Because the Optical Flow sensor is looking downwards [`FLIP` is default], there are only 4 possible alignment angles: `CW0FLIP`, `CW90FLIP`, `CW180FLIP` and `CW270FLIP`.

>[!Note]
> Those values are relative to the FC board, not the frame. So if your FC is mounted
upside down, possible values can be `CW0`, `CW90`, `CW180` and `CW270`, the opposite of `FLIP` being added.

**Optical flow calibration:**

Go to the Configurator and open the _Calibration tab_ and follow the instructions for _Optical Flow Calibration_. You will have 30 seconds to tilt the quad in a way you did in **"Aligning the hardware:"** section.   
For the Matek Opflow board and other modules that use the PMW3901 sensor chip. The optic flow scale `opflow_scale` value is generally between 9-10.

**Flight modes:**

There is no specific flight mode for Optical flow. From a flight modes perspective it’s the same as
POSHOLD mode when you use it with a GNSS module.
To enable terrain following altitude hold you need to enable SURFACE mode together with ALTHOLD or POSHOLD.  
SURFACE mode works as a modifier for the altitude hold controller and alters its behavior to use altitude above ground level (AGL) instead of altitude above launch point.

This image is only an example of how I use a rangefinder, together with a GNSS module for POSHOLD use, when the copter is above the workable altitude and position control range of the Lidar and Optical Flow sensors. 
You can however use POSHOLD at lower altitudes, together with the rangefinder surface mode, if you don't install a GNSS module into your copter.

![modes-](https://github.com/user-attachments/assets/6ccdfa2d-c049-4839-9213-26a2a1292876)

Only enable `inav_allow_dead_reckoning` if you do not have a GNSS module, for outside flight. Of if you do have one, and are flying indoors, with a slim chance of obtaining a GNSS 3D fix.

_Do not arm the FC with rangefinder surface mode active. It can have undesirable results. Always arm in ANGLE mode._

**Angle limits:**

The copters bank angle in Surface mode is limited by -
- `max_angle_inclination_rll`
- `max_angle_inclination_pit`  

It is not advisable to increase these setting beyond 38 degrees, due to the limited FOV both these sensors have.  

This also applies to -
- `nav_mc_bank_angle`  

For use in POHOLD. But its value is also constrained by the `max_angle_inclination` angles in the software. 


**Tuning:**

_The Rangefinder (surface) and Optical-flow (flow) gains should only be tuned after the XYZ navigation PID's are optimally tuned._

**Rangefinder** - Lidar or Sonar altitude terrain settings and sensor weights:
- `rangefinder_median_filter` - Enables a 3-point median filter to helps smooth out altitude variations in the readout.
- `nav_max_terrain_follow_alt` - Maximum allowable distance above the ground for altitude tracking in [CM], that directly maps throttle to altitude.
- `inav_max_surface_altitude` - Maximum allowable altitude [CM] for the vertical position estimators validity check over a set time period.
- `inav_w_z_surface_p` - Weight (cutoff frequency) for surface altitude applied to the Rangefinders estimated altitude. Setting is used when rangefinder is present, within its working distance above the ground. And/or _Surface mode_ is enabled.
- `inav_w_z_surface_v` - Weight (cutoff frequency) for surface velocity applied to the Rangefinders estimated climb rate. Setting is used when rangefinder is present, within its working distance above the ground. And/or _Surface mode_ is enabled.

**Optical-flow** - Terrain motion sensor weights:
- `inav_w_xy_flow_p` - Optical flow sensor weight measurement for XY position. Also effected by light intensity.
- `inav_w_xy_flow_v`- Optical flow sensor weight measurement for XY velocity. Also effected by light intensity and the texture of the terrain.
- `inav_allow_dead_reckoning` - Defines if INAV will dead-reckon over short GPS outages. May also be useful for indoor Optical Flow navigation

Both Lidar and optical flow offer more precise altitude and position accuracy, when comparing to a GNSS module and Barometer. So it's possible to tune Pos_XY, Vel_XY, Pos_Z and Vel_Z PIDs higher than defaults.
Here are PID settings that were tested with success:
- `nav_mc_vel_z_p = 150`
- `nav_mc_vel_z_i = 240`
- `nav_mc_vel_z_d = 25`
- `nav_mc_pos_xy_p = 80`
- `nav_mc_vel_xy_p = 50`
- `nav_mc_vel_xy_i = 40`
- `nav_mc_vel_xy_d = 60`

**However keep in mind these setting should be tuned to optimally support all available sensors, unless you only intend to use Rangefinder / Optical-flow, and not GNSS / Barometer.**

>[!Note]
> The manufacturer specifications for their rangefinder modules should always be taken into account.  
Optical flow sensors have a greater range limitation, than the Lidar altitude sensor they are coupled with. And most have a limited speed of operation around 7m/s max. With a required light intensity for reliable operation, greater than 60 Lux.  
So you will often find the copters ability to hold position is lost before the Lidar sensors looses its ability to hold altitude.


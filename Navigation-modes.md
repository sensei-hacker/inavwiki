
This page lists and explains all the different navigational flight modes of INAV:

- [NAV ALTHOLD - Altitude hold](#althold---altitude-hold)
- [NAV POSHOLD - 3D Position hold](#nav-Poshold---Position-hold)
- [NAV COURSE HOLD - Course Hold](#nav-course-hold---course-hold)
- [NAV CRUISE - Course Hold + Altitude Hold](#nav-cruise---course-hold--altitude-hold)
- [NAV RTH - Return to home](#rth---return-to-home)
- [NAV WP - Autonomous waypoint mission](#wp---autonomous-waypoint-mission)
- [WP PLANNER - On the fly waypoint mission planner](#wp-planner---on-the-fly-waypoint-mission-planner)
- [GCS NAV - Ground control station](#gcs_nav---ground-control-station)

For safety reasons, initial setup requires the conditions below to be met before navigation modes will appear in the Configurator modes tab:
- ACC and MAG are [calibrated](https://github.com/iNavFlight/inav/wiki/Sensor-calibration) properly. Also note other [specifics](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup#inav-71-changes) 
- _GPS for navigation and telemetry_ must be enabled. Along with the GNSS module being allocated to a serial port
- a valid altitude source is available

>[!Note]
>After the initial setup. Navigation modes will remain viewable in the modes tab for the sake of some flight controllers that do not provide USB power to drive the barometer. This requirement was added to prevent navigation modes from being left out of the DIFF file, if the users saves a DIFF without the flight battery being connected. 

When it comes to Arming at the flying field or for bench testing. Its not good enough to just meet the requirement of 6 satellites, for what is considered a **valid 3D fix**. This also includes an acceptable level of satellite precision. HDOP or EPH/EPV must be low enough so the software can use it for reliable navigation.

`nav_extra_arming_safety = ALLOW_BYPASS` in active by default. So you can use the RC sticks command to [bypass arming checks](https://www.mrd-rc.com/tutorials-tools-and-testing/inav-flight/inav-stick-commands-for-all-transmitter-modes/). But when doing so, remember your home location will not be saved. So RTH will not work correctly!

- **All multicopter navigation flight modes are self contained**. For example: In RTH, POSHOLD, CRUISE and WP modes, it is not necessary to enable ANGLE, ALTHOLD or Heading control along with the mode you select. The software will enable what is required for that mode to work as it was designed too. 
- The same applies to fixed wing aircraft. But enabling RTH, LOITER, CRUISE or WP modes, will also enables TURN ASSIST. TURN ASSIST applies elevator and rudder input when the airplane is banked to obtain a coordinated turn.

In later releases there is some flexibility in what sensors can be used for multicopter and fixedwing navigation. But as a general rule. The more sensors you have enabled, the more precision you will have for navigation.

### Navigation mode assistance:

* **Default** (`X`)
* **Optional** (`O`) - _Default for Copters, but can be disabled for convenience, with loss of precision. Or a Magnetometer can be enable on a fixedwing to provide greater heading precision._


|  Active Modifier/Sensor    | COURSE HOLD        | CRUISE | POSHOLD | WAYPOINT | RTH  |  
| ----                       | ----               | ----   | ----    | ----     | ---- | 
| ANGLE                      | X                  | X      | X       | X        | X    |         
| ALTHOLD                    |                    | X      | X       | X        | X    |        
| TURN ASSIST  - FW          | X                  | X      | X       | X        | X    |         
| MAG  - MC `X O`/ FW `O`    |                    | X      | X       | X        | X    |         
| BARO - MC/FW `X`/ MC/FW `O`|                    | X      | X       | X        | X    | 
| GNSS                       | X                  | X      | X       | X        | X    |         


- There is a companion [[wiki page further describing way point missions, tools and telemetry options|iNavFlight Missions]].


Note: All INAV parameters for distance, velocity, and acceleration are input in cm, cm/s and cm/s^2.

Let's have a look at each mode of operation in detail.

## ALTHOLD - Altitude hold
ALTHOLD is not a flight mode in it's own right. It is a modifier which when activated in combination with a flight mode, will maintains the aircraft's altitude.

**Please see the platform specific notes for ALTHOLD below.**

**Lidar sensor**: When the hardware is configured, the ALTHOLD code will use the Lidar sensor automatically when it comes into range of the terrain. It can also be placed into operation on a multicopter platform by enabling _Surface Mode_.

>[!Caution]
>**It is not advisable to use ALTHOLD combine with ACRO or HORIZON modes, on either a multicopter or fixedwing plateform.** 
ALTHOLD doesn't account for bank angles greater than 90° or inverted maneuvers. The only _independent_ flight mode you should apply ALTHOLD with is ANGLE mode. 
_However I will go on to say. ALTHOLD can be used by advanced multicopter users, together with ACRO mode. But ONLY if the user understands the importance of maintaining smooth control over the copters attitude._

Altitude is calculated by INAV's vertical position estimator, and is derived from up to four sensors. It is logged to BLACKBOX as `navPos[2]`.

## Using ALTHOLD with a MultiCopter (MC):

**Operation and Control :**

When just using ALTHOLD on a multicopter, it requires a barometer at minimum, to maintain a fixed altitude.

Activating AIRMODE along with ANGLE mode can provide extra stability for a multicopter in a fast descent. But it's advisable to disable AIRMODE before landing, if your copter has a very high thrust to weight ratio. Otherwise it may flip-over from i-term windup.

**Climb rate in ALTHOLD mode:**
The throttle stick can be used to alter the climb or sink up to a predetermined maximum [nav_mc_manual_climb_rate](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_manual_climb_rate).

The maximum climb and decent rate in **autonomous** flight modes is defined by [nav_mc_auto_climb_rate](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_auto_climb_rate)

Neutral position of the throttle stick to hold current altitude is defined by [nav_mc_althold_throttle](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_althold_throttle).
This setting provides three means for the ALTHOLD, throttle stick position to be acquired. The default setting, `STICK`, is useful in most cases when activating a flight mode that holds altitude. But it may cause issues under some conditions. e.g. If switching from ACRO to an altitude holding mode, at high throttle. In this case, the throttle/stick offset can be considerably higher than expected. Making it hard to alter altitude. So it may be beneficial to use one of the other two settings.

In the moment you engage ALTHOLD, INAV always sends [nav_mc_hover_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_mc_hover_thr) to the motors as the starting value of the altitude control loop. You should configure this to your copter's hover setting, if your copter doesn't hover close to the default value of 1500us. Otherwise your copter will begin to rise or sink.

`nav_mc_hover_thr` should be set to an approximate value within 2% of what the copter requires to maintain a fixed hover. The altitude controller can make up for small drift. The primary reason for this setting is to provide a general baseline for hover. Determined by your builds thrust to weight ratio.
Due to the battery voltage falling-off during the flight. It is beneficial to enable `feature THR_VBAT_COMP`. Which can help compensate for the thrust reduction as the battery voltage sags. 
To acquire your copters hover throttle value. You should do your best at getting it to hold a fixed hover position while in ANGLE mode. Then either reference the throttle value required, from a log or the OSD. Or even the LUA telemetry on your radio's display. The once you land, enter that value into `nav_mc_hover_thr`.

The [alt_hold_deadband](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#alt_hold_deadband) provides a deadband region either side of `nav_mc_althold_throttle` hover position. To reduce the stick sensitivity, and prevent unwanted altitude change occurring. 
If ALTHOLD is activated at zero throttle INAV will account for deadband and move the neutral "zero climb rate" position a little bit up to make sure you are able to descend.

[Multicopter navigation PID tuning](https://github.com/iNavFlight/inav/wiki/Navigation-PID-tuning-(MC))

## Using ALTHOLD with a FixedWing (FW):

INAV controls pitch angle and throttle. It assumes that altitude is held (roughly) when pitch angle is zero. If the airplane has to climb, INAV will also increase throttle. If plane has to dive, INAV will reduce throttle and glide. The strength of this function is controlled by `nav_fw_pitch2thr`.
Trim the aircraft via the **Auto Level Trim** mode [fw_level_pitch_trim](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#fw_level_pitch_trim) in such a way that your airplane is flying level both in "MANUAL" and in "ANGLE", when not touching the sticks.

Parameters for fixed wing:
- [nav_fw_cruise_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_cruise_thr) = 1450  
- [nav_fw_min_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_min_thr) = 1200  
- [nav_fw_max_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_max_thr) = 1750 
- [nav_fw_bank_angle](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_bank_angle) = 45
- [nav_fw_climb_angle](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_climb_angle) = 25
- [nav_fw_dive_angle](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_dive_angle) = 18
- [nav_fw_pitch2thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_pitch2thr) = 11  
- [nav_fw_loiter_radius](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_loiter_radius) = 5000


[Fixedwing navigation PID tuning](https://github.com/iNavFlight/inav/wiki/Navigation-PID-tuning-(FW))

## NAV POSHOLD - Position hold

**MULTIROTOR**

The Multirotor will hold 3D position. Altitude is controlled by the ALTHOLD mode, which uses the Barometer, GNSS altitude and the Accelerometer. Together with gyro based HEADING HOLD that is updated from the magnetometer or GNSS Course over Ground (no compass), to achieve **full 3D position** control. 

If the throttle stick is increased or decreased, the copters altitude will either climb or descend until you center the throttle stick, then it will hold the current altitude. This should be tuned for your hardware, by the settings `nav_mc_hover_thr` -  `nav_mc_althold_throttle` - `nav_manual_climb_rate`.

You can also use the roll or pitch sticks to move the copters location in POSHOLD. Then once you center the roll/pitch sticks again, it will stop and hold the new position. You can also use the Yaw stick to rotate the copter. The speed that rotation occurs, is based on the setting `heading_hold_rate_limit`.

POSHOLD permits smooth controlled flight and can be modified via the _Advanced Tuning Tab_ under the _Multirotor Navigation_ settings.

 The `Nav_User_Control_Mode` can be either **ATTI** or **CRUISE**:
 
-  **ATTITUDE** - When the Pitch/Roll sticks are moved, autopilot position control is disengaged. So the multirotor behaves with the freedom of ANGLE mode.
-  **CRUISE** - The autopilot position control always remains active. So when the Pitch/Roll sticks are moved, the input is transformed from a command 
   to speed and merged with the current position. To provide more precise 3D position control over the craft. But it may feel a little more vague than Attitude mode, if the satellite precision is low.

A number of other parameters can also be set:

- Default navigation speed
- Max. navigation speed
- Max. CRUISE speed
- Multirotor max. banking angle


**FIXED WING** -  aka **LOITER**

A fixed wing will loiter in a circle, holding altitude, with the throttle automatically controlled. The circles radius is defined by the setting `nav_fw_loiter_radius`. The altitude can be adjusted via the pitch stick if required.

Always check LOITER is working correctly, before you use RTH or start a WP mission.

Hints for safe operation:
- If used; Always run a bench test to ensure the magnetometer is setup correctly and calibrated. Otherwise this can cause an uncontrolled loiter turn.
- Activate without props installed to check for reasonable operation.

## NAV COURSE HOLD - Course Hold

Course hold is only available for multirotor from INAV 7.0.

When enabled the craft will try to maintain the current course and compensate for any external disturbances (2D CRUISE). Control behaviour is different for fixed wing and multirotor as follows:

**Fixed wing**  
The flight direction is controlled directly with ROLL stick as usual or with the YAW stick which provides a smoother way to adjust the flight direction.
The setting `nav_cruise_yaw_rate` adjusts the yaw rate at full stick deflection.

**Multirotor**  
The heading is adjusted using the YAW stick or the ROLL stick (ROLL stick behaves exactly the same as the YAW stick). Cruise speed is increased by raising the pitch stick with the speed set in proportion to stick deflection up to a maximum limit of `nav_manual_speed`. This speed is maintained after the stick returns to centre. If the multirotor is already moving when Course Hold is selected the current speed will be maintained up to the `nav_manual_speed` limit. Speed is decreased by lowering the pitch stick with the rate of reduction proportional to stick position such that at maximum deflection it should take around 2s to slow to a stop. Position is held when the speed drops below 0.5m/s.



If the mode is enabled in conjunction with NAV ALTHOLD the current altitude will also be maintained, essentially making it CRUISE mode. Altitude can be adjusted as usual, via the pitch stick for a fixed wing or the throttle stick for a multirotor. ANGLE mode is active so the craft will auto level and the heading will also be held on a multirotor.

## NAV CRUISE - Course Hold + Altitude Hold

Equivalent to the combination of NAV COURSE HOLD and NAV ALTHOLD described above.

## RTH - Return to home
RTH will attempt to bring the copter/airplane back to the arming or launch location. RTH will control both position and altitude. 

**MultiCopter**

With the default settings, if the Copter is farther than 10 meters from the arming location or a Safehome. The copter will climb according to the setting `nav_rth_climb_first` and then fly home. Once it is within 1 meters of the arming location or Safehome. The copter will attempt to land, according to the setting `nav_rth_allow_landing = ALWAYS`. And control the descent speed via the `nav_land` settings. Once on the ground, landing will be detected and the copter will disarm.

**FixedWing**

 A fixedwing uses the same setting to return to home as a copter. But it may be advisable to set `nav_rth_allow_landing = NEVER or FS` instead, if you do not have _fixedwing auto land_ configured. This will allow the airplane to loiter around the arming location until you exit the RTH mode and take-over control again.

There are many different modes for Altitude, see the [RTH mode page](https://github.com/iNavFlight/inav/wiki/Navigation-Mode:-Return-to-Home#rth-altitude-control-modes) for details.

Activated by **RTH** flight mode.


## WP - Autonomous waypoint mission
Autonomous waypoint missions allow the craft to fly a predefined sequence of mission waypoints. The mission waypoints include information about the type of waypoint, latitude, longitude, height and speed between the waypoints as well as other settings that control the behaviour during a mission. GUIs such as INAV Configurator Mission Control, [MWP Tools](https://github.com/stronnag/mwptools), EZ-GUI, Mission Planner for INAV, Mobile Flight and can be used to set the waypoints and upload the mission as well as store missions locally for reuse. Uploaded missions are saved in FC volatile memory until a reboot or a new uploaded mission overwrites the old one. Missions can also be saved to EEPROM non volatile memory which retains the mission after power off/reboot.

When waypoint mode is activated (using a switch as other modes), the quad/plane will start to fly the waypoint mission following the waypoints in numerical order. Waypoint missions can be interrupted during a mission by switching NAV WP off (Manual mode on a fixed wing or RTH will also interrupt a WP mission). Up to INAV 4.0 WP missions always start from the first WP. From INAV 4.0 it is possible to resume an interrupted mission from an intermediate WP using the [nav_wp_mission_restart](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_wp_mission_restart) setting.

Up to 30 waypoints can be set on F1 boards. On F3 boards and better 60 waypoints are available. This is increased to 120 waypoints from INAV 4.0.

There is an additional [[wiki page further describing way point missions, tools and telemetry options|iNavFlight Missions]].

The [MSP navigation message protocol documentation](https://github.com/iNavFlight/inav/wiki/MSP-Navigation-Messages) describes optional parameters affecting WP behaviour.

### Fixed Wing Waypoint Tracking Accuracy and Turn Smoothing
Waypoint tracking accuracy forces the craft to quickly head toward and track along the waypoint course line as closely as possible. 2 settings control the alignment behaviour. [nav_fw_wp_tracking_accuracy](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_wp_tracking_accuracy) adjusts the stability of the alignment. Higher values dampen the response reducing possible overshoot and oscillation. [nav_fw_wp_tracking_max_angle](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_wp_tracking_max_angle)
sets the maximum alignment convergence angle to the waypoint course line (see below). This is the maximum angle allowed during alignment and in reality will only be acheived when some distance away from the course line with the angle reducing as the craft gets closer to alignment. Lower values result in smoother alignment with the course line but a greater distance along the course line will be required until this is achieved.
 
Turn Smoothing helps to smooth turns during WP missions by switching to a loiter turn at waypoints with the turn initiated slightly before the waypoint is actually reached. This helps to avoid the overshoot often seen on tighter turns. The [nav_fw_wp_turn_smoothing](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_wp_turn_smoothing) setting provides 2 options as shown below.

(Available from INAV 6.0)

![](https://user-images.githubusercontent.com/56191411/216628721-034b4864-212d-47c7-89dd-c0f4c012cb0f.png)

> [!NOTE]
>Besides the waypoint _track angle_ and _accuracy_ settings, there are other setting that will influence the turn accuracy of a fixedwing aircraft in a _Waypoint mission_, _RTH Trackback_ or _Loiter_. It may also be beneficial to adjust these setting for windy conditions or for flying a tighter mission course. These setting can be found in the _Advanced Tuning Tab_ or the _CLI_.

* `nav_wp_radius` [CLI](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_wp_radius) - A lower value can be beneficial, however a value around 600 (6m) will allow the plane to commence the turn earlier on a tail wind leg. With less likelihood of it being pushed past or overshooting the turn.
* `nav_fw_bank_angle` [CLI](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_bank_angle) - A higher bank angle will allow a sharper turn. Helping the plane to pull through the corner faster. Practical responsive values are between 45 and 55 degrees.
* `nav_fw_control_smoothness` [CLI](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_control_smoothness) - Lower values can produce a more abrupt banking motion. But will also allow the plane to react faster to navigation heading controller commands.
* `nav_use_fw_yaw_control` [CLI](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_use_fw_yaw_control) - If your plane has a form of yaw control **e.g. Rudder or Differential Thrust**. This setting allows the plane to yaw as well as bank when making a turn. Therefore a lower `nav_fw_bank_angle` should be used, for a more controlled flatter level turn.
* `nav_fw_cruise_thr` [CLI](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_cruise_thr) - Waypoint overshoot is more likely to occur if the plane is holding a higher velocity, especially if it is traveling on a down-wind or lateral leg before the turn. Tuning this setting so your plane will hold an airspeeds between 50 - 70km/h is ideal.


### Multi-Missions
Multi-missions allows up to 9 missions to be stored in the FC at the same time. It works with missions saved to and loaded from EEPROM rather than missions loaded into the FC by other means. It requires the OSD `MISSION INFO` field be enabled in order to select loaded missions.

Multi-missions can be planned in Configurator Mission Control or MWP Tools and saved to/loaded from the FC as normal. It is also possible to load them into the FC [using the CLI.](https://github.com/iNavFlight/inav/blob/master/docs/Navigation.md#cli-command-wp-to-manage-waypoints)

The OSD `MISSION INFO` field will display the total number of missions loaded on power up. The required mission can be selected either by using the CMS MISSIONS menu or by using the roll stick to change the mission number in the `MISSION INFO` field. `MISSION INFO` will display the mission waypoint count if the current mission number is loaded or 'LOAD' if it isn't. To load a mission use the Mission load stick command. It is also possible to change missions in flight using adjustment function `Multi mission Index Adjustment` or by selecting `MISSION CHANGE` mode. The mission index is changed in `MISSION CHANGE` mode using the WP mode switch to cycle through the available missions. The newly selected mission becomes active when either the adjustment function or `MISSION CHANGE` mode is deselected.

Selecting mission numbers 1 to 9 will load missions saved in EEPROM. Mission selection behaviour changed slightly with INAV 6.0 as follows:

**Pre INAV 6.0**  
It is possible to select Mission number 0 which appears in the `MISSION INFO` field as "WP CNT". This shows the current active WP count loaded in FC volatile memory and changes depending on the Arm state. When disarmed with a mission loaded it shows the total number of WPs for all missions stored in EEPROM. After arming and until another mission is loaded on disarm it displays the number of WPs in the loaded mission. "WP CNT" will also display the waypoint count for missions loaded to the FC from a source other than EEPROM, e.g. via telemetry. When less than 2 missions are loaded in the FC EEPROM mission numbers can only be selected using the CMS MISSIONS menu.

**From INAV 6.0**  
Only mission numbers 1 - 9 can be selected and "WP CNT" only appears if a mission has been loaded from a source other than EEPROM. Also waypoint count now only shows the number of WPs in the selected mission.

The only limitation with multi missions relates to single WP RTH missions. There seems little purpose in such a mission but if used it must be saved as mission number 1 (if saved at any other position it will truncate loading of other missions beyond that number).

## WP PLANNER - On the fly waypoint mission planner
WP PLANNER mode allows a mission to be planned "on the fly" simply by moving the craft to a required location and saving a waypoint at that point then repeating for further waypoints until the mission is complete.

The OSD `MISSION INFO` field must be enabled and WP mode must be off before WP PLANNER mode can be used. With the mode selected the `MISSION INFO` field will display SAVE. To save a waypoint at the current location just operate the WP Mode switch. `MISSION INFO` will display OK if the waypoint was saved and the WP count will increment up. WP Mode must be selected off before another waypoint can be saved (OK will change back to SAVE). `MISSION INFO` will show WAIT if position data isn't valid, e.g. no GPS lock, or FULL if all available waypoints have been used.

The mission can be run at any time by turning WP PLANNER mode off and selecting WP mode as usual. In this case the `MISSION INFO` field will display PLAN indicating a WP PLANNER mission is currently active.

The mission can be reset if `nav_mission_planner_reset` is ON and the WP PLANNER Mode switch toggled ON-OFF-ON (resets WP count to 0). It is possible to save the mission to the FC EEPROM on disarm in the usual way, e.g. by using the Save WP Mission stick command.

It should be noted that unlike other Nav modes WP PLANNER will work when disarmed. It should also be noted that it saves the WP altitude using the sea level datum so if a WP is set with the craft on the ground it will use ground level as the WP altitude setting regardless of the subsequent takeoff location.

## GCS_NAV - Ground control station
This mode is just an permission for GCS to change position hold coordinates and the altitude.
So it's not a flight mode itself, and needs to be combined with other flight modes.

In order to let the GCS have full control over the aircraft, e.g. 'follow me', the following modes must be activated: `NAV POSHOLD` with `GCS_NAV`. In order to update the home position, no other mode is required.

For more [detail](https://github.com/iNavFlight/inav/wiki/INAV-Remote-Management,-Control-and-Telemetry#follow-me-gcs-nav).

## GPS loss during navigation
Loss of GPS during navigation will have the following affect on the different modes:

- RTH and WP: Emergency landing triggered. Switching the modes off will stop the emergency landing allowing the craft to be flown manually.
- CRUISE/COURSE HOLD: Heading hold no longer maintained (Altitude hold only maintained during CRUISE if ALTHOLD mode set independently).
- POSHOLD: Falls back to forced ANGLE mode.
- ALTHOLD mode should still work normally if a barometer is available.

## Emergency Landing
An emergency landing will be triggered during WP and RTH modes if navigation sensors fail or in the case of RTH if the craft heads off in the wrong direction.

It is also possible to manually trigger an emergency landing at any time using [MULTIFUNCTION](https://github.com/iNavFlight/inav/wiki/Modes#multi-function) mode or by using [POSHOLD](https://github.com/iNavFlight/inav/wiki/Navigation-modes#nav-poshold---Position-hold) mode. To trigger using POSHOLD mode rapidly toggle the mode ON/OFF at least 5 times. Repeat this action to cancel the emergency landing once started.

## Mode switch diagram

A diagram to indicate flight modes relation to navigation modes and illustrate sensor requirements:

![](images/nav_modes_diagram.jpg)

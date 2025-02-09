# Airplane launch assistant

This flight mode is intended to provide assistance for launching the fixed-wing UAVs. Launch detection works by monitoring airplane acceleration - once it breaches the threshold for a certain amount of time launch sequence is started.

Gliders have different needs than motorized planes. See below for note on glider launch setup.

The entire time `NAV LAUNCH` mode it will try and stabilize plane, it will target zero roll, zero yaw and predefined climb angle. The I-gain of the PIFF regulator is also disabled to prevent I-gain growing during launch until motor is started. When successful launch is detected it waits for preconfigured amount of time before starting motor.

`NAV LAUNCH` is automatically aborted after a timeout in seconds (default of 5 seconds), by exceeding an altitude (default to off), or by any pilot input on PITCH/ROLL stick. When it has aborted it goes to whichever selected mode, which can be Angle, Acro, Horizon, RTH or a waypoint mission (if no other mode is selected it will go to Acro mode).

It's safe to keep it activated the `NAV LAUNCH` mode during flight after the launch has being completed. Keep in mind that if you accidentally disarm while flying you need to disable `NAV LAUNCH` mode to being able to control the model again.

See INAV CLI for all available adjustable parameters, they start with `nav_fw_launch_`

## Launch sequence
Sequence for launching airplane using `NAV LAUNCH` mode looks like this:

1. Make sure you are in a non-navigation mode (Manual, Acro, Angle, or Horizon).
2. If autolaunch is not permanently enabled. Set switch to NAV LAUNCH mode prior to arming (note that it won't actually enable until arming).
3. ARM the plane.
4. Set the flight mode to the **exit** flight mode. This will be used after the launch has completed. **Loiter** is a great choice for the exit flight mode.
5. Put throttle stick to desired throttle value to be set **after** launch is finished. The motor should start spinning with `nav_fw_launch_idle_thr` if it is set. Verify that motor doesn't respond to throttle stick motion. Don't touch the pitch/roll stick! From version 3.0 `nav_fw_launch_idle_motor_delay` can be set to delay the motor starting at idle (useful for launching large aircraft). When idle motor delay is used the launch beep sound changes a few seconds before the motor is about to start as a warning to the pilot (beep becomes more rapid).
6. Throw the airplane. It must be thrown leveled, or thrown by slinging it by wingtip.
7. Motors will start at pre-configured `nav_fw_launch_thr` (default 1700) after `nav_fw_launch_motor_delay` (500ms).
8. Launch sequence will finish when pilot switch off the NAV LAUNCH mode or moves the sticks, or the exit criteria has been met (timeout or altitude).

If it won't detect launch it's possible that you need to lower your threshold. Look at the CLI variables.

> [!CAUTION]
> Motors will spin if you disable `NAV LAUNCH` mode after arming.

From version 1.9 `NAV LAUNCH` can be permanently enabled via the configurator or the CLI using `feature FW_LAUNCH`. In this case `NAV LAUNCH` doesn't need to be enabled via a transmitter switch prior to arming. If you want to launch the plane manually just move pitch/roll stick after you have armed the plane and you have back throttle control. If you inadvertently disarm mid-air before raising the throttle again (you should lower the throttle to arm again) move pitch/roll stick and you will have throttle control back.

## MANUAL THROTTLE LAUNCH

From INAV 6.0.0 it is possible to use NAV Launch with manual throttle control. This is really intended as a more controllable alternative to the shake to start motor and throw method of launching. When enabled using setting [nav_fw_launch_manual_throttle](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_launch_manual_throttle) the throttle is controlled manually throughout the launch using the throttle stick. There is no motor idle or detection used to start the motor, motor control is entirely manual and active via the throttle stick once armed. INAV only controls roll and pitch attitude during the launch climb out.

> [!NOTE]
> If this option is used with no GPS fix available it is recommended to throw the plane as soon as the throttle is raised in order to avoid possible degraded control issues and premature end of the launch timeout (moving the throttle stick back to idle will reset the affected launch parameters if required).

## Glider/Sloper setup

For obtaining launch assistance for hand-thrown gliders, it's a bit tricky. One possible solution is to setup the throttle as in input for switching modes. At lowest throttle setting, disarm and enter passthru. Just above minimal throttle, turn on Nav Launch, then just above that, Arm and activate Angle - all simultaneously "on" for launch.

This will allow the FC to reset the launch sequence and be ready for toss with Angle activated after launch.

Setup launch parameters appropriately:

`set nav_fw_launch_climb_angle = XX` 45?

This is the climb angle for launch sequence (degrees), is also restrained by global `max_angle_inclination_pit`.

`set nav_fw_launch_thr = 1700`

The `nav_fw_launch_thr` parameter can be problematic for a glider. Not obvious, since Airplanes change PID values for throttle based on `set tpa_rate = XX`X and `set tpa_breakpoint = XXXX` (adjust accordingly). Also, not well documented but PIDs are boosted at low throttles by 1.5X!! Can cause unexplained behaviour at launch. For some gliders - having PID gains reduced for toss is beneficial (DLG launch may be fastest speed the glider travels).

`set nav_fw_launch_velocity = XXX` 300?
This is the forward velocity threshold for swing-launch detection [cm/s].

One option is to add Horizon mode at very top end of throttle, to enable acro flying with ability to drop back to angle mode for emergency recovery.
# The Basics of Getting iNav Working on an Airplane

Note: A limitation of iNav (and all other Cleanflight based firmware for that matter) is that it cannot be flown longer than 1 hour and 15 minutes. This is **resolved** from INAV version 1.6 with F3 boards and newer.

### Step 1: Getting Your Flight Controller Ready.

* Flash the latest version of iNav.

* Do an entire [sensor calibration](https://github.com/iNavFlight/inav/wiki/Sensor-calibration). Level should be the angle of the plane itself when flying straight. **Do not skip this step**.

* Select a preset from the iNav presets tab that fits your aircraft the best, then press "Save & Reboot"

### Step 2: Hooking Everything Up.

* Servo and ESC/MOTOR. ( Keep in mind servos positive wire **should** go to an independent BEC instead of connecting to the flightcontroller itself. )

    * Airplane
        * Output 1 - Motor/ESC
        * Output 2 - Empty / Or 2. motor
        * Output 3 - Elevator
        * Output 4 - Aileron
        * Output 5 - Aileron
        * Output 6 - Rudder

    * Flying Wing
        * Output 1 - Motor/ESC
        * Output 2 - Empty / Or 2. motor
        * Output 3 - Port Elevon
        * Output 4 - Starboard Elevon

An example if using SpracingF3:. 
* If using GPS connect it to UART 2.
* If using Sbus connect it to UART 3 / or the uart which are dedicated for sbus on your board.
* If using regular PPM connect it to IO 1 pin 1.
* If using telemetry connect it with softserial. ( If using Smartport read [this](https://github.com/iNavFlight/inav/blob/master/docs/Board%20-%20Airbot%20F4%20and%20Flip32%20F4.md#frsky-smartport-using-softwareserial) )

### Step 3: Setting up Your Remote, Endpoints and Reversing of Servos.

* Setup receiver/transmitter according to what you are using.
* If using GPS setup UART2 for GPS at baud 57600 and enable GPS in configurations (if that doesn't work, try 115200).
* Your transmitter should use **NO mixing at all** (so separate channels for Thr, Ail, Rud, Ele). Check that when moving the sticks, the right channels moves in the receiver window. Also everything should be centered at 1500us, and full stick movement should be 1000-2000us. Use subtrim and travel range on TX to set this up. 

The correct way is:

* Throttle stick push away - increased value
* Yaw (Rudder) stick right - increased value
* Pitch (Elevator) stick push away - increased value
* Roll (Ailerons) stick right - increased value

Next is checking that your servo moves as expected:

1. Servo goes the right way when moving sticks. [Youtube help video](https://www.youtube.com/watch?v=Gf74geZyKYk&t=1s)
1. The servo movement does not exceed wanted maximum deflection of control surfaces. [Guide on setting up linkages](http://www.modelairplanenews.com/total-control-the-right-way-to-set-up-servos/)
1. The servo midpoint has control surfaces perfectly at center.

In the "Servos" Tab:  

* If they go reverse, change "Direction and rate" from +100 to -100  
* If they exceed maximum wanted deflection reduce min/max  
* If control surfaces is not perfectly centered adjust servo midpoint. (This is after setting them up as close as possible mechanically )  

(Note: In the Servos tab servos are counted from 0-7 while in the Motors tab they run from 1-8.)

At this point everything should do as expected.  

1: When moving sticks on TX the control surfaces should move correctly, do an [High Five](https://www.youtube.com/watch?v=Gf74geZyKYk) test  
2: When moving the airplane in the air in angle mode control surfaces should counter-act movement correctly. The controls surfaces needs to move the same way as the airplane is moved to counteract and stabilize the airplane. You may need to **temporarily** triple the amount on P-gain on Roll, Pitch and Yaw axis. (So its easy to see movement.)  

### Step 4, Replace Default Values

* Type this and save in CLI:  
``set max_angle_inclination_rll = 600``    
``set max_angle_inclination_pit = 600``  

* Stick arming is considered **unsafe** for fixed wing models. It's suggested instead that you use an AUX switch for arming (eg switch SF on a Taranis) or [fixed_wing_auto_arm](https://github.com/iNavFlight/inav/blob/master/docs/Cli.md). 

* Increase small angle (so iNav will let you arm in any position) type this and save in CLI:
``set small_angle = 180`` 

* If you wish for your fixed wing model to loiter instead of attempting a landing after RTL mode is selected & the model returning home, you can set the model to loiter by typing this and saving in CLI:
``set nav_rth_allow_landing = OFF``

* In iNav V1.7 when the RTL mode is enabled, the model will climb and then return home. If you set this value below, the model will **turn and then climb** on it's way back to the home position:
``set nav_rth_climb_first = OFF``

* In iNav V1.7 the default RTL height is 10 metres (approx 32') which might be too low for flying sites with trees. You can change this to 70 metres (approx 230') by setting this value in the CLI tab and typing save afterwards:
``set nav_rth_altitude = 7000``

* [Tune your PIFF controller](https://github.com/iNavFlight/inav/wiki/Tune-INAV-PIFF-controller-for-fixedwing) ( iNav versions 1.6 & later )

* Read through the iNav CLI commands, especially ALL marked with " fw_ " This will give you hints how the modes for fixedwings works.  


### Step 5: Optional, but Recommended:

* Have `passthrough` mode configured so if it happens anything with gyro / accelerometer in air you can go manual control, this includes example if your flight controller resets during flight because of example an brownout.  
* Use Airmode mode to get full stabilization and servo throw with no throttle applied.
* [Setting up failsafe with return to home.](https://github.com/iNavFlight/inav/wiki/Failsafe#setting-up-failsafe-with-return-to-home)
* If your compass is not 100% properly setup just disable it instead. **A calibrated compass can cause orientation drift during flight that may not show up in the configurator** (especially built-in ones on your FC). Really consider disabling it unless you need it. INAV uses GPS heading normally, Only on ground before GPS speed has been high enough or if error between GPS heading and compass heading exceed 60deg will it use compass heading

### Last Step, a Test Flight!:

* Double check following again:
    * 3d model in configurator moves correctly when moving airplane by hand. And that the aircraft is showing leveled when your holding the aircraft leveled in air.
    * Do the [High Five](https://youtu.be/Gf74geZyKYk) test in passthrough mode, verify everything is moving as expected.
    * Enable `Angle` / `Horizon` mode and verify the control surfaces moves correctly when moving aircraft by hand and by sticks on TX

* Arm and launch your aircraft using prefered mode, example `Horizon`.
    * If airplane is not flying leveled when in self leveling mode like `Horizon` you need to trim your [board aligment](https://github.com/iNavFlight/inav/wiki/Sensor-calibration#board-orientation-and-level-calibration)
    * If airplane flies leveled, do an [Servo Autotrim](https://github.com/iNavFlight/inav/wiki/Modes#servo-autotrim)
    * Tune your PIFF values, either manually or with [AUTOTUNE](https://github.com/iNavFlight/inav/wiki/Modes#autotune) 

* For GPS features
    * Test `NAV ALTHOLD` and see that it holds altitude.
    * Test `NAV ALTHOLD` and `NAV POSHOLD` combined
    * Test `RTH` flight mode
    * Test [failsafe](https://github.com/iNavFlight/inav/wiki/Failsafe)


### Optional / Guides related to Fixed Wing:

* Using a seperate BEC for servos to prevent the FC from restarting due to brownouts or interferences of the servos. [Example](http://www.rcgroups.com/forums/showpost.php?p=34254665&postcount=4006) INAV will not be able to function after an brownout, Pilot must switch into Passthrough mode and fly manually and land the airplane.

* [Using a minimosd](https://github.com/iNavFlight/inav/wiki/Howto:-CC3D-flight-controller,-minimOSD-and-GPS-for-fixed-wing#osd-setup)

* Howto in flight trim servos. [Aileron example at rcgroups.com](http://www.rcgroups.com/forums/showpost.php?p=35059861&postcount=6741) [Fixed wing example](https://www.rcgroups.com/forums/showpost.php?p=36039077&postcount=8732)

* Prefer using digital servos to analog ones. Digital servos are much faster. [Explanation](https://www.rcgroups.com/forums/showpost.php?p=36649528&postcount=10480)

* Add an capacitor on the +5v powering servos to avoid issues. ( Especially with digital servos ) [Link explanation](http://www.vstabi.info/en/node/1422) [Example to buy](http://www.multiwiicopter.com/products/c1-anti-brownout-cap-for-rc-drone-servos)

* [Why do I have limited servo throw-in-my airplane](https://github.com/iNavFlight/inav/wiki/Why-do-I-have-limited-servo-throw-in-my-airplane)
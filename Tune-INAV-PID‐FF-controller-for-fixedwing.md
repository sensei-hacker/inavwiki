### Description of PID-FF controller:

The FF-gain should do most of the work steering the airplane if tuned correctly. Leaving Proportional, Integral and Derivative to make up for slight target error and drift caused by turbulence.  

Tuning of the Rate and Feedforward can be done via [AutoTune](https://github.com/iNavFlight/inav/wiki/Modes#autotune-fw). However, tuning can be done manually as explained below.

**Manually tuning the maximum rates your airplane can achieve on each axis (pitch, roll, and yaw)**

* Fly in `MANUAL` mode with the `manual_roll_rate`, `manual_pitch_rate` and `manual_yaw_rate` settings set to 100%.  
Have some way of recording the flight: blackbox, DVR or both. Do hard rolls, hard loops and one 360° yaw turn. Use full stick deflection on all these    
maneuvers.
* To calculate an axis' _(approximate)_ rate from a DVR recording you'll need to count the number of frames it took for your aircraft to do a complete maneuver (roll/flip/yaw turn), determine the average FPS of the recording, and then use this formula: `360 / (number_of_frames / FPS)`. You can take multiples samples and average them for a better accuracy.  
You can also use [a Python script](https://gist.github.com/nmaggioni/e42d3f4eb242808df751b13413ebf22c) to help automating the process.

* Note down the maximum rates. Typical values are 300°/s on Roll, 110°/s on Pitch and 60°/s Yaw.  
Enter these values as your rates in configurator.

* Zero out P, I and D gains on the Roll, Pitch and Yaw controllers.  
* Set `tpa_rate` to 0.   
* Increase FF-gain until you get 90% of full servo throw when having sticks at full throw in `ACRO` mode, when compared to `MANUAL` mode.
* This is so the FF-gain does most of the work turning the airplane, but leaving some for the P and I gain to work with.
* For this step it's convenient to have the two modes `MANUAL` and `ACRO` available on a switch, so you can easily move between the two, and compare the throws.
* The 90% deflection value can also be calculated by dividing 13950 by the maximum rate for the axis, e.g. 360deg/s maximum roll 13950/360=38.75 FF. For 80% deflection, divide 12400 by rate. 

Now set some P and I gain as a starting point.   
Example :      
 `fw_p_pitch = 7`  
 `fw_i_pitch = 10`  
 `fw_p_roll = 3`    
 `fw_i_roll = 15`   
 `fw_p_yaw = 10`     
 `fw_i_yaw = 5`
    
**Go out and fly in acro mode.**

* If the airplane drifts to one side or up and down, increasing the I-gain on that given axis, can reduce the effect.   
Allowing I-gain to do a considerable amount of the work, after Feedforward. Can actually make the Roll axis response smoother from an FPV perspective.
* If you want more stabilization against hard buffeting from the wind, try increasing the P-gain. But only up to a point.   
Too much P-gain can cause oscillation as the airspeed increases. Which can not be corrected for, due to lag in overall control response time. e.g. PID, MIXER and SERVO speed.
* Once the P-gain it tuned to about 80% of its optimal, at a given air speed. Then start applying some D-gain in small amounts, to add damping.

**Want to calm your airplane down? Now is the time to reduce rates to fit your needs.**

* Note: It's normal to get reduced servo throw when reducing rates at this point, if you got full servo throw at this stages you would overshoot the target deg/s you wanted.

**Tune Angle / Horizon mode**

* [Auto Level Trim](https://github.com/iNavFlight/inav/wiki/Modes#auto-level-trim-fw) can be used for this purpose.  
However you also tune manually, by entering `Angle` mode. If your aircraft doesn't fly straight and level, your FC is probably not mounted flat relatively to the aircraft's natural attitude when flying (most planes and wings actually fly with a few degrees of nose-up attitude to maintain their altitude).   
You'll need to trim your board's alignment (`align_board_roll`, `align_board_pitch`, `align_board_yaw`) accordingly. After each adjustment fly again and check if the behavior has improved.

* If you are unhappy with the value of maximum bank/pitch angles, you can adjust them via the `max_angle_inclination_rll` and `max_angle_inclination_pit`. This will provide greater authority on both axis's, within the full stick deflection range.   
 Be aware that if you want the same bank angle in navigation modes, you will also need to increase their values via (`nav_fw_bank_angle`, `nav_fw_climb_angle`, `nav_fw_dive_angle`).

* If you are unhappy with the strength of the Angle mode. For example : it levels out too quickly or harshly. You reduce P-gain of the level controller via `fw_p_level`. While `fw_i_level` only works as a Low Pass Filter for the level controller. Any value greater than 5, is generally faster than a fixedwing can respond to attitude level correction. Reducing it can help, depending on the feel you are after.

### Other tuning tips:

* Setup your TPA correctly - [PID Attenuation and scaling](https://github.com/iNavFlight/inav/wiki/PID-Attenuation-and-scaling)

* Information on FW navigation tuning can be found here - [Navigation PID tuning](https://github.com/iNavFlight/inav/wiki/Navigation-PID-tuning-(FW)).  This is the place to look if you encounter wandering left or right of the heading target. Or oscillations on the pitch axis while attempting to hold altitude.
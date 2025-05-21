### Description of PID-FF controller:

The FF-gain should do most of the work of driving the airplane, if tuned correctly. Which leaves Proportional, Integral and Derivative to make up for slight target error and drift caused by turbulence.  

Tuning of the Rate and Feedforward can be done via [AutoTune](https://github.com/iNavFlight/inav/wiki/Modes#autotune-fw). However, tuning can also be done manually as explained below.

### Manually tuning the maximum rates your airplane can achieve on each axis

* Fly in `MANUAL` mode with the `manual_roll_rate`, `manual_pitch_rate` and `manual_yaw_rate` settings set to 100%.  
Have some way of recording the flight - blackbox, DVR or both.  
Do hard rolls, hard loops and one 360° yaw turn. Use full stick deflection on all these maneuvers.
* To calculate an axis _(approximate)_ rate from a DVR recording, you'll need to count the number of frames it took for your aircraft to do a complete maneuver (roll/flip/yaw turn), determine the average FPS of the recording, and then use this formula **:** `360 / (number_of_frames / FPS)`. You can take multiples samples and average them for a better accuracy.  
You can also use a [Python script](https://gist.github.com/nmaggioni/e42d3f4eb242808df751b13413ebf22c) to help automating the process.

* Typical starting values for Rates, which are suitable for most airplanes are -  
 Roll = 300°/s  
 Pitch = 110°/s  
 Yaw = 60°/s   

* Zero out P, I and D gains on the Roll, Pitch and Yaw controllers.  
* Set `tpa_rate` to 0.   
* Increase FF-gain until you get 90% of full servo throw when having sticks at full throw in `ACRO` mode, when compared to `MANUAL` mode.
* This is so the FF-gain does most of the work turning the airplane, but leaving some for the P and I gain to work with.
* For this step it's convenient to have the two modes `MANUAL` and `ACRO` available on a switch, so you can easily move between the two, and compare the throws.
* The 90% deflection value can also be calculated by dividing 13950 by the maximum rate for the axis, e.g. 360deg/s maximum roll 13950 / 360 = 38.75 FF. For 80% deflection, divide 12400 by the rate. 

* Now set some P and I gain as a starting point.      
   `fw_p_pitch = 7`  
   `fw_i_pitch = 10`  
   `fw_p_roll = 3`    
   `fw_i_roll = 15`   
   `fw_p_yaw = 10`     
   `fw_i_yaw = 5`
    
**Go out and fly in ACRO mode.**

* If the airplane drifts to one side or up/down, increasing the I-gain on that given axis, can reduce the effect.   
Allowing I-gain to do a considerable amount of the work, after Feedforward. Can actually make the Roll axis response smoother from an FPV perspective, than the use of higher P-gain.  

* If you want more stabilization against hard buffeting from the wind, try increasing the P-gain. But only up to a point.   
Too much P-gain can cause oscillations as the airspeed increases.  
P-term will never be able to fully correct for roll axis instability on smaller agile wings, due to processing and SERVO reaction lag. It can often be a case of what you prefer. **i.e.** Faster jittering OR Slower wallowing movements on the roll axis.  

* Once the P-gain it tuned to about 80% of its optimal, at a given air speed. Then start applying some D-gain in small amounts, to add axis damping.

After manually tuning your Rates and Gains. You can reduce them from their limit, to what suits your stick feel and flight requirements.  
It's normal to see reduced servo throw's when reducing rates at this point. If you have full servo throw at this stages you would likely overshoot the target deg/s as well, leaving the P-term to do the rest.

### Fixed Wing I-Term Lock:

The I-Term Lock aims to solve the I-term accumulation and bounce-back on Fixedwing platforms, when the sticks are quickly release back to center, when the airplane still has angular momentum on that axis. 
   
When pilot moves the sticks, the following happens:
* P-term and D-term are attenuated with a bell curve. With no attenuation at stick-center and full attenuation at the `fw_iterm_lock_rate_threshold` percentage of the maximum axis rotation rate.
* When error becomes greater than `fw_iterm_lock_engage_threshold` 10% (default) and `fw_iterm_lock_rate_threshold` 40% (default) is reached. The I-Term is completely attenuated until the Gyro rate error drops below `fw_iterm_lock_engage_threshold` percentage again, and the `fw_iterm_lock_time_max_ms` timer has expired.
* FF-term is never attenuated. As a result, the airplane feels fully stabilized near stick center, and performs like Manual mode when executing fast maneuvers.   

The default settings work fine.  
But if you require less attenuate at a higher rate of axis rotation, [fw_iterm_lock_rate_threshold](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#fw_iterm_lock_rate_threshold) can be increased. For example, in the case of 3D airplanes that uses the I-term to help hold axis attitude. 

On larger air frames that carry more axis angular momentum once in motion, [fw_iterm_lock_engage_threshold](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#fw_iterm_lock_engage_threshold) can also be increased. Or you could add more time to [fw_iterm_lock_time_max_ms](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#fw_iterm_lock_time_max_ms).

### Tune Angle / Horizon mode:

* [Auto Level Trim](https://github.com/iNavFlight/inav/wiki/Modes#auto-level-trim-fw) can be used for this purpose.  
However you can also tune manually if desired, by entering `Angle` mode. If your aircraft doesn't fly straight and level, your FC is probably not mounted flat relatively to the aircraft's natural attitude when flying (most planes and wings actually fly with a few degrees of nose-up attitude to maintain their altitude).   
You'll need to trim your board's alignment via `align_board_roll`, `align_board_pitch`, `align_board_yaw` accordingly. After each adjustment fly again and check if the behavior has improved.

* If you are unhappy with the value of maximum bank/pitch angles, you can adjust them via the `max_angle_inclination_rll` and `max_angle_inclination_pit`. This will provide greater authority on both axis's, within the full stick deflection range.   
 Be aware that if you want the same bank angle in navigation modes, you will also need to increase their values via `nav_fw_bank_angle`, `nav_fw_climb_angle`, `nav_fw_dive_angle`.

* If you are unhappy with the strength of the Angle mode. If it's levels out too quickly or abruptly. You can reduce the P-gain of the LEVEL controller via `fw_p_level`.   
While `fw_i_level` only works as a Low Pass cutoff frequency for the LEVEL controller. Any value greater than 5, is generally faster than a fixedwing can respond to attitude level correction. Reducing it can help, depending on the feel you are after.

### Other tuning tips:

* Setup your TPA correctly - [PID Attenuation and scaling](https://github.com/iNavFlight/inav/wiki/PID-Attenuation-and-scaling)

* Information on FW navigation tuning can be found here - [Navigation PID tuning](https://github.com/iNavFlight/inav/wiki/Navigation-PID-tuning-(FW)).  This is the place to look if you encounter wandering left or right of the heading target. Or oscillations on the pitch axis while attempting to hold altitude.
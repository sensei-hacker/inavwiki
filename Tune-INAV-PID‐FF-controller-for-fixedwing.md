### Description of PID-FF controller:

When tuned correctly, the FF-gain should do most of the work of turning the airplane. Which leaves Proportional, Integral and Derivative to make up for slight target error and drift caused by turbulence.  

Tuning of the Rates and Feedforwards can be done more easily via [AutoTune](https://github.com/iNavFlight/inav/wiki/Modes#autotune-fw), provided it's performed correctly.   
However, tuning can also be done manually as explained below.

### Manually tuning the maximum rates your airplane can achieve on each axis

While in the process of flying manually. It is beneficial at this time to run [Servo Autotrim](https://github.com/iNavFlight/inav/wiki/Modes#servo-autotrim-fw).

> [!Tip]
> Ensure the control surface servo throws are set correctly before you tune the Rates and Feedforwards manually or by the Autotune process.   
Any adjustments to the servo Mixer or Output travels after you have tuned the Rates and Feedforwards, will negatively effect performance. Requiring you to run the tuning process again.


* Fly in `MANUAL` mode with the `manual_roll_rate`, `manual_pitch_rate` and `manual_yaw_rate` settings set to 100%.  
Record DVR footage of the flight, and enable the blackbox to log flight data.  
Perform hard rolls, hard loops and one 360° yaw turn. Apply **full stick** deflection for as long as possible throughout these maneuvers.
* To calculate an axis _(approximate)_ rate from a DVR recording, you'll need to count the number of frames it took for your aircraft to do a complete maneuver (roll/flip/yaw turn), determine the average FPS of the recording, and then use this formula **:** `360 / (number_of_frames / FPS)`. You can take multiples samples and average them for a better accuracy.  
You can also use a [Python script](https://gist.github.com/nmaggioni/e42d3f4eb242808df751b13413ebf22c) to help automate the process.

* Typical starting values for Rates, that are suitable for most airplanes are -  
 Roll = 300°/s  
 Pitch = 110°/s  
 Yaw = 60°/s   

* Zero out P, I and D gains on the Roll, Pitch and Yaw controllers.  
* Set `tpa_rate = 0` -  [PID Attenuation and scaling](https://github.com/iNavFlight/inav/wiki/PID-Attenuation-and-scaling) 
* Increase FF-gain until you get 90% of full servo throw when having sticks at full throw in `ACRO` mode, when compared to `MANUAL` mode.
* This is so the FF-gain does most of the work turning the airplane, but leaving some for the P and I gain to work with.
* For this step it's convenient to have the two modes `MANUAL` and `ACRO` available on a switch, so you can easily move between the two, and compare the throws.
* The 90% deflection value can also be calculated by dividing 13950 by the maximum rate for the axis. e.g. 360deg/s maximum roll `13950 / 360 = 38.75` FF. For 80% deflection, divide 12400 by the rate. 

* Now set some P and I gain as a starting point.      
   `fw_p_pitch = 7`  
   `fw_i_pitch = 10`  
   `fw_p_roll = 3`    
   `fw_i_roll = 15`   
   `fw_p_yaw = 10`     
   `fw_i_yaw = 5`
    
**Go out and fly in `ACRO` mode.**

* If the airplane drifts slightly from center on an axis, once all the other tuning is done. Increasing the I-gain on that given axis, can reduce the effect.   
After Feedforward, allowing I-gain to do more of the work than P-gain. Can actually make the Roll axis response smoother from an FPV perspective, than fighting a loosing battle, by applying too much P-gain, in hopes of removing roll axis wobbles.   
Be cautious. Too much I-gain can also cause oscillation. Values should be limited to maximum of 22. Accounting for [pid_iterm_limit_percent](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#pid_iterm_limit_percent). And the use of [FW I-term Lock](https://github.com/iNavFlight/inav/wiki/Tune-INAV-PID%E2%80%90FF-controller-for-fixedwing/_edit#fixedwing-i-term-lock) in INAV version 8.0 and later.

* If you want more stabilization against hard buffeting from the wind, try increasing the P-gain. But only up to a point.   
Too much P-gain can cause oscillations as the airspeed increases. This is when you want to apply some [Fixedwing TPA](https://github.com/iNavFlight/inav/wiki/PID-Attenuation-and-scaling#airplanes).  
P-term will never be able to fully correct for fixedwing roll axis instability at lower airspeeds, due to processing and SERVO reaction lag. And there not being enough air flow over the control surfaces for it to work with. It can often be a case of what you prefer on the Roll axis. **i.e.** Faster jittering from higher P-gain. Or Slower wallowing movements from higher I-gain.

* Once the P-gain it tuned to about 80% of its optimal, at a given air speed. Then start applying some D-gain in small amounts, to add axis damping.

After manually tuning your Rates and Gains. You can reduce them from their limit, to what suits your stick feel and flight requirements.  
It's normal to see reduced servo throw's when reducing rates at this point. If you have full servo throw at this stages you would likely overshoot the target deg/s as well, leaving the P-term to do the rest.

## Tuning Angle mode:

* [Auto Level Trim](https://github.com/iNavFlight/inav/wiki/Modes#auto-level-trim-fw) should be used for the purpose of tuning the flight inclination level of the wing, comparing to the Flight Controller boards mounting angle.  
However it can also be fine tuned manually if desired. Enter `ANGLE` mode. And check if your aircraft fly's straight and level, without climbing or diving slightly. If it does, your FC is probably not mounted flat relative to the aircraft's Angle of Incidence when flying.
You can adjust it with [fw_level_pitch_trim](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#fw_level_pitch_trim). Or even adjusting the board's alignment via `align_board_roll`, `align_board_pitch`, `align_board_yaw` can also work. Adjustments can be made using the OSD CMS or inflight tuning with the Adjustments tab.
* If the Roll/Pitch bank angles are too low for your taste, you can adjust them via the `max_angle_inclination_rll` and `max_angle_inclination_pit`. This will provide greater authority on both axis's, within the full stick deflection range.   
 Be aware that if you want the same amount of bank angle in navigation modes, you will also need to increase their values via `nav_fw_bank_angle`, `nav_fw_climb_angle`, `nav_fw_dive_angle`. However, keep in mind `nav_fw_bank` angles can not be set greater than `max_angle_inclination`.

* **LEVEL controller** - If you're unhappy with the strength ANGLE based modes return to level, after the stick is released. You can adjust the P-gain of the LEVEL controller via `fw_p_level`. The default value of 20 is optimal. However reducing it can't provide a smoother feel.  
While increasing this value beyond 30 on a fixedwing; generally makes the corresponding axis more jittery when trying to maintain level in turbulent conditions.  
`fw_i_level` works as a Low Pass Filter for the LEVEL controllers update rate. Any value greater than 5, is faster than most fixedwing can respond to attitude level correction. Reducing it in some cases, to 3 or 2, can help provide a smoother feel.

## Fixedwing I-term Lock:

This feature solves the problem of I-term accumulation and bounce-back on a Fixedwing platform, when the stick is quickly release back to center, and the airplane still has angular momentum on that axis. 
   
When the pilot moves the sticks, the following happens:
* P-term and D-term are attenuated with a bell curve. With no attenuation at stick-center, and full attenuation at the `fw_iterm_lock_rate_threshold` percentage of the maximum axis rotation rate.

* When error becomes greater than `fw_iterm_lock_engage_threshold` 10% (default) and `fw_iterm_lock_rate_threshold` 40% (default) is reached. The I-term is completely attenuated until the Gyro rate error drops below `fw_iterm_lock_engage_threshold` percentage again, and the `fw_iterm_lock_time_max_ms` timer has expired.

* FF-term is never attenuated. As a result, the airplane feels fully stabilized near stick center, and performs like Manual mode when executing fast maneuvers.   

The default settings work fine.  
But if you require less attenuate at a higher rate of axis rotation, [fw_iterm_lock_rate_threshold](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#fw_iterm_lock_rate_threshold) can be increased. For example, in the case of 3D airplanes that uses the I-term to help hold axis attitude. 

On air frames that carry more axis angular momentum once in motion, like those with a very high rotation rate or higher wing mass [fw_iterm_lock_engage_threshold](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#fw_iterm_lock_engage_threshold) can be decreased. Or you could add more time to [fw_iterm_lock_time_max_ms](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#fw_iterm_lock_time_max_ms).

______________________

### Other tuning tips:

* Information on FW navigation tuning can be found here - [Navigation PID tuning](https://github.com/iNavFlight/inav/wiki/Navigation-PID-tuning-(FW)).  This is the place to look if you encounter wandering left or right of the heading target. Or oscillations on the pitch axis while attempting to hold altitude.
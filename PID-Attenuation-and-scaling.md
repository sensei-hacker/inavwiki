**TPA** [***Throttle PID Attenuation***] is what allows aircraft that are optimally tuned in the cruise flight range, based on throttle or airspeed, to dynamically adjust PID gains to prevent control oscillations.

## Multirotors

[TPA_Rate](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#tpa_rate) = percentage of PID attenuation that will occur when the throttle is increased above the TPA Breakpoint.

[TPA_Breakpoint](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#tpa_breakpoint) = the throttle micro-second value in the curve at which **TPA_Rate** will begin to be applied. Below that point the PIDs are not attenuated at all.

### How and why to use it?

Firstly, set `TPA_Rate = 15` as a starting point.  
The PID's should be tuned in the throttle range your copter will comfortably cruise at - _e.g. _1300 - 1600uS_ based on thrust to weight ratio and bank angle_.   
But once the throttle is moved higher than this point, you may start seeing oscillations. So begin increasing the **TPA_Breakpoint** to a throttle value just prior to the onset of those oscillations.   
Then slowly increase the **TPA_Rate** value until the oscillations in the higher throttle range are gone.  
It may need to be increase even more on powerful freestyle or race quads.  

**Note** - On reverse motor 3D installs, TPA is not recommended.

### Example of multirotor TPA curve

![](images/tpa_multirotor.png)

## Airplanes

For airplanes **TPA_Rate** works in a different way - It not only attenuates PID gains at higher throttle, but also boosts them at lower throttle, allowing for better control when flying or gliding at low speeds with minimal or no throttle.  
**TPA** is expressed as a curve that boosts PIDs below the **TPA Breakpoint** and attenuates them above the breakpoint.

**TPA_Rate** = amount of attenuation apply to the PIDs. 100% TPA allows PIDs to be scaled by a factor of `[2x boost]` `[0.4 reduction]`.

**TPA Breakpoint** = the point in the throttle curve at which PIDs are not boosted or attenuated. 

[FW_TPA_TIME_CONSTANT](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#fw_tpa_time_constant) = TPA smoothing and time delay constant, to reflect non-instantaneous speed/throttle response of the airplane.

### How to use this?

Tune your PIDs to the throttle range you intend to fly your airplane. [nav_fw_cruise_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_cruise_thr) is ideal. Set that value as the **TPA Breakpoint**. e.g. 1400 - 1480uS  
Once your P and D gains are tuned, and before you add **TPA_Rate**. You may notice when flying at lower throttle, your airplane handles more loosely. And when flying at higher throttle (up to full throttle) it begins to oscillate.   
You can now start increasing the **TPA_Rate** value until those oscillations are gone or minimal in the higher throttle/air-speed range. This will also translate to better handling at lower throttle/air-speeds, by boosting the PID gains.


The **TPA Time Constant** feature uses an asymmetric filter, that effects both increasing and decreasing throttle/speed. Meaning it delays the Removal/Addition of the Attenuation/boost for the selected time period, when the throttle is moved above or below the **TPA Breakpoint**. 
Airplanes with low thrust/weight ratio generally need higher time constant for launch. While planes with a lower drag coefficient, also require a higher time constant during speed wash-off; requiring the constant to be balanced to suit your models requirements.


### Example of airplane TPA curve

![](images/tpa_airplane.png)

> [!NOTE]
> The present airplane implementation has limits. 
Until air-speed support is introduced, INAV only uses the throttle for attenuation, which is relatively proportional to air-speed. But it can not attenuate the PIDs at _lower_ throttle values if the airplane is placed into a dive, causing the air-speed to increase.
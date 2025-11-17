This topic covers methods used to dynamically adjust your models PID gains, to prevent control oscillations as the models airspeed changes throughout the flight.   
Multiple methods are used to accomplish this. Depending on whether it's a multicopter or fixedwing platform.

* [Multicopter TPA](#Multicopter-TPA) - **T**hrottle **P**ID **A**ttenuation

* [Fixedwing TPA and Pitch Angle](#Fixedwing-TPA-and-pitch-angle) - **T**hrottle and Pitch Angle **P**ID **A**ttenuation and boost **(INAV 9.0)**

* [Fixedwing APA](#Fixedwing-APA) - **A**irSpeed **P**ID **A**ttenuation and boost **(INAV 9.0)**

* [Fixedwing TPA](#Fixedwing-TPA) - **T**hrottle **P**ID **A**ttenuation and boost **(Pre INAV 9.0)**

# Multicopter TPA

**Settings :**  

* [TPA_Rate](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#tpa_rate) - percentage of PID attenuation that will occur when the throttle is increased above the `TPA_breakpoint`.

* [TPA_Breakpoint](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#tpa_breakpoint) - the throttle micro-second value in the curve at which `TPA_Rate` will begin to be applied. Below that point the PIDs are not attenuated at all.

### How to use it?

* Firstly, set `TPA_Rate = 15` as a starting point.  
The PID's should be tuned in the throttle range your copter will comfortably cruise at - _e.g. _1300 - 1600uS_ based on thrust to weight ratio and bank angle_.   
* But once the throttle is moved higher than this point, you may start seeing oscillations. So begin increasing the `TPA_breakpoint` to a throttle value just prior to the onset of those oscillations.   
* Then slowly increase the `TPA_Rate` value until the oscillations in the higher throttle range are gone.  
_It may require increasing even more on powerful freestyle or race quads._  

**Note** - On reverse motor 3D installs, TPA is not recommended.

### Example of multicopter TPA curve

![](images/tpa_multirotor.png)

  
> [!note]
>Fixedwing dynamic PIDFF adjustment is broken into multiple methods, based on changes made in INAV 9.0.   

# Fixedwing TPA and Pitch Angle   

_This method uses the throttle position, combine with the airplanes climb or dive angle, to determine the optimal PIDFF gain adjustment required._   

**INAV 9.0**

**Settings :**  

* `TPA_Rate` - the amount of scaling apply to the PIDs. 100% `TPA_Rate` allows the base PID tune to be scaled by a factor of `[2x boost]` _200% gain increase_ - `[0.5 attenuation]` 50% gain reduction.

* `TPA_breakpoint` -  the point in the throttle curve that the base PID tune is not boosted or attenuated. 

* `nav_fw_pitch2thr` - Is used to calculate the collective effect throttle and pitch will exert to dynamically adjust the PIDFF gains.   
The ideal value required for the calculation of this function is **10** or **11**. With 10 being the default value. Adjusting too far outside this range may significantly reduce or increase _TPA/pitch angle_ effectiveness.   
**NOTE :** This setting also influences the navigation [climb throttle](https://github.com/iNavFlight/inav/wiki/Navigation-PID-tuning-(FW)#pitch2throttle-tuning). _So only adjust it in small amounts either side of the default._

* `fw_tpa_time_constant` - is a smoothing and time delay constant, reflecting the non-instantaneous response of the airplane, based on drag, inertia and thrust. This filter works upon forward speed and pitch based gravity induced speed changes.

**FUNCTION :**   

The Throttle position and Climb/Dive angle are used to maintain a balance between attenuating or boosting the gains above or below the `TPA_breakpoint`. This strength is determined by how high you set `TPA_rate`.    
Because this method can account for the pitch angle. It can override the conventional throttle based gain adjustments, according to the effect gravity has on the airplane in a climb or a dive. i.e. The airplane either speeding up in a fall, or slowing down in a climb; which throttle alone can not determine.

**Example :**   
 If you have the airplane flying level at 80% throttle, the gains will have some attenuation applied, so not to experience oscillations at higher flight speeds.  
But if you then pull back on the elevator stick, so the airplane starts climbing vertically at 90°. The speed will now start to wash-off. This in turn will start _reducing_ the gain attenuation, even when at high throttle. Which may even lead to the gains being boosted all the way up to full (200% increase); if the airplane slows enough and comes to a stop while climbing, because it ran out of thrust.     
The same applies if the airplane is placed in a 90° downward dive. When using the old method, having the throttle low in this case, would cause the gains to boost. But because this method knows that the airplane is in a dive, it will start attenuating the gains up to full (50% reduction), because the free-fall speed is increasing, irrespective of the throttle.


### How to use this?

* Tune your PIDs to the throttle range you intend to fly your airplane. [nav_fw_cruise_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_cruise_thr) is ideal. Set that value as the `TPA_breakpoint`. e.g. 1400 - 1480uS  

* If you haven't already tuned your airplane. Make sure you complete an AutoTune with the default PID gains. Otherwise you can use the tune you already have.

* Now you can start increasing the P and D gains around the general throttle value you have `TPA_breakpoint` set. This should be done before altering the `TPA_Rate` from default. 
 
* Now you may notice when flying at lower throttle, your airplane handles more loosely. And when flying at higher throttle (up to full throttle), the control surfaces may begin to oscillate a little.     
You can now start increasing the `TPA_Rate` value until those oscillations are gone in the higher throttle/speed range. This will also translate to tighter handling at lower throttle/speeds, by boosting the PIDFF gains.

* Due to drag also effecting how fast a given airplane will gain or lose speed. `fw_tpa_time_constant` may require adjustment to account for the time it takes for the speed to ramp up or ramp down, based on climb or dive pitch angle. 


# Fixedwing APA

**INAV 9.0**

**Settings :**  

* `Fw_reference_airspeed` - Is the Airspeed at which your _PIDs_, _Rates_ and _Feedforwards_ should be optimally tuned, to provide a strong stabilization response.

* `apa_pow` - Sets how aggressively the gains will be dynamically adjusted from the base PIDFF tune.   
Increasing its value from the default of 120, will boost the gains more aggressively below the `fw_reference_airspeed`, and attenuate them more aggressively above the `fw_reference_airspeed`.    
While decreasing `apa_pow` will make the gain adjustments less aggressive. Meaning the PIDFF gain boost will be weaker, as will its attenuation strength, leaving the based gain tune less altered by airspeed changes.  

> [!tip]  
> Setting `apa_pow = 0` will disable this function and revert to using the _TPA and Pitch Angle_ method instead.   
> If either GNSS data or the Pitot sensor data becomes untrusted. It will also revert back to the _TPA and Pitch Angle_ method. 

**FUNCTION :**    

This method uses airspeed data to dynamically adjusts the PIDFF gains.    
Airspeed can be obtained from either a Pitot airspeed sensor. Or Virtual airspeed, derived from GNSS data _requiring a 3D satellite fix._.    
As with the throttle `TPA_rate` setting, `APA_pow` also uses a similar scaling limit factor of `[2x boost]` 200% increase - `[0.3 attenuation]` 30% reduction.

### How to use this?  
  
* If you have not done so; firstly tune your airplanes rates and Feedforwards with AutoTune, using the default PID gains. But if you already have a workable tune for your airplane, use that. 

* Enter the airspeed value your airplane will comfortably cruise at, into the `fw_reference_airspeed` setting.  
 
* Start incrementally increasing your PID gains, while holding the approximate cruise airspeed you entered above. Tuning can be done easier via [inflight tuning](https://www.youtube.com/watch?v=A5i0gs9LfE8).  

* Once this is complete. You will notice that the stabilization automatically becomes tighter when the airspeed reduces below the `fw_reference_airspeed`, and control surface oscillations are prevented as the airspeed increases above that point.  

* However, if you do encounter control surface oscillations at higher airspeeds, this is when you can increase the value of `apa_pow`. It will allow the gains to become more aggressively attenuated at higher speeds to prevent this occurrence. Only make adjustments by 10 at a time.  

* Also keep in mind that control surface throws as well as higher airspeeds will influence the need to adjust `apa_pow`. If you have larger control surface throws, it may also require increasing.  
But if your airplane is very draggy and can't make it past 120km in a full throttle dive. You can reduce `apa_pow` to provide a tighter stabilization response over the planes whole speed range.

* `fw_tpa_time_constant` is not used in airspeed based dynamic PID adjustment.


# Fixedwing TPA 
**Pre INAV 9.0**

**Settings :**  

* `TPA_Rate` - the amount of scaling apply to the PIDs. 100% **TPA_Rate** allows the base PID tune to be scaled by a limiting factor of `[2x boost]` 200% - `[0.5 attenuation]` 50%.

* `TPA_breakpoint` - the point in the throttle curve that the base PID tune is not boosted or attenuated. 

* `fw_tpa_time_constant` - is a smoothing and time delay constant, reflecting the non-instantaneous speed/throttle response of an airplane, based on drag and inertia. 

**FUNCTION :**

The Throttle stick position is used to not only attenuate the PID gains in the higher throttle range, above the `TPA_Breakpoint`. But also boosts them in the lower throttle range, below the `TPA_breakpoint`, for tighter stabilization control when flying or gliding at lower speeds with minimal or no throttle.  

### How to use this?

* Tune your PIDs to the throttle range you intend to fly your airplane. [nav_fw_cruise_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_cruise_thr) is ideal. Set that value as the `TPA_breakpoint`. e.g. 1400 - 1480uS  

* Once your P and D gains are tuned, and before you add any `TPA_Rate`. You may notice when flying at lower throttle, your airplane handles more loosely. And when flying at higher throttle (up to full throttle) control surfaces may begin to oscillate.     
You can now start increasing the `TPA_Rate` value until those oscillations are gone or minimal in the higher throttle/speed range. This will also translate to better handling at lower throttle/speeds, by boosting the PID gains.


> [!NOTE]
> The above method had its limitations. It can not attenuate the PIDs at _lower_ throttle values if the airplane is placed into a dive, causing the air-speed to increase. This could lead to control surface oscillations.


### Example of airplane TPA curve

<img width="527" height="381" alt="tpa_airplane" src="https://github.com/user-attachments/assets/13615703-e8e5-4738-9351-a9c448275077" />

This topic covers methods used to dynamically adjust your models PID gains, to prevent control oscillations as the models airspeed changes throughout the flight; while still maintaining an adequate stabilization response.  
Multiple methods are used to accomplish this. Depending on whether it's a multicopter or fixedwing platform.

* [Multicopter TPA](#Multicopter-TPA) - **T**hrottle **P**ID **A**ttenuation

* [Fixedwing APA](#Fixedwing-APA) - **A**irSpeed **P**ID **A**ttenuation and boost **(INAV 9.0)**

* [Fixedwing TPA and Pitch Angle](#Fixedwing-TPA-and-pitch-angle) - **T**hrottle and Pitch Angle **P**ID **A**ttenuation and boost **(INAV 9.0)**

* [Fixedwing TPA](#Fixedwing-TPA) - **T**hrottle **P**ID **A**ttenuation and boost **(Before INAV 9.0)**

# Multicopter TPA

**Settings :**  

* [TPA_Rate](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#tpa_rate) - percentage of PID attenuation that will occur when the throttle is increased above the `TPA_breakpoint`.

* [TPA_Breakpoint](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#tpa_breakpoint) - the throttle micro-second value in the curve at which `TPA_Rate` will be applied. Below this value the PIDs are not attenuated at all.

### How to use it?

* Firstly, set `TPA_Rate = 15` as a starting point.  
The PID's should be tuned in the approximate throttle range your copter will comfortably cruise at.  
* Once the throttle is moved higher than this point, you may start experiencing oscillations. So begin increasing the `TPA_breakpoint` to a throttle value just prior to the onset of those oscillations.   
* Then incrementally increase the `TPA_rate` value until the oscillations in the higher throttle ranges are gone.  
_It may require increasing considerably higher on more powerful freestyle or race quads._  

**Note** - TPA is not recommended for reverse motor 3D installs.

### Example of Multicopter TPA curve

![](images/tpa_multirotor.png)

# Fixedwing
  
> [!Warning]   
>Fixedwing dynamic PIDFF adjustment is broken into multiple methods, based on changes made in INAV 9.0.   
>It is important to understand the operation of both new methods.   
**_TPA and Pitch angle_ should also be tuned, due to it becoming a fall-back if the _APA_ speed source fails**.  

## Fixedwing APA

_This method uses the planes airspeed to determine the optimal dynamic PIDFF gain adjustments required._ 

**INAV 9.0**

**Settings :**  

* `Fw_reference_airspeed` - Is the cruise airspeed at which your _PIDs_, _Rates_ and _Feedforwards_ should be optimally tuned, to provide a strong stabilization response.

* `apa_pow` - Sets how aggressively the gains will be dynamically adjusted from the base PIDFF tune.   
Increasing its value from the default of 120, will boost the gains more aggressively below the `fw_reference_airspeed`, and attenuate them more aggressively above the `fw_reference_airspeed`. Which will also cause the gain scaling factor to reach its limit at a lower maximum airspeed.    
While decreasing `apa_pow` will provide less aggressive gain scaling, allowing attenuation/boost to occur over a broader speed range. _[See plot](https://github.com/iNavFlight/inav/wiki/PID-Attenuation-and-scaling/_#example-of-a-fixedwing-apa-curve)_ 

> [!Note]
> Setting `apa_pow = 0` will disable this function and revert to using the _TPA and Pitch Angle_ method instead.   
> If either GNSS data or the Pitot sensor data becomes **untrusted**. It will also revert back to the _TPA and Pitch Angle_ method.    



**FUNCTION :**    

This method uses airspeed data to dynamically adjusts the PIDFF gains.    
Airspeed can be obtained from either a Pitot airspeed sensor. Or Virtual airspeed, derived from GNSS data, _requiring a 3D satellite fix._.    
As with the throttle `TPA_rate` setting, `APA_pow` also uses a similar scaling limit factor of `[2x boost]` 100% increase of the base gains - `[0.3 attenuation]` 70% reduction of the base gains.

> [!Caution]   
> Neither airspeed source is perfect. A Pitot tube can become partially blocked in flight. And Virtual airspeed may fluctuate depending on its data quality. For this reason, do not over tune your base PID gains. For the same reason, do not increase `apa_pow` too far above the default unless you have a slower airplane.

### How to use this?  
  
* If you have not done so; firstly tune your airplanes rates and feedforwards with AutoTune, using the default PID gains. But if you already have a workable tune for your airplane, start with that. 

* Enter the airspeed value your airplane will comfortably cruise at, into the `fw_reference_airspeed` setting. `[cm/s]`  
 
* Start incrementally increasing your PID gains, while holding the approximate cruise airspeed you entered in the above setting. Tuning can be done easier via [inflight tuning](https://www.youtube.com/watch?v=A5i0gs9LfE8).   
**Ideally you do not want to tune the PID gains too tight. Backing them off at least 15% from the point you experience oscillations, gives the software some working room.** 

* Once this is complete. You will notice that the stabilization automatically becomes tighter when the airspeed reduces below the `fw_reference_airspeed`. And control surface oscillations are prevented as the airspeed increases above that point.  

* However if you have a faster airplane that encounters control surface oscillations at much higher speeds. You can decrease the value of `apa_pow`. It will allow the dynamic gain attenuation to occur over a wider speed range. Which also prevents the boost scaling limit being reached too far above the planes minimum flight speed.
Keep in mind. The strength or tightness of the base PID tune will also effect this. e.g. The tighter the tune, the more noticeable control surface oscillation may become if the flight speed continues to rise above the point of which the attenuation scaling limit is reached.  _[See plot](https://github.com/iNavFlight/inav/wiki/PID-Attenuation-and-scaling/_#example-of-a-fixedwing-apa-curve)_          
**NOTE :** Do not make adjustments of more than 10 at a time.   

* Also keep in mind that control surface throws as well as higher airspeed will influence the need to adjust `apa_pow`.  
If you have larger control surface throws, it may also require decreasing.  
But if your airplane is very draggy and can't make it past 125km in a full throttle dive. You can increase `apa_pow` to provide a tighter stabilization response over the airplanes narrow flight speed envelope.

* `fw_tpa_time_constant` is not used for airspeed based dynamic PID adjustment.


### Example of a Fixedwing APA curve

This plot shows how adjusting `apa_pow` alters the scaling of the gains across the airplanes whole speed envelope.
Take note of the airspeed at which the gain scaling limits will be reached, depend on the relationship between `fw_reference_airspeed` and `apa_pow`.   
Altering either will mathematically change the points in the speed curve at which the attenuation/boost scaling limits are reached.

<img width="1000" height="600" alt="Apa plot" src="https://github.com/user-attachments/assets/2d513a9c-9f85-4447-8d6c-ea1541173f62" />




## Fixedwing TPA and Pitch Angle   

_This method uses the throttle position, combine with the airplanes climb or dive angle, to determine the optimal dynamic PIDFF gain adjustments required._   

**INAV 9.0**

**Settings :**  

* `TPA_rate` - is the amount of scaling apply to the dynamic PID adjustment.   
 200% `TPA_rate` allows the base PID tune to be scaled by a factor of `[2x boost]` _100% increase of the base gains_ - `[0.4 attenuation]` 60% reduction of the base gains. _[See plot](https://github.com/iNavFlight/inav/wiki/PID-Attenuation-and-scaling/_#example-of-a-fixedwing-tpa-curve)_

* `TPA_breakpoint` -  is the throttle value when the base PID tune is not boosted or attenuated. This value should approximate the amount of throttle/thrust the airplane requires to hold its optimal cruise speed when flying in no wind, or a crosswind. Ideally you should aim for a throttle value that approximates the same speed as you have APA `fw_reference_airspeed` set.

* `tpa_pitch_compensation` - is used to calculate the collective effect pitch will exert on-top of the raw throttle input, to _reverse_ the way gains are dynamically adjusted. _Put simply - Boost becomes Attenuation, and Attenuation becomes Boost under certain flight conditions._       
The ideal value for this function is **8**, which is the default.    
DECREASING its value will provide a weaker gravity induced pitch angle influence over the raw throttle, and therefor the gains.  While INCREASING it will provide a stronger pitch angle influence over the raw throttle.  _[See plot](https://github.com/iNavFlight/inav/wiki/PID-Attenuation-and-scaling/_#example-of-a-fixedwing-tpa--pitch-angle)_ 

> [!Note] 
>Setting `tpa_pitch_compensation = 0` allows it to work in way the old fixedwing TPA did. Which isn't really desirable.

* `fw_tpa_time_constant` - is a smoothing and time delay constant, reflecting the non-instantaneous speed response of an airplane to throttle changes, based on relative drag, inertia and thrust.  
This filter accounts for rapid throttle movements and the effect gravity has upon speed in a climb or dive. 

**FUNCTION :**   

The Stick or Nav throttle input is used collectively with the climb/dive angle, to more accurately attenuation or boost the gains if the airspeed source fails. Or if you choose not to fly with an airspeed source.  
The dynamic PID attenuation/boost strength is determined by how high you set `TPA_rate`.    
Because this method accounts for the pitch angle. It can override the conventional throttle based gain adjustments, according to the effect gravity has on the airplane in a climb or a dive. **i.e.** The airplane will either speed up in a fall, or slow down in a climb; which throttle position alone can not determine.

**Example :**   
If your airplane is flying level at 80% throttle, the gains will have some attenuation applied to them at that airspeed to prevent control oscillations.
But if you then pull back on the elevator stick, so the airplane starts climbing at a high angle. The vertical airspeed will generally start to wash-off if your airplane is not over powered. Leading to a transition from gain attenuation to gain boost. This will tighten the gains as the airplane slows closer to a stall, even when the throttle is higher. 
 
The same applies if the airplane is placed into a low throttle steep downward dive.  
When using the old TPA method, having the throttle low in this case would cause the gains to boost. But because this method knows the airplane is in a dive, it will override the raw throttle command and start attenuating the gains to prevent oscillations; because the airplanes free-fall speed is increasing, irrespective of the throttle.


### How to use this?

* **You should increase the** `TPA_Rate` **from the default, to a conservative value of 80% when you're tuning the base gains**. So it allows _some_ dynamic PID adjustment to occur. Otherwise a tight base gain tune around the TPA_breakpoint will instantly cause oscillation if you increase the throttle/speed by too much.

* If you haven't already tuned your airplane. Make sure you complete an AutoTune with the default PID gains. Otherwise you can use the tune you already have.    

* Set`TPA_breakpoint` to the approximate throttle/cruise speed your airplane will comfortably fly at. [nav_fw_cruise_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_cruise_thr) is ideal.      

> [!Tip] 
>If you have already tuned your base PID gains tightly using the APA function. You do not need to re-tune them again, as stated in the next step.

* While [inflight](https://www.youtube.com/watch?v=A5i0gs9LfE8) you can start increasing the P and D gains around the throttle value you have `TPA_breakpoint` set. Keep an eye on the OSD airspeed indicator. Make sure it doesn't wonder too far from the approximate speed, which correlates to holding the throttle stick position you set for the `TPA_breakpoint`. This is better done on a day with little wind.
 
* Once you have the `TPA_breakpoint` base PID gains tuned firmly, but not tight. Push the throttle upwards toward full and let the speed increase. If oscillations start to occur. Incrementally increase the `TPA_rate` until they are gone.     
Now when your flying at lower throttle, your airplane should feel tighter in its stabilization response. And when flying at higher throttle (up to full throttle), the control surfaces should not oscillate. 

* Due to drag also effecting how fast a given airplane will gain or lose speed. `fw_tpa_time_constant` may require adjustment to account for the time it takes for the speed to ramp up or ramp down, based on climb or dive pitch angle, or a fast throttle stick command.

* If your airplane has a high thrust to weight ratio and can climb at a high angle and at high speed. It can be beneficial to start **incrementally** decreasing `tpa_pitch_compensation`. This will reduce the effect pitch angle has over raw throttle. Thus preventing the gains for being boosted excessively at higher climb speeds, preventing control surface oscillations.  
The same will apply in a lower throttle dive, if you feel the gains are being attenuated too much. You can also **incrementally** reduce `tpa_pitch_compensation`.   
**NOTE :** I wouldn't recommend going lower than 5 in either case, unless your airplane is very fast. Other wise it may reduce the effect gravity induced pitch angle scaling has over TPA in a high speed dive. _[See plot](https://github.com/iNavFlight/inav/wiki/PID-Attenuation-and-scaling/_#example-of-a-fixedwing-tpa--pitch-angle)_

### Example of a Fixedwing TPA curve

This plot shows how adjusting the `TPA_rate` will effect the scaling of the gains at different points in the throttle/speed range.  

<img width="1000" height="600" alt="TPA curve" src="https://github.com/user-attachments/assets/11788db8-4a7a-4337-ac75-e4c927d2c5c5" />


### Example of a Fixedwing TPA + pitch angle

This plot shows the collective effect pitch angle and raw throttle have on PID scaling. And the influence which lowering `tpa_pitch_compensation` has on those gains, to prevent oscillations on powerful planes while in a sustained high speed climb. The plot also shows a slight increase in the gains while in a dive at lower throttle. This is why reducing `tpa_pitch_compensation` below 5 is not recommend. Especially if your airplane is very aerodynamic.

<img width="1000" height="600" alt="TPA+ pitch output vs pitch angle (full envelope)" src="https://github.com/user-attachments/assets/d238af2c-dab5-49e2-a2cf-5dbd1e9ed6c0" />



## Fixedwing TPA 
**Before INAV 9.0**

**Settings :**  

* `TPA_Rate` - the amount of scaling apply to the PIDs. 100% **TPA_Rate** allows the base PID tune to be scaled by a limiting factor of `[2x boost]` - `[0.5 attenuation]`.

* `TPA_breakpoint` - is the point in the throttle curve when the base PID tune is not boosted or attenuated. 

* `fw_tpa_time_constant` - is a smoothing and time delay constant, reflecting the non-instantaneous speed response of an airplane to throttle changes, based on drag and inertia. 

**FUNCTION :**

The Throttle stick position is used to not only attenuate the PID gains in the higher throttle range, above the `TPA_Breakpoint`. But also boosts them in the lower throttle range, below the `TPA_breakpoint`, for tighter stabilization control when flying or gliding at lower speeds with minimal or no throttle.  

### How to use this?

* Tune your PIDs to the throttle range you intend to fly your airplane. [nav_fw_cruise_thr](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_fw_cruise_thr) is ideal. Set that value as the `TPA_breakpoint`. e.g. 1400 - 1480uS  

* Once your P and D gains are tuned, and before you add any `TPA_Rate`. You may notice when flying at lower throttle, your airplane handles more loosely. And when flying at higher throttle (up to full throttle) control surfaces may begin to oscillate.     
You can now start increasing the `TPA_Rate` value until those oscillations are gone or minimal in the higher throttle/speed range. This will also translate to better handling at lower throttle/speeds, by boosting the PID gains.


> [!NOTE]
> The above method had its limitations. It can not attenuate the PIDs at _lower_ throttle values if the airplane is placed into a dive, causing the air-speed to increase. This could lead to control surface oscillations.

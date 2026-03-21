> [!NOTE]
>This page provides a general guide for things specific to Multicopter setup and tuning.  
 It assumes you have already setup your `Ports`, `Modes`, `Navigation`, `Receiver`, `GPS`, `OSD` etc. They are outside the scope of this document.


## 1. Getting your flight controller ready.

* Download latest configurator from [here](https://github.com/iNavFlight/inav-configurator/releases). And the latest INAV firmware from [here](https://github.com/iNavFlight/inav/releases/tag/9.0.1).

* Flash you flight controller with the full chip erase option selected.

* You will be asked to select a model preset type. Choosing one of these options will provide you base setting to begin tuning from.

* Go to the `Calibration Tab` and follow the instructions given, to perform an `Accelerometer Calibration`.

* If the model type you required was not in the presets. Go to the `Mixer Tab` and select one of the `Mixer presets` in the drop-down menu. Many of the more common mixers are available. (Tri, Hex, Octo etc)   
Press **Load and Apply** to make your choice.  
For even less common mixer types, also see [Custom mixes for exotic setups](https://github.com/iNavFlight/inav/wiki/Custom-mixes-for-exotic-setups#setups-that-can-be-implemented-with-custom-mixer).
Other Mixer related information can be found [here](https://github.com/iNavFlight/inav/wiki/Mixer-Tab) and [here](https://github.com/iNavFlight/inav/blob/master/docs/Mixer.md). 

* If the motor output plug on your flight controller does not align with the input plug of the **4 in 1** ESC. e.g. **S1** to **S1** and **S2** to **S2** etc. But instead, they may be something like **S1** to **S4** and **S4** to **S1**. You can use the `Motor Mixer Wizard` in the `Mixer Tab`, to allocate a motor output from the flight Controller, to the corresponding position each motor is located, according to which of the 4 ESC's it is wired to.

* Select motor direction if required. Depending on whether you want to run `Props IN` or `Props OUT`.

* Now go to the `Outputs Tab`, and **Enable Motor and Servo output**.

* While in the `Outputs Tab`, select the **ESC protocol** of your choice.

* If you use a magnetometer (recommended), it will also require setup in the `Alignment Tool Tab` and `Calibration Tab`. More specific information with regards to Flight Controller / Magnetometer alignment and calibration can be under [GPS and Compass setup](https://github.com/iNavFlight/inav/wiki/GPS-and-Compass-setup).

* Once the above is complete. Make sure the Copter moves identical to the virtual image in the `Status Tab`. It must do this on all 3 axis's. An deviation indicates incorrect alignment or calibration.

## 2. Tune your copter's Pitch/Roll/Yaw/Level PIDs and other values

INAV multicopter tuning can be made easier for new users with [EZ-Tune](https://github.com/iNavFlight/inav/wiki/EZ%E2%80%90TUNE).  
When you load a platform preset after flashing your hardware. Multicopter EZ-Tune will be enabled by default in the Tuning Tab.  
If you wish to run your own tune. Turn off the ENABLED button.


> [!Tip]
> The default presets many not always be correct. Due to the influence your selected hardware can have upon the PID tune.    
>
> **Example:** A lower powered 5" cruiser running on a 3 cell battery, will generally require a different tune to a 5" race quad running on a 6 cell battery.   
> The reason being is because the 6s quad will provide far more thrust for the PID controller to work with. Actually making tuning easier. But often requiring the PID values to be lower, because the PID setpoint error can be dealt with much faster.

The image below shows an example of the preset tune for a 7" multicopter.

<img width="1113" height="354" alt="7 inch MC preset" src="https://github.com/user-attachments/assets/212b1b0e-a138-40b8-9826-94150834bc7c" />

But in the case mentioned above under the `TIP`. Such a tune is better suited to a multicopter that is NOT running a stronger power train. Like a 6 cell install.    

The tune below has the _Integral_ and _Derivative_ gains on the pitch and roll reduced, to better suit a multicopter that has a higher power to weight ratio.     
If you have migrated from BetaFlight to INAV. These gains will provide a safer start point to begin tuning from. Whether it be a 3", 5" or 7" build.

<img width="1112" height="349" alt="Higher performance quad starting tune" src="https://github.com/user-attachments/assets/0c5334df-9578-4f39-a9b5-b27e87c41217" />

## 3. Navigation specific settings

Adjusting these setting won't take long, but it is often over looked in setup. Leading to poor navigation performance or a crash landing in a Failsafe condition.

`nav_mc_hover_thr` - Please read [here](https://github.com/iNavFlight/inav/wiki/Navigation-modes#using-althold-with-a-multicopter-mc) for a more detailed explanation of why it is important to adjust this setting.

`failsafe_throttle` and `failsafe_of_delay` - Please read through this short explanation [here](https://github.com/iNavFlight/inav/wiki/Failsafe#configuration-of-inav) to help understand why adjusting these settings is required.

## 4. Battery settings

Adding your batteries specifics into the CLI, under `# battery_profile`. Or in the Configurator _Configuration Tab_ is a very important step.    
Overlooking this step can leave you in a bad situation. Causing your battery to become unknowingly discharged during flight, leading to a crash. Which could be a safety hazard on a longer range flight.

* `vbat_warning_cell_voltage` - _Pre-warning_. Set to 3.6v is good for a LiPo. 
* `vbat_min_cell_voltage` - _Time to land_. Set to 3.4v is good for a LiPo.   
* `battery_capacity` - Set to the rated `mAh` capacity of your battery pack.  
* `battery_capacity_warning` - Generally set to 25%. Which is 25% of the batteries rated capacity. 
* `battery_capacity_critical` - Set to 20%. 

> [!Note] 
> Continually discharging many lithium chemistry batteries below 20% or their capacity, under higher discharge loads can shorten the batteries life expectancy.

More in depth battery related setup information can be found [here](https://github.com/iNavFlight/inav/blob/master/docs/Battery.md).

## 5. Selecting filters 

At the time of writing this. INAV has the following software filter methods. They are used to isolate and remove vibrations from the Gyro and Accelerometer data.
* `gyro_filter_mode` - STATIC, DYNAMIC, ADAPTIVE
* `dynamic_gyro_notch_enabled` (default ON - aka Matrix filter)
* `rpm_gyro_filter_enabled` (default OFF - ESC telemetry, non bi-directional Dshot)
* `gyro_anti_aliasing_lpf_hz` (default ON - zero = OFF)
* `gyro_lulu_enabled` (default OFF)
* `smith_predictor_delay` (zero = default OFF)
* `setpoint_kalman_enabled` (default ON - aka Unicon filter) 

Filters add control delay, and can only remove so much noise. For this reason it is always better to tune your hardware first, to eliminate as many vibrations as possible. By balancing the motors and the props.   
Just because the hardware is new. Does not mean it is well balanced from factory.  
Also provide good vibration damping on your flight controller. Do not set the stack bolts too tight, only firm to lite. 

It's better to run a few good filters, than to run every filter available. Which will only add more delay and little benefit.  
I have placed the filters in the order of the ones I would personally choose, from first to last.

 

## 5. Get to know the CLI values.
INAV offers a lot of customization through CLI variables. It is strongly recommended to read through [CLI Variable reference](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md) and [available CLI variables](https://github.com/iNavFlight/inav/blob/master/docs/Cli.md)

# Setting up Failsafe for RTH

>[!Warning]
>You can assign an RC mode switch to _simulate_ how a FAILSAFE condition will respond, if the RX signal is actually lost in flight.  
**FAILSAFE mode** will return the aircraft to the home location. But it should not be used in place of **RTH mode** for manual activation. Functionally, FAILSAFE mode does not work the same as RTH mode in all cases.   
So bear in mind, that while the FAILSAFE mode is activated, the FC will behave as if the radio link is lost. This means you will **not** be able to Disarm.    
To regain control, either -   
>- Cancel the FAILSAFE mode with your assigned RC switch.    
>- Move the roll or pitch stick. [failsafe_stick_threshold](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#failsafe_stick_threshold)  


## Foreword

The goal is to configure both your flight controller and radio receiver so that failsafe does as you expect in every situation.

For failsafe to work optimally INAV needs to know it's in a failsafe event and not just doing regular RTH. This is necessary for it to correctly handle loss of GNSS signal while returning to home. Or to handle functions that can be operated by stick command in RTH mode. e.g. [nav_rth_alt_control_override](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_rth_alt_control_override)

This assumes you have regular GNSS navigation modes like `RTH` working **already**.

## Configuration of receiver

You have several options on how to configure your receiver:

### Option one

Set your receiver to `NO PULSES`/ `CUT` in the case of radio signal loss.    
`NO PULSES` / `CUT` is generally best used for modern RX links. The RX will send data via the serial connection, to inform the FC of a Failsafe condition. Or a loss of that data by hardware failure also triggers a failsafe.

### Option two

Set your receiver to `FS POS`. Also set one of the receiver channels to output a value to activate INAV FAILSAFE mode when the radio link is lost.  
Set up INAV FAILSAFE mode on that RC channel.   


### Option three

Set up `FS POS` so the radio receivers throttle channel outputs a value below the [rx_min_usec](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#rx_min_usec) setting in an RX Failsafe condition. This will trigger INAV FAILSAFE when the RX link is lost.   
_The throttle channel lower endpoint may need to be temporarily set to the lowest setting allowing the failsafe value to be set low also. Once the receiver failsafe setting has been saved the throttle endpoint can be returned to the normal value._

## Configuration of INAV

Go to the Configurator `Failsafe` tab, and enable `RTH` as Stage 2 failsafe.

For fixed wing set [failsafe_throttle_low_delay](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#failsafe_throttle_low_delay) = 0 or else it will disarm the airplane in flight when Failsafe triggers, if you have the throttle low for the default time period.

The behavior of `RTH` can also be configured in [Navigation: RTH mode](https://github.com/iNavFlight/inav/wiki/Navigation-Mode:-Return-to-Home) 

Loss of GNSS during Failsafe RTH will result in an emergency landing. So make sure the following are set to avoid surprises:
- [nav_emerg_landing_speed](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#nav_emerg_landing_speed) - default is 5 m/s. Alter for a fixed wing.
- [failsafe_off_delay](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#failsafe_off_delay) - default will disarm after 20s. Increase or decrease to suit the estimated time required, for the general altitude you fly at.
- [failsafe_throttle](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#failsafe_throttle) - The default setting of 1000uS will cause a copter to revert to the DROP procedure if not increased to slightly below hover throttle.

## Verifying that failsafe works as intended

**Verify that your failsafe works without props:**

1. Remove all props

2. Go outside, Arm and apply throttle. Walk/run more than 10 meters away from the arming location and then turn off the radio transmitter.     
The aircraft should now try to climb. This can be seen by the motor/s increasing in speed. And in the case of a fixedwing. The elevator will deflect upwards, as if to climb. And the ailerons will also deflect, as if it's turning back towards home.  
_Also verify that you're able to regain control by turning on transmitter again, and move the ROLL/PITCH stick more than `failsafe_stick_threshold`_


>[!Note] 
>If you are using a fixed wing without a magnetometer enabled, you will need to run with the airplane before the test. This is because GNSS speed needs to be above a certain threshold to acquire a valid heading. Without a valid heading failsafe will not initiate. 

**Now, verify that failsafe works while in flight:**

1. Put the props on again

2. Take off, fly at least 50 meters from the home arming location. Then turn off the radio transmitter.   
 
>[!Tip] 
>Do this over soft grass if its a multicopter. While if it's an airplane, it's better to have some altitude.  
>To regain control after a failsafe event, you must move the roll/pitch sticks more than `failsafe_stick_threshold` in order to regain control. 
______________________________________________________

### INAV offers additional failsafe safety features ###

[failsafe_min_distance](failsafe_min_distance) and the action you wish to invoke [failsafe_min_distance_procedure](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md#failsafe_min_distance_procedure)  

[failsafe_throttle_low_delay](failsafe_min_distance_procedure) (Time throttle level must have be low before auto disarm)  
This setting could ruin your day with a mid-air disarm. But conversely save you from personal injury if it is forgotten to disarm the craft (not using motor stop also goes a long way to making the craft safer as the spinning propellers are a visible sign the craft is armed and dangerous).

Handling with and without GNSS data loss - https://github.com/iNavFlight/inav/wiki/GPS-Failsafe-and-Glitch-Protection#emergency-landing

Further reading and settable parameters are available here -
https://github.com/iNavFlight/inav/blob/master/docs/Failsafe.md#failsafe_throttle



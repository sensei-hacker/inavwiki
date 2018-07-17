## 0. Setup hardware
Balance props and motors, install FC on a vibration-damping mount if possible.

## 1. Getting your flight controller ready.

* Download latest configurator from [here](https://github.com/iNavFlight/inav-configurator/releases)
* Flash newest iNav with full chip erase option selected
* Do the advanced 6-point [sensor calibration](https://github.com/iNavFlight/inav/wiki/Sensor-calibration).
* Select your Mixer. Most common ones are already available as presets. For exotic setups, see [Custom mixes for exotic setups](https://github.com/iNavFlight/inav/wiki/Custom-mixes-for-exotic-setups#setups-that-can-be-implemented-with-custom-mixer)
* Be sure the model moves on the configurator as it is moving on the bench. If not, adjust board alignement from the Configuration tab


## 2. Configure your TX
No special mixers have to be applied on the TX. Just bypass all the channels as they are to the FC.
Set trim on your TX to zero. Use subtrim to adjust your TX midpoints to be precisely 1500 when Roll/Pitch/Yaw sticks are centered. You can check the input values in the Receiver tab in iNav configurator. All values should be in the range 1000-2000uS.

## 3. Tune your copter's Pitch/Roll/Yaw/Level PIDs and other values

Many presets are available on the specific configurator tab and they mostly represent a good starting point.
Be sure to load the correct present and double check the applied configuration.

[Default values for different type of aircrafts](https://github.com/iNavFlight/inav/wiki/Default-values-for-different-type-of-aircrafts)

## 4. Trim copter to level flight
DO NOT USE TRIM on your Transmitter to stop your copter drifting. Use board alignment settings or accelerometer trim stick combos.
You can use RX stick combination to trim the quadcopter: [Controls](https://github.com/iNavFlight/inav/blob/master/docs/Controls.md) 

## 5. Check your sensors
* If any, be sure the baro readings are correct and be sure the barometer is shielded with some foam to avoid to be disturbed my the air pushed on it by the propellers.
* If a magnetometer is in use, be sure to check it is proving the correct heading information. After having calibrated it (outside far away from buildings and parking lots) be sure that when you point the multirotor nose to the north the heading is 0 and it still be around 0 even if you tilt the quadcopter a bit on pitch and roll axis. Be also sure that magnetometer is placed resonably away from interference source (see power wires).
Having a good compass reading is **crucial** for navigation function to function correctly.

## 6. Setup and verify failsafe on TX and iNav
[Guide for setting up failsafe](https://github.com/iNavFlight/inav/wiki/Failsafe#setting-up-failsafe-with-return-to-home)

## 7. Determine and set hover throttle
To let the altitude hold controller work correctly you need to input your hover throttle (the throttle you need to apply to make the multirotor to hover) into the **nav_mc_hover_thr** CLI variable or just set it via the configurator's configuration tab.
If your copter jumps/rises when you activate altitude hold, reduce your nav_mc_hover_thr a bit. If your copter falls, increase it a bit, fine tune until there is no jump or fall when activating altitude hold.


## 8. Get to know the CLI values.
iNav offers a lot of customization through CLI variables. Its strongly recommended to read through [iNav CLI variables](https://github.com/iNavFlight/inav/wiki/iNav-CLI-variables) and [available CLI variables](https://github.com/iNavFlight/inav/blob/master/docs/Cli.md)

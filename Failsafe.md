# Setting up Failsafe for RTH

## Foreword

The goal is to configure both your flight controller and radio receiver so that failsafe does as you expect in every situation.

For failsafe to work optimally iNav needs to know it's in a failsafe event and not just doing regular RTH. This is necessary for example to correctly handle loss of GPS while returning to home.

This assumes you have regular GPS modes like `RTH` working **already**.

## Configuration of receiver

You have two options on how to configure receiver.

### Option one

Set receiver to send out `NO PULSES` on a failsafe event.

### Option two

1. In `Modes` tab select a switch for "Failsafe"

1. Set your switches and sticks of your radio to the following conditions:

    -  `Throttle: approx. 0% (no throttle)`
    -  `Aileron: 50% (no input, stick center)`
    -  `Rudder: 50% (no input, stick center)`
    -  `Elevator: 50% (no input, stick center)`
    -  `Failsafe mode: activated`
    -  `Arm switch: Disarmed (If you use stick arming you can skip this)`

1. Configure failsafe on your receiver to the above conditions on link loss (consult manual for your receiver on how to do it)

## Configuration of iNav

Go to `Failsafe` tab, and enable `RTH` as Stage 2 failsafe.

The behavior of `RTH` can also be configured.

 - [iNav Flight modes / Navigation Modes](/iNavFlight/inav/wiki/Navigation-modes#rth-altitude-control-modes)

## Verifying that failsafe works as intended

Verify that your failsafe works without props:

1. Remove all props

1. Go outside, arm and apply throttle, walk with it 20meter away from home (normally the place where you armed it) and then turn off transmitter. The aircraft should now try to climb (increase throttle). Also verify that you're able to regain control by turning on transmitter again, and move the ROLL/PITCH stick more than `failsafe_stick_threshold`.

Now, verify that failsafe works while in flight:

1. Put the props on again.

1. Take off, fly at least 20 meters from home, and turn off transmitter. Tip: Do this over soft grass. If it's an airplane it's better to have some altitude.

Note: If you are using a fixedwing without a magnetometer enabled you will need to run with the airplane before turning off the transmitter to test failsafe. This is because GPS speed needs to be above a certain threshold to acquire a valid heading. Without a valid heading failsafe will not initiated.

Note: To regain control after a failsafe event, you must move the roll/pitch sticks more than `failsafe_stick_threshold` in order to regain control.

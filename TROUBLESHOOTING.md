# UAV won't arm
1. Verify that it is level. You can bypass this requirement by typing "set Small_angle=180" then "save" in the CLI.
2. Run-time calibration not completed. Put the UAV flat and immobile on a surface.
3. GPS doesn't have a lock. Move to an area with no sky obstruction or interference and wait. If lock still doesn't happen after a minute, relocate your GPS far from ob-board electrics or shield the bottom part with copper tape.
4. Compass not calibrated. Start compass calibration from configurator or stick control and, within 30 seconds, face all 6 face of the UAV to the ground.
If none of the above work, verify in your goggles or CLI "status" command the cause. Hardware malfunction might be the cause.

# UAV shakes
1. Verify that frame & motors are solidly bolted together, on an H-frame double up the bottom plate.
2. lower P on Roll and Pitch from configurator, adjustments or stick control
3. drop PID to 1,1,1 for Pitch and Roll and do a PID tuning from scrartch https://youtu.be/4sjXJ5HoU_c or https://youtu.be/ehyXLsvaEhw

# POS HOLD moves...
1. ...in circles, redo MAG calibration

# Transition to ALT HOLD is bad
1. Get your UAV in a stable hover in ACRO or ANGLE mode, find the amount of throttle required (openTX>Output>Throttle number at the top). Dial this number in configurator>Advanced Tuning tab>Hover Throttle
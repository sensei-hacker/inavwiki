# Introduction
We're assuming you've installed the configurator and have connected to your flight controller (FC). The Setup Tab is the first screen you see once a connection is made. This tab has three main sections:
- Reset Settings
- Live 3D Graphic of your Aircraft
- Pre-Arming Checks
- Info (power stats & Rx RSSI)
- GPS (status)

### Reset Settings
Pressing this button will reset the flight controller (FC) to default values. This is useful if you truly want to restart from scratch such as if you installed a FC into a different aircraft.

### Live 3D Graphic of your Aircraft
As you move the flight controller (FC) the gyro and accelerometer values are being read by the FC where it applies the board orientation settings and then streams the intended aircraft orientation over to your computer where the Live 3D Graphic shows what it believes the movement of your aircraft should be. If your other settings are correct, then this Graphic should match the movements of your aircraft. If the movements do not match, then calibration or board alignment need to be adjusted.

### Pre-Arming Checks
The FC performs several checks before it will allow INAV to be Armed. This list shows the status of all of the checks and all need to be green before the plane will arm. If your plane refuses to arm, this screen is a valuable resource in helping to track down an issue.

If **Navigation is safe** is the only red X, then this is usually cause by GPS not yet having a locations fix. It also could be that the FC is powered only by the USB cable and so the GPS may not be receiving power depending on whether it is dependent on the battery being plugged in.

### Info
This list is here for reference and is not critical to setting up your FC.

### GPS
This lets you know the status of the GPS lock and is helpful for deducing the cause of a Pre-Arming Check of **Navigation is safe** red X.
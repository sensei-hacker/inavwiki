# Overview

Blackbox is a valuable tool for analyzing the flight dynamics of our airborne vehicles and as such it can be useful for troubleshooting and debugging purposes.

In INAV we use a set of specific variables, each variable may contain multiple arrays, for example - navPos[0-2].

**navPos**, **navVel**, **navTgtPos** and **navTgtVel** each hold arrays [0-2], which represent distances due North [0], due East [1] and straight Up [2], all relative to the "point of origin".
North and East are fused from accelerometer and GPS data, while Up is fused from accelerometer + barometer for multicopters and accelerometer + gps for airplanes if no barometer is available. Read the Inertial position estimator|Inertial-position-estimator-(INAV) section in the [[Developer info]] page for detailed explanation.

"Point of origin" might be different from "Home". "Home" is defined as position at the time of arming. While "Point of origin" is recorded after a valid GPS fix is aquired.

For further information about the coordinate system used please read the Coordinate systems|Coordinate-systems section on the [[Developer info]] page.

#INAV Variables

Variables listed below with a short description of each:

*  **navMode** (**navState** in newer code):
current mode of operation from INAV's point of view. Might be different from flight mode. Meaning vary by version, but navMode=0 and navState=1 means idle.

* **navFlags**:
binary flags of INAV internal state: new data availability for altitude, position and heading, validity of altitude, surface distance and position, flags to indicate if pilot is adjusting altitude and position via rc input.

* **navTgtPos**:
represents the desired position as used/calculated by INAV. When you are in PH, navTgtPos will be set to hold position coordinates.

* **navPos**:
array of latest NEU coordinates as provided by inertial estimator. Will be slightly different from GPS/baro readings for 99% of time. Units - cm.

* **navVel**:
same as navPos, but for estimated velocity. Units - cm/s

* **navTgtVel**:
represents the desired velocity as used/calculated by INAV. When you are in PH, navTgtVel will be set to calculated desired velocity to reach the target position.

* **navDebug**:
as the name suggests it is used for debugging. Meaning of these values differ all the time depending on what part of the code is currently being debugged.

Blackbox can log data either via serial port or into internal dataflash. In order to log the data into the internal flash at the moment is possible via CLI:
set blackbox_device = SPIFLASH # instead of SERIAL
set blackbox_rate_num = 1
set blackbox_rate_denom = 2
This will make it work and store every second value.

# INAV Logging Intervals

Blackbox logs several types of frames - flight behaviour is written using I- and P-frames. I-frames are fairly big and contain absolute values, P-frames are delta-encoded to save space. Blackbox denominator only reduces P-frame rate, the I-frame rate is constant.

Originally I-frames were logged every 32 iterations, P-frame is logged every blackbox_rate_denom after I-frame. This doesn't give you exactly 1 / blackbox_rate_denom rate, i.e. for 1/16 - 1/31 rates it's going to be c. 16 iterations between frames on average.

For INAV 1.6 and later, the I-frame interval is set dynamically at 1/32, 1/64, 1/128 and 1/256 based on the blackbox_rate_denom chosen.

For example, if a blackbox_rate_denom of 50 is used, INav will select 64 as the I-frame interval, meaning c. 1/32 actual logging rate.

>[!Note]
> Due to the complexity of the tasks being performed in later INAV releases. e.g. _2K_looptime, lower Dshot values, Control Profiles, Programming framework, OSD_ etc. It is advisable to run _blackbox_rate_denom_ at the lowest value (32 - 3%) to start with. Otherwise higher rates may cause breaks in the log, or inability to record any log data. This will vary based on the hardware logging type (FLASH, SDCARD, SDIO)

Some fields that are logged, are not yet accessible with Blackbox Explorer, particularly navigation related.. Other options:

* [backbox_decode](https://github.com/iNavFlight/blackbox-tools) Decode to CSV file
* [flightlog2kml](https://codeberg.org/stronnag/flightlog2kml), [fl2xui](https://codeberg.org/stronnag/fl2xui/). Decode to KML (for Google Earth).
* [mwptools](https://codeberg.org/stronnag/mwptools/). Interactive log replay, inter-alia.

### Explanation of all the parameters

|  Name of field in txt file 	|  Name in Blackbox Log Viewer 	|  Explanation 	|  . 	|  ..            |
|:--------------------------:	|:----------------------------:	|:------------:	|:---:	|:----------:|
|  loopIteration 	|  not used 	|  counter from main loop 	|   	|   |
|  time (us) 	    |  x-axis of diagram 	|  real time in micoseconds 	|   	|   |sensors/acceleration.h
|  axisRate[0] 	    |  gyros[roll] (.. deg/s) 	|  rotation rate 	|  roll 	|  deg/sec |
|  axisRate[1] 	    |  gyros[pitch] (.. deg/s) 	|  rotation rate 	|  pitch 	|  deg/sec |
|  axisRate[2] 	    |  gyros[yaw] (.. deg/s) 	|  rotation rate 	|  yaw 	|  deg/sec |
|  axisP[0] 	    |  PID_P[roll] 	|  PID controller 	|  roll 	|  P |
|  axisP[1] 	|  PID_P[pitch] 	|  PID controller 	|  pitch 	|  P |
|  axisP[2] 	|  PID_P[yaw] 	|  PID controller 	|  yaw 	|  P |
|  axisI[0] 	|  PID_I[roll] 	|  PID controller 	|  roll 	|  I |
|  axisI[1] 	|  PID_I[pitch] 	|  PID controller 	|  pitch 	|  I |
|  axisI[2] 	|  PID_I[yaw] 	|  PID controller 	|  yaw 	|  I |
|  axisD[0] 	|  PID_D[roll] 	|  PID controller 	|  roll 	|  D |
|  axisD[1] 	|  PID_D[pitch] 	|  PID controller 	|  pitch 	|  D |
|  axisD[2] 	|  PID_D[yaw] 	|  PID controller 	|  yaw 	|  D |
|  mcPosAxisP[0] 	|   mcPosAxisP[0] 	|  multicopter position 	|  north 	|  cm |
|  mcPosAxisP[1] 	|   mcPosAxisP[1] 	|  multicopter position 	|  east 	|  cm |
|  mcPosAxisP[2] 	|   mcPosAxisP[2] 	|  multicopter position 	|  vertical 	|  cm |
|  mcVelAxisP[0] 	|   mcVelAxisP[0] 	|  multicopter velocity 	|  north 	|  cm/sec |
|  mcVelAxisP[1] 	|   mcVelAxisP[1] 	|  multicopter velocity 	|  east 	|  cm/sec |
|  mcVelAxisP[2] 	|   mcVelAxisP[2] 	|  multicopter velocity 	|  vertical 	|  cm/sec |
|  mcVelAxisI[0] 	|   mcVelAxisI[0] 	|  multicopter velocity 	|  north 	|  cm/sec |
|  mcVelAxisI[1] 	|   mcVelAxisI[1] 	|  multicopter velocity 	|  east 	|  cm/sec |
|  mcVelAxisI[2] 	|   mcVelAxisI[2] 	|  multicopter velocity 	|  vertical 	|  cm/sec |
|  mcVelAxisD[0] 	|   mcVelAxisD[0] 	|  multicopter velocity 	|  north 	|  cm/sec |
|  mcVelAxisD[1] 	|   mcVelAxisD[1] 	|  multicopter velocity 	|  east 	|  cm/sec |
|  mcVelAxisD[2] 	|   mcVelAxisD[2] 	|  multicopter velocity 	|  vertical 	|  cm/sec |
|  mcVelAxisOut[0] 	|   mcVelAxisOut[0] 	|  multicopter velocity 	|  north 	|  cm/sec |
|  mcVelAxisOut[1] 	|   mcVelAxisOut[1] 	|  multicopter velocity 	|  east 	|  cm/sec |
|  mcVelAxisOut[2] 	|   mcVelAxisOut[2] 	|  multicopter velocity 	|  vertical 	|  cm/sec |
|  mcSurfaceP 	|   mcSurfaceP 	|  multicopter surface mode 	|   	|  P |
|  mcSurfaceI 	|   mcSurfaceI 	|  multicopter surface mode 	|   	|  I |
|  mcSurfaceD 	|   mcSurfaceD 	|  multicopter surface mode 	|   	|  D |
|  mcSurfaceOut 	|   mcSurfaceOut 	|  multicopter surface mode 	|   	|   |
|  fwAltP       |   fwAltP      |  fixedwing altitude position |  | P |
|  fwAltI       |   fwAltI      |  fixedwing altitude position |  | I |
|  fwAltD       |   fwAltD      |  fixedwing altitude position |  | D |
|  fwAltOut     |   fwAltOut    |  fixedwing altitude position output  | |
|  fwPosP       |   fwPosP      |  fixedwing horizontal position | | P |
|  fwPosI       |   fwPosI      |  fixedwing horizontal position | | I |
|  fwPosD       |   fwPosD      |  fixedwing horizontal position | | D |
|  fwPosOut     |   fwPosOut    |  fixedwing horizontal position output |||
|  rcData[0] 	|   rcData[0] 	|  received rc signal 	|  roll 	|  1000-2000  µs |
|  rcData[1] 	|   rcData[1] 	|  received rc signal 	|  pitch 	|  1000-2000  µs |
|  rcData[2] 	|   rcData[2] 	|  received rc signal 	|  yaw 	|  1000-2000  µs |
|  rcData[3] 	|   rcData[3] 	|  received rc signal 	|  throttle 	|  1000-2000  µs |
|  rcCommand[0] 	|   rcCommand[0] 	|  stabilization controller command |  roll 	|  1000-2000  µs |
|  rcCommand[1] 	|   rcCommand[1] 	|  stabilization controller command |  pitch 	|  1000-2000  µs |
|  rcCommand[2] 	|   rcCommand[2] 	|  stabilization controller command |  yaw 	|  1000-2000  µs |
|  rcCommand[3] 	|   rcCommand[3] 	|  stabilization controller command |  throttle |  1000-2000  µs |
|  vbat 	|   vbat 	|  voltage of flight battery 	|   	|  volts |
|  sagCompensatedVBat 	|   	| load compensated battery voltage  	|   	| volts  |
|  powerSupplyImpedance 	|   	| flight battery internal resistance  	|   	|mΩ   |
|  amperage 	|   	|system current drain   	|   	| amps  |
|  magADC[0] 	|   mag[x] 	|  compass 	|  north    |   |
|  magADC[1] 	|   mag[y] 	|  compass 	|  east     |   |
|  magADC[2] 	|   mag[z] 	|  compass 	|  vertical |   |
|  BaroAlt  	|   Baro  	|  altitude(barometric) 	|   	| m |
|  gyroADC[0] 	|   gyro[0] 	|  rotation(gyro) 	|  roll 	|  deg/sec |
|  gyroADC[1] 	|   gyro[1] 	|  rotation(gyro) 	|  pitch 	|  deg/sec |
|  gyroADC[2] 	|   gyro[2] 	|  rotation(gyro) 	|  yaw 	|  deg/sec |
|  gyroRaw[0] 	|   gyroRaw[0] 	|  rotation(gyro before filtering)|  roll 	|  deg/sec |
|  gyroRaw[1] 	|   gyroRaw[1] 	|  rotation(gyro before filtering)|  pitch 	|  deg/sec |
|  gyroRaw[2] 	|   gyroRaw[2] 	|  rotation(gyro before filtering)|  yaw 	|  deg/sec |
|  accSmooth[0] |  acc[x] 	|  acceleration  	|  north 	|  ADC * normalised 1g |
|  accSmooth[1] |  acc[y] 	|  acceleration  	|  east 	|  ADC * normalised 1g |
|  accSmooth[2] |  acc[z] 	|  acceleration  	|  vertical 	|  ADC * normalised 1g |
|  accVib       |  accVib 	|  accelerometer vibration level|  frequency	|  Hz |
|  attitude[0] 	|   attitude[0] 	|  heading  	|  roll 	|  0-3600 deg/10 |
|  attitude[1] 	|   attitude[1] 	|  heading  	|  pitch 	|  0-3600 deg/10 |
|  attitude[2] 	|   attitude[2] 	|  heading  	|  yaw 	|  0-3600 deg/10 |
|  debug[0-7]       |  debug[0-7]   | CLI `debug_mode` | |0 - 7 |
|  motor[0] 	|   motor[0] 	|  output to motor ESC 	|  0 	|  1000-2000  µs |
|  motor[1] 	|   motor[1] 	|  output to motor ESC 	|  1 	|  1000-2000  µs |
|  motor[2] 	|   motor[2] 	|  output to motor ESC 	|  2 	|  1000-2000  µs |
|  motor[3] 	|   motor[3] 	|  output to motor ESC 	|  3 	|  1000-2000  µs |
|  navState 	|   	|  navigation control mode state |   	|   |
|  navFlags 	|   	|  navigation data trusted 	|   	|   |
|  navPos[0] 	|   navPos[0] 	|  position of vehicle 	|  north 	|  cm |
|  navPos[1] 	|   navPos[1] 	|  position of vehicle 	|  east 	|  cm |
|  navPos[2] 	|   navPos[2] 	|  position of vehicle 	|  vertical 	|  cm |
|  navVel[0] 	|   navVel[0] 	|  velocity of vehicle 	|  north 	|  cm/s |
|  navVel[1] 	|   navVel[1] 	|  velocity of vehicle 	|  east 	|  cm/s |
|  navVel[2] 	|   navVel[2] 	|  velocity of vehicle 	|  vertical 	|  cm/s |
|  navAcc[0] 	|   navAcc[0] 	|  acceleration of vehicle 	|  north 	|  cm/s/s |
|  navAcc[1] 	|   navAcc[1] 	|  acceleration of vehicle 	|  east 	|  cm/s/s |
|  navAcc[2] 	|   navAcc[2] 	|  acceleration of vehicle 	|  vertical 	|  cm/s/s |
|  navTgtVel[0] 	|   navTgtVel[0] 	|  target value: velocity 	|  north 	|  cm/s |
|  navTgtVel[1] 	|   navTgtVel[1] 	|  target value: velocity 	|  east 	|  cm/s |
|  navTgtVel[2] 	|   navTgtVel[2] 	|  target value: velocity 	|  vertical 	|  cm/s |
|  navTgtPos[0] 	|   navTgtPos[0] 	|  target value: position 	|  north 	|  cm |
|  navTgtPos[1] 	|   navTgtPos[1] 	|  target value: position 	|  east 	|  cm |
|  navTgtPos[2] 	|   navTgtPos[2] 	|  target value: position 	|  vertical 	|  cm |
|  navTgtHdg           |                        |  active heading computation   | horizontal    |     |
|  navSurf[0] 	|   navSurf[0] 	|  requires surface mode  	|   	|   |
|  flightModeFlags (flags) 	|   	| active modes  	|   	|   |
|  stateFlags (flags) 	|   	| active control states  	|  	|   |
|  failsafePhase (flags) 	|failsafePhase   	| idle/active (RTH/Land)|boolean |0/1   |
|  rxSignalReceived 	|   	| active RX link|boolean   	| 0/1  |
|  rxFlightChannelsValid 	|   	|   	|   	|   |
|  hwHealthStatus 	|   	| active sensor communication  	|   	|   |
|  waypoint             |  activeWPNumber   | current flight waypoint  | | decimal |
|  rpm                  | escRPM | ESC telemetry motor revolutions/min|   |RPM |
|  escTemperature 	|  escTemperature 	| ESC telemetry temperature|   	| decidegrees C|
|  IMUTemperature       |  IMUTemperature       | Gyro/Acc device temperature  |      | degrees C |
|  baroTemperature      |  baroTemperature      | barometer device temperature  |    | degrees C |
|   sensTemp            |   Sens 0-7 Temp       | user dedicated temperature sensors |0-7| degrees C |
|                       |windHeading    |direction  	|      	| degrees |
|                       |windVelocity   |speed  	|      	| m/s |
|  wind[0] 	|windVelocity   |wind X axis velocity   | north 	| m/s |
|  wind[1] 	|windVelocity   |wind Y axis velocity 	| east  	| m/s |
|  wind[2] 	|windVelocity 	|wind Z axis velocity  	| vertical  	| m/s |
|  AirSpeed     | AirSpeed | Pitot or Virtual      |       | cm/s |
|  GPS_home[0] 	|   	|  latitude 	|   	| degrees  |
|  GPS_home[1] 	|   	|  longitude 	|   	| degrees  |
|  GPS_fixType 	|   	|  positional lock accuracy |   	|None - 2D - 3D |
|  GPS_numSat 	|   	|  number of satellites acquired |   	| decimal |
|  GPS_coord[0] 	|   	|  latitude 	|   	| deg : min : sec |
|  GPS_coord[1] 	|   	|  longitude	|   	| deg : min : sec |
|  GPS_altitude 	|   	|  GPS_altitude 	|   	| m |
|  GPS_speed 	        |   	|  velocity 	|   	| cm/s  |
|  GPS ground course 	|   	|  ground course heading 	|   	| degrees |
|  GPS_hdop 	        |   	|  quality of GPS fix 	|   	| 10 down to 0.5 |
|  navEPH 	|   	|  Std deviation horizontal position error 	|   	| meters |
|  navEPV 	|   	|  Std deviation of vertical position error	|   	| meters |
|  GPS_velned[0] 	|   	| CoG X axis velocity 	|  north | m/s |
|  GPS_velned[1] 	|   	| CoG Y axis velocity	|  east | m/s |
|  GPS_velned[2] 	|   	| CoG Z axis velocity 	|  down	| m/s |

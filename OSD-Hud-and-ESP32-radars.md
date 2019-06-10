## The Hud

The Hud is a feature that displays various points of interest (POI) on the OSD, live, by showing a marker where the location is on the screen. For now it's capable to display the home point, and nearby aicrafts as sent by an ESP32 LoRa modem. In the future it's planned to have it also display the next waypoints during a mission.

## Configuration

The hud must be set from the CMS menu of the OSD or from the CLI in the Configurator.
Right now the Configurator does not show the hud in the OSD panel.

**Important! The Hud is a sub-set of the crosshair, it's designed this way since the crosshair is the origin/reference for anything hud-related. So make sure you have the crosshair enabled and display in the OSD tab of the Configurator. It is not recommended to have any of the map items displayed in your OSD, as this could cause massive overlaps on the screen**

In order for the hud to display in "3D" where the POI is, it needs to know the angle in pitch and the approximate field of view (FOV) for your FPV camera.

In the CMS/OSD menu, go to OSD > Hud >... 

**Crosshair style** : Choose between 7 different types of crosshairs.

**Horizon offset** : Can be adjusted between -2 and +2, this setting moves the whole OSD and AHI and side scrolls block vertically, it's highly recommended to leave it at 0.

**Camera Uptilt** : Set the camera uptilt for the FPV camera. That's the angle in degres between the horizontal of the aircraft and the line of sight of the camera. For a multirotor it's often a positive value, usually between 5 and 30°. For a plane with the camera pointing down it should be a negative value, often between -5 and -10°.

**Camera FOV horizontal + vertical** : The FOV for the FPV camera, the default values are ok for a 2.8mm lens. If your camera is a 2.5mm or 2.1mm, try to raise both the horizontal and vertical FOVs by 5 or 10° by steps. If the FOV is too far off, the tracking won't work well near the borders of the screen.

**Hud Margin horizontal + vertical** : How far from the border of the screen the hud ends, so it does not overwrite the rest of your OSD datas.

**Displayed items >** : This sub menu will let you choose exactly what is displayed on the Hud :

**Homing arrows** : To display little arrows around the crossair showing where the home point is.

**Home point** : To display the home point as a "H" marker.

**Radar max aircraft** : Maximum count of nearby aircrafts or POIs to display, as sent from an ESP32 LoRa  module. Set to 0 to disable (show nothing).

**Radar min range** : In meters, by default 1, radar aicrafts closer than this will not be displayed. This setting exists mostly to unclutter the OSD view during close range pursuits.

**Radar max range** : In meters, by default 4000, radar aicrafts further away than this will not be displayed. 

**Radar detail nearest** : To display an extra bar of informations at the bottom of the hud area (Relative altitude in meters of feet, speed in m/s or f/s, and absolute heading in °), for the closest radar aircraft found.

## CLI commands

All the settings are available from the CLI, defaults are :

set osd_crosshairs_style = DEFAULT
set osd_horizon_offset = 0
set osd_camera_uptilt = 0
set osd_camera_fov_h = 135
set osd_camera_fov_v = 85
set osd_hud_margin_h = 3
set osd_hud_margin_v = 3
set osd_hud_homing = OFF
set osd_hud_homepoint = OFF
set osd_hud_radar_disp = 0
set osd_hud_radar_range_min = 1
set osd_hud_radar_range_max = 4000
set osd_hud_radar_nearest = OFF

##  Accuracy and limitations

There's a long chain of inacuraccies conspiring to make the tracking not perfectly aiming at the other aircrafts :

* The heading of your aircraft can be wrong by a significant margin during or right after a hard turn. The steadier the flight, the more accurate it is.

* The artificial horizon drift issue does not help. Accurate positioning for the POI markers depends on the actual attitude and heading of the aircraft, any slight difference of few degres will mess up the tracking.

* OSD is character based, it's a 30x16 grid for PAL, and 30x13 for NTSC, it's not super high-definition.

* The crosshair is not perfectly centered in both horizontal and vertical dimensions because of an even numbers of columns and rows

* The position of the other aircrafts as sent by the ESP32 modules are updated at 2Hz (every 0.5sec), so at high speed there's lag involved because of relative movements.


## ESP32 LoRa modem ("iNav Radar" project)

If you have such a module fitted on your aicraft, few extra steps are required in order to display the remote aircrafts live on the Hud :

* Wire the ESP32 module to a free UART on your flight controller, same as you would connect a GPS (+5V, GND, TX, RX). Using a Softserial port is not stable at the time of writing, and not recommended.

* In the iNav Configurator, Ports tab, enable the MSP option for this UART, and set the speed to **115200**. You don't have to set anything else for the port, the ESP32 will then communicate with the flight controller using standard MSP/MSP2 messages.

* In the CMS, OSD > Hud > Displayed items, set **Radar max aircraft to 4**

Please see this [discussion at RCGroups](https://www.rcgroups.com/forums/showthread.php?3304673-iNav-Radar-ESP32-LoRa-modems) for mode details about the ESP32 modules and the radar project.

##  Troubleshooting and details

**The ESP32 says "NoFC", it does not see the iNav flight controller**

Check that all 4 wires 5V GND TX RX are connected
Check that the port/UART the ESP32 is connected to is set with MSP enabled and speed is 115200 baud

**Does it work with Betaflight ?**

Since position sharing is based on the MSP protocol, Betaflight should work (not heavily tested) as a GPS source, but it won't be able to display on his OSD the position of the other aircrafts since it does not have the Hud obviously. Said another way, an iNav aircraft can track a Betaflight aircraft (if fitted with a functional GPS unit), but the Betaflight won't see the iNav aircraft.

**Conditions before display**

The H marker and/or the A, B, C ... markers will appear on the OSD view only if the position of your aircraft is known. So it needs a valid GPS lock. The H-for-home marker will show only when the home point is recorded, so after the flight controller is armed. The home lock is not required to display nearby radar POIs.
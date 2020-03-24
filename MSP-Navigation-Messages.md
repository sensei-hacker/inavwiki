# MultiWii NAV Protocol and Types

This document describes a number of values and enumerations for for **MultiWii** MSP messages. As **iNav** implements a part of this specification it is documented in the iNav wiki.

This information is provided in the hope it might be useful NO WARRANTY.

Note that all binary values are little endian (MSP standard).

# Implementation and versions

This document should match the iNav 1.2 (and later) and Multiwii 2.4 flight controller firmware. The messages described are implemented in mwp (Linux / FreeBSD / Windows (Cygwin,WSL)) and ezgui (Android) ground station applications. mwp and ezgui support both iNav and Multiwii; WinGui is a Windows / Multiwii only mission planner that also supports this message set. The iNav configurator also supports (a subset of) the MSP standard for mission planning.

# WayPoint / Action Attributes

Each  waypoint has a type and takes a number of parameters, as below. These are used in the MSP_WP message. The final column indicated if the message is implemented for iNav 1.2 (and later).

| Value | Enum | P1 | P2 | P3 | Lat | Lon | Alt | iNav |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 1 | WAYPOINT      | speed [1] | | | ✔ | ✔ | ✔ | ✔ |
| 2 | POSHOLD_UNLIM |          | | | ✔ | ✔ | ✔ | [5] |
| 3 | POSHOLD_TIME  | Seconds | (speed [6],[1])| | ✔ | ✔ | ✔ | [6] |
| 4 | RTH [4]       | Land | | |    |    | ✔ [2] | ✔ |
| 5 | SET_POI       |          | | | ✔ | ✔ | | |
| 6 | JUMP          | WP#      | Repeat (-1 = forever) | | | | | [6] |
| 7 | SET_HEAD [3]  | Heading  | | | | | | |
| 8 | LAND | | | | ✔ | ✔ | ✔ | [6] |

1. Leg speed is an iNav extension (for multi-rotors only). It is the speed on the leg terminated by the WP (so the speed for WP2 is used for the leg WP1 -> WP2) (cm/s).
2. Not used by iNav
3. Once SET_HEAD is invoked, it remains active until cleared by a P1 value of -1.
4. If a mission contains multiple RTH stanzas, then for MultiWii, the mission terminates at the first RTH. For iNav, the mission will continue if LAND is not set, and valid waypoints follow.
5. If the final entry in a mission is a WAYPOINT, the iNav treats it as POSHOLD_UNLIM.
6. iNav 2.5 and later.

## Annotated Example
The following example, using the MW XML (ezgui, inav configurator, mwp) format, illustrates the WAYPOINT, JUMP, POSHOLD_TIME and LAND types
![Complex Mission](images/eg_complex_mission.png)
```
<?xml version="1.0" encoding="utf-8"?>
<mission>
  <missionitem no="1" action="WAYPOINT" lat="54.353319318038153" lon="-4.5179273723848077" alt="35" parameter1="0" parameter2="0" parameter3="0"></missionitem>
  <missionitem no="2" action="WAYPOINT" lat="54.353572350395972" lon="-4.5193913118652516" alt="35" parameter1="0" parameter2="0" parameter3="0"></missionitem>
  <missionitem no="3" action="WAYPOINT" lat="54.354454163955907" lon="-4.5196617811150759" alt="50" parameter1="0" parameter2="0" parameter3="0"></missionitem>
  <missionitem no="4" action="WAYPOINT" lat="54.354657830207479" lon="-4.5186895986330455" alt="50" parameter1="0" parameter2="0" parameter3="0"></missionitem>
  <missionitem no="5" action="JUMP" lat="0" lon="0" alt="0" parameter1="2" parameter2="2" parameter3="0"></missionitem>
  <missionitem no="6" action="WAYPOINT" lat="54.354668848061756" lon="-4.5176009696657218" alt="35" parameter1="0" parameter2="0" parameter3="0"></missionitem>
  <missionitem no="7" action="WAYPOINT" lat="54.354122567317191" lon="-4.5172673708680122" alt="35" parameter1="0" parameter2="0" parameter3="0"></missionitem>
  <missionitem no="8" action="JUMP" lat="0" lon="0" alt="0" parameter1="1" parameter2="1" parameter3="0"></missionitem>
  <missionitem no="9" action="POSHOLD_TIME" lat="54.353138333126651" lon="-4.5190405596657968" alt="35" parameter1="45" parameter2="0" parameter3="0"></missionitem>
  <missionitem no="10" action="WAYPOINT" lat="54.354847022143616" lon="-4.518210497615712" alt="35" parameter1="0" parameter2="0" parameter3="0"></missionitem>
  <missionitem no="11" action="LAND" lat="54.354052100964488" lon="-4.5178091504726012" alt="60" parameter1="0" parameter2="0" parameter3="0"></missionitem>
</mission>
```
Mission points 5 and 8 are JUMP; they have no location as they affect the current location (the previous WP) and cause an action. 
* After WP 4 (JUMP at 5), the vehicle will proceed to WP 2 (`parameter1 = 2`); it will do this twice (`parameter2 = 2`). Then it will proceed to WP 6.
* After WP 7 (JUMP at 8), the vehicle will proceed to WP 1 (`parameter1 = 1`); it will do this once (`parameter2 = 1`). Then it will proceed to WP 9.
* The second JUMP (8) will cause the first jump (5) to be re-executed.

Mission point 9 is POSHOLD_TIME. The vehicle will loiter for 45 seconds (`parameter1 = 45`) at the WP9 location. A multi-rotor will hold a steady position, fixed wing will fly in a circle as defined by the CLI parameter `nav_fw_loiter_radius`.

Mission point 11 is LAND. The vehicle will land (unconditionally, regardless of `nav_rth_allow_landing`) at the given location. The CLI setting `nav_disarm_on_landing` is honoured.

The mission is executed as:

| WP / next wp | Course |  Dist |  Total |
| ------------ | ------ | ----- | ------ |
| WP01 - WP02 | 287° |   99m |    99m |
| WP02 - WP03 | 350° |  100m |   198m |
| WP03 - WP04 | 070° |   67m |   265m |
| WP04 (J05) WP02 | 201° |  129m |   394m |
| WP02 - WP03 | 350° |  100m |   494m |
| WP03 - WP04 | 070° |   67m |   561m |
| WP04 (J05) WP02 | 201° |  129m |   690m |
| WP02 - WP03 | 350° |  100m |   789m |
| WP03 - WP04 | 070° |   67m |   856m |
| WP04 - WP06 | 089° |   71m |   927m |
| WP06 - WP07 | 160° |   64m |   991m |
| WP07 (J08) WP01 | 206° |   99m |  1090m |
| WP01 - WP02 | 287° |   99m |  1189m |
| WP02 - WP03 | 350° |  100m |  1288m |
| WP03 - WP04 | 070° |   67m |  1355m |
| WP04 (J05) WP02 | 201° |  129m |  1484m |
| WP02 - WP03 | 350° |  100m |  1584m |
| WP03 - WP04 | 070° |   67m |  1651m |
| WP04 (J05) WP02 | 201° |  129m |  1779m |
| WP02 - WP03 | 350° |  100m |  1879m |
| WP03 - WP04 | 070° |   67m |  1946m |
| WP04 - WP06 | 089° |   71m |  2016m |
| WP06 - WP07 | 160° |   64m |  2081m |
| WP07 - PH09 | 226° |  159m |  2239m |
| PH09 - WP10 | 016° |  197m |  2437m |
| WP10 - WP11 | 164° |   92m |  2529m |


## Modifier actions
A number of the WP types (JUMP, SET_POI, SET_HEAD, RTH) act as modifiers to the current location (i.e. the previous WP), as follows:

### JUMP
JUMP facilitates adding loop to mission, the first parameter is the WP to jump to, which must be prior to the JUMP WP, and the second parameter is the number of times the JUMP is executed. A P2 value of `-1` means JUMP indefinitely (i.e. the pilot must eventually manually abort the mission and take control).

### RTH
The craft returns to the home location.

### SET POI (Multirotor only)

The SET_POI type has a location which defines a point of interest (POI). The craft will fly the mission (until a SET_HEAD) with the nose pointing at the POI, which might be useful for aerial photography.

In the image below, the craft will point its nose at the yellow POI (WP#1) for the duration of the mission (as there is no SET_HEAD -1).

![Set POI ](images/mission-set-poi.png)

### SET_HEAD (Multirotor only)

The SET_HEAD type sets the craft's heading (where is 'looks', not the direction of travel). This may be useful for useful for aerial photography. A value of `-1` causing the heading to be 'straight ahead', i.e. the direction of travel. Thus, SET_POI `-1` may used to cancel with a previous valid SET_HEAD or SET_POI.

In the image below, the craft will fly normally ('nose first') to WP 3, it will the fly WP3 - WP5 with the nose pointing 300° (towards the top left of the image) to WP5; the subsequent SET_HEAD -1 will cause the craft to resume normal (nose first) behaviour, which continues to WP7. Here, the SET_POI means the craft will fly WP7 - WP9 with the nose pointing 120° (towards the lower right of the image). WP 10 resumes normal 'nose ahead' behaviour.

![SET_HEAD image](images/mission-set-head.png)

## Uploading

For safety, if no mission is defined, a single RTH action should be sent.

| Enum | P1 | P2 | P3 | Lat | Lon | Alt | Flag |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| RTH | 0 | 0 | 0 | 0 | 0 | 25m [1] | 0xa5 |

1. your choice, really.

In general, flag is 0, unless it's the last point in a mission, in which case it is set to 0xa5. When waypoints are uploaded, the values are also returned by the FC, thus enabling the application to verify that the mission has been uploaded correctly.

## FC Capabilities (MW only)

Note that 32bit flight controllers (baseflight, cleanflight) use capability == 16 for a different purpose
(CAP_CHANNEL_FORWARDING). It is advised to use other messages for checking for capabilities on non-MW platforms.

| Capability | Value |
| ---- | ---- |
| BIND | 1 |
| DYNBAL | 4 |
| FLAP | 8 |
| NAV | 16 |

# Messages (Nav related)

| MNEMONIC | Value | Direction (relative to FC) |
| -------- | ---- | ---- |
| MSP_NAV_STATUS | 121 | Out |
| MSP_NAV_CONFIG | 122 | Out |
| MSP_WP | 118  | Out |
| MSP_RADIO | 199 | Out |
| MSP_SET_NAV_CONFIG | 215 | In |
| MSP_SET_HEAD | 211 | In |
| MSP_SET_WP | 209 | In (& out) |

# MSP_WP / MSP_SET_WP

Special waypoints are 0 and 255. 0 is the RTH (Home) position, 255 is the POSHOLD position (lat, lon, alt).

| Name | Type | Usage |
| ---- | ---- | ----- |
| wp_no | uchar | way point number |
| action | uchar | action (wp type / action) |
| lat | int32 | decimal degrees latitude * 10,000,000 |
| lon | int32 | decimal degrees longitude * 10,000,000 |
| altitude | int32 | altitude (metre) * 100 |
| p1 | int16 | varies according to action |
| p2 | int16 | varies according to action |
| p3 | int16 | varies according to action |
| flag | uchar | 0xa5 = last, otherwise set to 0 |

The values for the various parameters are given in the section “WayPoint / Action Attributes”
Note that altitude is measured from the "home" location, not absolute above mean sea level.

# MSP_NAV_STATUS

The following data are returned by a MSP_NAV_STATUS message. The texts are those defined by Wingui; multiwii and iNav support this message. Almost the same data is returned by the [iNav LTM NFRAME](https://github.com/iNavFlight/inav/wiki/Lightweight-Telemetry-(LTM)#navigation-frame-n)

<table>
<thead>
<tr class="header">
<th>Name</th>
<th>Type</th>
<th>Usage</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>gps_mode</td>
<td>uchar</td>
<td>None <br/>
PosHold <br/>
RTH <br/>
Mission</td>
</tr>
<tr class="even">
<td>nav_state</td>
<td>uchar</td>
<td>None <br/>
RTH Start <br/>
RTH Enroute <br/>
PosHold infinite<br/>
PosHold timed<br/>
WP Enroute <br/>
Process next <br/>
Jump <br/>
Start Land <br/>
Land in Progress <br/>
Landed <br/>
Settling before land <br/>
Start descent <br/>
Hover above home <br/>
Emergency Landing </td>
</tr>
<tr class="odd">
<td>action</td>
<td>uchar</td>
<td>(last wp, next wp?)</td>
</tr>
<tr class="even">
<td>wp_number</td>
<td>uchar</td>
<td>(last wp, next wp?)</td>
</tr>
<tr class="even">
<td>nav_error</td>
<td>uchar</td>
<td>Navigation system is working <br/>
Next waypoint distance is more than the safety limit, aborting mission <br/>
GPS reception is compromised - pausing mission, COPTER IS ADRIFT! <br/>
Error while reading next waypoint from memory, aborting mission. <br/>
Mission Finished. <br/>
Waiting for timed position hold. <br/>
Invalid Jump target detected, aborting mission. <br/>
Invalid Mission Step Action code detected, aborting mission. <br/>
Waiting to reach return to home altitude. <br/>
GPS fix lost, mission aborted - COPTER IS ADRIFT! <br/>
Copter is disarmed, navigation engine disabled. <br/>
Landing is in progress, check attitude if possible. </td>
</tr>
<tr class="odd">
<td>target_bearing</td>
<td>int16</td>
<td>(presumably to the next WP?)</td>
</tr>
</tbody>
</table>

# MSP_NAV_CONFIG (MW)

The following data are returned from a MSP_NAV_CONFIG message. Values are from multiwii config.h. Values may also be set by MSP_SET_NAV_CONFIG. 

<table>
<thead>
<tr class="header">
<th>Name</th>
<th>Type</th>
<th>Usage</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>flags1</td>
<td>uchar</td>
<td>
Bitmap of settings from MW config.h <br/>
b0 : GPS filtering <br/>
b1 : GPS Lead <br/>
b2 : Reset Home <br/>
b3 : Heading control <br/>
b4 : Tail first <br/>
b5 : RTH Head <br/>
b6 : Slow Nav <br/>
b7 : RTH Alt </td>
</tr>
<tr class="even">
<td>flags2</td>
<td>uchar</td>
<td>
Bitmap of settings from MW config.h <br/>
b0 : Disable sticks <br/>
b1 : Baro takeover</td>
</tr>
<tr class="odd">
<td>wp_radius</td>
<td>uint16</td>
<td>radius around which waypoint is reached (cm)</td>
<tr class="even">
<td>safe_wp_distance</td>
<td>uint16</td>
<td>Maximum permitted first leg of mission (m, assumed?)</td>
</tr>
<tr class="odd">
<td>nav_max_altitude</td>
<td>uint16</td>
<td>Maximum altitude for NAV (m)</td>
</tr>
<tr class="even">
<td>nav_speed_max</td>
<td>uint16</td>
<td>maximum speed for NAV (cm/sec)</td>
</tr>
<tr class="odd">
<td>nav_speed_min</td>
<td>uint16</td>
<td>minimum speed for NAV (cm/s)</td>
</tr>
<tr class="even">
<td>crosstrack_gain</td>
<td>uchar</td>
<td>MW config.h value*100</td>
</tr>
<tr class="odd">
<td>nav_bank_max</td>
<td>uint16</td>
<td>maximum bank ??? for NAV, MW config.h value*100</td>
</tr>
<tr class="even">
<td>rth_altitude</td>
<td>uint16</td>
<td>RTH altitude (m)</td>
</tr>
<tr class="odd">
<td>land_speed</td>
<td>uchar</td>
<td>Governs the descent speed during landing. 100 ~= 50 cm/sec unknown units</td>
</tr>
<tr class="even">
<td>fence</td>
<td>uint16</td>
<td>Distance beyond which forces RTH (m)</td>
</tr>
<tr class="odd">
<td>max_wp_number</td>
<td>uchar</td>
<td>maximum number of waypoints possible (read only)</td>
</tr>
</tbody>
</table>

# MSP_RADIO

If you have a 3DR radio with the MW/MSP specific firmware, the follow data are sent from the radio, unsolicited.

| Name | Type | Usage |
| ---- | ---- | ----- |
| rxerrors | uint16 | Number of RX errors |
| fixed_errors | uint16 | Number of fixed errors, if error correction is set |
| localrssi | uchar | Local RSSI |
| remrssi | uchar | Remote RSSI |
| txbuf  | uchar | Size of TX buffer |
| noise | uchar | Local noise |
| remnoise | uchar | Remote noise |

# Implementations

The MSP NAV message set is implemented by mwptools (Linux), ezgui / mission planner for iNav (Android), WinGUI (MS Windows) and the iNav Configurator.

# XML Mission Files

mwptools, ezgui / mp4i, iNav Configurator (and WinGUI) share an XML mission file format. A [reverse engineered definition (XSD)](https://github.com/stronnag/mwptools/blob/master/samples/mw-mission.xsd) can be found in the mwp samples  directory.

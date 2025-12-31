![](http://static.rcgroups.net/forums/attachments/6/1/0/3/7/6/a9088858-102-inav.png)

INAV is a Free and Open Source Flight Controller and Autopilot Software System that is **actively developed** with large releases annually, and support releases as needed. INAV has two primary components, the [firmware](https://github.com/iNavFlight/inav/releases/) that runs on the flight controller board, and the [GUI configuration tool](https://github.com/iNavFlight/inav-configurator/releases/) that runs on your computer (Linux, MacOS, and Windows are supported). Some INAV features include:

- Support for a large variety and quantity of inexpensive flight controller (FC) boards and sensors. Many FC's are built specifically for INAV with board layouts intended for easy connection of motors, sensors, servos, etc. intended for use in RC vehicles.
- Support for a wide variety of flying vehicles including airplanes, gliders, multi-rotors, quadcopters, etc. as well as ground vehicles (cars, tanks) and water vehicles (boats).
- Support for Auto Navigation Modes such as [[RTH (return to home)|Navigation-Mode:-Return-to-Home]], position hold, [[waypoints|iNavFlight Missions]], "follow-me", and many more.
- Support for video transmission & receive systems for FPV (first person view) with On-Screen Display (OSD) of telemetry data.
- Use of flight controller (FC) boards based on those below.

   | Processor | Speed  | Flash |
   |:---------:|:------:|:-----:|
   | STM-F405  | 168Mhz |  1Mb  |
   | STM-F722  | 216Mhz | 512k  |
   | STM-F745  | 216Mhz |  1Mb  |
   | STM-F765  | 216Mhz |  2Mb  |
   | STM-H743  | 480Mhz |  2Mb  |
   | AT-F435   | 288Mhz |  1Mb  |

General support for STM-F411 processors finished in 7.1.2. 
All other chips listed will support current and future releases of INAV. (flash memory dependent)
- Go to the [INAV Welcome Page](https://github.com/iNavFlight/inav?tab=readme-ov-file#readme) for a longer list of features.

Check out our [Hardware-Design-Guidelines](https://github.com/iNavFlight/inav/wiki/Hardware-Design-Guidelines) if you want to design your own flight controller to run INAV.

## Downloads

### INAV Configurator

**[Download INAV Configurator](https://github.com/iNavFlight/inav-configurator/releases/latest)** - Available for Windows, macOS, and Linux

The INAV Configurator is the official desktop application for configuring your INAV flight controller. Select your platform from the Assets section.

### INAV Firmware

**[Download INAV Firmware](https://github.com/iNavFlight/inav/releases/latest)**

Download the latest INAV flight controller firmware to flash to your FC board using the configurator.

## Using the wiki

- The right sidebar lists Wiki Pages and DevDocs grouped under Topic Headings.
- Search using [Github Wiki Search](https://github.com/search?q=repo%3AiNavFlight%2Finav&type=wikis) which applies a wikis filter to github search. Unfortunately, the wiki is no longer indexed by the major search engines.

## Getting Started

- See the sidebar to the right and look at the wiki pages under **INTRODUCTION** and **QUICK START GUIDES**
- When buying a flight controller board, INAV support is usually listed in the product's description.
- To connect and configure INAV on a flight controller, use the [INAV Configurator](https://github.com/iNavFlight/inav-configurator/releases/latest).
- If you have experience with BetaFlight, see the wiki page [INAV for BetaFlight users](https://github.com/iNavFlight/inav/wiki/INAV-for-BetaFlight-users) to get started.
- See our [YouTube video guides](YouTube-video-guides) for some of the many great tutorials on YouTube. YouTube has hundreds and hundreds of great guides on all features of INAV.
- Find and Join an INAV user group on your social media platform of choice. INAV users are happy to help get you started.

## INAV versions and compatibility

Since INAV 4.0.0, the SemVer system has been used for deciding when the different parts of the version number changes. This system makes it easy to see which versions of INAV are compatible. The version number is made up of 3 sections, separated by dots. These are major.minor.patch.

So with **INAV 7.1.2**:
- **7** is the major version number
- **1** is the minor version number
- **2** is the patch version number

Both the firmware and Configurator follow the same versioning scheme. The major version numbers match.

**Major** version numbers are increased when a change is made that breaks backwards compatibility. This does not have to be a big change or new feature. It can be something as simple as adding a new symbol on the OSD (due to the font update) or changing or removing a CLI parameter. When the major version number is increased, the minor and patch version numbers are reset to 0.

**Minor** version numbers are increased when a a feature is added or updated that does not break backwards compatibility. This can be complete new features, even new CLI parameters. When the minor version number is increased, the patch version number is reset to 0.

**Patch** version numbers are increased when the release contains only bug fixes or new targets.

With INAV you must match the major version number of the [firmware](https://github.com/iNavFlight/inav) and [Configurator](https://github.com/iNavFlight/inav-configurator). This has been the case for a long time. Even pre-SemVer. In fact, before SemVer you had to match the major and minor version numbers. Now, it is recommended to use the latest version of Configurator that has the same major version number of your firmware. For example with firmware 7.0.0 it is recommended to use Configurator 7.1.2.
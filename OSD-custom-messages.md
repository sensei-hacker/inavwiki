One of INAV's most useful features has been the [Programming Framework](https://github.com/iNavFlight/inav/blob/master/docs/Programming%20Framework.md) . Allowing users to customize their flight logic, to suit their requirements.

But from the release of INAV 7.1.0 there is the addition of _custom OSD_ elements. So users can add their own messages, and display relevant global variables derived from the Programming framework.

The settings are found under the Configurator OSD tab. 

![Custom OSD elements](https://github.com/iNavFlight/inav/assets/47995726/09905b3d-6217-4777-939a-7174c2207a63)

![Custom elements GV](https://github.com/iNavFlight/inav/assets/47995726/26c8b12d-27da-4a10-9ce7-e8b42289623b)

With 3 custom elements available. And various user selections. Which are as follows.

|  Options       |        Description                                                                                            |
| ------------   |  -----------------------------------------------------------------------------------------------------------  |
| **NONE**       | Don't use any selection in the drop-down                                                                     |
| **TEXT**       | Show your text. 0 - 15 characters which can include [`A-Z`] [`0-9`] [`^!.\*`]                                            |
| **ICON STATIC**| User can select a [character](https://github.com/iNavFlight/inav-configurator/blob/master/resources/osd/analogue/impact.png) number from the [INAV OSD](https://github.com/iNavFlight/inav-configurator/tree/master/resources/osd/digital/default/36x54) they want to display as a descriptive reference                                                                      |
| **ICON GV**    | OSD character appears, when driven by a global variable value                                                           |                                                              
| **GV**         | Select global variable value with different decimal formats [`00000` `000.00` `000` `0.0`]                                                                                 
| **VISIBILITY** | Display items as **Always** or as the result of a **Global variable** or **Logic Condition** being met        |


This video made by the features developer. Shows an example of a custom distance to !GROUND! message with the GV containing the Lidar readout next to it. And a static altitude icon character. 
https://youtu.be/BqkDo-2O7js?si=_vOAHQn2N0MGbKdl&t=81
One of INAV's most useful features has been the [Programming Framework](https://github.com/iNavFlight/inav/blob/master/docs/Programming%20Framework.md) . Allowing users to customize their flight logic, to suit their requirements.

But from the release of INAV 7.1.0 there is the addition of _custom OSD_ elements. So users can add their own messages, and display relevant global variables derived from the Programming framework.

The settings are found under the Configurator OSD tab. 

![Custom elements GV](https://github.com/iNavFlight/inav/assets/47995726/26c8b12d-27da-4a10-9ce7-e8b42289623b)


With 3 custom elements available. And various user selections. Which are as follows.

|  Options       |        Description                                                                                            |
| ------------   |  -----------------------------------------------------------------------------------------------------------  |
| **NONE**       | Don't use any selection in the drop-down                                                                     |
| **TEXT**       | Displays text. 0 - 15 characters which can include [`A-Z`] [`0-9`] [`^!.\*`] * Text can only be used once in a single element, due to memory limitations                                           |
| **ICON STATIC**| User can select a [character](https://github.com/iNavFlight/inav-configurator/blob/master/resources/osd/analogue/impact.png) number from the [INAV OSD](https://github.com/iNavFlight/inav-configurator/tree/master/resources/osd/digital/default/36x54) they want to display as a descriptive reference                                                                      |
| **ICON GV**    | OSD character appears, when driven by a global variable value                                                           |                                                              
| **GV**         | Select global variable value with different decimal formats [`00000` `000.00` `000` `0.0`]                                                                                 
| **VISIBILITY** | Display items as **Always** or as the result of a **Global variable** or **Logic Condition** being met        |

This [video](https://youtu.be/BqkDo-2O7js?si=_vOAHQn2N0MGbKdl&t=81) made by the features developer. Shows an example of a custom element, which is the **!GROUND!** message, and a GV containing Lidar altitude above the surface. With a static altitude character beside it. 

## This is an example of a simple stall detection message.

The logic checks if the throttle is less than 20%, with the airplanes AoA at greater than 23 degree.. The timer is set to flash the message every 800mS.

![Stall warning logic](https://github.com/iNavFlight/inav/assets/47995726/7ec0ecaa-a804-4b2a-a860-f5e10598aedb)

The message will display STALL WARNING and the pitch angle, with an OSD warning symbol (221). The stall message will only appear when the conditions are met.

![OSD custom](https://github.com/iNavFlight/inav/assets/47995726/b386631b-2589-448e-ab00-6703ea70b332)




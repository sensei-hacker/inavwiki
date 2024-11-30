One of INAV's most useful features has been the [Programming Framework](https://github.com/iNavFlight/inav/blob/master/docs/Programming%20Framework.md) . Allowing users to customize their flight logic, to suit their requirements.

But from the release of INAV 7.1.0 there is the addition of _custom OSD_ elements. So users can add their own messages, and display relevant global variables derived from the Programming framework.

The settings are found under the Configurator OSD tab. 

![Custom elements GV](https://github.com/iNavFlight/inav/assets/47995726/26c8b12d-27da-4a10-9ce7-e8b42289623b)
![elements](https://github.com/iNavFlight/inav/assets/47995726/33bb28e2-d090-4716-b01c-6a0aec59f9eb)

With 3 custom elements available. And various user selections. Which are as follows.

|  Options       |        Description                                                                                            |
| ------------   |  -----------------------------------------------------------------------------------------------------------  |
| **None**       | Don't use any selection in the drop-down                                                                     |
| **Text**       | Displays text. 0 - 15 characters which can include [`A-Z`] [`0-9`] [`^!.\*`] * Text can only be used once in a single element, due to memory limitations                                           |
| **Icon Static**| User can select a [character](https://github.com/iNavFlight/inav-configurator/blob/master/resources/osd/INAV%20Character%20Map.md) number from the [INAV OSD](https://github.com/iNavFlight/inav-configurator/blob/master/resources/osd/analogue/impact.png) , they want to display as a descriptive reference                                                                      |
| **ICON from Global Variable**    | Displays the icon, driven from a global variable
| **ICON from Logic Condition**    | Displays the icon, driven from a logic condition (Added in INAV 8.0.0)                                                  |                                                              
| **Global Variable #**         | Data within the global variable can be displayed in these decimal format's [`00000` `0000` `000` `00` `0` `0000.0` `000.00` `000.0` `00.00` `00.0` `0.0`] (Some formats added in INAV 8.0.0) |
| **Logic Condition #**         | Status of the logic condition can be displayed in these decimal format's [`00000` `0000` `000` `00` `0` `0000.0` `000.00` `000.0` `00.00` `00.0` `0.0`] (Added in INAV 8.0.0) |
| **VISIBILITY** | Choose when to display custom message - **Always** or as the result of a **Global Variable** or **Logic Condition** being met        |

This [video](https://youtu.be/BqkDo-2O7js?si=_vOAHQn2N0MGbKdl&t=81) made by the features' developer. Shows an example of a custom element, which is the **!GROUND!** message, and a GV containing Lidar altitude above the surface. With a static altitude character beside it. 

***

## This is an example of a simple stall warning indicator

The logic checks if the _Virtual Airspeed_ had dropped below 30km/h, and the _Pitch_ being above 20° Angle of Attack or the _Throttle_ below 48%. Warning of a potential stall. Being that most tip stalls conditions are induced unknowingly by the pilot, this can help avoid such events.

Makes sure you enable the _virtual pitot_ if you do not use a real pitot. To better suit your aircraft. **Pitch** angle, **Throttle** and **Airspeed** values should be altered for best detection.

![Air speed stall warning logic](https://github.com/user-attachments/assets/0f9ecb36-7903-476f-a843-5c53cfcbeac0)


The message will display STALL WARNING with a warning symbol (221). The stall message will only appear when the conditions are met.

![OSD warning](https://github.com/iNavFlight/inav/assets/47995726/1d479cda-6620-4025-9958-fb693149d886)

> [!NOTE]
> Please note that stalls are not caused directly by the speed of the aircraft. Stalls are caused by too little airflow over the wing. Which is dependent on airspeed at the attitude of the aircraft. So ground speed will only give a very basic warning. It will not detect all instances of a stall. So please do not be complacent.

## This is an example of a basic switch indicator
While there are switch indicators for the OSD. Using the Custom OSD elements can give you much more control over this. This is an example of how to set them up.

On the Programming Framework page. Set up the Logic Conditions for the switch.

![Programming for a switch indicator](https://github.com/user-attachments/assets/68490129-b2fb-4441-8437-35e2ac824cfe)

- LC0 takes the channel that you want to display the switch for, and subtracts 1000. This gives the switch a 0-1000 range.
- LC1 maps that range to 3 values: 0, 1, and 2.
- LC2 Adds the value from LC1 to the first switch indicator icon. 208 is switch down, 209 is switch in the middle, and 210 is switch up.
- LC3 sets GVAR 0 to the value from LC2. **Note** In INAV 8.0.0, you do not need LC3. You can use the output from LC2 directly to select the icon.

Then on the OSD page. Add the Custom OSD element to handle the programming.

![Custom OSD Settings](https://github.com/user-attachments/assets/8a20e38d-4373-4ed9-ab7d-33f2fcc6df32)

- Setup the icon. For INAV 7.1.x you will need to set this to **Icon Global Variable**. You would set the GV to the variable you chose in the programming. In this example, GV 0. With INAV 8.0.0 onwards, we don't need to use the Global Variable. So set this to use **Icon from Logic Condition**. Then set the LC to the appropriate Logic Condition. LC2 in our example.
- Next, we simple add the **Text** for what the switch represents.

If you want to swap the icon and text sides. You simply switch the text and icon.

> [!NOTE]
> Please note that Custom element previews are added in INAV 8.0.0. Currently, the Custom OSD icons in the OSD preview cannot retrieve the actual value from the global variable. The actual value of Global Variable 0 in the above example is 209. Which displays the mid switch position
> ![](https://raw.githubusercontent.com/iNavFlight/inav-configurator/master/resources/osd/analogue/default/209.png)

## Custom OSD Elements video tutorials

[How to add custom OSD elements in INAV - Mr.D RC](https://youtu.be/DR6rxMLTP44)


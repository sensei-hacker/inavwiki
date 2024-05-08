# Overview

This tab in the INAV Configurator controls the UART and USB serial ports on your flight controller (FC). These serial ports are used to communicate with devices and sensors typically soldered or connected by pins or plugs to your FC. (Other connections such as I2C, gyro, barometer, etc. are configured on the Configuration Tab)

The serial port settings are presented in a table format with each UART and USB serial port on a separate row. INAV supports a number of protocols and connection speeds. Here are some general rules:
- Do not disable the Data toggle going to the USB VCP port as this will soft brick your ability to connect to your FC over USB. There are two ways to fix this, 1) hope one of your other UARTS have MSP enabled and use a serial adapter to connect to your FC, or 2) press the DFU button and reflash your FC losing your current configuration and start from scratch.
- A serial UART allows two-way communication using a pair of wires. There is also a required ground wire and a wire for power so there is usually four wires going to a device. Some devices only need three total wires since they don't require two-way communication or they use half duplex communication so only one wire is enough. These requirements are usually listed with your device on in the wiring diagram that may have been included in the FC documentation.
- Your device requires a specific protocol and port speed and INAV needs to be set accurately configured for your FC to communicate with it.
- The columns represent different types or groups of communication devices and sensors.
- Remember, **only one device can be active per serial port**. Having more than one device on a port is an invalid configuration and INAV running on the FC will reject the configuration and not save the updated settings. Effectively you will lose the changes you just made. Take your time and maybe save your settings often.



- Identifier


- Data
* Multiwii Serial Protocol (MSP). This is a polled protocol, and thus in INAV terms, not considered 'telemetry', even when used for remote measurement. The application (OSD, CGS) polls the flight controller "send me status data" and the FC responds, "here's the status data"; "send me the GPS data" -> "here's the GPS data". This is supported by most OSDs and CGS. It has advantages and disadvantages:
  - The remote (OSD, CGS) can determine what data it requests (+ve)
  - The configurator uses MSP to communicate with and configure the FC (+ve)
  - The remote (OSD, CGS) must maintain a timeout and retry, as data can be lost in transmission (-ve)
  - For packet radio links (3DR, HC-12), this is slow (much slower than the data rate would indicate), due the overheads on creating and tearing down the packets.
  
  **It is not necessary to define an "telemetry protocol" to use MSP alone.** 



- Telemetry
Factually and classically, telemetry is an automated communications process by which measurements and other data are collected at remote or inaccessible points and transmitted to receiving equipment for monitoring. The word is derived from Greek roots: tele = remote, and metron = measure. 
In INAV terms, it has a rather more specific meaning, describing a means by which measurement data is pushed automatically from the vehicle to another device, typically a CGS (Computer Ground Station) or OSD (On-screen Display). 

- RX
 TX protocols. A number of TX devices (FrSky, Hott, IBUS, Smartport) can also receive telemetry. 


- Sensors
- Peripherals
It is also the case in INAV that getting data into a CGS or OSD can be achieved _without_ defining a telemetry protocol (using MSP, below).



### Example

Please note that this port configuration is not directly applicable to your flight controller and aircraft.
![Ports](https://imgur.com/PnqqpAN.png)



# Overview

This controls the UART and USB serial ports on your flight controller (FC). These serial ports are used to communicate with devices and sensors typically soldered or connected by pins or plugs to your FC. (Other connections such as I2C, gyro, barometer, etc. are configured on the Configuration Tab)

The serial port settings are presented in a table format with each UART and USB serial port on a separate row. INAV supports a number of protocols and connection speeds. Here are some general rules:
- Do not disable the Data toggle going to the USB VCP port as this will soft brick your ability to connect to your FC over USB. There are two ways to fix this, 1) hope one of your other UARTS have MSP enabled and use a serial adapter to connect to your FC, or 2) press the DFU button and reflash your FC losing your current configuration and start from scratch.
- A serial UART allows two-way communication using a pair of wires. There is also a required ground wire and a wire for power so there is usually four wires going to a device. Some devices only need three total wires since they don't require two-way communication or they use half duplex communication so only one wire is enough. These requirements are usually listed with your device on in the wiring diagram that may have been included in the FC documentation.
- The TX pad on your FC need to be connected to the RX pad on your device, and the RX pad on your FC need to be connected to the TX pad on your device. TX -> RX and RX -> TX and getting this backwards will mean your device will not function.
- Inverted Serial protocols are a special situation that is less of an issue in modern times. But you should consider this if you are having issues.
- Your device requires a specific protocol and port speed and INAV needs to be set accurately configured for your FC to communicate with it.
- The columns represent different types or groups of communication devices and sensors.
- Remember, **only one device can be active per serial port**. Having more than one device on a port is an invalid configuration and INAV running on the FC will reject the configuration and not save the updated settings. Effectively you will lose the changes you just made. Take your time and maybe save your settings often.

## Ports Table Columns

### Identifier
Lists the available ports with their labels. The UART numbers match the UART labels on your FC board. On your FC board, the labels are abbreviated to UART 1 = R1 and T1 or sometimes TX1 and RX1. You might find an inverted UART on your FC and its most times labeled as nT1 or nR1 with stands for -not-.

### Data
The MSP protocol is the native data protocol of INAV used by only specific devices.\
**Supported Devices:** INAV Radar, Formation Flight, Bluetooth or other wireless configuration connection, some RemoteID modules\
**Other Notes:** Its good practice to setup MSP on at least one UART. There is a possibility that you might break off or damage your USB port in a crash or soldering. A UART with MSP can be uses as an alternate connection method.

### Telemetry
In the RC world, telemetry is generally used to refer to the measurements and stats from your aircraft that is sent back to your radio control (RC) transmitter (TX). This allows you to see these values live and even set alerts in your radio as the values change. An example would be your live battery voltage or current GPS coordinates all being sent back to your radio for your to set a low battery alarm or find a lost aircraft. The RC Receiver is what handles the telemetry communication between the FC and your RC TX. Some RC Receivers use their RX connection for telemetry and as such do not use this telemetry column at all. While other Receivers (RX) use a separate wire for telemetry and in these cases they need a separate UART for the telemetry connection.\
**Supported Devices:** See the dropdown list in the configurator\
**Non-Telem Port Devices:** TBS Crossfire / Tracer, ExpressLRS, Ghost, FPORT, Spektrum, and others\
**Other Notes:** Receivers that have a separate wire for telemetry need to have a UART dedicated for just telemetry only. This wire cannot be on the same UART as the RX. The wiring diagram that may have been included in the FC documentation may help you in selecting an acceptable port.

### RX
 TX protocols. A number of TX devices (FrSky, Hott, IBUS, Smartport) can also receive telemetry. 
\
**Supported Devices:** \
**Other Notes:** 

- Sensors
- Peripherals
It is also the case in INAV that getting data into a CGS or OSD can be achieved _without_ defining a telemetry protocol (using MSP, below).
\
**Supported Devices:** \
**Other Notes:** 


### Example

Please note that this port configuration is not directly applicable to your flight controller and aircraft.
![Ports](https://imgur.com/PnqqpAN.png)

Advanced: Multiwii Serial Protocol (MSP). This is a polled protocol, and thus in INAV terms, not considered 'telemetry', even when used for remote measurement. The application (OSD, CGS) polls the flight controller "send me status data" and the FC responds, "here's the status data"; "send me the GPS data" -> "here's the GPS data". This is supported by most OSDs and CGS. It has advantages and disadvantages:
- The remote (OSD, CGS) can determine what data it requests (+ve)
- The configurator uses MSP to communicate with and configure the FC (+ve)
- The remote (OSD, CGS) must maintain a timeout and retry, as data can be lost in transmission (-ve)
- For packet radio links (3DR, HC-12), this is slow (much slower than the data rate would indicate), due the overheads on creating and tearing down the packets.


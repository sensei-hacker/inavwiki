INAV implements universal interconnect bus for various types of sensors and executable devices.

It's compatible with all existing controllers that have a spare UART and designed to be able to connect multiple sensors to one shared bus. Devices on the bus can be daisy-chained together for neater wiring.

## Physical layer
### Option 1: Differential signalling

This option is taken from automotive applications and uses CAN bus transceivers (MCP2551 or SN65HVD232) to convert between twisted pair and UART. A special converter is required between each device and a bus. While this option is more expensive it's also very reliable.

Advantages: high reliability, long wires possible

### Option 2: Shared wire

This option is designed for tight spaces or very cost-sensitive solutions. Wiring should follow Siemens Application Node AP2921: On-Board Communication via CAN without Transceiver (https://www.mikrocontroller.net/attachment/28831/siemens_AP2921.pdf)

Advantages: low price, low wire count

### Data format on the wire

From data format point of view it's plain asynchronous serial with following parameters: 128000,8,n,1

## Device addressing

Each slave device on a bus has a unique **DevID** which defines device functionality (GPS, Optical flow, RC receiver etc). **DevID** is one byte and also serves as a device priority - master controller will favor devices with lower **DevID**

During discovery phase on the bus each device is assigned a **SlotID** which it must use for communicating with the master. **DevID** is only used during discovery phase.

## Transactions on a bus

Everything on a bus is coordinated by a master device (flight controller) and all transactions are organised in **slots**. There are at most 64 slots possible on a single bus.

Master begins transaction with one byte. Highest two bits indicate a **command**, while lower 6 bits indicate a **SlotID**. The rest of transaction depends on which command is being executed.

A 2ms guard interval is mandatory between transactions and is used by all devices to reset internal state. First byte after guard interval is assumed to be a command from master device.

### Data integrity

Each transaction on a bus ends with a 1-byte CRC calculated by CRC-8/DVB-S2 algorithm. 
CRC is calculated over all transaction bytes starting with command byte. 
CRC is calculated by the data originator and verified by the master.

## Commands on a bus

### IDENTIFY (0x00)

| Byte | Originator | Description |
|------|------------|-------------|
| 0    | Master     | Value of (0x00 + SlotID)  |
| 1    | Master     | DevID of requested device |
| 2    | Slave      | Poll interval (high byte) |
| 3    | Slave      | Poll interval (low byte)  |
| 4    | Slave      | Device flags (high byte)  |
| 5    | Slave      | Device flags (low byte)   |
| 6    | Slave      | CRC (over bytes 0-5)      |

During discovery phase master sends *IDENTIFY* commands for each supported **DevID**. 
Device with corresponding **DevID** must respond with desired poll interval (in milliseconds) and flag field.
Also, device which has detected it's **DevID** must remember the **SlotID** of the transaction - this will be the **SlotID** assigned to the device.

### READ (0x40)

| Byte | Originator | Description |
|------|------------|-------------|
| 0    | Master     | Value of (0x40 + SlotID)  |
| 1-16 | Slave      | Data packet (16 bytes)    |
| 17   | Slave      | CRC (over bytes 0-16)     |

Device with **SlotID** that was assigned to it during discovery phase must respond to this command with a 16-byte data packet.

### WRITE (0x80)

| Byte | Originator | Description |
|------|------------|-------------|
| 0    | Master     | Value of (0x80 + SlotID)  |
| 1-16 | Master     | Data packet (16 bytes)    |
| 17   | Master     | CRC1 (over bytes 0-16)    |
| 18   | Slave      | Acknowledgement flag (1 = received correctly) |
| 19   | Slave      | CRC2 (over bytes 0-17)    |

Device with **SlotID** that was assigned to it during discovery phase must accept the data, verify the CRC and acknowledge it.
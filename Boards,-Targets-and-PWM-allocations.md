# INav Boards, Targets and PWM allocations

Due to the complexity of output options available in iNav, dynamic resource allocation is not available.
It can be difficult for an aircraft builder to determine if a particular board / target will meet their needs.

Paweł Spychalski as published a [video](https://www.youtube.com/watch?v=v4R-pnO4srU)
explaining why resource allocation is not supported by iNav.

In order to offer some guidance, the following list is machine
generated from the files under `inav/source/main/target` to
provide a list of the options offered by supported boards.

The usage is taken directly from the source code, the following interpretation is offered:

| Symbol | Interpretation |
| ------ | -------------- |
| MC_MOTOR | Multi-rotor motor |
| FW_MOTOR | Fixed wing motor |
| MC_SERVO | Multi-rotor servo |
| FW_SERVO | Fixed wing servo |
| LED      | LED strip  |
| PWM, ANY | Some other PWM function |

*List generated 2019-06-19 from the iNav development branch / master 2.2.0 by [`parse_targets.rb`](http://seyrsnys.myzen.co.uk/parse_targets.rb). Some targets may not be available in master or prior releases.* **E&OE.**

Note: Due to the fact that there is no reliable, consistent means to get from the timer definition in `target.c` to human readable output names, the script cowardly refuses to parse more than 8 outputs. You are strongly advised to check the board documentation as to the suitability of any particular board.
## Board: AIRBOTF4

Board is DSHOT enabled.

### Target: AIRBOTF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO, ANY |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 7 | PWM, FW_SERVO |
| 8 | PWM, FW_SERVO |

## Board: AIRHEROF3

### Target: AIRHEROF3

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

### Target: AIRHEROF3_QUAD

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, MC_SERVO, FW_SERVO |

## Board: ALIENFLIGHTF3

### Target: ALIENFLIGHTF3

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_SERVO, ANY |

## Board: ALIENFLIGHTF4

### Target: ALIENFLIGHTF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_SERVO |

## Board: ALIENFLIGHTNGF7

### Target: ALIENFLIGHTNGF7

| PWM | Usage |
| --- | ----- |
| 1 | MC_SERVO |
| 2 | MC_SERVO |
| 3 | MC_SERVO |
| 4 | MC_SERVO |
| 5 | MC_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_SERVO |

## Board: ANYFC

### Target: ANYFC

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_MOTOR |
| 5 | MC_MOTOR, FW_MOTOR |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_SERVO |

## Board: ANYFCF7

### Target: ANYFCF7

| PWM | Usage |
| --- | ----- |
| 1 | PWM, MC_SERVO |
| 2 | PWM, MC_SERVO |
| 3 | PWM, MC_SERVO |
| 4 | PWM, MC_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_MOTOR |

### Target: ANYFCF7_EXTERNAL_BARO

| PWM | Usage |
| --- | ----- |
| 1 | PWM, MC_SERVO |
| 2 | PWM, MC_SERVO |
| 3 | PWM, MC_SERVO |
| 4 | PWM, MC_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_MOTOR |

## Board: ANYFCM7

### Target: ANYFCM7

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_MOTOR |
| 5 | MC_MOTOR, FW_MOTOR |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO, LED |
| 8 | MC_MOTOR, FW_SERVO |

## Board: ASGARD32F4

Board is DSHOT enabled.

### Target: ASGARD32F4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR |
| 2 | MC_MOTOR |
| 3 | MC_MOTOR |
| 4 | MC_MOTOR |

## Board: ASGARD32F7

Board is DSHOT enabled.

### Target: ASGARD32F7

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR |
| 2 | MC_MOTOR |
| 3 | MC_MOTOR |
| 4 | MC_MOTOR |

## Board: BEEROTORF4

### Target: BEEROTORF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 7 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 8 | MC_MOTOR, MC_SERVO, FW_SERVO |

## Board: BETAFLIGHTF3

### Target: BETAFLIGHTF3

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_SERVO |

## Board: BETAFLIGHTF4

### Target: BETAFLIGHTF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |

## Board: BLUEJAYF4

### Target: BLUEJAYF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO, LED |
| 6 | MC_MOTOR, FW_SERVO |

## Board: CHEBUZZF3

### Target: CHEBUZZF3

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

## Board: CLRACINGF4AIR

### Target: CLRACINGF4AIR

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

### Target: CLRACINGF4AIRV2

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_MOTOR |
| 5 | MC_MOTOR, FW_MOTOR |
| 6 | MC_MOTOR, FW_SERVO |

### Target: CLRACINGF4AIRV3

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_MOTOR |
| 5 | MC_MOTOR, FW_MOTOR |
| 6 | MC_MOTOR, FW_SERVO |

## Board: COLIBRI

### Target: COLIBRI

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, MC_SERVO, FW_MOTOR |
| 8 | MC_MOTOR, MC_SERVO, FW_MOTOR |

### Target: QUANTON

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, MC_SERVO, FW_MOTOR |
| 8 | MC_MOTOR, MC_SERVO, FW_MOTOR |

## Board: COLIBRI_RACE

Board is DSHOT enabled.

### Target: COLIBRI_RACE

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR |
| 6 | MC_MOTOR |
| 7 | MC_MOTOR |
| 8 | MC_MOTOR |

## Board: DALRCF405

### Target: DALRCF405

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, MC_SERVO, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_SERVO |

## Board: DALRCF722DUAL

### Target: DALRCF722DUAL

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_MOTOR |
| 6 | MC_MOTOR, FW_SERVO |

## Board: F4BY

### Target: F4BY

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_SERVO |

## Board: FALCORE

### Target: FALCORE

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR |
| 2 | MC_MOTOR |
| 3 | MC_MOTOR |
| 4 | MC_MOTOR |
| 5 | MC_SERVO |
| 6 | MC_SERVO |

## Board: FF_F35_LIGHTNING

### Target: FF_F35_LIGHTNING

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

### Target: WINGFC

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

## Board: FF_FORTINIF4

### Target: FF_FORTINIF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |

## Board: FF_PIKOF4

### Target: FF_PIKOF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |

### Target: FF_PIKOF4OSD

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

## Board: FIREWORKSV2

Board is DSHOT enabled.

### Target: FIREWORKSV2

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR |
| 2 | FW_MOTOR |
| 3 | MC_MOTOR |
| 4 | FW_MOTOR |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_SERVO |

### Target: OMNIBUSF4V6

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR |
| 2 | FW_MOTOR |
| 3 | MC_MOTOR |
| 4 | FW_MOTOR |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_SERVO |

## Board: FISHDRONEF4

### Target: FISHDRONEF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

## Board: FOXEERF405

Board is DSHOT enabled.

### Target: FOXEERF405

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

## Board: FOXEERF722DUAL

Board is DSHOT enabled.

### Target: FOXEERF722DUAL

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

## Board: FRSKYF3

### Target: FRSKYF3

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_SERVO |

## Board: FRSKYF4

### Target: FRSKYF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

## Board: FURYF3

### Target: FURYF3

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR |
| 2 | MC_MOTOR |
| 3 | MC_MOTOR |
| 4 | MC_MOTOR |
| 5 | MC_MOTOR |
| 6 | MC_MOTOR |

### Target: FURYF3_SPIFLASH

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR |
| 2 | MC_MOTOR |
| 3 | MC_MOTOR |
| 4 | MC_MOTOR |
| 5 | MC_MOTOR |
| 6 | MC_MOTOR |

## Board: FURYF4OSD

Board is DSHOT enabled.

### Target: FURYF4OSD

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_MOTOR |

### Target: MAMBAF405

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_MOTOR |

## Board: KAKUTEF4

### Target: KAKUTEF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

### Target: KAKUTEF4V2

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |

## Board: KAKUTEF7

### Target: KAKUTEF7

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO, MC_SERVO |
| 6 | MC_MOTOR, FW_SERVO, MC_SERVO |

### Target: KAKUTEF7MINI

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO, MC_SERVO |
| 6 | MC_MOTOR, FW_SERVO, MC_SERVO |

## Board: KFC32F3_INAV

### Target: KFC32F3_INAV

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_SERVO |

## Board: KISSFC

### Target: KISSFC

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

## Board: KROOZX

### Target: KROOZX

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR |
| 2 | MC_MOTOR |
| 3 | MC_MOTOR |
| 4 | MC_MOTOR |
| 5 | MC_MOTOR |
| 6 | MC_MOTOR |
| 7 | MC_MOTOR |
| 8 | MC_MOTOR |

## Board: LUX_RACE

### Target: LUX_RACE

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR |
| 6 | MC_MOTOR |
| 7 | MC_MOTOR |
| 8 | MC_MOTOR |

## Board: MATEKF405

Board is DSHOT enabled.

### Target: MATEKF405

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, MC_SERVO, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, LED |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_MOTOR |

### Target: MATEKF405OSD

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, MC_SERVO, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, LED |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_MOTOR |

### Target: MATEKF405_SERVOS6

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, LED |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 7 | MC_MOTOR, FW_MOTOR |

## Board: MATEKF405SE

Board is DSHOT enabled.

### Target: MATEKF405SE

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_SERVO, FW_SERVO |
| 8 | MC_SERVO, FW_SERVO |

## Board: MATEKF411

Board is DSHOT enabled.

### Target: MATEKF411

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_SERVO, FW_SERVO |
| 6 | MC_SERVO, FW_SERVO |
| 7 | MC_SERVO, FW_SERVO |

### Target: MATEKF411_FD_SFTSRL

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_SERVO, FW_SERVO |
| 6 | MC_SERVO, FW_SERVO |
| 7 | MC_SERVO, FW_SERVO |

### Target: MATEKF411_RSSI

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_SERVO, FW_SERVO |
| 6 | MC_SERVO, FW_SERVO |
| 7 | MC_SERVO, FW_SERVO |

### Target: MATEKF411_SFTSRL2

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_SERVO, FW_SERVO |
| 6 | MC_SERVO, FW_SERVO |
| 7 | MC_SERVO, FW_SERVO |

## Board: MATEKF722

Board is DSHOT enabled.

### Target: MATEKF722

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_MOTOR |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 7 | MC_SERVO, FW_SERVO |

### Target: MATEKF722_HEXSERVO

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_MOTOR |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_SERVO, FW_SERVO |

## Board: MATEKF722SE

Board is DSHOT enabled.

### Target: MATEKF722MINI

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_SERVO, FW_MOTOR |
| 8 | MC_SERVO, FW_MOTOR |

### Target: MATEKF722SE

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_SERVO, FW_MOTOR |
| 8 | MC_SERVO, FW_MOTOR |

## Board: MOTOLAB

### Target: MOTOLAB

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 8 | MC_MOTOR, MC_SERVO, FW_SERVO |

## Board: NOX

### Target: NOX

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |

## Board: OMNIBUS

### Target: OMNIBUS

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, MC_SERVO, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

## Board: OMNIBUSF4

Board is DSHOT enabled.

### Target: DYSF4PRO

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |

### Target: DYSF4PROV2

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |

### Target: OMNIBUSF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |

### Target: OMNIBUSF4PRO

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |

### Target: OMNIBUSF4PRO_LEDSTRIPM5

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |

### Target: OMNIBUSF4V3

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |

### Target: OMNIBUSF4V3_S5S6_SS

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |

### Target: OMNIBUSF4V3_S5_S6_2SS

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |

### Target: OMNIBUSF4V3_S6_SS

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |

## Board: OMNIBUSF7

### Target: OMNIBUSF7

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |

### Target: OMNIBUSF7V2

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |

## Board: OMNIBUSF7NXT

Board is DSHOT enabled.

### Target: OMNIBUSF7NXT

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_MOTOR |
| 6 | MC_MOTOR, FW_MOTOR |

## Board: PIKOBLX

### Target: PIKOBLX

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |

## Board: PIXRACER

### Target: PIXRACER

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_MOTOR |
| 6 | MC_MOTOR, FW_MOTOR |

## Board: QUARKVISION

### Target: QUARKVISION

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 8 | MC_MOTOR, MC_SERVO, FW_SERVO |

## Board: RADIX

### Target: RADIX

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR |
| 2 | MC_MOTOR |
| 3 | MC_MOTOR |
| 4 | MC_MOTOR |
| 5 | MC_MOTOR |
| 6 | MC_MOTOR |

## Board: RCEXPLORERF3

### Target: RCEXPLORERF3

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_MOTOR, MC_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_MOTOR |
| 5 | MC_MOTOR, FW_SERVO |

## Board: REVO

Board is DSHOT enabled.

### Target: REVO

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO, ANY |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 7 | PWM, FW_SERVO |
| 8 | PWM, FW_SERVO |

## Board: RMDO

### Target: RMDO

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 8 | MC_MOTOR, MC_SERVO, FW_SERVO |

## Board: SPARKY

### Target: SPARKY

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, MC_SERVO, FW_MOTOR |
| 2 | MC_MOTOR, MC_SERVO, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO, LED |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, FW_SERVO |
| 8 | MC_MOTOR, FW_SERVO |

## Board: SPARKY2

### Target: SPARKY2

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |

## Board: SPEEDYBEEF4

### Target: SPEEDYBEEF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 7 | MC_MOTOR, MC_SERVO, FW_SERVO |

## Board: SPRACINGF3

### Target: SPRACINGF3

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 8 | MC_MOTOR, MC_SERVO, FW_SERVO |

## Board: SPRACINGF3EVO

### Target: SPRACINGF3EVO

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 7 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 8 | MC_MOTOR, MC_SERVO, FW_SERVO |

### Target: SPRACINGF3EVO_1SS

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 8 | MC_MOTOR, MC_SERVO, FW_SERVO |

## Board: SPRACINGF3MINI

### Target: SPRACINGF3MINI

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 7 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 8 | MC_MOTOR, MC_SERVO, FW_SERVO |

## Board: SPRACINGF3NEO

### Target: SPRACINGF3NEO

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_MOTOR |
| 6 | MC_MOTOR, FW_MOTOR |

## Board: SPRACINGF4EVO

### Target: SPRACINGF4EVO

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_SERVO |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, FW_SERVO |
| 6 | MC_MOTOR, FW_SERVO |
| 7 | MC_MOTOR, MC_SERVO, FW_MOTOR |
| 8 | MC_MOTOR, MC_SERVO, FW_MOTOR |

## Board: SPRACINGF7DUAL

Board is DSHOT enabled.

### Target: SPRACINGF7DUAL

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR |
| 2 | MC_MOTOR |
| 3 | MC_MOTOR |
| 4 | MC_MOTOR |
| 5 | MC_MOTOR |
| 6 | MC_MOTOR |
| 7 | MC_MOTOR |
| 8 | MC_MOTOR |

## Board: YUPIF4

### Target: YUPIF4

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO, LED |

### Target: YUPIF4MINI

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO |

### Target: YUPIF4R2

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_MOTOR |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO, LED |

## Board: YUPIF7

### Target: YUPIF7

| PWM | Usage |
| --- | ----- |
| 1 | MC_MOTOR, FW_MOTOR |
| 2 | MC_MOTOR, FW_SERVO |
| 3 | MC_MOTOR, FW_SERVO |
| 4 | MC_MOTOR, FW_SERVO |
| 5 | MC_MOTOR, MC_SERVO, FW_SERVO |
| 6 | MC_MOTOR, MC_SERVO, FW_SERVO, LED |


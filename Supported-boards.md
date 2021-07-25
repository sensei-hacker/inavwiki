### Sponsored and recommended boards

These boards come from companies that support INAV development. Buying one of these boards you make your small contribution for improving INAV as well. 

Also these boards are tested by INAV development team and usually flown on a daily basis.

| Board name                | CPU Family | Target name(s)            | GPS  | Compass | Barometer      | Telemetry | RX                             | Blackbox             |
|---------------------------|:----------:|:-------------------------:|:----:|:-------:|:--------------:|:---------:|:------------------------------:|:--------------------:|
| [Airbot OMNIBUS F4 PRO](https://inavflight.com/shop/p/OMNIBUSF4PRO)| F4         | OMNIBUSF4PRO   | All  | All     | All            | All       | All                            | SERIAL, SD |
| [Airbot OMNIBUS F4](https://inavflight.com/shop/s/bg/1319176)| F4         | OMNIBUSF4  | All  | All     | All            | All       | All                            | SERIAL, SD |

Note: In the above and following tables, the sensor columns indicates firmware support for the sensor category; it does not necessarily mean there is an on-board sensor.

### Recommended boards

These boards are well tested with INAV and are known to be of good quality and reliability.

| Board name                | CPU Family | Target name(s)            | GPS  | Compass | Barometer      | Telemetry | RX                             | Blackbox             |
|---------------------------|:----------:|:-------------------------:|:----:|:-------:|:--------------:|:---------:|:------------------------------:|:--------------------:|
| [Matek F405-CTR](https://inavflight.com/shop/p/MATEKF405CTR)       | F4         | MATEKF405                | All  | All     | All            | All       | All                            | SERIAL, SD     |
| [Matek F405-STD](https://inavflight.com/shop/p/MATEKF405STD)       | F4         | MATEKF405                | All  | All     | All            | All       | All                            | SERIAL, SD     |
| [Matek F405-WING](https://inavflight.com/shop/p/MATEKF405WING)       | F4         | MATEKF405SE                | All  | All     | All            | All       | All                            | SERIAL, SD     |
| [Matek F722 WING](https://inavflight.com/shop/p/MATEKF722WING)       | F7         | MATEKF722SE                | All  | All     | All            | All       | All                            | SERIAL, SD     |
| [Matek F722-SE](https://inavflight.com/shop/p/MATEKF722SE)       | F7         | MATEKF722SE               | All  | All     | All            | All       | All                            | SERIAL, SD     |
| [Matek F722-STD](https://inavflight.com/shop/p/MATEKF722STD)       | F7         | MATEKF722               | All  | All     | All            | All       | All                            | SERIAL, SD     |
| [Matek F722-MINI](https://inavflight.com/shop/p/MATEKF722MINI)       | F7         | MATEKF722SE               | All  | All     | All            | All       | All                            | SPIFLASH    |

It's possible to find more supported and tested boards [here](https://github.com/iNavFlight/inav/wiki/Welcome-to-INAV,-useful-links-and-products)
### Boards documentation

See the [docs](https://github.com/iNavFlight/inav/tree/master/docs) folder for additional information regards to many targets in INAV, to example help in finding pinout and features. _Feel free to help improve the docs._

### Boards based on F4/F7 CPUs

These boards are powerful and in general support everything INAV is capable of. Limitations are quite rare and are usually caused by hardware design issues.

### Boards based on F3 CPUs

Boards based on STM32F3 CPUs will be supported as far as possible (at least INAV 2.5); however they are not recommended for new builds, and new features will not be added.

### Boards based on F1 CPUs

Boards based on STM32F1 CPUs are no longer supported by latest INAV version. Last release is 1.7.3

### Not recommended for new setups

These boards will work with INAV but are either end-of-life, limited on features, rare or hard to get from a reliable source. In particular, F1 boards will not be supported post 1.7.3

| Board name                | CPU Family | Target name(s)            | GPS  | Compass | Barometer      | Telemetry | RX                             | Blackbox             |
|---------------------------|:----------:|:-------------------------:|:----:|:-------:|:--------------:|:---------:|:------------------------------:|:--------------------:|
| [PARIS Sirius™ AIR3]        | F3         | AIRHEROF3, AIRHEROF3_QUAD | All  | All     | All            | All       | All                            | SERIAL               |
| [Airbot OMNIBUS AIO F3](http://shop.myairbot.com/index.php/flight-control/cleanflight-baseflight/omnibusv11.html) | F3         | OMNIBUS                   | All  | All     | All            | All       | All                            | SERIAL, SD           |
| TBS Colibri Race          | F3         | COLIBRI_RACE              | All  | All     | All            | All       | All                            | SERIAL               |
| FURY F3                   | F3         | FURYF3, FURYF3_SPIFLASH   | All  | All     | All            | All       | All                            | SERIAL, SD, SPIFLASH |
| RCExplorer F3FC Tricopter | F3         | RCEXPLORERF3              | All  | All     | All            | All       | All                            | SERIAL               |
| Taulabs Sparky            | F3         | SPARKY                    | All  | All     | All            | All       | All                            | SERIAL               |
| SPRacing F3 MINI          | F3         | SPRACINGF3MINI            | All  | All     | All            | All       | All                            | SERIAL, SD           |
| RMRC Seriously DODO       | F3         | RMDO                      | All  | All     | All            | All       | All                            | SERIAL               |
| SPRacing F3 EVO           | F3         | SPRACINGF3EVO             | All  | All     | All            | All       | All                            | SERIAL, SD           |
| PARIS Sirius™ AIR HERO    | F1         | AIRHERO3                  | UBLOX | HMC5883 | MS5611, BMP280 | LTM, FRSKY | PWM, PPM, SBUS, IBUS, SPEKTRUM | SERIAL               |
| OpenPilot CC3D            | F1         | CC3D, CC3D_PPM1           | UBLOX | HMC5883 | BMP085, BMP280 | LTM       | PWM, PPM, SBUS, IBUS, SPEKTRUM | no                   |
| AfroFlight NAZE32         | F1         | NAZE                      | UBLOX | HMC5883 | MS5611, BMP280 | LTM, FRSKY | PWM, PPM, SBUS, IBUS, SPEKTRUM | SERIAL, SPIFLASH     |
| ANYFC                     | F4         | ANYFC                     | All  | All     | All            | All       | All                            | SERIAL               |
### Recommended boards

These boards are well tested with INAV and are known to be of good quality and reliability.

| Board name                | CPU Family | Target name(s)            | GPS  | Compass | Barometer      | Telemetry | RX                             | Blackbox             |
|---------------------------|:----------:|:-------------------------:|:----:|:-------:|:--------------:|:---------:|:------------------------------:|:--------------------:|
| [Matek F765-WSE](https://inavflight.com/shop/s/bg/1890404)       | F7 | MATEKF765SE | All  | All     | All      | All  | All | SERIAL, SD |
| [Matek F405-STD](https://inavflight.com/shop/p/MATEKF405STD)       | F4         | MATEKF405                | All  | All     | All            | All       | All                            | SERIAL, SD     |
| [Matek F405-WING](https://inavflight.com/shop/p/MATEKF405WING)       | F4         | MATEKF405SE                | All  | All     | All            | All       | All                            | SERIAL, SD     |
| [Matek F722-SE](https://inavflight.com/shop/p/MATEKF722SE)       | F7         | MATEKF722SE               | All  | All     | All            | All       | All                            | SERIAL, SD     |

It's possible to find more supported and tested boards [here](https://github.com/iNavFlight/inav/wiki/Welcome-to-INAV,-useful-links-and-products)
### Boards documentation

See the [docs](https://github.com/iNavFlight/inav/tree/master/docs) folder for additional information regards to many targets in INAV, to example help in finding pinout and features. _Feel free to help improve the docs._

### Boards based on F405/F745/F765 CPUs

These boards are powerful and, in general, offer everything INAV is capable of. Limitations are quite rare and are usually caused by hardware design issues.

### Boards based on F411/F722 CPUs

These boards are capable of running most of the features INAV offers. However, some exotic features might be missing. For example, Virtual Pitot, SUMD, SUMH, PCA9685 features are not available for F411/F722 boards.

### Boards based on F1/F3 CPUs

Boards based on STM32F1 and STM32F3 CPUs are no longer supported by the latest INAV versions
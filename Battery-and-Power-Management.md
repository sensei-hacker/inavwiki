# Battery and Power Management

This guide covers battery monitoring, power limiting, and related features in INAV. For complete technical details, see the [official Battery documentation](https://github.com/iNavFlight/inav/blob/master/docs/Battery.md).
This wiki page is a draft - feel free to edit if you see anything incorrect or unclear.

## Quick Start Checklist

- [ ] Enable `VBAT` feature for voltage monitoring
- [ ] Enable `CURRENT_METER` feature if you have a current sensor
- [ ] Calibrate voltage scale (`vbat_scale`)
- [ ] Calibrate current sensor (`current_meter_scale`, `current_meter_offset`)
- [ ] Set battery capacity (`battery_capacity`)
- [ ] Configure power limits to protect your battery (optional)
- [ ] Add battery OSD elements for monitoring

## Battery Voltage Monitoring

### Setup

1. **Enable voltage monitoring**:
   ```
   feature VBAT
   ```

2. **Calibrate voltage** - Measure your battery voltage with a multimeter, then adjust:
   ```
   set vbat_scale = 1100    # Adjust until FC matches multimeter reading
   ```

3. **Configure cell voltages** (in 0.01V units):
   ```
   set vbat_max_cell_voltage = 420      # 4.20V - fully charged (LiPo)
   set vbat_warning_cell_voltage = 350  # 3.50V - warning alarm
   set vbat_min_cell_voltage = 330      # 3.30V - critical alarm
   ```

INAV will auto-detect the number of cells when you plug in the battery.

### Sag Compensation

Battery voltage drops under load (sag). INAV can calculate the unloaded voltage:

```
set bat_voltage_source = SAG_COMP    # Use sag-compensated voltage (recommended)
# or
set bat_voltage_source = RAW         # Use raw measured voltage
```

Sag compensation provides more stable readings for alarms and telemetry.

## Current Monitoring

### Hardware Current Sensor

1. **Enable current monitoring**:
   ```
   feature CURRENT_METER
   set current_meter_type = ADC
   ```

2. **Calibrate** - Use a multimeter in series or check against charger data:
   ```
   set current_meter_scale = 400    # Adjust for your sensor
   set current_meter_offset = 0     # Offset at zero current
   ```

### Virtual Current Sensor

If you don't have a hardware sensor, INAV can estimate current from throttle:

```
set current_meter_type = VIRTUAL
set current_meter_scale = 200       # Calibrate based on actual mAh usage
set current_meter_offset = 100      # Current when disarmed
```

**Calibration method**: Fly a battery, note INAV's reported mAh, charge the battery noting actual mAh, then:
```
new_scale = (reported_mAh / actual_mAh) * old_scale
```

## Battery Capacity Monitoring

Track remaining capacity in mAh or mWh:

```
set battery_capacity_unit = MAH          # or MWH for energy
set battery_capacity = 2200              # Your battery capacity in mAh
set battery_capacity_warning = 660       # Warning at 30% (660mAh left)
set battery_capacity_critical = 440      # Critical at 20% (440mAh left)
```

The OSD battery gauge will show remaining capacity. The battery must be full when plugged in (>= 4.1V per cell for LiPo).

## Power Limiting (Protect Your Battery!)

Automatically limit throttle to protect your from over-current.

### Why Use It?

- Prevents exceeding battery C-rating
- Avoids damaging voltage sag
- Extends battery life
- Prevents ESC overheating
- Meets power-limited racing class rules

### How It Works

Power limiting uses "continuous" and "burst" limits:
- **Burst**: High power allowed for short time (punch-outs, climbs)
- **Continuous**: Sustained power limit for normal flight

When you exceed continuous, you use "burst reserve". When reserve runs out, throttle reduces smoothly back to continuous limit.

### Basic Setup

**Example**: Protect a 1500mAh 4S 50C battery (75A burst, 50A continuous):

```
battery_profile 1

set limit_cont_current = 500         # 50A continuous (500 deci-amps)
set limit_burst_current = 750        # 75A burst
set limit_burst_current_time = 100   # 10 seconds burst (100 deci-seconds)
set limit_burst_current_falldown_time = 20   # 2s smooth ramp-down
```

**Calculate your limits**:
```
Continuous limit (dA) = battery_mAh × continuous_C_rating / 100
Burst limit (dA) = battery_mAh × burst_C_rating / 100
```

Example for 1500mAh 50C/75C battery:
```
Continuous = 1500 × 50 / 100 = 750 dA = 75A (but use 500 = 50A for safety margin)
Burst = 1500 × 75 / 100 = 1125 dA = 112.5A (use 750 = 75A for safety margin)
```

### Power Limiting (Alternative to Current)

Limit by watts instead of amps (useful for racing classes):

```
set limit_cont_power = 8000          # 800W continuous (8000 deci-watts)
set limit_burst_power = 10000        # 1000W burst
set limit_burst_power_time = 50      # 5 seconds
```

You can use both current AND power limits together - the most restrictive applies.

### Monitoring Power Limits

Add these OSD elements to see limiting in action:

- **Remaining Burst Time**: Shows how much burst reserve is left
- **Active Current Limit**: Shows current limit (blinks when limiting)
- **Active Power Limit**: Shows power limit (blinks when limiting)

When you see blinking, the system is actively reducing throttle to protect your battery!

### Disable Power Limiting

```
set limit_cont_current = 0     # Disables current limiting
set limit_cont_power = 0       # Disables power limiting
```

## Battery Profiles

INAV supports up to 3 battery profiles. Use different profiles for different batteries:

```
battery_profile 1
set bat_cells = 3
set battery_capacity = 2200
set limit_cont_current = 500

battery_profile 2
set bat_cells = 4
set battery_capacity = 1500
set limit_cont_current = 600
```

**Switch profiles**:
- In Configurator GUI (Battery tab)
- Via OSD menu
- CLI command: `battery_profile 1`
- Stick commands (see [Controls](Controls.md))

**Auto-switching**: Enable `BAT_PROF_AUTOSWITCH` feature to auto-select based on cell count:
```
feature BAT_PROF_AUTOSWITCH
```

## Configurator Setup

### Configuration Tab → Battery Section

1. **Voltage**: Enable voltage monitoring, set scale and cell voltages
2. **Current**: Select sensor type (None/ADC/Virtual), calibrate
3. **Capacity**: Set capacity and warning/critical thresholds
4. **Power Limits**: Configure current/power limits (continuous and burst)
5. **Battery Profiles**: Create profiles for different batteries

## Common Issues

**OSD shows "NF" (Not Full)**:
- Battery isn't considered full on plugin (< 4.1V/cell for LiPo)
- Charge battery fully or reduce `vbat_max_cell_voltage - 140mV` threshold

**Capacity drains too fast**:
- Calibrate current sensor using charger method
- Check for interference affecting current readings

**Power limiting too aggressive**:
- Reduce `limit_pi_p` and `limit_pi_i` in advanced settings
- Increase continuous limit if battery can handle it

**Power limiting causes oscillation**:
- Decrease `limit_pi_p` for smoother response
- Increase `limit_attn_filter_cutoff` to reduce noise

## Advanced Features

### Throttle Compensation (THR_VBAT_COMP)

Maintains constant thrust as battery voltage drops:
```
feature THR_VBAT_COMP
set thr_comp_weight = 1.0
```

### Remaining Flight Time (Fixed Wing)

Estimates time/distance until RTH needed (requires GPS, current sensor, capacity in mWh):
```
set battery_capacity_unit = MWH
set idle_power = 50       # Power at zero throttle (5.0W)
set cruise_power = 1200   # Power at cruise throttle (120W)
```

## Quick Reference

| Feature | CLI Command | Configurator Tab |
|---------|-------------|------------------|
| Voltage monitoring | `feature VBAT` | Configuration → Battery |
| Current sensor | `feature CURRENT_METER` | Configuration → Battery |
| Auto battery switching | `feature BAT_PROF_AUTOSWITCH` | Configuration → Battery |
| Throttle compensation | `feature THR_VBAT_COMP` | Configuration → Battery |

## See Also

- [Official Battery Documentation](https://github.com/iNavFlight/inav/blob/master/docs/Battery.md) - Complete technical reference
- [OSD Configuration](OSD.md) - Add battery elements to OSD
- [Controls](Controls.md) - Stick commands for battery profiles
- [Settings Reference](https://github.com/iNavFlight/inav/blob/master/docs/Settings.md) - All battery-related settings

## Tips

1. **Always calibrate** voltage and current sensors with real measurements
2. **Start conservative** with power limits, increase gradually
3. **Use mWh** for capacity if you want accurate flight time estimates
4. **Monitor in flight** using OSD elements to verify settings
5. **Set limits to protect**, not restrict - 80-90% of max spec is good practice
6. **Test on bench** before flying with new power limit settings

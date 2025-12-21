# INAV JavaScript Programming

The INAV Configurator includes a JavaScript transpiler that allows you to program flight controller logic conditions using JavaScript instead of raw logic condition commands. This provides a modern development experience with IntelliSense, syntax highlighting, and real-time validation.

## 📚 Table of Contents

- [Quick Start](#quick-start)
- [Features](#features)
- [Programming Patterns](#programming-patterns)
- [Supported Operations](#supported-operations)
- [Common Questions](#common-questions)
- [Examples](#examples)

---

## Quick Start

The JavaScript transpiler converts JavaScript code into INAV logic conditions, enabling you to program flight controller behavior using familiar JavaScript syntax.

### Modern Development Experience

<img width="843" height="222" alt="javascript_programming_intellisense" src="https://github.com/user-attachments/assets/efb31ba4-33db-4114-9344-f5201de4e025" />

*Real-time autocomplete with type information and documentation*


<img width="633" height="552" alt="javascript_programming_warnings" src="https://github.com/user-attachments/assets/b8fec9e5-9f95-4e07-a306-3eb88805ab6e" />


*Clear error messages with line numbers and suggestions*

### Basic Example

```javascript

// Increase VTX power when far from home
if (inav.flight.homeDistance > 500) {
  inav.override.vtx.power = 4;
}


```


<img width="1190" height="844" alt="javascript_programming_vtx_example" src="https://github.com/user-attachments/assets/b081edc7-a489-4fa0-91b0-e88ab216297c" />

*Complete example showing VTX power control based on distance*

---

## Features

### Bidirectional Translation

- **Transpiler**: JavaScript → INAV Logic Conditions
- **Decompiler**: INAV Logic Conditions → JavaScript
- **Round-trip capable**: Code survives transpile/decompile cycles

### Development Experience

- **Monaco Editor**: Full-featured code editor with syntax highlighting
- **IntelliSense**: Context-aware autocomplete with documentation
- **Real-time Validation**: Immediate feedback on syntax errors
- **Error Messages**: Clear, actionable messages with line numbers

### Language Support

**All INAV Operations Supported:**
- Arithmetic operations (`+`, `-`, `*`, `/`, `%`)
- Comparison and logical operations (`>`, `<`, `===`, `&&`, `||`, `!`)
- Math functions (`Math.min()`, `Math.max()`, `Math.sin()`, `Math.cos()`, `Math.tan()`, `Math.abs()`)
- Flow control (`inav.events.edge()`, `inav.events.sticky()`, `inav.events.delay()`, `inav.events.timer()`, `inav.events.whenChanged()`)
- Variable management (`inav.gvar[0-7]`, `let`, `var`)
- RC channel access and state detection (`inav.rc[n].value`, `inav.rc[n].low`, `inav.rc[n].mid`, `inav.rc[n].high`)
- Flight parameter overrides (`inav.override.vtx.*`, `inav.override.throttle`, etc.)
- Flight mode detection (`inav.flight.mode.poshold`, `inav.flight.mode.rth`, etc.)
- PID controller outputs (`inav.pid[0-3].output`)
- Waypoint navigation

**JavaScript Features:**
- `let` variables: variables with a lifetime of that loop only
- `var` variables: allocated to global variables for long lifetime
- Arrow functions: `() => condition`
- Object property access: `inav.flight.altitude`, `inav.rc[1].value`

---

## Programming Patterns

### Continuous Conditions (if statements)

Use `if` statements for conditions that check and execute **every cycle**:

```javascript

// Checks every cycle - adjusts VTX power continuously
if (inav.flight.homeDistance > 100) {
  inav.override.vtx.power = 3;
}


```

**Use when:** You want the action to happen continuously while the condition is true.

### One-Time Execution (edge)

Use `edge()` for actions that should execute **only once** when a condition becomes true:

```javascript

// Executes ONCE when armTimer reaches 1000ms
inav.events.edge(() => inav.flight.armTimer > 1000, { duration: 0 }, () => {
  inav.gvar[0] = inav.flight.yaw;  // Save initial heading
  inav.gvar[1] = 0;           // Initialize counter
});


```

**Parameters:**
- **condition**: Function returning boolean
- **duration**: Minimum duration in ms (0 = instant, >0 = debounce)
- **action**: Function to execute once

**Use when:**
- Initializing on arm
- Detecting events (first time RSSI drops)
- Counting discrete occurrences
- Debouncing noisy signals

### Latching Conditions (sticky)

Use `sticky()` for conditions that latch ON and stay ON until reset.

**Option 1: Variable assignment syntax** (recommended when you need to reference the latch state):

```javascript

// Create a latch that turns ON when RSSI < 30, OFF when RSSI > 70
var rssiWarning = inav.events.sticky({
  on: () => inav.flight.rssi < 30,
  off: () => inav.flight.rssi > 70
});

// Use the latch variable to control actions
if (rssiWarning) {
  inav.override.vtx.power = 4;  // Max power while latched
}


```

The latch variable can be referenced multiple times:

```javascript

var lowBatteryLatch = inav.events.sticky({
  on: () => inav.flight.cellVoltage < 330,
  off: () => inav.flight.cellVoltage > 350
});

// Use the latch variable to control multiple actions
if (lowBatteryLatch) {
  inav.override.throttleScale = 50;
  inav.gvar[0] = 1;  // Warning flag
}


```

**Option 2: Callback syntax** (simpler when actions are self-contained):

```javascript

// Latch ON when RSSI < 30, OFF when RSSI > 70
inav.events.sticky(
  () => inav.flight.rssi < 30,  // ON condition
  () => inav.flight.rssi > 70,  // OFF condition
  () => {
    inav.override.vtx.power = 4;  // Executes while latched
  }
);


```

**Use when:**
- Warning states that need manual reset
- Hysteresis/deadband behavior
- Failsafe conditions

### Delayed Execution (delay)

Use `delay()` to execute after a condition has been true for a duration:

```javascript

// Executes only if RSSI < 30 for 2 seconds continuously
inav.events.delay(() => inav.flight.rssi < 30, { duration: 2000 }, () => {
  inav.gvar[0] = 1;  // Set failsafe flag
});


```

**Use when:**
- Avoiding false triggers
- Requiring sustained conditions
- Timeouts and delays

### Periodic Timer (timer)

Use `timer()` for actions that toggle ON and OFF periodically:

```javascript

// Toggle inav.gvar[0] every second: ON for 1000ms, OFF for 1000ms
inav.events.timer(1000, 1000, () => {
  inav.gvar[0] = 1;  // Active during ON phase
});


```

**Use when:**
- Blinking indicators
- Periodic sampling
- Timed sequences

### Change Detection (whenChanged)

Use `whenChanged()` to detect when a value changes by a threshold:

```javascript

// Trigger when altitude changes by >= 10m within 100ms
inav.events.whenChanged(inav.flight.altitude, 10, () => {
  inav.gvar[0] = inav.gvar[0] + 1;  // Count altitude changes
});


```

**Use when:**
- Detecting significant value changes
- Monitoring sensor variations
- Change-based triggers

---

## Supported Operations

### Arithmetic
- `+`, `-`, `*`, `/`, `%` (modulus)

### Comparisons
- `===`, `>`, `<` (standard comparisons)
- `inav.helpers.approxEqual(a, b, tolerance)` - approximate equality with tolerance

### Logical
- `&&`, `||`, `!` (standard logical operators)
- `inav.helpers.xor(a, b)` - exclusive OR
- `inav.helpers.nand(a, b)` - NOT AND
- `inav.helpers.nor(a, b)` - NOT OR

### Math Functions
- `Math.min(a, b)` - minimum of two values
- `Math.max(a, b)` - maximum of two values
- `Math.sin(degrees)` - sine (takes degrees, not radians)
- `Math.cos(degrees)` - cosine (takes degrees)
- `Math.tan(degrees)` - tangent (takes degrees)
- `Math.abs(x)` - absolute value

### Scaling Functions
- `inav.helpers.mapInput(value, maxValue)` - scales from [0:maxValue] to [0:1000]
- `inav.helpers.mapOutput(value, maxValue)` - scales from [0:1000] to [0:maxValue]

Example:
```javascript
// Scale RC throttle (1000-2000) to normalized (0-1000)
const normalized = inav.helpers.mapInput(inav.rc[3].value - 1000, 1000);

// Scale normalized (0-1000) to servo angle (0-180)
const servoAngle = inav.helpers.mapOutput(normalized, 180);


```

### RC Channel Access

```javascript
// RC channel value (1000-2000us)
if (inav.rc[1].value > 1500) {
  inav.gvar[0] = 1;
}

// RC channel state detection
if (inav.rc[1].low) {      // < 1333us
  inav.gvar[1] = 1;
}
if (inav.rc[1].mid) {      // 1333-1666us
  inav.gvar[2] = 1;
}
if (inav.rc[1].high) {     // > 1666us
  inav.gvar[3] = 1;
}


```

### Variables

#### Global Variables (gvar)

Runtime state that persists across logic condition evaluations:

```javascript
// Global variables (runtime state, 8 slots)
inav.gvar[0] = 100;
inav.gvar[1] = inav.gvar[1] + 1;  // Counter


```

#### Let/Const Variables

Compile-time named expressions that make code more readable:

```javascript

// Define reusable calculations with meaningful names
let distanceThreshold = 500;
let altitudeLimit = 100;
let combinedCheck = inav.flight.homeDistance > distanceThreshold && inav.flight.altitude > altitudeLimit;

if (combinedCheck) {
  inav.override.vtx.power = 4;
}


```

**Benefits:**
- Makes code self-documenting with meaningful names
- Compiler automatically optimizes duplicate expressions
- Variable names preserve through compile/decompile cycles

**Important:** `let`/`const` are **compile-time substituted**, not runtime variables. For runtime state, use `gvar[]`.

#### Var Variables

Allocated to gvar slots automatically:

```javascript
// Var variables (allocated to gvar slots)
var counter = 0;
counter = counter + 1;


```


**Note:** Variable *names* are stored in Configurator. Loading from FC to a different computer will use default names.
Save your scripts in a text editor when upgrading INAV or switching computers.

Variables can also be renamed by right-click on the variable.


#### Ternary Operator

Conditional value assignment in a single expression:

```javascript

// Choose value based on condition
let throttleLimit = inav.flight.cellVoltage < 330 ? 25 : 50;

if (inav.flight.cellVoltage < 350) {
  inav.override.throttleScale = throttleLimit;
}

// Inline ternary
inav.override.vtx.power = inav.flight.homeDistance > 500 ? 4 : 2;

// Nested ternary for multiple conditions
let powerLevel = inav.flight.rssi < 30 ? 4 :
                 inav.flight.rssi < 50 ? 3 :
                 inav.flight.rssi < 70 ? 2 : 1;


```

### Flight Parameter Overrides

```javascript

// VTX control
inav.override.vtx.power = 4;      // Power level (0-4)
inav.override.vtx.band = 5;       // Band (0-5)
inav.override.vtx.channel = 7;    // Channel (0-8)

// Throttle control
inav.override.throttle = 1500;         // Direct throttle (1000-2000)
inav.override.throttleScale = 75;      // Scale percentage (0-100)

// Arming safety
inav.override.armSafety = 1;           // Override arming checks


```

### Flight Mode Detection

Check which flight modes are currently active:

```javascript

// Check specific flight modes
if (inav.flight.mode.poshold === 1) {
  inav.gvar[0] = 1;  // Flag: in position hold
}

if (inav.flight.mode.rth === 1) {
  inav.override.vtx.power = 4;  // Max power during RTH
}

if (inav.flight.mode.failsafe === 1) {
  inav.gvar[7] = 1;  // Emergency flag
}


```

**Available flight modes:**
- `flight.mode.failsafe` - Failsafe mode
- `flight.mode.manual` - Manual/passthrough mode
- `flight.mode.rth` - Return to home
- `flight.mode.poshold` - Position hold
- `flight.mode.cruise` - Cruise mode
- `flight.mode.althold` - Altitude hold
- `flight.mode.angle` - Angle/self-level mode
- `flight.mode.horizon` - Horizon mode
- `flight.mode.air` - Air mode
- `flight.mode.acro` - Acro mode
- `flight.mode.courseHold` - Course hold
- `flight.mode.waypointMission` - Waypoint mission active
- `flight.mode.user1` through `flight.mode.user4` - User-defined modes

### PID Controller Outputs

INAV has 4 programming PID controllers (configured in the Programming PID tab). You can read their output values in JavaScript:

```javascript

// Read PID controller outputs
if (inav.pid[0].output > 500) {
  inav.override.throttle = 1600;
}

// Store PID output for OSD display
inav.gvar[0] = inav.pid[0].output;

// Combine multiple PID outputs
inav.gvar[1] = inav.pid[0].output + inav.pid[1].output;


```

**PID controllers:**
- `pid[0].output` through `pid[3].output` - Output values from the 4 programming PID controllers

Note: PID controller parameters (setpoint, measurement, gains) are configured in the Programming PID tab, not in JavaScript. The JavaScript code can only read the output values.

---

## Common Questions

**Q: Which pattern should I use?**
- Use `if` for continuous control (checking every cycle)
- Use `edge()` for one-time actions when condition becomes true
- Use `sticky()` for latching conditions with hysteresis
- Use `delay()` for actions that need sustained conditions
- Use `timer()` for periodic toggling
- Use `whenChanged()` for detecting value changes

**Q: How do I debug my code?**

Use global variables to track state:
```javascript

// Initialize debug counter
inav.events.edge(() => inav.flight.armTimer > 1000, { duration: 0 }, () => {
  inav.gvar[7] = 0; // Use inav.gvar[7] as debug counter
});

// Increment on each event
inav.events.edge(() => inav.flight.rssi < 30, { duration: 0 }, () => {
  inav.gvar[7] = inav.gvar[7] + 1;
});

// Check inav.gvar[7] value in OSD or Configurator


```

**Q: What's the difference between let and var?**
- `let` the variable goes away after each loop (implemented via compile-time expression substitution)
- `var` variables are allocated to gvar slots (keep their values between loops)

**Q: How many global variables can I use?**

INAV has 8 global variables: `gvar[0]` through `gvar[7]`. Each can store values from -1,000,000 to 1,000,000.

**Q: Can I use regular JavaScript functions?**

specific INAV functions are supported (`edge()`, `sticky()`, `delay()`, `timer()`, `whenChanged()`, and Math functions). The transpiler converts JavaScript to INAV logic conditions, which have specific supported operations.

---

## Examples

### Initialize Variables on Arm

```javascript

inav.events.edge(() => inav.flight.armTimer > 1000, { duration: 0 }, () => {
  inav.gvar[0] = 0;              // Reset counter
  inav.gvar[1] = inav.flight.yaw;     // Save heading
  inav.gvar[2] = inav.flight.altitude; // Save starting altitude
});


```

### Count Events

```javascript

// Initialize counter on arm
inav.events.edge(() => inav.flight.armTimer > 1000, { duration: 0 }, () => {
  inav.gvar[0] = 0;
});

// Count each time RSSI drops below 30
inav.events.edge(() => inav.flight.rssi < 30, { duration: 100 }, () => {
  inav.gvar[0] = inav.gvar[0] + 1;
});


```

### VTX Power Based on Distance

![RC Override Example]<img width="892" height="580" alt="javascript_programming_rc_example" src="https://github.com/user-attachments/assets/bd8af129-85a3-46e8-a8fc-b26db00febfa" />



```javascript

// Far away - maximum power
if (inav.flight.homeDistance > 500) {
  inav.override.vtx.power = 4;
}

// Medium distance
if (inav.flight.homeDistance > 200 && inav.flight.homeDistance <= 500) {
  inav.override.vtx.power = 3;
}

// Close to home - reduce power
if (inav.flight.homeDistance <= 200) {
  inav.override.vtx.power = 2;
}


```

### Low Voltage Warning with Hysteresis

```javascript

// Latch warning at 3.3V/cell, clear at 3.5V/cell
var lowVoltageWarning = inav.events.sticky({
  on: () => inav.flight.cellVoltage < 330,   // Warning threshold
  off: () => inav.flight.cellVoltage > 350   // Recovery threshold
});

if (lowVoltageWarning) {
  inav.override.throttleScale = 50;   // Reduce throttle
  inav.gvar[0] = 1;                   // Warning flag
}


```

### Debounce Noisy Signal

```javascript

// Only trigger if RSSI < 30 for at least 500ms
inav.events.edge(() => inav.flight.rssi < 30, { duration: 500 }, () => {
  inav.override.vtx.power = 4;
});


```

### Stick Combination Detection

```javascript

// Detect specific stick position combination
if (inav.rc[1].low && inav.rc[2].mid && inav.rc[3].high) {
  inav.gvar[0] = 1;  // Special mode activated
}


```

---

## Available Objects

The INAV JavaScript API is accessed through the `inav` namespace:

**Flight Data:**
- `inav.flight.*` - Flight telemetry (altitude, speed, GPS, battery, etc.)
- `inav.flight.mode.*` - Active flight modes (poshold, rth, althold, etc.)

**Control & Override:**
- `inav.override.*` - Override flight parameters (VTX, throttle, arming)
- `inav.rc[1-18].*` - RC channels (.value, .low, .mid, .high)

**Variables:**
- `inav.gvar[0-7]` - Global variables (persistent state)

**Navigation & Control:**
- `inav.waypoint.*` - Waypoint navigation info
- `inav.pid[0-3].*` - Programming PID controller outputs

**Event Handlers:**
- `inav.events.edge()` - Edge detection (executes once on condition change)
- `inav.events.sticky()` - Latching condition (hysteresis)
- `inav.events.delay()` - Delayed execution
- `inav.events.timer()` - Periodic timer
- `inav.events.whenChanged()` - Change detection

**Helper Functions:**
- `inav.helpers.xor()`, `inav.helpers.nand()`, `inav.helpers.nor()` - Logical operations
- `inav.helpers.approxEqual()` - Approximate comparison
- `inav.helpers.mapInput()`, `inav.helpers.mapOutput()` - Scaling functions

---

## Tips

1. **Initialize variables on arm** using `inav.events.edge()` with `inav.flight.armTimer > 1000`
2. **Use gvars for state** - they persist between logic condition evaluations
3. **edge() duration = 0** means instant trigger on condition becoming true
4. **edge() duration > 0** adds debounce time
5. **if statements are continuous** - they execute every cycle
6. **sticky() provides hysteresis** - prevents rapid ON/OFF switching
7. **All trig functions take degrees**, not radians
8. **RC channels**: 1-18 (18 channels total, use `inav.rc[1]` through `inav.rc[18]`)
9. **Global variables**: -1,000,000 to 1,000,000 range (use `inav.gvar[0]` through `inav.gvar[7]`)

---

## Version History

**INAV 9.0**: JavaScript programming introduced
- All INAV logic condition operations supported
- RC channel state detection (LOW/MID/HIGH)
- XOR/NAND/NOR logical operations
- Approximate equality with tolerance
- MAP_INPUT/MAP_OUTPUT scaling functions
- Timer and change detection functions
- Flight mode detection (`flight.mode.poshold`, `flight.mode.rth`, etc.)
- PID controller output access (`pid[0-3].output`)
- Named parameter syntax for sticky with variable assignment
- IntelliSense and real-time validation

---

**Related Pages:**
- [Programming Tab](Programming-tab.md) - How to use the Programming tab
- [Logic Conditions](Logic-Conditions.md) - Traditional logic condition programming

**Last Updated**: 2025-12-10

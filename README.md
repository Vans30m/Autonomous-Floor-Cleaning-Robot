# Autonomous Floor-Cleaning Rover

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Arduino](https://img.shields.io/badge/Platform-Arduino-blue.svg)](https://www.arduino.cc/)
[![Status: Active](https://img.shields.io/badge/Status-Active-brightgreen.svg)]()

> An open-source, Arduino-powered smart cleaning robot featuring triple-sensor spatial awareness, a timer-based spatial bypass algorithm, and Bluetooth manual override. 

## Project Overview

The **Autonomous Floor-Cleaning Rover** is a versatile robotics project designed to maintain hard floor surfaces. Moving beyond simple "bump-and-turn" mechanics, this robot utilizes a 3-point ultrasonic array to detect walls and obstacles, executing a calculated 90-degree side-step maneuver to bypass obstructions while maintaining its original heading. 

When autonomous mode isn't enough, the integrated HC-05 module allows seamless transition to manual control via any standard Bluetooth serial application. 

### Key Features
* **Dual-Mode Operation:** Switch instantly between Autonomous navigation and Manual Bluetooth control.
* **Smart Bypass Maneuver:** Replaces chaotic 180-degree spins with a calculated 90-degree side-step to navigate around obstacles.
* **Independent Mop Control:** Dedicated low-side NPN switching circuit for the cleaning/mop motor.
* **Real-time Sensor Polling:** Non-blocking code architecture ensures rapid response to dynamic environments without freezing the main control loop.

---

## Hardware Architecture

### Components Required
* **Microcontroller:** Arduino Nano (ATmega328P)
* **Motor Driver:** L298N Dual H-Bridge
* **Drive System:** 2x DC Geared Motors + Wheels
* **Cleaning System:** 1x DC Mop/Brush Motor
* **Sensors:** 3x HC-SR04 Ultrasonic Sensors (Left, Center, Right)
* **Connectivity:** HC-05 or HC-06 Bluetooth Module
* **Power Supply:** 2x 18650 Li-ion Batteries (7.4V total)
* **Switching:** 1x NPN Transistor (e.g., TIP120) + 1x Flyback Diode (1N4007) + 1kΩ Resistor

### The NPN Mop Switching Circuit
Because the Arduino Nano cannot supply the necessary current to drive the mop motor, we utilize an NPN transistor as a low-side switch:
1.  **Base:** Connected to Arduino `D5` via a 1kΩ resistor.
2.  **Collector:** Connected to the Negative (-) terminal of the mop motor.
3.  **Emitter:** Connected to the common ground rail.
4.  *Safety Note:* A flyback diode is placed in parallel across the mop motor terminals (silver stripe facing the positive wire) to protect the transistor from inductive voltage spikes.

---

## Master Pinout Reference

| Component | Pin / Wire | Arduino Nano Pin | Notes |
| :--- | :--- | :--- | :--- |
| **L298N Driver** | ENA (Right Speed) | `D6` (PWM) | Must be a PWM capable pin |
| | IN1 & IN2 (Right Dir) | `D7`, `D8` | |
| | ENB (Left Speed) | `D9` (PWM) | Must be a PWM capable pin |
| | IN3 & IN4 (Left Dir) | `D12`, `D13` | |
| **HC-05 Bluetooth**| TXD | `D10` (RX) | Configured via `SoftwareSerial` |
| | RXD | `D11` (TX) | Configured via `SoftwareSerial` |
| **Left HC-SR04** | TRIG / ECHO | `A0` / `D2` | |
| **Center HC-SR04** | TRIG / ECHO | `A1` / `D3` | |
| **Right HC-SR04**| TRIG / ECHO | `A2` / `D4` | |
| **Mop Motor** | NPN Transistor Base| `D5` (PWM) | Variable speed control |

* **CRITICAL:** Ensure the Arduino, L298N, Bluetooth module, and all sensors share a common Ground (GND) connection.*

---

## Software Setup & Installation

### 1. Prerequisites
* [Arduino IDE](https://www.arduino.cc/en/software) (v1.8.x or v2.x)

### 2. Required Libraries
This project relies on built-in Arduino libraries. Ensure the following are included at the top of your sketch:
```cpp
#include <SoftwareSerial.h>
```
## Prototype and Circuit Images
<div align="center" style="margin: 10px 0; padding: 10px 0;" > <strong>Block Diagram</strong><br>
<img src="Images%20and%20Videos/Block_Diagram.png" alt="Project Block Diagram" width="100%"><br><br>

<div align="center" style="margin: 10px 0; padding: 10px 0;" > <strong>Circuit Diagram</strong><br>
<img src="Images%20and%20Videos/CLEANING%20ROBOT%20(Circuit%20Diagram%20LABLED).png" alt="Circuit Diagram" width="100%"><br><br>

<div align="center" style="margin: 10px 0; padding: 10px 0;" > <strong>In Real</strong><br>
<img src="Images%20and%20Videos/Autonomous-Floor-Cleaning-Robot.jpeg" alt="Real Image" width="25%" style="margin: 10px" ><br><br>

---

## Final Video

<video width="100%" controls>
  <source src="https://github.com/Vans30m/Autonomous-Floor-Cleaning-Robot/raw/refs/heads/main/Images%20and%20Videos/Video%20with%20voiceover.mp4" type="video/mp4">
</video>

## Author  

**Vansh Thakur**  
B.Tech CSE (Core)  
Chitkara University, Punjab  

---

## License  

This project is open‑source and can be used for learning and experimentation. Add a formal license (e.g., MIT) as `LICENSE` in the repository if required.

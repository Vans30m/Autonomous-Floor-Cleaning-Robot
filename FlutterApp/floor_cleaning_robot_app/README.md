# Floor Cleaning Robot Controller

A high-tech, futuristic Flutter application designed to control a custom floor cleaning robot via Bluetooth. The app features a professional glassmorphism dark theme, interactive animations, and a rich set of controls for driving, automation, and mopping operations.

## Features

- **Bluetooth Serial Connectivity**: Seamlessly connect and disconnect from paired Bluetooth devices (e.g., ESP32, HC-05).
- **Glassmorphism UI**: Beautiful, immersive dark interface with animated glowing buttons and satisfying tactile feedback.
- **Directional Control (D-Pad)**: Send continuous driving commands (Forward, Backward, Left, Right) while holding, and a pause command when released.
- **Autopilot Controls**: Engage autonomous cleaning routines or override them manually.
- **Mop Turbine Speed**: Adjust the mopping turbine speed in stages (Off, 25%, 50%, 75%, MAX).
- **Thrust Limiter**: Set speed limits for manual driving (25%, 50%, 75%, 100%).

## Command Reference (Bluetooth via UART)

The app sends simple ASCII characters to the connected robot based on the button pushed. You can program your microcontroller (Arduino, ESP32, Pi Pico) to react to these specific characters sent via Bluetooth:

| Button Name (Arduino Code) | Action |
| :--- | :--- |
| `Forward (F)` | Drive Forward (hold) |
| `Backward (B)` | Drive Backward (hold) |
| `Left (L)` | Turn Left (hold) |
| `Right (R)` | Turn Right (hold) |
| `Release (P)` | Pause/Stop (sent on button release) |
| `Engage (A)` | Autopilot Engage |
| `Override (M)` | Autopilot Override |
| `OFF (G)` | Mop Turbine OFF |
| `25% (H)` | Mop Turbine 25% |
| `50% (I)` | Mop Turbine 50% |
| `75% (J)` | Mop Turbine 75% |
| `MAX (K)` | Mop Turbine MAX |
| `25% (S)` | Speed Thrust 25% |
| `50% (T)` | Speed Thrust 50% |
| `75% (C)` | Speed Thrust 75% |
| `100% (X)` | Speed Thrust 100% |

## Permissions Required
For Android devices, ensure that proximity and location permissions are granted for Bluetooth discovery and connection. The app handles runtime permission requests using the `permission_handler` package.

## Getting Started

1. **Clone the repository.**
2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the App:**
   ```bash
   flutter run
   ```

## Dependencies
- `flutter_bluetooth_serial`
- `permission_handler`

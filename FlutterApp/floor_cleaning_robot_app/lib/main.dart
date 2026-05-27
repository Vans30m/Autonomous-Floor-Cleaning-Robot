import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  // Hide the Android status bar for full-immersion gaming feel
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const RobotApp());
}

class RobotApp extends StatelessWidget {
  const RobotApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pro Robot Controller',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF090C10), // Deep Space Black
        colorScheme: const ColorScheme.dark(primary: Color(0xFF00E5FF)), // Neon Cyan
      ),
      home: const ControllerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({super.key});
  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  BluetoothConnection? connection;
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  void _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (statuses[Permission.bluetooth]!.isGranted &&
        statuses[Permission.location]!.isGranted) {
      _getDevices();
    }
  }

  void _getDevices() async {
    List<BluetoothDevice> pairedDevices = await FlutterBluetoothSerial.instance.getBondedDevices();
    setState(() => devices = pairedDevices);
  }

  void _connect() async {
    if (selectedDevice == null) return;
    try {
      connection = await BluetoothConnection.toAddress(selectedDevice!.address);
      setState(() => isConnected = true);
    } catch (e) {
      print('Cannot connect: $e');
    }
  }

  void _disconnect() {
    connection?.dispose();
    connection = null;
    setState(() => isConnected = false);
  }

  void _sendCommand(String command) {
    if (isConnected && connection != null) {
      connection!.output.add(ascii.encode(command));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // High-end dark radial gradient background
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Color(0xFF161B22), Color(0xFF0D1117), Color(0xFF010409)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- GLASSMORPHISM TOP BAR ---
              Container(
                margin: const EdgeInsets.only(top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bluetooth_connected,
                            color: isConnected ? const Color(0xFF00E5FF) : Colors.white38,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<BluetoothDevice>(
                              dropdownColor: const Color(0xFF161B22),
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
                              hint: const Text("SELECT DRONE", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              value: selectedDevice,
                              items: devices.map((device) {
                                return DropdownMenuItem(
                                  value: device,
                                  child: Text(device.name ?? "Unknown", style: const TextStyle(color: Colors.white, fontSize: 14)),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() => selectedDevice = value),
                            ),
                          ),
                          const SizedBox(width: 20),
                          _CyberConnectButton(
                            isConnected: isConnected,
                            onTap: isConnected ? _disconnect : _connect,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // --- MAIN DASHBOARD ---
              Expanded(
                child: Row(
                  children: [
                    // ZONE 1: Left Driving D-Pad (Animated Glow)
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _AnimatedHoldButton(icon: Icons.keyboard_double_arrow_up, command: "F", onSend: _sendCommand),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _AnimatedHoldButton(icon: Icons.keyboard_double_arrow_left, command: "L", onSend: _sendCommand),
                              const SizedBox(width: 70),
                              _AnimatedHoldButton(icon: Icons.keyboard_double_arrow_right, command: "R", onSend: _sendCommand),
                            ],
                          ),
                          _AnimatedHoldButton(icon: Icons.keyboard_double_arrow_down, command: "B", onSend: _sendCommand),
                        ],
                      ),
                    ),

                    // ZONE 2: Glass Center Console
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white.withOpacity(0.08)),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text("AUTOPILOT", style: TextStyle(letterSpacing: 3, color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _AnimatedClickButton(label: "ENGAGE", command: "A", color: const Color(0xFF7C4DFF), onSend: _sendCommand),
                                      const SizedBox(width: 15),
                                      _AnimatedClickButton(label: "OVERRIDE", command: "M", color: const Color(0xFFFF5252), onSend: _sendCommand),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 40),
                                    child: Divider(color: Colors.white10, thickness: 1),
                                  ),
                                  const Text("MOP TURBINE", style: TextStyle(letterSpacing: 3, color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900)),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _AnimatedClickButton(label: "OFF", command: "G", color: Colors.grey, onSend: _sendCommand),
                                      _AnimatedClickButton(label: "25%", command: "H", color: const Color(0xFF00B0FF), onSend: _sendCommand),
                                      _AnimatedClickButton(label: "50%", command: "I", color: const Color(0xFF00E5FF), onSend: _sendCommand),
                                      _AnimatedClickButton(label: "75%", command: "J", color: const Color(0xFF1DE9B6), onSend: _sendCommand),
                                      _AnimatedClickButton(label: "MAX", command: "K", color: const Color(0xFF00E676), onSend: _sendCommand),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ZONE 3: Right Speed Controls
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("THRUST LIMITER", style: TextStyle(letterSpacing: 3, color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 15),
                          _AnimatedClickButton(label: "50%", command: "T", color: const Color(0xFF8C9EFF), onSend: _sendCommand, icon: Icons.change_history),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _AnimatedClickButton(label: "25%", command: "S", color: const Color(0xFF8C9EFF), onSend: _sendCommand, icon: Icons.crop_square),
                              const SizedBox(width: 15),
                              _AnimatedClickButton(label: "75%", command: "C", color: const Color(0xFF8C9EFF), onSend: _sendCommand, icon: Icons.circle_outlined),
                            ],
                          ),
                          _AnimatedClickButton(label: "100%", command: "X", color: const Color(0xFF8C9EFF), onSend: _sendCommand, icon: Icons.close),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// CUSTOM PROFESSIONAL WIDGETS (Animations & Physics)
// =====================================================================

class _AnimatedHoldButton extends StatefulWidget {
  final IconData icon;
  final String command;
  final Function(String) onSend;

  const _AnimatedHoldButton({required this.icon, required this.command, required this.onSend});

  @override
  State<_AnimatedHoldButton> createState() => _AnimatedHoldButtonState();
}

class _AnimatedHoldButtonState extends State<_AnimatedHoldButton> {
  bool _isPressed = false;
  Timer? _timer;

  void _startFire() {
    setState(() => _isPressed = true);
    widget.onSend(widget.command);
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) => widget.onSend(widget.command));
  }

  void _stopFire() {
    setState(() => _isPressed = false);
    _timer?.cancel();
    widget.onSend("P"); // Pause command
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startFire(),
      onTapUp: (_) => _stopFire(),
      onTapCancel: () => _stopFire(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.all(8),
        width: 75,
        height: 75,
        // The Scale Transformation (Makes it sink into the screen)
        transform: Matrix4.identity()..scale(_isPressed ? 0.90 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isPressed ? const Color(0xFF1F2937) : const Color(0xFF111827),
          shape: BoxShape.circle,
          // The Dynamic Glow Effect
          boxShadow: _isPressed
              ? [
                  BoxShadow(color: const Color(0xFF00E5FF).withOpacity(0.6), blurRadius: 20, spreadRadius: 2), // Neon Glow
                  const BoxShadow(color: Colors.black, blurRadius: 10, offset: Offset(2, 2)), // Inner depth
                ]
              : [
                  const BoxShadow(color: Colors.black87, offset: Offset(4, 4), blurRadius: 8), // Standard drop shadow
                  BoxShadow(color: Colors.white.withOpacity(0.05), offset: const Offset(-2, -2), blurRadius: 4), // Light rim
                ],
          border: Border.all(color: _isPressed ? const Color(0xFF00E5FF) : Colors.white12, width: _isPressed ? 2 : 1),
        ),
        child: Center(
          child: Icon(widget.icon, size: 40, color: _isPressed ? const Color(0xFF00E5FF) : Colors.white70),
        ),
      ),
    );
  }
}

class _AnimatedClickButton extends StatefulWidget {
  final String label;
  final String command;
  final Color color;
  final IconData? icon;
  final Function(String) onSend;

  const _AnimatedClickButton({required this.label, required this.command, required this.color, required this.onSend, this.icon});

  @override
  State<_AnimatedClickButton> createState() => _AnimatedClickButtonState();
}

class _AnimatedClickButtonState extends State<_AnimatedClickButton> {
  bool _isPressed = false;

  void _tap() {
    widget.onSend(widget.command);
    setState(() => _isPressed = true);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _isPressed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _tap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.identity()..scale(_isPressed ? 0.92 : 1.0),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: _isPressed ? widget.color.withOpacity(0.3) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _isPressed ? widget.color : widget.color.withOpacity(0.3), width: 1.5),
          boxShadow: _isPressed ? [BoxShadow(color: widget.color.withOpacity(0.5), blurRadius: 15)] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[Icon(widget.icon, size: 16, color: widget.color), const SizedBox(width: 6)],
            Text(widget.label, style: TextStyle(color: _isPressed ? Colors.white : widget.color, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}

class _CyberConnectButton extends StatelessWidget {
  final bool isConnected;
  final VoidCallback onTap;

  const _CyberConnectButton({required this.isConnected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isConnected 
                ? [const Color(0xFFFF5252), const Color(0xFFD50000)] // Red alert disconnect
                : [const Color(0xFF00E5FF), const Color(0xFF00B0FF)], // Cyber connect
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isConnected ? Colors.redAccent.withOpacity(0.4) : const Color(0xFF00E5FF).withOpacity(0.4),
              blurRadius: 10, spreadRadius: 1,
            )
          ],
        ),
        child: Text(
          isConnected ? "DISCONNECT" : "INITIALIZE",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 2),
        ),
      ),
    );
  }
}
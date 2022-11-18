import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Socket socket;

  bool isConnected = false;

  Future<void> connectToTheHardware() async {
    try {
      socket = await Socket.connect('192.168.178.39', 5000);
      debugPrint(
          'Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
      setState(() {
        isConnected = true;
      });
    } catch (error) {
      debugPrint("$error");
      setState(() {
        isConnected = false;
      });
    }
    debugPrint('isConnected = $isConnected');
  }

  Future<void> sendData(
      {required Socket socket, required String command}) async {
    try {
      debugPrint('new command: $command');
      socket.write(command);
    } on Exception catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("RaspberryPi Controller Client"),
          actions: [
            Icon(
              Icons.circle,
              color: isConnected ? Colors.green : Colors.red,
            )
          ],
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await sendData(socket: socket, command: "start");
            },
            child: const Text("Send Start Command"),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.online_prediction),
          onPressed: () async {
            await connectToTheHardware();
          },
        ),
      ),
    );
  }
}

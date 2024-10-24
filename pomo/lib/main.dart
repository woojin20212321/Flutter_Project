import 'package:flutter/material.dart';
import 'package:pomo/screens/login_screen.dart';
import 'package:pomo/screens/timer_screen.dart';

void main() {
  runApp(const Pomo());
}

class Pomo extends StatelessWidget {
  const Pomo({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[300],
        focusColor: Colors.greenAccent[400],
      ),
      home: TimerScreen(),
    );
  }
}

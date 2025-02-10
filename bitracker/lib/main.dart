import 'package:bitracker/screens/menu_screen.dart';
import 'package:bitracker/screens/track_screen.dart';
import 'package:bitracker/theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: appColorScheme(),
        useMaterial3: true,
      ),
      home: const Scaffold(body: TrackScreen()),
    );
  }
}

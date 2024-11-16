import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomo/provider/time_set.dart';
import 'package:pomo/screens/timer_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const Pomo(),
  );
}

Future<void> initServices() async {
  // Widget Binding 및 초기화
  WidgetsFlutterBinding.ensureInitialized();
  // 가로모드 방지
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class Pomo extends StatelessWidget {
  const Pomo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return TimeSet();
        })
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green[300],
          focusColor: Colors.greenAccent[400],
        ),
        home: TimerScreen(),
      ),
    );
  }
}

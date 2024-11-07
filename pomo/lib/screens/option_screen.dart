import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pomo/screens/timer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({
    super.key,
  });

  @override
  State<OptionScreen> createState() => _OptionScreenState();

  static _OptionScreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_OptionScreenState>();
}

class _OptionScreenState extends State<OptionScreen> {
  double currentValue = 1500.0;
  int time = 1500;
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.lightGreen[100],
          appBar: AppBar(
            backgroundColor: Colors.green[300],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('설정'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '타이머 설정',
                      style: TextStyle(
                        fontSize: 20.w,
                      ),
                    ),
                    SizedBox(),
                    Text('$time'),
                    SizedBox()
                  ],
                ),
                Slider(
                  value: currentValue,
                  max: 3600,
                  divisions: 60,
                  onChanged: (value) => setState(() {
                    currentValue = value;
                    time = currentValue.toInt();
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

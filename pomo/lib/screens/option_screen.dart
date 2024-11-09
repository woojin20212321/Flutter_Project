import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  double workTimeValue = 1500.0;
  double breakTimeValue = 300.0;
  int optionWorkTime = 25;
  int optionBreakTime = 5;
  late SharedPreferences prefs;

  void save() {}
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.lightGreen[100],
          appBar: AppBar(
            backgroundColor: Colors.green[300],
            actions: [
              IconButton(onPressed: save, icon: Icon(Icons.save_outlined))
            ],
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
                      '공부 타임 설정',
                      style: TextStyle(
                        fontSize: 20.w,
                      ),
                    ),
                    SizedBox(),
                    Text('$optionWorkTime'),
                    SizedBox()
                  ],
                ),
                Slider(
                  value: workTimeValue,
                  max: 7200,
                  divisions: 60,
                  onChanged: (value) => setState(() {
                    workTimeValue = value;
                    optionWorkTime = workTimeValue.toInt();
                    optionWorkTime = (optionWorkTime / 60).floor();
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '휴식 타임 설정',
                      style: TextStyle(
                        fontSize: 20.w,
                      ),
                    ),
                    SizedBox(),
                    Text('$optionBreakTime'),
                    SizedBox()
                  ],
                ),
                Slider(
                  value: breakTimeValue,
                  max: 3600,
                  divisions: 60,
                  onChanged: (value) => setState(() {
                    breakTimeValue = value;
                    optionBreakTime = breakTimeValue.toInt();
                    optionBreakTime = (optionBreakTime / 60).floor();
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

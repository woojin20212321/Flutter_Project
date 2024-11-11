import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomo/screens/menu_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pomo/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});
  // const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int totalSeconds = 1500;
  late Timer timer;
  bool isRunning = false;
  int totalPomodors = 0;
  AudioPlayer audioPlayer = AudioPlayer();
  bool worktime = true;
  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      audioPlayer.play(AssetSource('ring.mp3'));

      setState(() {
        totalPomodors = totalPomodors + 1;
        isRunning = false;
        breakTime();
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void breakTime() {
    totalSeconds = 300;
    worktime = false;
    if (totalSeconds == 0) {
      audioPlayer.play(AssetSource('ring.mp3'));
      setState(() {});
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
    setState(() {
      isRunning = true;
      worktime = true;
    });
  }

  void onpausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void reset() {
    timer.cancel();
    setState(() {
      isRunning = false;
      totalSeconds = 1500;
      totalPomodors = 0;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    print('$duration');
    return duration.toString().split(".").first.substring(2, 7);
  }

  void openMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MenuScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.lightGreen[200],
            appBar: AppBar(
              backgroundColor: Colors.green[300],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: openMenu,
                    icon: Icon(Icons.menu_rounded),
                    iconSize: 25.w.h,
                  ),
                  Icon(
                    Icons.access_time_rounded,
                    color: Colors.green[900],
                    size: 35.w,
                  ),
                  SizedBox(
                    width: 45.w,
                  ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                children: [
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Container(
                      width: 400.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            worktime ? 'worktime!' : 'breaktime',
                            style: TextStyle(
                              fontSize: 25.w,
                              fontWeight: FontWeight.w400,
                              color: Colors.green[400],
                            ),
                          ),
                          Text(
                            format(totalSeconds),
                            style: TextStyle(
                              color: Colors.green[400],
                              fontSize: 100.w,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Container(
                      width: 400.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Pomo',
                            style: TextStyle(
                                fontSize: 25.w,
                                fontWeight: FontWeight.w400,
                                color: Colors.green[400]),
                          ),
                          Text(
                            '$totalPomodors',
                            style: TextStyle(
                                fontSize: 100.w,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[400]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 60,
                          ),
                          IconButton(
                            onPressed:
                                isRunning ? onpausePressed : onStartPressed,
                            icon: Icon(
                              isRunning
                                  ? Icons.pause_circle_outlined
                                  : Icons.play_circle_outlined,
                              size: 50.w.h,
                              color: Colors.green[600],
                            ),
                          ),
                          IconButton(
                            onPressed: reset,
                            icon: Icon(
                              Icons.stop_circle_outlined,
                              size: 40.w,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;
  int totalSeconds = twentyFiveMinutes;
  late Timer timer;
  bool isRunning = false;
  int totalPomodors = 0;
  AudioPlayer audioPlayer = AudioPlayer();

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      audioPlayer.play(AssetSource('bark.mp3'));
      setState(() {
        totalPomodors = totalPomodors + 1;
        isRunning = false;
        totalSeconds = 1500;
      });
      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }
  /* onTick
     타이머가 0 이면 bark 사운드 재생
     setState 동작에 뽀모 횟수 1 추가, isRunning 상태를 false로 변경 (타이머가 0이 되면 라운드가 끝나기 때문에)
     타이머는 1500초로 다시 초기화
     타이머 끄기

     0이 아니라면
     타이머의 1초 마다 카운트 될때 setState 하여 UI의 타이머 값도 똑같이 1씩 감소
  */

  void onStartPressed() {
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
    setState(() {
      isRunning = true;
    });
  }

  /* 
     onStartPressed
     1초 단위로 카운트 되는 타이머 생성
     카운트 마다 isRunning에 true를 저장하는 동작을하는 setState 실행

  */

  void onpausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  /*
  onpausePressed
  타이머 취소
  isRunning false 
  */

  void reset() {
    timer.cancel();
    setState(() {
      isRunning = false;
      totalSeconds = twentyFiveMinutes;
      totalPomodors = 0;
    });
  }

  /*
  reset
  타이머 취소
  isRunning false 로 변경
  totalSecond값 1500초로 초기화
  뽀모 값도 0으로 초기화
  */

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    print('$duration');
    return duration.toString().split(".").first.substring(2, 7);
  }

  /*
   초를 분으로 환산하는 함수
   int seconds 값을 받아 Duration 함수로 0:00:00:000000 형태의 듀라에이션 값으로 변환 
   totalSeconds 값에 twentyFiveMinutes(1500 초단위 값)이 저장돼 있으니
   Duration은 1500초값이 입력되어 0:25:00.000000 값이 저장된다.
   duration.toString() 스트링 자료형으로 변환
   split(".")으로 나누어 스트링 자료형 리스트로 변환 [0:25:00, 0000]
   first 리스트 첫번째 값을 반환
   first.substring(2,7) 첫번째 값인 0:25:00에서 2번부터 7번까지 반환
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                format(totalSeconds),
                style: TextStyle(
                  color: Theme.of(context).cardColor,
                  fontSize: 89,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 120,
                    color: Theme.of(context).cardColor,
                    onPressed: isRunning ? onpausePressed : onStartPressed,
                    icon: Icon(
                      isRunning
                          ? Icons.pause_circle_outlined
                          : Icons.play_circle_outlined,
                    ),
                  ),
                  IconButton(
                    iconSize: 40,
                    color: Theme.of(context).cardColor,
                    onPressed: reset,
                    icon: const Icon(
                      Icons.stop_circle_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodors',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .color,
                          ),
                        ),
                        Text(
                          '$totalPomodors',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

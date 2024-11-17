import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pomo/provider/time_set.dart';
import 'package:provider/provider.dart';

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
  late TimeSet timeSet = Provider.of<TimeSet>(context);
  late int timerValue = timeSet.getTime();
  late int brktimerValue = timeSet.getbrkTime();

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    print('$duration');
    return duration.toString().split(".").first.substring(2, 4);
  }

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
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.save_outlined))
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
                      '타이머 설정',
                      style: TextStyle(
                        fontSize: 20.w,
                      ),
                    ),
                    IconButton(
                        onPressed: timeSet.decrement,
                        icon: Icon(Icons.minimize_rounded)),
                    SizedBox(),
                    Text(format(timeSet.getTime())),
                    SizedBox(),
                    IconButton(
                        onPressed: timeSet.increment,
                        icon: Icon(Icons.add_box_rounded)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '휴식 타이머 설정',
                      style: TextStyle(
                        fontSize: 20.w,
                      ),
                    ),
                    IconButton(
                        onPressed: timeSet.decrementbrktime,
                        icon: Icon(Icons.minimize_rounded)),
                    SizedBox(),
                    Text(format(timeSet.getbrkTime())),
                    SizedBox(),
                    IconButton(
                        onPressed: timeSet.incrementbrktime,
                        icon: Icon(Icons.add_box_rounded)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

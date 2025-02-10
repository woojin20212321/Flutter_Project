import 'package:bitracker/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyrecordScreen extends StatefulWidget {
  const MyrecordScreen({super.key});

  @override
  State<MyrecordScreen> createState() => _MyrecordScreenState();
}

class _MyrecordScreenState extends State<MyrecordScreen> {
  double maxSpeed = 0.0;
  double totalDistance = 0.0;
  double averageSpeed = 0.0;
  String elapsedTime = "00:00:00";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      maxSpeed = prefs.getDouble('maxSpeed') ?? 0.0;
      totalDistance = prefs.getDouble('totalDistance') ?? 0.0;
      averageSpeed = prefs.getDouble('averageSpeed') ?? 0.0;
      elapsedTime = prefs.getString('elapsedTime') ?? "00:00:00";
    });

    print('불러온 데이터:');
    print('최고 속도: $maxSpeed');
    print('총 이동 거리: $totalDistance');
    print('평균 속도: $averageSpeed');
    print('경과 시간: $elapsedTime');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Record'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '최고 속도: ${maxSpeed.toStringAsFixed(2)} km/h',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '총 이동 거리: ${(totalDistance / 1000).toStringAsFixed(2)} km',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '평균 속도: ${averageSpeed.toStringAsFixed(2)} km/h',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              '경과 시간: $elapsedTime',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

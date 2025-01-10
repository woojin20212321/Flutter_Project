import 'package:bitracker/screens/myrecord_screen.dart';
import 'package:bitracker/screens/track_screen.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('메뉴'),
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                // Navigator.push를 람다 함수로 전달
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyrecordScreen(),
                  ),
                );
              },
              child: const Text('내 기록'),
            ),
            TextButton(
              onPressed: () {
                // Navigator.push를 람다 함수로 전달
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TrackScreen(),
                  ),
                );
              },
              child: const Text('라이딩'),
            ),
          ],
        ),
      ),
    );
  }
}

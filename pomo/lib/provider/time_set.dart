import 'package:flutter/material.dart';

class TimeSet with ChangeNotifier {
  int _time = 1500;

  int getTime() => _time;

  void increment() {
    _time += 300;
    notifyListeners();
  }

  void decrement() {
    _time -= 300;
    notifyListeners();
  }
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

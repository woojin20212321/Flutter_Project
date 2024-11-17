import 'package:flutter/material.dart';

class TimeSet with ChangeNotifier {
  int _time = 1500;
  int _brktime = 300;
  int getTime() => _time;
  int getbrkTime() => _brktime;

  void increment() {
    if (_time > 5 && _time < 14400) {
      _time += 300;
      notifyListeners();
    } else {
      _time = 5;
    }
  }

  void decrement() {
    if (_time > 5 && _time < 14400) {
      _time -= 300;
      notifyListeners();
    } else {
      _time = 5;
    }
  }

  void incrementbrktime() {
    if (_brktime > 5 && _brktime < 3600) {
      _brktime += 300;
      notifyListeners();
    } else {
      _brktime = 5;
    }
  }

  void decrementbrktime() {
    if (_brktime > 5 && _brktime < 3600) {
      _brktime -= 300;
      notifyListeners();
    } else {
      _brktime = 5;
    }
  }
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

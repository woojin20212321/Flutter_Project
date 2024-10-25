import 'package:flutter/material.dart';
import 'package:pomo/screens/login_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void tapReturn() {}

  void openLogin() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.green[300],
        title: Text(
          'Menu',
        ),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: openLogin,
            child: Text('로그인'),
          ),
        ],
      ),
    );
  }
}

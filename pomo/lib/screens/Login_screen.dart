import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 160),
              Icon(
                Icons.login_outlined,
                size: 130,
              ),
              SizedBox(
                height: 60,
              ),
              TextField(),
            ],
          ),
        ],
      ),
    );
  }
}

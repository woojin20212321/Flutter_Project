import 'package:bitracker/screens/menu_screen.dart';
import 'package:flutter/material.dart';

class MyrecordScreen extends StatelessWidget {
  const MyrecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(builder: (context) {
                return IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MenuScreen()),
                      );
                    },
                    icon: const Icon(Icons.menu_rounded));
              }),
              const SizedBox(),
              const Text('My Record'),
            ],
          ),
        ),
        body: const Column(
          children: [],
        ),
      ),
    );
  }
}

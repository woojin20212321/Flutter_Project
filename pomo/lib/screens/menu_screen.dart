import 'package:flutter/material.dart';
import 'package:pomo/screens/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  void tapReturn() {}

  void openLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
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
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontSize: 30.w,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:pomo/screens/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pomo/screens/option_screen.dart';

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

  void openOption() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OptionScreen()));
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
              title: Row(
                children: const [
                  Text(
                    '메뉴',
                  ),
                ],
              ),
            ),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    TextButton(
                      onPressed: openLogin,
                      child: Text(
                        '로그인',
                        style: TextStyle(
                            fontSize: 30.w,
                            fontWeight: FontWeight.w500,
                            color: Colors.green[500]),
                      ),
                    ),
                    TextButton(
                      onPressed: openOption,
                      child: Text(
                        '설정',
                        style: TextStyle(
                          fontSize: 30.w,
                          fontWeight: FontWeight.w500,
                          color: Colors.green[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

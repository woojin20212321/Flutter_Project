import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart' as Path;
import 'package:pomo/screens/adduser_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void tapReturn() {}
  void openAddUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AdduserScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: Colors.lightGreen[200],
            appBar: AppBar(
              backgroundColor: Colors.green[300],
              title: Text(
                '로그인',
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Icon(
                      Icons.login_outlined,
                      size: 120.w,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: '이메일'),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(labelText: '비밀번호'),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 16),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('로그인'),
                          ),
                          ElevatedButton(
                            onPressed: (openAddUser),
                            child: Text('회원가입'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

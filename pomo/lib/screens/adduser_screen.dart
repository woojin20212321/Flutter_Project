import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdduserScreen extends StatefulWidget {
  const AdduserScreen({super.key});

  @override
  State<AdduserScreen> createState() => _AdduserScreenState();
}

class _AdduserScreenState extends State<AdduserScreen> {
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
                '회원가입',
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
                      decoration: InputDecoration(labelText: '이름'),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: '아이디'),
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

import 'package:flutter/material.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('내 정보')),
      body: Center(child: Text('프로필 및 설정')),
    );
  }
}

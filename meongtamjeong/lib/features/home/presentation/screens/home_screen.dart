import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('탐정 사무소에 오신 걸 환영합니다!', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

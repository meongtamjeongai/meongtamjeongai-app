// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('홈')),
      body: Center(child: Text('홈 화면')),
    );
  }
}

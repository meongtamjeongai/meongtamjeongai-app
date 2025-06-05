import 'package:flutter/material.dart';

class PhishingScreen extends StatelessWidget {
  const PhishingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('피싱방지')),
      body: Center(child: Text('피싱 방지 기능')),
    );
  }
}

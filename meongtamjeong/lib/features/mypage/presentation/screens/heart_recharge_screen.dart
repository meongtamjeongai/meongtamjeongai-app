import 'package:flutter/material.dart';

class HeartRechargeScreen extends StatelessWidget {
  const HeartRechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('하트 충전')),
      body: const Center(child: Text('하트를 충전할 수 있는 화면입니다.')),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      if (context.mounted) {
        context.go('/login');
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // const SizedBox(height: 40),
              const Image(
                image: AssetImage('assets/images/characters/example_meong.png'),
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 40),
              const Text(
                '멍탐정',
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '당신을 지키는 반려 챗봇',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 16),
              // Text(
              //   '다양한 멍탐정들과 대화하며\n피싱을 예방해요',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontSize: 15,
              //     color: Colors.grey[700],
              //     height: 1.5,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

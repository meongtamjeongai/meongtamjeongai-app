import 'package:flutter/material.dart';
import 'package:meongtamjeong/features/auth/presentation/widgets/google_login_button.dart';
import 'package:meongtamjeong/features/auth/presentation/widgets/kakao_login_button.dart';
import 'package:meongtamjeong/features/auth/presentation/widgets/naver_login_button.dart';
import 'package:meongtamjeong/features/auth/presentation/widgets/guest_browse_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/characters/example_meong.png',
                height: 120,
              ),
              const SizedBox(height: 24),

              // 안내 텍스트
              const Text(
                '멍탐정과 함께\n피싱을 예방하세요!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),

              // 로그인 버튼들
              const KakaoLoginButton(),
              const SizedBox(height: 12),

              const NaverLoginButton(),
              const SizedBox(height: 12),

              const GoogleLoginButton(),
              const SizedBox(height: 20),

              const GuestBrowseButton(),
            ],
          ),
        ),
      ),
    );
  }
}

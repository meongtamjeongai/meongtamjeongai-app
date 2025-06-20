import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/features/auth/presentation/widgets/google_login_button.dart';
import 'package:meongtamjeong/features/auth/presentation/widgets/kakao_login_button.dart';
import 'package:meongtamjeong/features/auth/presentation/widgets/naver_login_button.dart';
import 'package:meongtamjeong/features/auth/presentation/widgets/guest_browse_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  void _startLogin() {
    if (!isLoading && mounted) {
      setState(() {
        isLoading = true;
      });
    }
  }

  void _resetLoading() {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onLoginSuccess() {
    context.go('/username-setup');
  }

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
                height: 180,
              ),
              const SizedBox(height: 25),
              const Text(
                '멍탐정과 함께\n피싱을 예방하세요!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 55),

              KakaoLoginButton(
                isEnabled: !isLoading,
                onStartLogin: _startLogin,
                onFinishLogin: _resetLoading,
                onLoginSuccess: _onLoginSuccess,
              ),
              const SizedBox(height: 5),

              NaverLoginButton(
                isEnabled: !isLoading,
                onStartLogin: _startLogin,
                onFinishLogin: _resetLoading,
                onLoginSuccess: _onLoginSuccess,
              ),
              const SizedBox(height: 5),

              GoogleLoginButton(
                isEnabled: !isLoading,
                onStartLogin: _startLogin,
                onFinishLogin: _resetLoading,
              ),
              const SizedBox(height: 10),

              GuestBrowseButton(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NaverLoginButton extends StatelessWidget {
  const NaverLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleNaverLogin(context),
      child: Image.asset(
        'assets/images/icons/naver.png',
        width: double.infinity,
        height: 70,
        fit: BoxFit.contain,
      ),
    );
  }

  void _handleNaverLogin(BuildContext context) {
    print('네이버 로그인 시작');
  }
}

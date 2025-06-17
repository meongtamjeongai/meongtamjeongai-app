import 'package:flutter/material.dart';

class NaverLoginButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onStartLogin;

  const NaverLoginButton({
    super.key,
    required this.isEnabled,
    required this.onStartLogin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          isEnabled
              ? () {
                onStartLogin();
                // TODO: 네이버 로그인 구현
                print('네이버 로그인 시작');
              }
              : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Image.asset(
          'assets/images/icons/naver.png',
          width: double.infinity,
          height: 70,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

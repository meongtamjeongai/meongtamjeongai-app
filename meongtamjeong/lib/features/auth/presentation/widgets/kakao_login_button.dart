import 'package:flutter/material.dart';

class KakaoLoginButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onStartLogin;

  const KakaoLoginButton({
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
                // TODO: 카카오 로그인 구현
                print('카카오 로그인 시작');
              }
              : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Image.asset(
          'assets/images/icons/kakao.png',
          height: 70,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

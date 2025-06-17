import 'package:flutter/material.dart';

class KakaoLoginButton extends StatelessWidget {
  const KakaoLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleKakaoLogin(context),
      child: Image.asset(
        'assets/images/icons/kakao.png',
        height: 70,
        fit: BoxFit.contain,
      ),
    );
  }

  void _handleKakaoLogin(BuildContext context) {
    print('카카오 로그인 시작');
  }
}

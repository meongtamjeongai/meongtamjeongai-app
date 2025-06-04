import 'package:flutter/material.dart';

class KakaoLoginButton extends StatelessWidget {
  const KakaoLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _handleKakaoLogin(context),
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFFEE500),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size.fromHeight(56),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        elevation: 0,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/icons/kakao.png',
              height: 24,
              width: 24,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.chat_bubble,
                  size: 24,
                  color: Color(0xFF3C1E1E),
                );
              },
            ),
          ),
          const Text(
            '카카오로 시작하기',
            style: TextStyle(
              color: Color(0xFF3C1E1E),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _handleKakaoLogin(BuildContext context) {
    print('카카오 로그인 시작');
  }
}

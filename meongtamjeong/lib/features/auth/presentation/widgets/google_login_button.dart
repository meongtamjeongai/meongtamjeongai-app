import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _handleGoogleLogin(context),
      style: OutlinedButton.styleFrom(
        backgroundColor: const Color(0xFFF2F2F2),
        side: const BorderSide(color: Color(0xFFDADCE0)),
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
              'assets/images/icons/google.png',
              height: 40,
              width: 40,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.g_mobiledata,
                  size: 24,
                  color: Colors.black,
                );
              },
            ),
          ),
          const Text(
            '구글로 시작하기',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _handleGoogleLogin(BuildContext context) {
    print('구글 로그인 시작');
    // TODO: 구글 로그인 연동
  }
}

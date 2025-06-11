import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meongtamjeong/core/services/auth_service.dart';
import 'package:go_router/go_router.dart';

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

  Future<void> _handleGoogleLogin(BuildContext context) async {
    final authService = context.read<AuthService>();

    try {
      await authService.signInWithGoogle();
      if (context.mounted && authService.isAuthenticated) {
        context.go('/nickname-setup'); // 로그인 후 별명 설정 페이지로
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('구글 로그인 실패: $e')));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meongtamjeong/core/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleGoogleLogin(context),
      child: Image.asset(
        'assets/images/icons/google.png', // 반드시 실제 경로와 파일명 확인
        width: double.infinity,
        height: 70,
        fit: BoxFit.contain,
      ),
    );
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    final authService = context.read<AuthService>();

    try {
      await authService.signInWithGoogle();
      if (context.mounted && authService.isAuthenticated) {
        context.go('/username-setup');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('구글 로그인 실패: $e')));
    }
  }
}

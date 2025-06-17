import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/core/services/auth_service.dart';

class GoogleLoginButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onStartLogin;
  final VoidCallback onFinishLogin;

  const GoogleLoginButton({
    super.key,
    required this.isEnabled,
    required this.onStartLogin,
    required this.onFinishLogin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? () => _handleGoogleLogin(context) : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.5,
        child: Image.asset(
          'assets/images/icons/google.png',
          width: double.infinity,
          height: 70,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    onStartLogin();
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
    } finally {
      onFinishLogin();
    }
  }
}

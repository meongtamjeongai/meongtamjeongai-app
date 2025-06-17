import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/core/services/auth_service.dart';
import 'package:provider/provider.dart';

class GuestBrowseButton extends StatelessWidget {
  const GuestBrowseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();

    return TextButton(
      onPressed: () async {
        try {
          debugPrint('🔘 [GuestBrowseButton] 익명 로그인 시도');
          final user = await authService.signInAnonymously();
          if (user != null) {
            debugPrint('✅ 게스트 로그인 성공: ${user.uid}');
            context.go('/character-select');
          } else {
            throw Exception('게스트 로그인 실패: 사용자 정보 없음');
          }
        } catch (e) {
          debugPrint('❌ 게스트 로그인 오류: $e');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('게스트 로그인에 실패했습니다.')));
        }
      },
      child: const Text(
        '로그인 없이 둘러보기',
        style: TextStyle(
          fontSize: 17,
          color: Colors.grey,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

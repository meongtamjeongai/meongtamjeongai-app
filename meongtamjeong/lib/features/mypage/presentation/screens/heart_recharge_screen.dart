import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:meongtamjeong/navigation/widgets/custom_bottom_nav_bar.dart';
import 'package:meongtamjeong/features/character_selection/logic/providers/character_provider.dart';

class HeartRechargeScreen extends StatelessWidget {
  const HeartRechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedCharacter =
        context.read<CharacterProvider>().selectedCharacter;

    return Scaffold(
      appBar: AppBar(
        title: const Text('하트 충전'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: const Center(child: Text('하트 충전 화면입니다.')),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          if (selectedCharacter != null) {
            context.goNamed(
              'main',
              extra: {'character': selectedCharacter, 'index': index},
            );
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('캐릭터 정보가 없습니다.')));
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/core/constants/colors.dart';
import 'package:meongtamjeong/features/character_selection/logic/models/character_model.dart';

class CharacterDetailScreen extends StatelessWidget {
  final CharacterModel character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: const Color(0xFFE4F2FA),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(character.imagePath, width: 80, height: 80),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이름: ${character.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '성격: ${character.personality}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      '특징: ${character.specialty}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // 대화 예시
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              itemCount: character.conversationExamples.length,
              itemBuilder: (context, index) {
                final msg = character.conversationExamples[index];
                final isBot = index % 2 == 0;
                return Align(
                  alignment:
                      isBot ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isBot ? Colors.white : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg, style: const TextStyle(fontSize: 14)),
                  ),
                );
              },
            ),
          ),

          // 대화 시작 버튼
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.go('/chat', extra: character);
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text(
                  '대화시작하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../logic/models/character_model.dart';

class CharacterInfoDialog extends StatelessWidget {
  final CharacterModel character;

  const CharacterInfoDialog({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 캐릭터 이미지
          Image.asset(
            character.imagePath,
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),

          // 캐릭터 정보 텍스트
          Text(
            '이름: ${character.name}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            '성격: ${character.personality}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            '특징: ${character.specialty}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

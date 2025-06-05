import 'package:flutter/material.dart';
import '../../logic/models/character_model.dart';

class CharacterCard extends StatelessWidget {
  final CharacterModel character;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 캐릭터 이미지
              Image.asset(character.imagePath, width: 90, height: 90),
              const SizedBox(height: 12),
              Text(
                character.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${character.personality}, ${character.specialty}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // 레이아웃 깨짐 방지
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

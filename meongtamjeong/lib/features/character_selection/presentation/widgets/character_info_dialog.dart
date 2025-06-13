import 'package:flutter/material.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';

class CharacterInfoDialog extends StatelessWidget {
  final PersonaModel character;

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
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[100],
            backgroundImage:
                character.profileImageUrl != null
                    ? NetworkImage(character.profileImageUrl!)
                    : null,
            child:
                character.profileImageUrl == null
                    ? const Icon(Icons.pets, size: 40, color: Colors.grey)
                    : null,
          ),

          const SizedBox(height: 16),

          // 이름
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

          // 설명 (description 사용)
          if (character.description != null)
            Text(
              character.description!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                letterSpacing: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

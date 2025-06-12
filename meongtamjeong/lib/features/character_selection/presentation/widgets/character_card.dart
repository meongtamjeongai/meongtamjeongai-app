import 'package:flutter/material.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';

class CharacterCard extends StatelessWidget {
  final PersonaModel character;
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
              // 이미지 로드
              CircleAvatar(
                radius: 45,
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
              const SizedBox(height: 12),

              // 이름
              Text(
                character.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 8),

              // 설명
              if (character.description != null)
                Text(
                  character.description!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

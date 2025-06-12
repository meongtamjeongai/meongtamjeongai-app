import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';

class CharacterDetailScreen extends StatelessWidget {
  final PersonaModel character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE6F4F9),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black87,
                    ),
                    onPressed: () => context.pop(),
                  ),
                ),
                Positioned.fill(
                  top: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            character.profileImageUrl != null
                                ? NetworkImage(character.profileImageUrl!)
                                : null,
                        child:
                            character.profileImageUrl == null
                                ? const Icon(
                                  Icons.pets,
                                  size: 40,
                                  color: Colors.grey,
                                )
                                : null,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '이름: ${character.name}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (character.description != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              '소개: ${character.description}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // 대화 예시 영역 (systemPrompt 일부 사용)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    character.systemPrompt,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
            ),

            // 하단 버튼
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.pushNamed(
                      'main',
                      extra: {'persona': character, 'index': 2},
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text(
                    '대화시작하기',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';
import 'package:meongtamjeong/features/character_selection/logic/providers/character_provider.dart';

class CharacterSelectionScroll extends StatefulWidget {
  const CharacterSelectionScroll({super.key});

  @override
  State<CharacterSelectionScroll> createState() =>
      _CharacterSelectionScrollState();
}

class _CharacterSelectionScrollState extends State<CharacterSelectionScroll> {
  Map<String, String> _specialties = {};

  @override
  void initState() {
    super.initState();
    _loadSpecialties();
  }

  Future<void> _loadSpecialties() async {
    try {
      final jsonStr = await rootBundle.loadString(
        'assets/persona_specialties.json',
      );
      final Map<String, dynamic> data = json.decode(jsonStr);
      setState(() {
        _specialties = data.map(
          (key, value) => MapEntry(key, value.toString()),
        );
      });
    } catch (e) {
      debugPrint('❌ 특징 로딩 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final characters = context.watch<CharacterProvider>().characters;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: characters.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final character = characters[index];
              final specialty = _specialties[character.name] ?? '특징 정보 없음';

              return GestureDetector(
                onTap: () {
                  context.pushNamed('character-detail', extra: character);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[200],
                        backgroundImage:
                            character.profileImageUrl != null
                                ? NetworkImage(character.profileImageUrl!)
                                : null,
                        child:
                            character.profileImageUrl == null
                                ? const Icon(
                                  Icons.pets,
                                  size: 32,
                                  color: Colors.grey,
                                )
                                : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        character.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        specialty,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // ✅ 스크롤 자연스럽게
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true, // ✅ 부모 Column 내부에서 사용
              physics: const NeverScrollableScrollPhysics(), // ✅ Grid 자체 스크롤 방지
              padding: const EdgeInsets.only(bottom: 32), // ✅ 여유 공간
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
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              character.profileImageUrl != null
                                  ? Image.network(
                                    character.profileImageUrl!,
                                    height: 140,
                                    width: 140,
                                    fit: BoxFit.contain,
                                  )
                                  : Container(
                                    height: 140,
                                    width: 140,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.pets,
                                      size: 32,
                                      color: Colors.grey,
                                    ),
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          character.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          specialty,
                          style: const TextStyle(
                            fontSize: 14,
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
      ),
    );
  }
}

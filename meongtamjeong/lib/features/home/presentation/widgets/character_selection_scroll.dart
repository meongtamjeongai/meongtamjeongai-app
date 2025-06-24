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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(
                child: SizedBox(height: 12), // 상단 여백
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 24), // 하단 여백
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final character = characters[index];
                    final specialty =
                        _specialties[character.name] ?? '특징 정보 없음';

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
                            Flexible(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child:
                                    character.profileImageUrl != null
                                        ? Image.network(
                                          character.profileImageUrl!,
                                          height: 120, // 높이 조금 줄임
                                          width: 120,
                                          fit:
                                              BoxFit
                                                  .cover, // contain에서 cover로 변경
                                        )
                                        : Container(
                                          height: 120,
                                          width: 120,
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.pets,
                                            size: 32,
                                            color: Colors.grey,
                                          ),
                                        ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Flexible(
                              flex: 1,
                              child: Text(
                                character.name,
                                style: const TextStyle(
                                  fontSize: 16, // 폰트 크기 조금 줄임
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Flexible(
                              flex: 1,
                              child: Text(
                                specialty,
                                style: const TextStyle(
                                  fontSize: 12, // 폰트 크기 조금 줄임
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: characters.length),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

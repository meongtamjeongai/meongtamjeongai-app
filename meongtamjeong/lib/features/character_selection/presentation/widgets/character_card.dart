import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';

class CharacterCard extends StatefulWidget {
  final PersonaModel character;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.onTap,
  });

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {
  String? _specialty;

  @override
  void initState() {
    super.initState();
    _loadSpecialty();
  }

  Future<void> _loadSpecialty() async {
    try {
      final String jsonStr = await rootBundle.loadString(
        'assets/persona_specialties.json',
      );
      final Map<String, dynamic> data = json.decode(jsonStr);
      final key = widget.character.name.trim();
      setState(() {
        _specialty = data[key] ?? '특징 없음';
      });
    } catch (e) {
      print('🔴 특징 로딩 에러: $e');
      setState(() {
        _specialty = '특징 로딩 실패';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;
    final bool hasNetworkImage =
        character.profileImageUrl != null &&
        character.profileImageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        print('🔵 캐릭터 카드 탭됨: ${character.name}');
        widget.onTap(); // 이 부분이 빠져있었습니다!
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16), // 모서리 둥글게
              child:
                  hasNetworkImage
                      ? Image.network(
                        character.profileImageUrl!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain, // ✅ 이미지 전체 보이게
                        errorBuilder: (context, error, stackTrace) {
                          print('🔴 이미지 로딩 에러: $error');
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.pets,
                              size: 30,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                      : Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.pets,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
            ),

            // const SizedBox(height: 12),
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
              _specialty ?? '로딩 중...',
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
    );
  }
}

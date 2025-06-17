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
      setState(() {
        _specialty = data[widget.character.name] ?? '특징 없음';
      });
    } catch (e) {
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

    return Container(
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
          ClipOval(
            child:
                hasNetworkImage
                    ? Image.network(
                      character.profileImageUrl!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                    : Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.pets,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
          ),
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
    );
  }
}

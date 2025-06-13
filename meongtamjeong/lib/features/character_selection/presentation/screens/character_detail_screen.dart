import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';
import 'package:meongtamjeong/features/character_selection/presentation/widgets/character_info_dialog.dart';
import 'package:meongtamjeong/features/character_selection/presentation/widgets/character_message_bubble.dart';

class CharacterDetailScreen extends StatefulWidget {
  final PersonaModel character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final String jsonString = await rootBundle.loadString(
      'assets/persona_messages.json',
    );
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    final List<dynamic> messages = jsonMap[widget.character.name] ?? [];
    setState(() {
      _messages = messages.cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6F4F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFE6F4F9),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: CharacterInfoDialog(character: character),
          ),
          const SizedBox(height: 10),

          // 대화 예시
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isPersona = msg['from'] == 'persona';
                return CharacterMessageBubble(
                  character: character,
                  message: msg['message'],
                  isFromCharacter: isPersona,
                );
              },
            ),
          ),

          // 하단 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.pushNamed(
                    'main',
                    extra: {'character': character, 'index': 2},
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
    );
  }
}

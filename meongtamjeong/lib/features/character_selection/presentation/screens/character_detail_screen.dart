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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _debugNavigationStack(); // ✅ context-safe
  }

  Future<void> _loadMessages() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/persona_messages.json',
      );
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      final List<dynamic> messages = jsonMap[widget.character.name] ?? [];
      setState(() {
        _messages = messages.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print('🔥 메시지 로딩 오류: $e');
    }
  }

  void _debugNavigationStack() {
    print('🔍 현재 라우트 경로: ${GoRouterState.of(context).uri.path}');
    print('🔍 현재 라우트 이름: ${GoRouterState.of(context).name}');
    print('🔍 canPop: ${GoRouter.of(context).canPop()}');
  }

  void _navigateBack() {
    print('🔙 뒤로가기 버튼 클릭');
    if (GoRouter.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/character-list');
    }
  }

  void _startChat() {
    print('💬 대화 시작 버튼 클릭');
    context.pushReplacement(
      '/main',
      extra: {'persona': widget.character, 'index': 2},
    );
  }

  @override
  Widget build(BuildContext context) {
    final character = widget.character;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE6F4F9),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: _navigateBack,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _startChat,
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

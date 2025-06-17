import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';
import 'package:meongtamjeong/features/character_selection/presentation/widgets/character_info_dialog.dart';
import 'package:meongtamjeong/features/character_selection/presentation/widgets/character_message_bubble.dart';
import 'package:meongtamjeong/app/service_locator.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/conversation_model.dart';

class CharacterDetailScreen extends StatefulWidget {
  final PersonaModel character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  List<Map<String, dynamic>> _messages = [];
  bool _isCreatingConversation = false;
  final ApiService _apiService = locator<ApiService>();

  @override
  void initState() {
    super.initState();
    _loadMessages();
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

  // ✏️ 비동기 함수로 변경하고 API 호출 로직 추가
  Future<void> _startChat() async {
    if (_isCreatingConversation) return; // 중복 클릭 방지

    setState(() {
      _isCreatingConversation = true;
    });

    try {
      print('💬 대화 시작 버튼 클릭: ${widget.character.name} (ID: ${widget.character.id})');
      
      // API를 호출하여 새 대화방 생성 또는 기존 대화방 정보 가져오기
      final ConversationModel? conversation = await _apiService.startNewConversation(
        personaId: widget.character.id,
      );

      if (conversation != null && mounted) {
        // 성공 시, 응답받은 conversation 객체를 /main 라우터로 전달
        context.pushReplacement(
          '/main',
          extra: {'conversation': conversation, 'index': 2},
        );
      } else {
        throw Exception('대화방 생성에 실패했습니다.');
      }
    } catch (e) {
      print('❌ 대화방 생성 오류: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('대화방을 시작할 수 없습니다: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingConversation = false;
        });
      }
    }
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
                onPressed: _isCreatingConversation ? null : _startChat, // 로딩 중 비활성화
                icon: _isCreatingConversation
                    ? Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(2.0),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.chat_bubble_outline),
                label: Text(
                  _isCreatingConversation ? '대화방 준비 중...' : '대화시작하기',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.blue.withOpacity(0.7), // 로딩 중 배경색
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}

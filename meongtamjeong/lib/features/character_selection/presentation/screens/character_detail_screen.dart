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
import 'package:meongtamjeong/features/chat/logic/models/chat_message_model.dart';

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

  void _navigateBack() {
    if (GoRouter.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/character-list');
    }
  }

  Future<void> _startChat() async {
    if (_isCreatingConversation) return;

    setState(() {
      _isCreatingConversation = true;
    });

    try {
      final ConversationModel? conversation = await _apiService
          .startNewConversation(personaId: widget.character.id);

      if (conversation != null && mounted) {
        // ✅ presigned URL 수동 처리
        if ((conversation.persona.profileImageUrl == null ||
                conversation.persona.profileImageUrl!.isEmpty) &&
            conversation.persona.profileImageKey != null) {
          try {
            final url = await _apiService.getPresignedImageUrl(
              conversation.persona.profileImageKey!,
            );
            final updatedPersona = conversation.persona.copyWith(
              profileImageUrl: url,
            );
            final updatedConversation = conversation.copyWith(
              persona: updatedPersona,
            );

            context.pushReplacement(
              '/main',
              extra: {'conversation': updatedConversation, 'index': 2},
            );
            return;
          } catch (e) {
            print('⚠️ presigned URL 요청 실패: $e');
          }
        }

        // presigned URL 불필요하거나 실패 시 그대로 전송
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
                  messageModel: ChatMessageModel(
                    from: isPersona ? 'ai' : 'user',
                    text: msg['message'],
                    image: null, // 여기선 텍스트 메시지만
                    file: null,
                    time: DateTime.now(), // 임시
                  ),
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
                onPressed: _isCreatingConversation ? null : _startChat,
                icon:
                    _isCreatingConversation
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.blue.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

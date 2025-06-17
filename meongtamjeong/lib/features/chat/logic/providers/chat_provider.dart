import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/conversation_model.dart';

import 'package:meongtamjeong/domain/models/message_model.dart' as domain_message;
import 'package:meongtamjeong/features/chat/logic/models/chat_message_model.dart';

import 'package:meongtamjeong/domain/models/persona_model.dart';
import '../models/chat_message_model.dart';
import '../models/chat_history_model.dart';

class ChatProvider with ChangeNotifier {
  final ConversationModel conversation;
  final ApiService _apiService;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSendingMessage = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSendingMessage => _isSendingMessage;

  List<ChatMessageModel> messages = [];

  final List<File> pendingImages = [];
  final ScrollController scrollController = ScrollController();

  static final List<ChatHistoryModel> chatHistories = [];

  PersonaModel get persona => conversation.persona; 
  int get conversationId => conversation.id;

  ChatProvider({required this.conversation, required ApiService apiService})
      : _apiService = apiService {
      loadInitialMessages();
  }

  Future<void> loadInitialMessages() async {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
          final List<domain_message.MessageModel> fetchedMessages =
              await _apiService.getConversationMessages(
                  conversationId,
                  sortAsc: true,
              );

          messages = fetchedMessages.map((msg) {
              return ChatMessageModel(
                  from: msg.senderType.name, // 'user' or 'ai'
                  text: msg.content,
                  time: msg.createdAt,
              );
          }).toList();

          print('✅ ${messages.length}개의 메시지를 불러왔습니다.');

      } catch (e) {
          _errorMessage = '메시지를 불러오는 데 실패했습니다.';
          print('❌ 메시지 로드 오류: $e');
      } finally {
          _isLoading = false;
          notifyListeners();
          scrollToBottom();
      }
  }

  Future<void> sendMessage(String text) async {
    final content = text.trim();
    if (content.isEmpty) return;    
    
    _isSendingMessage = true;
    notifyListeners();

    final optimisticUserMessage = ChatMessageModel(
      from: 'user',
      text: content,
      time: DateTime.now(),
    );
    messages.add(optimisticUserMessage);
    scrollToBottom();
    
    try {

      final chatResponse = await _apiService.sendNewMessage(conversationId, content);

      if (chatResponse != null) {

        final aiMessage = ChatMessageModel(
          from: chatResponse.aiMessage.senderType.name,
          text: chatResponse.aiMessage.content,
          time: chatResponse.aiMessage.createdAt,
        );
        messages.add(aiMessage);

        // TODO: 제안 질문(suggested_user_questions) UI에 반영하는 로직 추가
        // print('🤖 AI 제안 질문: ${chatResponse.suggestedUserQuestions}');

      } else {
        // API 응답이 null인 경우 (오류)
        throw Exception('API로부터 응답을 받지 못했습니다.');
      }
    } catch (e) {
      print('❌ 메시지 전송 실패: $e');
      // ✏️ 오류 발생 시 사용자에게 피드백
      final errorMessage = ChatMessageModel(
        from: 'ai',
        text: '죄송합니다, 메시지 전송에 실패했어요. 멍! 다시 시도해주세요.',
        time: DateTime.now(),
      );
      messages.add(errorMessage);
    } finally {
      // ✏️ 전송 완료 상태로 변경
      _isSendingMessage = false;
      notifyListeners();
      scrollToBottom();
    }
  }

  void pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      final files = picked.map((x) => File(x.path)).toList();
      if (pendingImages.length + files.length <= 4) {
        pendingImages.addAll(files);
        notifyListeners();
      }
    }
  }

  void removeImage(File file) {
    pendingImages.remove(file);
    notifyListeners();
  }

  void scrollToBottom() {
    Timer(const Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

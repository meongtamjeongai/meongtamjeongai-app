import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/core/utils/image_utils.dart';
import 'package:meongtamjeong/domain/models/conversation_model.dart';
import 'package:meongtamjeong/domain/models/message_model.dart'
    as domain_message;
import 'package:meongtamjeong/features/chat/logic/models/chat_message_model.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';

import '../models/chat_history_model.dart';

class ChatProvider with ChangeNotifier {
  late ConversationModel _conversation;
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

  PersonaModel get persona => _conversation.persona;
  int get conversationId => _conversation.id;
  ConversationModel get conversation => _conversation;

  ChatProvider({
    required ConversationModel conversation,
    required ApiService apiService,
  }) : _apiService = apiService {
    _conversation = conversation;
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

      messages =
          fetchedMessages.map((msg) {
            return ChatMessageModel(
              from: msg.senderType.name,
              text: msg.content,
              time: msg.createdAt.toLocal(),
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

    final now = DateTime.now().toLocal();
    final optimisticUserMessage = ChatMessageModel(
      from: 'user',
      text: content,
      time: now,
    );
    messages.add(optimisticUserMessage);
    scrollToBottom();

    try {
      final chatResponse = await _apiService.sendNewMessage(
        conversationId: conversationId,
        content: content, // ✅ 여기에만 텍스트
      );

      if (chatResponse != null) {
        final aiMsg = chatResponse.aiMessage;
        final aiMessage = ChatMessageModel(
          from: aiMsg.senderType.name,
          text: aiMsg.content,
          time: aiMsg.createdAt.toLocal(),
        );
        messages.add(aiMessage);

        final latest =
            aiMessage.time.isAfter(optimisticUserMessage.time)
                ? aiMessage.time
                : optimisticUserMessage.time;

        _conversation = _conversation.copyWith(lastMessageAt: latest);
      } else {
        throw Exception('API로부터 응답을 받지 못했습니다.');
      }
    } catch (e) {
      print('❌ 메시지 전송 실패: $e');
      messages.add(
        ChatMessageModel(
          from: 'ai',
          text: '죄송합니다, 메시지 전송에 실패했어요. 멍! 다시 시도해주세요.',
          time: DateTime.now().toLocal(),
        ),
      );
    } finally {
      _isSendingMessage = false;
      notifyListeners();
      scrollToBottom();
    }
  }

  void pickImages(BuildContext context) async {
    if (pendingImages.isNotEmpty) {
      _showImageLimitExceededMessage(context);
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();

    if (picked.isNotEmpty) {
      const maxSize = 5 * 1024 * 1024; // 5MB
      for (final x in picked) {
        final file = File(x.path);
        final fileSize = await file.length();

        if (fileSize > maxSize) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '❗ ${_formatBytes(fileSize)} 파일은 너무 커요 (최대 5MB까지 가능)',
              ),
              duration: const Duration(seconds: 3),
            ),
          );
          continue;
        }

        if (pendingImages.length < 2) {
          pendingImages.add(file);
        }
      }

      notifyListeners();
    }
  }

  String _formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB"];
    final i = (bytes.bitLength / 10).floor();
    return '${(bytes / (1 << (10 * i))).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  void _showImageLimitExceededMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('한 번에 1개의 이미지만 첨부 가능합니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void removeImage(File file) {
    pendingImages.remove(file);
    notifyListeners();
  }

  Future<void> sendImageMessages() async {
    if (pendingImages.isEmpty || _isSendingMessage) return;

    _isSendingMessage = true;
    notifyListeners();

    for (final imageFile in List<File>.from(pendingImages)) {
      final now = DateTime.now().toLocal();

      // 1. Optimistic UI
      final optimisticMsg = ChatMessageModel(
        from: 'user',
        text: '',
        image: imageFile,
        time: now,
      );
      messages.add(optimisticMsg);
      notifyListeners();
      scrollToBottom();

      try {
        // 2. base64 인코딩
        final base64 = await ImageUtils.resizeAndConvertToBase64(imageFile);

        // 3. API 전송
        final resp = await _apiService.sendNewMessage(
          conversationId: conversationId,
          content: '이미지 첨부', // 텍스트 공백방지
          base64Image: base64,
        );

        if (resp != null) {
          // 4. 실제 userMessage로 대체
          final msg = resp.userMessage;
          final idx = messages.indexOf(optimisticMsg);
          if (idx != -1) {
            messages[idx] = ChatMessageModel(
              from: msg.senderType.name,
              text: msg.content,
              imageKey: msg.imageKey,
              time: msg.createdAt.toLocal(),
            );
          }

          // 5. timestamp 갱신
          _conversation = _conversation.copyWith(
            lastMessageAt: msg.createdAt.toLocal(),
          );
        } else {
          throw Exception("이미지 메시지 응답 없음");
        }
      } catch (e) {
        print('❌ 이미지 메시지 전송 실패: $e');
        messages.remove(optimisticMsg);
      }

      notifyListeners();
      scrollToBottom();
    }

    pendingImages.clear();
    _isSendingMessage = false;
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

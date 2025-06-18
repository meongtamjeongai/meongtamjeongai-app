import 'package:flutter/material.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/conversation_model.dart';

class ChatHistoryProvider with ChangeNotifier {
  final ApiService _apiService;

  List<ConversationModel> _conversations = [];
  bool _isLoading = false;
  String? _errorMessage;

  ChatHistoryProvider({required ApiService apiService})
    : _apiService = apiService {
    fetchConversations();
  }

  // Getters
  List<ConversationModel> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchConversations({bool forceRefresh = false}) async {
    if (_isLoading && !forceRefresh) return;

    _isLoading = true;
    _errorMessage = null;
    if (!forceRefresh) {
      notifyListeners();
    }

    try {
      final fetchedList = await _apiService.getUserConversations();

      // presigned URL 처리 + 정렬
      final updatedList = await Future.wait(
        fetchedList.map((conversation) async {
          final persona = conversation.persona;

          if ((persona.profileImageUrl == null ||
                  persona.profileImageUrl!.isEmpty) &&
              persona.profileImageKey != null) {
            try {
              final presignedUrl = await _apiService.getPresignedImageUrl(
                persona.profileImageKey!,
              );
              final updatedPersona = persona.copyWith(
                profileImageUrl: presignedUrl,
              );
              return conversation.copyWith(persona: updatedPersona);
            } catch (e) {
              debugPrint('⚠️ presigned URL 요청 실패 (${persona.name}): $e');
              return conversation;
            }
          }
          return conversation;
        }),
      );

      // ✅ 최신 대화순으로 정렬 (lastMessageAt 내림차순)
      updatedList.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));

      _conversations = updatedList;
    } catch (e) {
      _errorMessage = "대화 목록을 불러오는 데 실패했습니다.";
      debugPrint('❌ 대화 목록 로드 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ 대화 삭제
  Future<bool> deleteConversation(int conversationId) async {
    try {
      final success = await _apiService.deleteConversation(conversationId);
      if (success) {
        _conversations.removeWhere((c) => c.id == conversationId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ 대화 삭제 실패: $e');
      return false;
    }
  }

  // ✅ 외부에서 수동 갱신 시 호출할 수 있게 업데이트 메서드 추가 (예: 채팅 후 최신화)
  void updateConversation(ConversationModel updated) {
    final index = _conversations.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      _conversations[index] = updated;
      _conversations.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
      notifyListeners();
    }
  }
}

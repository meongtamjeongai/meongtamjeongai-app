import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meongtamjeong/app/service_locator.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/conversation_model.dart';
import 'package:meongtamjeong/history/logic/providers/chat_history_provider.dart';
import 'package:provider/provider.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider로 ChatHistoryProvider를 주입
    return ChangeNotifierProvider(
      create: (_) => ChatHistoryProvider(apiService: locator<ApiService>()),
      child: const _ChatHistoryScreenContent(),
    );
  }
}

class _ChatHistoryScreenContent extends StatefulWidget {
  const _ChatHistoryScreenContent();

  @override
  State<_ChatHistoryScreenContent> createState() => _ChatHistoryScreenContentState();
}

class _ChatHistoryScreenContentState extends State<_ChatHistoryScreenContent> {
  bool sortByLatest = true;

  @override
  Widget build(BuildContext context) {
    // Provider를 통해 상태와 데이터에 접근
    final provider = context.watch<ChatHistoryProvider>();

    // 데이터 정렬 (백엔드에서 이미 정렬했지만, 클라이언트에서도 옵션 제공)
    List<ConversationModel> sortedHistory = [...provider.conversations];
    sortedHistory.sort(
      (a, b) =>
          sortByLatest
              ? b.lastMessageAt.compareTo(a.lastMessageAt)
              : a.lastMessageAt.compareTo(b.lastMessageAt),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        title: const Text(
          '지난 대화 보기',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<bool>(
            onSelected: (value) => setState(() => sortByLatest = value),
            itemBuilder:
                (_) => const [
                  PopupMenuItem(value: true, child: Text('최신순')),
                  PopupMenuItem(value: false, child: Text('오래된순')),
                ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      // 로딩 및 에러 상태에 따른 UI 분기 처리
      body: RefreshIndicator(
        onRefresh: () => provider.fetchConversations(forceRefresh: true),
        child: Builder(
          builder: (context) {
            if (provider.isLoading && sortedHistory.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(child: Text(provider.errorMessage!));
            }

            if (sortedHistory.isEmpty) {
              return const Center(child: Text('아직 대화 기록이 없습니다.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: sortedHistory.length,
              itemBuilder: (context, index) {
                final history = sortedHistory[index];
                final persona = history.persona;
                // 마지막 메시지 정보는 아직 없으므로, 대화방 제목으로 대체
                final lastMessage = history.title ?? "${persona.name}님과의 대화";
                final time = history.lastMessageAt;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Material(
                    color: const Color(0xFFF7F9FB),
                    borderRadius: BorderRadius.circular(16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                            persona.profileImageUrl != null
                                ? NetworkImage(persona.profileImageUrl!)
                                : null,
                        radius: 28,
                        child:
                            persona.profileImageUrl == null
                                ? const Icon(Icons.pets, color: Colors.white)
                                : null,
                      ),
                      title: Text(
                        persona.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          lastMessage.length > 25
                              ? '${lastMessage.substring(0, 25)}...'
                              : lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      trailing: Text(
                        _formatTime(time),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () {
                        // 대화방으로 이동 시 ConversationModel 객체 전달
                        context.pushReplacement(
                          '/main',
                          extra: {
                            'conversation': history,
                            'index': 2, // 대화하기 탭
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (DateUtils.isSameDay(time, now)) {
      return DateFormat.Hm().format(time);
    } else if (now.difference(time).inDays == 1) {
      return '어제';
    } else {
      return DateFormat.MMMd('ko_KR').format(time);
    }
  }
}
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
    return ChangeNotifierProvider(
      create: (_) => ChatHistoryProvider(apiService: locator<ApiService>()),
      child: const _ChatHistoryScreenContent(),
    );
  }
}

class _ChatHistoryScreenContent extends StatefulWidget {
  const _ChatHistoryScreenContent();

  @override
  State<_ChatHistoryScreenContent> createState() =>
      _ChatHistoryScreenContentState();
}

class _ChatHistoryScreenContentState extends State<_ChatHistoryScreenContent> {
  bool sortByLatest = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatHistoryProvider>();
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
        automaticallyImplyLeading: false,
        shadowColor: Colors.black.withOpacity(0.1),
        title: const Text(
          '지난 대화 보기',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                final lastMessage = history.title ?? "${persona.name}님과의 대화";
                final time = history.lastMessageAt;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Dismissible(
                    key: Key(history.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.redAccent,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (_) async {
                      return await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text('대화 삭제'),
                              content: const Text('정말 이 대화를 삭제하시겠어요?'),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: const Text('취소'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text(
                                    '삭제',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                    onDismissed: (_) async {
                      final success = await provider.deleteConversation(
                        history.id,
                      );
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('대화가 삭제되었습니다.')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('삭제에 실패했습니다.')),
                        );
                      }
                    },
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
                          context.pushReplacement(
                            '/main',
                            extra: {'conversation': history, 'index': 2},
                          );
                        },
                      ),
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
    final localTime = time.toLocal(); // ✅ UTC → Local 변환
    final now = DateTime.now();

    if (DateUtils.isSameDay(localTime, now)) {
      return DateFormat.Hm().format(localTime);
    } else if (now.difference(localTime).inDays == 1) {
      return '어제';
    } else {
      return DateFormat.MMMd('ko_KR').format(localTime);
    }
  }
}

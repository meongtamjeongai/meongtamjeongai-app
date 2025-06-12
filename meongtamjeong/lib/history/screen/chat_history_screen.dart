import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meongtamjeong/features/chat/logic/models/chat_history_model.dart';
import 'package:meongtamjeong/features/chat/logic/providers/chat_provider.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  bool sortByLatest = true;

  @override
  Widget build(BuildContext context) {
    List<ChatHistoryModel> sortedHistory = [...ChatProvider.chatHistories];

    sortedHistory.sort(
      (a, b) =>
          sortByLatest
              ? b.lastTimestamp.compareTo(a.lastTimestamp)
              : a.lastTimestamp.compareTo(b.lastTimestamp),
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
      body:
          sortedHistory.isEmpty
              ? const Center(child: Text('아직 대화 기록이 없습니다.'))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: sortedHistory.length,
                itemBuilder: (context, index) {
                  final history = sortedHistory[index];
                  final persona = history.persona;
                  final lastMessage = history.lastMessage;
                  final time = history.lastTimestamp;

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
                          context.goNamed(
                            'main',
                            extra: {
                              'character': persona,
                              'index': 2, // 대화하기 탭
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
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

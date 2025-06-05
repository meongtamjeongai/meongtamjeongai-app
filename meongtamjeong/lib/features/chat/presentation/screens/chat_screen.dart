import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/features/character_selection/presentation/widgets/character_message_bubble.dart';
import 'package:meongtamjeong/navigation/widgets/custom_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../character_selection/logic/models/character_model.dart';
import '../../logic/providers/chat_provider.dart';
import '../widgets/preview_attachment_list.dart';
import '../widgets/attachment_button.dart';

class ChatScreen extends StatelessWidget {
  final CharacterModel character;

  const ChatScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(character),
      child: ChatScreenContent(character: character),
    );
  }
}

class ChatScreenContent extends StatefulWidget {
  final CharacterModel character;

  const ChatScreenContent({super.key, required this.character});

  @override
  State<ChatScreenContent> createState() => _ChatScreenContentState();
}

class _ChatScreenContentState extends State<ChatScreenContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                controller: provider.scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                itemCount: provider.messages.length,
                itemBuilder: (context, index) {
                  final msg = provider.messages[index];
                  final isFromBot = msg['from'] == 'bot';

                  final currentDate = msg['time'] ?? DateTime.now();
                  final previousDate =
                      index > 0
                          ? provider.messages[index - 1]['time'] ??
                              DateTime.now()
                          : null;

                  final showDate =
                      previousDate == null ||
                      !DateUtils.isSameDay(currentDate, previousDate);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (showDate)
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 8),
                          child: Text(
                            DateFormat.yMMMMd('ko_KR').format(currentDate),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      CharacterMessageBubble(
                        character: widget.character,
                        message: msg['text'] ?? '',
                        isFromCharacter: isFromBot,
                      ),
                    ],
                  );
                },
              ),
            ),
            // 첨부파일 미리보기
            PreviewAttachmentList(
              images: provider.pendingImages,
              files: provider.pendingFiles,
              onRemoveImage: provider.removeImage,
              onRemoveFile: provider.removeFile,
            ),
            _buildInputBar(provider),
          ],
        ),
      ),
      // bottomNavigationBar 제거 - MainNavigationScreen에서 관리
    );
  }

  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 160,
          decoration: const BoxDecoration(
            color: Color(0xFFE6F4F9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(widget.character.imagePath),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              widget.character.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputBar(ChatProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AttachmentButton(
            onImageTap: provider.pickImages,
            onFileTap: provider.pickFiles,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              decoration: InputDecoration(
                hintText: '메시지를 입력하세요',
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              provider.sendMessage(_controller.text, DateTime.now());
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}

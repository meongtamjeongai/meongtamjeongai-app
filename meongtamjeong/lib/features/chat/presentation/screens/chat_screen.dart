import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:meongtamjeong/app/service_locator.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/conversation_model.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';
import 'package:meongtamjeong/features/chat/logic/models/chat_message_model.dart';
import 'package:meongtamjeong/features/chat/logic/providers/chat_provider.dart';
import 'package:meongtamjeong/features/chat/presentation/widgets/attachment_button.dart';
import 'package:meongtamjeong/features/chat/presentation/widgets/preview_attachment_list.dart';
import 'package:meongtamjeong/features/character_selection/presentation/widgets/character_message_bubble.dart';

class ChatScreen extends StatelessWidget {
  final ConversationModel conversation;

  const ChatScreen({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(
        conversation: conversation,
        apiService: locator<ApiService>(),
      ),
      child: ChatScreenContent(conversation: conversation),
    );
  }
}

class ChatScreenContent extends StatefulWidget {
  final ConversationModel conversation;

  const ChatScreenContent({super.key, required this.conversation});

  @override
  State<ChatScreenContent> createState() => _ChatScreenContentState();
}

class _ChatScreenContentState extends State<ChatScreenContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(widget.conversation.persona),
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.errorMessage != null) {
                    return Center(
                      child: Text(provider.errorMessage!),
                    );
                  }

                  return ListView.builder(
                    controller: provider.scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final ChatMessageModel msg = provider.messages[index];
                      final currentDate = msg.time;
                      final previousDate =
                          index > 0 ? provider.messages[index - 1].time : null;
                      final showDate = previousDate == null ||
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
                            character: widget.conversation.persona,
                            message: msg.text,
                            isFromCharacter: msg.isFromBot,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            PreviewAttachmentList(
              images: provider.pendingImages,
              //files: provider.pendingFiles,
              onRemoveImage: provider.removeImage,
              //onRemoveFile: provider.removeFile,
            ),
            _buildInputBar(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(PersonaModel character) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 160,
          decoration: const BoxDecoration(
            color: Color(0xFFE6F4F9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage:
                  character.profileImageUrl != null
                      ? NetworkImage(character.profileImageUrl!)
                      : null,
              child:
                  character.profileImageUrl == null
                      ? const Icon(Icons.pets, size: 40, color: Colors.grey)
                      : null,
            ),
            const SizedBox(height: 8),
            Text(
              character.name,
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
            //onFileTap: provider.pickFiles,
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
              onSubmitted: (_) => _handleSend(provider),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () => _handleSend(provider),
          ),
        ],
      ),
    );
  }

  void _handleSend(ChatProvider provider) {
    provider.sendMessage(_controller.text, DateTime.now());
    _controller.clear();
    FocusScope.of(context).unfocus();
  }
}
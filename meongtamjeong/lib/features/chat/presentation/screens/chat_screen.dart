import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:meongtamjeong/app/service_locator.dart';
import 'package:meongtamjeong/core/services/api_service.dart';
import 'package:meongtamjeong/domain/models/conversation_model.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';
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
      create:
          (_) => ChatProvider(
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
  PersonaModel? _updatedPersona;
  bool _isFetchingImage = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileImageUrlIfNeeded();
  }

  void _fetchProfileImageUrlIfNeeded() async {
    final persona = widget.conversation.persona;

    if ((persona.profileImageUrl == null || persona.profileImageUrl!.isEmpty) &&
        persona.profileImageKey != null) {
      setState(() {
        _isFetchingImage = true;
      });

      try {
        final url = await locator<ApiService>().getPresignedImageUrl(
          persona.profileImageKey!,
        );
        setState(() {
          _updatedPersona = persona.copyWith(profileImageUrl: url);
          _isFetchingImage = false;
        });
      } catch (e) {
        debugPrint('❌ 프로필 이미지 불러오기 실패: $e');
        setState(() {
          _isFetchingImage = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(_updatedPersona ?? widget.conversation.persona),
            Expanded(
              child:
                  provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.errorMessage != null
                      ? Center(child: Text(provider.errorMessage!))
                      : ListView.builder(
                        controller: provider.scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                        itemCount: provider.messages.length,
                        itemBuilder: (context, index) {
                          final msg = provider.messages[index];
                          final showDate =
                              index == 0 ||
                              !DateUtils.isSameDay(
                                msg.time,
                                provider.messages[index - 1].time,
                              );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (showDate)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 12,
                                    bottom: 8,
                                  ),
                                  child: Text(
                                    DateFormat.yMMMMd(
                                      'ko_KR',
                                    ).format(msg.time.toLocal()),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              CharacterMessageBubble(
                                character:
                                    _updatedPersona ??
                                    widget.conversation.persona,
                                messageModel: msg,
                                isFromCharacter: msg.isFromBot,
                              ),
                            ],
                          );
                        },
                      ),
            ),
            PreviewAttachmentList(
              images: provider.pendingImages,
              onRemoveImage: provider.removeImage,
            ),
            _buildInputBar(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(PersonaModel character) {
    final imageUrl = character.profileImageUrl;
    final hasValidImage = imageUrl != null && imageUrl.isNotEmpty;

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
              backgroundImage: hasValidImage ? NetworkImage(imageUrl) : null,
              child:
                  !hasValidImage
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
            onImageTap:
                provider.isSendingMessage
                    ? null
                    : () => provider.pickImages(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              enabled: !provider.isSendingMessage,
              decoration: InputDecoration(
                hintText:
                    provider.isSendingMessage ? '응답을 기다리는 중...' : '메시지를 입력하세요',
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
          provider.isSendingMessage
              ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              )
              : IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: () => _handleSend(provider),
              ),
        ],
      ),
    );
  }

  void _handleSend(ChatProvider provider) async {
    if (provider.isSendingMessage) return;

    final textToSend = _controller.text.trim();
    _controller.clear();
    FocusScope.of(context).unfocus();

    // 텍스트가 있으면 먼저 전송
    if (textToSend.isNotEmpty) {
      await provider.sendMessage(textToSend);
    }

    // 이미지가 있으면 전송
    if (provider.pendingImages.isNotEmpty) {
      await provider.sendImageMessages();
    }
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meongtamjeong/domain/models/persona_model.dart';
import 'package:meongtamjeong/features/chat/logic/models/chat_message_model.dart';

class CharacterMessageBubble extends StatelessWidget {
  final PersonaModel character;
  final ChatMessageModel messageModel;
  final bool isFromCharacter;

  const CharacterMessageBubble({
    super.key,
    required this.character,
    required this.messageModel,
    this.isFromCharacter = true,
  });

  @override
  Widget build(BuildContext context) {
    final isBot = isFromCharacter;
    final isImage = messageModel.image != null;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ).copyWith(top: 16, bottom: 16),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) ...[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                backgroundImage:
                    character.profileImageUrl != null
                        ? NetworkImage(character.profileImageUrl!)
                        : null,
                child:
                    character.profileImageUrl == null
                        ? const Icon(Icons.pets, size: 26, color: Colors.grey)
                        : null,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                if (isBot)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                Container(
                  padding:
                      isImage
                          ? EdgeInsets.zero
                          : const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                  decoration: BoxDecoration(
                    color:
                        isBot
                            ? Colors.grey[300]
                            : const Color.fromARGB(255, 193, 221, 245),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child:
                      isImage
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              messageModel.image!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          )
                          : Text(
                            messageModel.text,
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

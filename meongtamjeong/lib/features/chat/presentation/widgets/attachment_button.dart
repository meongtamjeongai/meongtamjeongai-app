import 'package:flutter/material.dart';

class AttachmentButton extends StatelessWidget {
  final VoidCallback onImageTap;
  final VoidCallback onFileTap;

  const AttachmentButton({
    super.key,
    required this.onImageTap,
    required this.onFileTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.add_circle_outline),
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: 'image',
              onTap: onImageTap,
              child: const Text('이미지 선택'),
            ),
            PopupMenuItem(
              value: 'file',
              onTap: onFileTap,
              child: const Text('파일 선택'),
            ),
          ],
    );
  }
}

import 'package:flutter/material.dart';

class AttachmentButton extends StatelessWidget {
  final VoidCallback onImageTap;

  const AttachmentButton({super.key, required this.onImageTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera_alt),
      onPressed: onImageTap,
    );
  }
}

import 'package:flutter/material.dart';

class AttachmentButton extends StatelessWidget {
  final VoidCallback? onImageTap;

  const AttachmentButton({super.key, required this.onImageTap});

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onImageTap == null;

    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate_outlined,
        size: 28,
        color: isDisabled ? Colors.blue : Theme.of(context).primaryColor,
      ),
      onPressed: isDisabled ? null : onImageTap,
      tooltip: '이미지 추가',
    );
  }
}

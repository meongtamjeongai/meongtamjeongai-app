import 'dart:io';
import 'package:flutter/material.dart';

class PreviewAttachmentList extends StatelessWidget {
  final List<File> images;
  final void Function(File) onRemoveImage;

  const PreviewAttachmentList({
    super.key,
    required this.images,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox();

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final image = images[index];
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: -6,
                top: -6,
                child: IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    size: 20,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => onRemoveImage(image),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';

class PreviewAttachmentList extends StatelessWidget {
  final List<File> images;
  final List<File> files;
  final void Function(File) onRemoveImage;
  final void Function(File) onRemoveFile;

  const PreviewAttachmentList({
    super.key,
    required this.images,
    required this.files,
    required this.onRemoveImage,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty && files.isEmpty) return const SizedBox();

    final attachments = [
      ...images.map((file) => _buildPreviewCard(context, file, isImage: true)),
      ...files.map((file) => _buildPreviewCard(context, file, isImage: false)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: attachments.take(4).toList(), // 최대 4개
      ),
    );
  }

  Widget _buildPreviewCard(
    BuildContext context,
    File file, {
    required bool isImage,
  }) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isImage
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(file, height: 80, fit: BoxFit.cover),
                  )
                  : Icon(
                    Icons.insert_drive_file,
                    size: 48,
                    color: Colors.grey[600],
                  ),
              const SizedBox(height: 6),
              Text(
                file.path.split('/').last,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          onPressed: () => isImage ? onRemoveImage(file) : onRemoveFile(file),
        ),
      ],
    );
  }
}

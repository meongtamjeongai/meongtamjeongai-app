import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? selectedImage;
  File? selectedFile;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
        selectedFile = null;
      });
    }
  }

  Future<void> pickFile() async {
    final result = await openFile();
    if (result != null) {
      setState(() {
        selectedFile = File(result.path);
        selectedImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fileName =
        selectedImage?.path.split('/').last ??
        selectedFile?.path.split('/').last ??
        '파일 또는 이미지 없음';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '첨부 파일',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              if (selectedImage != null)
                Image.file(selectedImage!, height: 160, fit: BoxFit.cover)
              else if (selectedFile != null)
                Row(
                  children: [
                    const Icon(Icons.insert_drive_file, size: 40),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        fileName,
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              else
                const Text(
                  '선택된 파일이 없습니다.',
                  style: TextStyle(color: Colors.grey),
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('이미지 선택'),
                  ),
                  OutlinedButton.icon(
                    onPressed: pickFile,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('파일 선택'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

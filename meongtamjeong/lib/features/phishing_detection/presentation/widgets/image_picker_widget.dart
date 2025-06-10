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
    final imageName = selectedImage?.path.split('/').last;
    final fileName = selectedFile?.path.split('/').last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '사진, 문서 올리기',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildUploadCard(
                icon: Icons.image,
                label: '이미지 업로드',
                subtext: '스크린샷, 사진 등',
                onTap: pickImage,
                highlight: selectedImage != null,
                preview:
                    selectedImage != null
                        ? Image.file(
                          selectedImage!,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildUploadCard(
                icon: Icons.insert_drive_file,
                label: '파일 업로드',
                subtext: fileName ?? '문서 파일',
                onTap: pickFile,
                highlight: selectedFile != null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadCard({
    required IconData icon,
    required String label,
    required String subtext,
    required VoidCallback onTap,
    bool highlight = false,
    Widget? preview,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: highlight ? Colors.blue : Colors.grey.shade300,
            width: highlight ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            preview ??
                Text(
                  subtext,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
          ],
        ),
      ),
    );
  }
}

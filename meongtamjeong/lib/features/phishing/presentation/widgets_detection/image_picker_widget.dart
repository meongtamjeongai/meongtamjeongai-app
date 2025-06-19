import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(File)? onImageChanged;

  const ImagePickerWidget({super.key, this.onImageChanged});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? selectedImage;
  final int maxSizeInMB = 5;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      final bytes = await file.length();
      if (bytes > maxSizeInMB * 1024 * 1024) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❗ ${picked.name} 은(는) ${maxSizeInMB}MB를 초과했습니다.'),
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }

      setState(() {
        selectedImage = file;
      });
      widget.onImageChanged?.call(file);
    }
  }

  void removeImage() {
    setState(() {
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '캡처 사진 올리기',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: pickImage,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFB1BDC9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child:
                selectedImage == null
                    ? Column(
                      children: const [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 56,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          '이미지를 업로드하세요',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '문자, 카카오톡, 이메일 등의 피싱 의심 이미지를 선택하세요',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                    : Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            selectedImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: removeImage,
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }
}

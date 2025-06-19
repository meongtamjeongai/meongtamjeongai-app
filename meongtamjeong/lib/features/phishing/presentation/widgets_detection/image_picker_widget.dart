import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final void Function(List<File>)? onImagesChanged; // ✅ 콜백 추가

  const ImagePickerWidget({super.key, this.onImagesChanged});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final List<File> selectedImages = [];

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();

    if (picked.isNotEmpty) {
      final newFiles = picked.map((x) => File(x.path)).toList();

      if (selectedImages.length + newFiles.length > 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❗ 최대 10개까지 업로드 가능합니다.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      setState(() {
        selectedImages.addAll(newFiles);
      });
      widget.onImagesChanged?.call(selectedImages); // ✅ 콜백 호출
    }
  }

  void removeImage(File file) {
    setState(() {
      selectedImages.remove(file);
    });
    widget.onImagesChanged?.call(selectedImages); // ✅ 콜백 호출
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: selectedImages.length < 10 ? pickImages : null,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color:
              selectedImages.length < 10
                  ? const Color(0xFFF1F6FB)
                  : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 32,
              color: selectedImages.length < 10 ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              '추가',
              style: TextStyle(
                fontSize: 12,
                color: selectedImages.length < 10 ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyUploadBox() {
    return GestureDetector(
      onTap: pickImages,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color.fromARGB(255, 177, 189, 201),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.cloud_upload_outlined, size: 56, color: Colors.blueGrey),
            SizedBox(height: 16),
            Text(
              '이미지를 업로드하세요',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '문자, 카카오톡, 이메일 등의 피싱 의심 이미지를 선택하세요',
              style: TextStyle(fontSize: 15, color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagesBox() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...selectedImages.map((file) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  file,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: IconButton(
                  icon: const Icon(Icons.cancel, size: 20, color: Colors.red),
                  onPressed: () => removeImage(file),
                ),
              ),
            ],
          );
        }),
        _buildAddButton(),
      ],
    );
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
        selectedImages.isEmpty
            ? _buildEmptyUploadBox()
            : _buildSelectedImagesBox(),
        if (selectedImages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${selectedImages.length}/10개 선택됨',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
      ],
    );
  }
}

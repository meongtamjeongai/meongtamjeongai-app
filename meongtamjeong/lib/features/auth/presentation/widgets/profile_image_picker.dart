import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatelessWidget {
  final File? profileImage;
  final Function(File) onImageSelected;
  final Function(String) onError;

  const ProfileImagePicker({
    super.key,
    this.profileImage,
    required this.onImageSelected,
    required this.onError,
  });

  Future<void> _pickImage(BuildContext context) async {
    final ImageSource? source = await _showImageSourceDialog(context);
    if (source == null) return;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (picked != null) {
        onImageSelected(File(picked.path));
      }
    } catch (e) {
      onError('이미지를 불러오는데 실패했습니다.');
    }
  }

  Future<ImageSource?> _showImageSourceDialog(BuildContext context) {
    return showDialog<ImageSource>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('프로필 사진 선택'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('갤러리에서 선택'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('카메라로 촬영'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
      children: [
        Row(
          children: const [
            Text(
              '프로필 사진 설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 8),
            Text('(선택)', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: GestureDetector(
            onTap: () => _pickImage(context),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        profileImage != null ? FileImage(profileImage!) : null,
                    child:
                        profileImage == null
                            ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            )
                            : null,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

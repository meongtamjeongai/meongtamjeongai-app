import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageEditor extends StatelessWidget {
  final File? profileImage;
  final Function(File) onImageSelected;

  const ProfileImageEditor({
    super.key,
    required this.profileImage,
    required this.onImageSelected,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      onImageSelected(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('프로필 사진', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () => _pickImage(context),
            child: CircleAvatar(
              radius: 60,
              backgroundImage:
                  profileImage != null ? FileImage(profileImage!) : null,
              child:
                  profileImage == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
            ),
          ),
        ),
      ],
    );
  }
}

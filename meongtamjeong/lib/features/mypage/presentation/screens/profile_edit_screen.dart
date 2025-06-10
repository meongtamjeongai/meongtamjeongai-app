import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meongtamjeong/features/auth/presentation/widgets/nickname_input_section.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  File? _profileImage;
  final TextEditingController _nicknameController = TextEditingController();
  bool _isNicknameConfirmed = false;

  bool get _isNicknameValid {
    final nickname = _nicknameController.text.trim();
    return nickname.isNotEmpty && nickname.runes.length <= 10;
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  void _confirmNickname() {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty || nickname.runes.length > 10) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('별명은 1~10자 이내로 입력해주세요.')));
    } else {
      setState(() => _isNicknameConfirmed = true);
    }
  }

  void _saveProfile() {
    if (!_isNicknameConfirmed) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('별명을 먼저 설정해주세요.')));
      return;
    }

    // 저장 로직 TODO
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('프로필이 저장되었습니다.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 관리'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                    child:
                        _profileImage == null
                            ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            )
                            : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2962FF),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            NicknameInputSection(
              controller: _nicknameController,
              isConfirmed: _isNicknameConfirmed,
              onConfirm: _confirmNickname,
              onError:
                  (msg) => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(msg))),
              onSuccess:
                  (msg) => ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(msg))),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2962FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              '저장하기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

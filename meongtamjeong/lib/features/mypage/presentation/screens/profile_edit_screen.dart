// features/profile_edit/presentation/screens/profile_edit_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meongtamjeong/features/mypage/logic/models/profile_edit_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:meongtamjeong/features/auth/presentation/widgets/username_input_section.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileEditViewModel(context.read()),
      child: const _ProfileEditScreenContent(),
    );
  }
}

class _ProfileEditScreenContent extends StatelessWidget {
  const _ProfileEditScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileEditViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '프로필 관리',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,

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
              onTap: () async {
                final picker = ImagePicker();
                final picked = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (picked != null) {
                  viewModel.setProfileImage(File(picked.path));
                }
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        viewModel.profileImage != null
                            ? FileImage(viewModel.profileImage!)
                            : null,
                    child:
                        viewModel.profileImage == null
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
            UsernameInputSection(
              controller: viewModel.usernameController,
              isConfirmed: viewModel.isUsernameConfirmed,
              onConfirm: viewModel.confirmUsername,
              onError: (msg) => _showSnackbar(context, msg),
              onSuccess: (msg) => _showSnackbar(context, msg),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ElevatedButton(
            onPressed:
                viewModel.canSubmit
                    ? () async {
                      final success = await viewModel.submitProfile();
                      if (success && context.mounted) {
                        _showSnackbar(context, '✅ 저장 완료');
                        Navigator.pop(context);
                      } else if (viewModel.errorMessage != null &&
                          context.mounted) {
                        _showSnackbar(context, viewModel.errorMessage!);
                      }
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2962FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
                viewModel.isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      '저장하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

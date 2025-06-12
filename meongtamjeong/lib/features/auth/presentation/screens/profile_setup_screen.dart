import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meongtamjeong/features/auth/logic/models/user_profile_setup_viewmodel.dart';
import 'package:meongtamjeong/features/auth/presentation/widgets/username_input_section.dart';
import 'package:meongtamjeong/features/auth/presentation/widgets/profile_image_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final UserProfileSetupViewModel _viewModel = UserProfileSetupViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  Future<void> _handleSubmit() async {
    final success = await _viewModel.submitProfile();
    if (success && mounted) {
      context.goNamed('character-list');
    } else if (mounted) {
      _showDialog('오류', _viewModel.errorMessage ?? '프로필 설정 중 오류가 발생했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFE6F4F9),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        ProfileImagePicker(
                          profileImage: _viewModel.profileImage,
                          onImageSelected: _viewModel.setProfileImage,
                          onError: (msg) => _showDialog('오류', msg),
                        ),
                        const SizedBox(height: 32),
                        UsernameInputSection(
                          controller: _viewModel.usernameController,
                          isConfirmed: _viewModel.isUsernameConfirmed,
                          onConfirm: () {
                            _viewModel.confirmUsername();
                            if (_viewModel.isUsernameConfirmed) {
                              _showDialog('완료', '이름이 설정되었습니다.');
                            } else if (_viewModel.errorMessage != null) {
                              _showDialog('알림', _viewModel.errorMessage!);
                            }
                          },
                          onError: (msg) => _showDialog('알림', msg),
                          onSuccess: (msg) => _showDialog('완료', msg),
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: ElevatedButton(
              onPressed: _viewModel.canSubmit ? _handleSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _viewModel.canSubmit
                        ? const Color(0xFF2962FF)
                        : Colors.grey.shade300,
                foregroundColor:
                    _viewModel.canSubmit ? Colors.white : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  _viewModel.isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Text(
                        '시작하기',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}

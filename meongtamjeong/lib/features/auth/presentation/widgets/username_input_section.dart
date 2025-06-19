import 'package:flutter/material.dart';
import 'package:meongtamjeong/core/utils/no_whitespace_input_formatter.dart';

class UsernameInputSection extends StatelessWidget {
  final TextEditingController controller;
  final bool isConfirmed;
  final VoidCallback onConfirm;
  final Function(String) onError;
  final Function(String) onSuccess;
  final void Function(String)? onChanged; // ✅ 추가

  const UsernameInputSection({
    super.key,
    required this.controller,
    required this.isConfirmed,
    required this.onConfirm,
    required this.onError,
    required this.onSuccess,
    this.onChanged, // ✅ 추가
  });

  void _showUsernameHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('사용자 이름이란?'),
            content: const Text(
              '멍탐정과 대화할 때 사용되는 이름입니다.\n\n'
              '다른 사용자에게는 노출되지 않으며,\n자신만의 이름을 자유롭게 정할 수 있어요!\n\n'
              '한글, 영문, 특수문자, 이모지 포함 최대 10자까지 설정 가능합니다.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
    );
  }

  bool get _isUsernameValid {
    final username = controller.text.trim();
    return username.isNotEmpty &&
        username.runes.length <= 10 &&
        username.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '사용자 이름 설정',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Text(' *', style: TextStyle(fontSize: 18, color: Colors.red)),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => _showUsernameHelpDialog(context),
              child: const Icon(
                Icons.help_outline,
                size: 20,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged, // ✅ 콜백 연결
                maxLength: 20,
                inputFormatters: [NoWhitespaceInputFormatter()],
                decoration: InputDecoration(
                  hintText: '사용자 이름을 입력해주세요',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isConfirmed ? Colors.green : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF2962FF),
                      width: 2,
                    ),
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon:
                      isConfirmed
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _isUsernameValid ? onConfirm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isConfirmed ? Colors.green : const Color(0xFF2962FF),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isConfirmed ? '완료' : '설정'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final length = value.text.runes.length;
                return Text(
                  '$length/10',
                  style: TextStyle(
                    color: length > 10 ? Colors.red : Colors.grey,
                    fontSize: 12,
                  ),
                );
              },
            ),
            if (isConfirmed)
              const Text(
                '사용자 이름 설정 완료 ✓',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

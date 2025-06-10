import 'package:flutter/material.dart';

class NicknameEditor extends StatefulWidget {
  final TextEditingController controller;
  final bool isConfirmed;
  final VoidCallback onConfirm;

  const NicknameEditor({
    super.key,
    required this.controller,
    required this.isConfirmed,
    required this.onConfirm,
  });

  @override
  State<NicknameEditor> createState() => _NicknameEditorState();
}

class _NicknameEditorState extends State<NicknameEditor> {
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateCharCount);
  }

  void _updateCharCount() {
    setState(() {
      _charCount = widget.controller.text.runes.length;
    });
  }

  bool get _isNicknameValid =>
      widget.controller.text.trim().isNotEmpty && _charCount <= 10;

  @override
  void dispose() {
    widget.controller.removeListener(_updateCharCount);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: '별명을 입력하세요',
            suffixIcon:
                widget.isConfirmed
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_charCount/10',
              style: TextStyle(
                color: _charCount > 10 ? Colors.red : Colors.grey,
              ),
            ),
            ElevatedButton(
              onPressed: _isNicknameValid ? widget.onConfirm : null,
              child: Text(widget.isConfirmed ? '완료' : '설정'),
            ),
          ],
        ),
      ],
    );
  }
}

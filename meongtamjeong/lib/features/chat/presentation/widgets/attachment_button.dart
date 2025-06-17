import 'package:flutter/material.dart';

class AttachmentButton extends StatelessWidget {
  // 파라미터 타입을 null을 허용하는 VoidCallback? 로 변경
  final VoidCallback? onImageTap;
  final VoidCallback? onFileTap;

  const AttachmentButton({
    super.key,
    required this.onImageTap,
    required this.onFileTap,
  });

  @override
  Widget build(BuildContext context) {
    // 버튼이 비활성화 상태인지 확인 (두 콜백이 모두 null일 때)
    final bool isDisabled = onImageTap == null && onFileTap == null;

    return PopupMenuButton<String>(
      // 비활성화 상태일 때 아이콘 색상을 회색으로 변경
      icon: Icon(
        Icons.add_circle_outline,
        color: isDisabled ? Colors.grey : Theme.of(context).primaryColor,
      ),
      // 비활성화 상태일 때는 메뉴가 나타나지 않도록 onSelected를 null로 설정
      onSelected: isDisabled
          ? null
          : (String value) {
              if (value == 'image') {
                onImageTap?.call();
              } else if (value == 'file') {
                onFileTap?.call();
              }
            },
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'image',
          child: Text('이미지 선택'),
        ),
        const PopupMenuItem<String>(
          value: 'file',
          child: Text('파일 선택'),
        ),
      ],
      // 비활성화 상태일 때 버튼 자체의 인터랙션을 막기 위해 enabled 프로퍼티 사용
      enabled: !isDisabled,
    );
  }
}
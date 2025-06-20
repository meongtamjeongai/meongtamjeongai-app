import 'dart:io';

class ChatMessageModel {
  final String from; // 'user' or 'ai'
  final String text;
  final File? image; // 로컬 이미지 (업로드용)
  final File? file; // 로컬 파일 (업로드용)
  final String? imageKey; // 서버 저장된 이미지의 object_key
  final DateTime time;

  ChatMessageModel({
    required this.from,
    required this.text,
    this.image,
    this.file,
    this.imageKey,
    required this.time,
  });

  bool get isFromBot => from == 'ai';
  bool get isImage => image != null || imageKey != null;
  bool get isFile => file != null;

  /// presigned URL을 생성하는 유틸리티
  String? get imageUrl {
    if (imageKey == null) return null;
    return 'https://meong.shop/api/v1/storage/presigned-url/download?object_key=$imageKey';
  }
}

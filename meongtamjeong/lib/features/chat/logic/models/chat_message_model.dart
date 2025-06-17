import 'dart:io';

class ChatMessageModel {
  final String from; // 'user' or 'ai'
  final String text;
  final File? image;
  final File? file;
  final DateTime time;

  ChatMessageModel({
    required this.from,
    required this.text,
    this.image,
    this.file,
    required this.time,
  });

  bool get isFromBot => from == 'ai';
  bool get isImage => image != null;
  bool get isFile => file != null;
}

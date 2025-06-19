// lib/core/utils/image_utils.dart

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageUtils {
  /// 이미지를 지정한 너비로 리사이즈하고 base64로 인코딩
  static Future<String> resizeAndConvertToBase64(
    File imageFile, {
    int maxWidth = 800,
  }) async {
    // 원본 바이트 로드
    final bytes = await imageFile.readAsBytes();

    // 디코딩 (image 패키지)
    final decodedImage = img.decodeImage(bytes);
    if (decodedImage == null) throw Exception("이미지 디코딩 실패");

    // 리사이즈 (너비 기준)
    final resizedImage = img.copyResize(decodedImage, width: maxWidth);

    // JPEG로 인코딩
    final resizedBytes = img.encodeJpg(
      resizedImage,
      quality: 85,
    ); // quality 낮추면 용량 더 줄어듦

    // base64 변환
    return base64Encode(resizedBytes);
  }
}

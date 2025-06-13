import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonaMessageLoader {
  static Future<List<Map<String, String>>> loadMessages(String name) async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/persona_messages.json',
      );
      final Map<String, dynamic> data = json.decode(jsonString);

      if (!data.containsKey(name)) {
        debugPrint('🚫 메시지가 없습니다: $name');
        return [];
      }

      final List<dynamic> rawMessages = data[name];

      return rawMessages.map<Map<String, String>>((item) {
        return {
          'from': item['from']?.toString() ?? '',
          'message': item['message']?.toString() ?? '',
        };
      }).toList();
    } catch (e) {
      debugPrint('🔥 메시지 로딩 오류: $e');
      return [];
    }
  }
}

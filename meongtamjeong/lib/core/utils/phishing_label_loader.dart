import 'dart:convert';
import 'package:flutter/services.dart';

class PhishingLabelLoader {
  static Map<String, String>? _labels;

  static Future<void> loadLabels() async {
    final String jsonString = await rootBundle.loadString(
      'assets/phishing_category_labels.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _labels = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  static String getLabel(String code) {
    return _labels?[code] ?? code;
  }
}

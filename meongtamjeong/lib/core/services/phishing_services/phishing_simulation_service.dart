import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meongtamjeong/features/phishing/logic/model/phishing_case_model.dart';
import 'package:meongtamjeong/features/phishing/logic/model/phishing_category_model.dart';

class PhishingSimulationService {
  final String baseUrl = 'https://meong.shop/api/v1/phishing';

  Future<List<PhishingCategory>> fetchCategories() async {
    final res = await http.get(Uri.parse('$baseUrl/categories'));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => PhishingCategory.fromJson(e)).toList();
    } else {
      throw Exception('카테고리 불러오기 실패: ${res.statusCode}');
    }
  }

  Future<List<PhishingCase>> fetchCasesByCategory(String categoryId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/cases?category_id=$categoryId'),
    );

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => PhishingCase.fromJson(e)).toList();
    } else {
      throw Exception('피싱 사례 불러오기 실패: ${res.statusCode}');
    }
  }

  // ✅ 피싱 사례 상세 조회 추가
  Future<PhishingCase> fetchCaseDetail(int caseId) async {
    final res = await http.get(Uri.parse('$baseUrl/cases/$caseId'));

    if (res.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(res.body);
      return PhishingCase.fromJson(data);
    } else {
      throw Exception('피싱 사례 상세 조회 실패: ${res.statusCode}');
    }
  }
}

import 'package:dio/dio.dart';
import 'package:meongtamjeong/features/phishing/logic/model/phishing_category_model.dart';

class PhishingRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://meong.shop/api/v1'));

  Future<List<PhishingCategory>> fetchPhishingCategories() async {
    final response = await _dio.get('/phishing/categories');
    if (response.statusCode == 200 && response.data is List) {
      return (response.data as List)
          .map((e) => PhishingCategory.fromJson(e))
          .toList();
    } else {
      throw Exception('피싱 카테고리 불러오기 실패');
    }
  }
}

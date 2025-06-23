// enum PhishingCategoryCode {
//   GovScam,
//   FriendScam,
//   LoanScam,
//   Smishing,
//   DeliveryScam,
//   Sextortion,
//   InvestScam,
//   NewAlerts;

//   static PhishingCategoryCode fromString(String code) {
//     return PhishingCategoryCode.values.firstWhere(
//       (e) => e.name == code,
//       orElse: () => PhishingCategoryCode.GovScam,
//     );
//   }
// }

// class PhishingCategory {
//   final PhishingCategoryCode code;
//   final String description;

//   PhishingCategory({required this.code, required this.description});

//   factory PhishingCategory.fromJson(Map<String, dynamic> json) {
//     return PhishingCategory(
//       code: PhishingCategoryCode.fromString(json['code']),
//       description: json['description'] ?? '',
//     );
//   }

//   /// ✅ 라벨 매핑을 위한 코드 → 객체 생성
//   static PhishingCategory fromCode(PhishingCategoryCode code) {
//     switch (code) {
//       case PhishingCategoryCode.GovScam:
//         return PhishingCategory(code: code, description: '검찰/경찰 사칭');
//       case PhishingCategoryCode.FriendScam:
//         return PhishingCategory(code: code, description: '지인 사칭');
//       case PhishingCategoryCode.LoanScam:
//         return PhishingCategory(code: code, description: '대출 사기');
//       case PhishingCategoryCode.Smishing:
//         return PhishingCategory(code: code, description: '스미싱');
//       case PhishingCategoryCode.DeliveryScam:
//         return PhishingCategory(code: code, description: '택배 사칭');
//       case PhishingCategoryCode.Sextortion:
//         return PhishingCategory(code: code, description: '몸캠 피싱');
//       case PhishingCategoryCode.InvestScam:
//         return PhishingCategory(code: code, description: '투자 사기');
//       case PhishingCategoryCode.NewAlerts:
//         return PhishingCategory(code: code, description: '최신 피싱 경고');
//     }
//   }
// }
enum PhishingCategoryCode {
  GovScam,
  FriendScam,
  LoanScam,
  Smishing,
  DeliveryScam,
  Sextortion,
  InvestScam,
  NewAlerts;

  static PhishingCategoryCode fromString(String code) {
    return PhishingCategoryCode.values.firstWhere(
      (e) => e.name == code,
      orElse: () => PhishingCategoryCode.NewAlerts,
    );
  }

  static PhishingCategoryCode? tryFromString(String code) {
    try {
      return PhishingCategoryCode.values.firstWhere((e) => e.name == code);
    } catch (_) {
      return null;
    }
  }
}

class PhishingCategory {
  final PhishingCategoryCode code;
  final String description;

  PhishingCategory({required this.code, required this.description});

  factory PhishingCategory.fromJson(Map<String, dynamic> json) {
    final codeStr = json['code'] as String? ?? '';
    final code =
        PhishingCategoryCode.tryFromString(codeStr) ??
        PhishingCategoryCode.NewAlerts;

    return PhishingCategory(code: code, description: json['description'] ?? '');
  }

  /// 정적 코드 라벨링 (enum만 있을 때 사용)
  static PhishingCategory fromCode(PhishingCategoryCode code) {
    switch (code) {
      case PhishingCategoryCode.GovScam:
        return PhishingCategory(code: code, description: '검찰/경찰 사칭');
      case PhishingCategoryCode.FriendScam:
        return PhishingCategory(code: code, description: '지인 사칭');
      case PhishingCategoryCode.LoanScam:
        return PhishingCategory(code: code, description: '대출 사기');
      case PhishingCategoryCode.Smishing:
        return PhishingCategory(code: code, description: '스미싱');
      case PhishingCategoryCode.DeliveryScam:
        return PhishingCategory(code: code, description: '택배 사칭');
      case PhishingCategoryCode.Sextortion:
        return PhishingCategory(code: code, description: '몸캠 피싱');
      case PhishingCategoryCode.InvestScam:
        return PhishingCategory(code: code, description: '투자 사기');
      case PhishingCategoryCode.NewAlerts:
        return PhishingCategory(code: code, description: '최신 피싱 경고');
    }
  }
}

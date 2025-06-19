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
      orElse: () => PhishingCategoryCode.GovScam,
    );
  }
}

class PhishingCategory {
  final PhishingCategoryCode code;
  final String description;

  PhishingCategory({required this.code, required this.description});

  factory PhishingCategory.fromJson(Map<String, dynamic> json) {
    return PhishingCategory(
      code: PhishingCategoryCode.fromString(json['code']),
      description: json['description'] ?? '',
    );
  }
}

class PhishingCase {
  final int id;
  final String title;
  final String content;
  final String? caseDate;
  final String? referenceUrl;
  final String categoryCode;

  PhishingCase({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryCode,
    this.caseDate,
    this.referenceUrl,
  });

  factory PhishingCase.fromJson(Map<String, dynamic> json) {
    return PhishingCase(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      categoryCode: json['category_code'],
      caseDate: json['case_date'],
      referenceUrl: json['reference_url'],
    );
  }
}

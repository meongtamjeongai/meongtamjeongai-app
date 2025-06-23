class PhishingCase {
  final int id;
  final String title;
  final String content;
  final String? caseDate;
  final String? referenceUrl;
  final String categoryCode;
  final List<String> simulationMessages; // ✅ 시뮬레이션 메시지

  PhishingCase({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryCode,
    required this.simulationMessages, // ✅ 생성자에 추가
    this.caseDate,
    this.referenceUrl,
  });

  factory PhishingCase.fromJson(Map<String, dynamic> json) {
    return PhishingCase(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      categoryCode: json['category_code'],
      simulationMessages: List<String>.from(
        json['simulation_messages'] ?? [],
      ), // ✅ 파싱
      caseDate: json['case_date'],
      referenceUrl: json['reference_url'],
    );
  }
}

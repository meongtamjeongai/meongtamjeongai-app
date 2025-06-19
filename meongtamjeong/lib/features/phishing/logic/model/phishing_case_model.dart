class PhishingCase {
  final String id;
  final String title;

  PhishingCase({required this.id, required this.title});

  factory PhishingCase.fromJson(Map<String, dynamic> json) {
    return PhishingCase(id: json['id'], title: json['title']);
  }
}

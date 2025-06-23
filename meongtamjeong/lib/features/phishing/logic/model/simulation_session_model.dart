import 'package:meongtamjeong/domain/models/persona_model.dart';

class SimulationSession {
  final int id;
  final String title;
  final int userId;
  final PersonaModel persona;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final int? appliedPhishingCaseId;

  SimulationSession({
    required this.id,
    required this.title,
    required this.userId,
    required this.persona,
    required this.createdAt,
    required this.lastMessageAt,
    this.appliedPhishingCaseId,
  });

  factory SimulationSession.fromJson(Map<String, dynamic> json) {
    return SimulationSession(
      id: json['id'],
      title: json['title'],
      userId: json['user_id'],
      persona: PersonaModel.fromJson(json['persona']),
      createdAt: DateTime.parse(json['created_at']),
      lastMessageAt: DateTime.parse(json['last_message_at']),
      appliedPhishingCaseId: json['applied_phishing_case_id'],
    );
  }
}

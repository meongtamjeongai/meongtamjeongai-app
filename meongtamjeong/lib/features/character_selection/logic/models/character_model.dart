class CharacterModel {
  final String id;
  final String name;
  final String personality;
  final String specialty;
  final String description;
  final String imagePath;
  final List<String> conversationExamples;
  final String greeting;

  CharacterModel({
    required this.id,
    required this.name,
    required this.personality,
    required this.specialty,
    required this.description,
    required this.imagePath,
    required this.conversationExamples,
    required this.greeting,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      personality: json['personality'],
      specialty: json['specialty'],
      description: json['description'],
      imagePath: json['imagePath'],
      conversationExamples: List<String>.from(json['conversationExamples']),
      greeting: json['greeting'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'personality': personality,
      'specialty': specialty,
      'description': description,
      'imagePath': imagePath,
      'conversationExamples': conversationExamples,
      'greeting': greeting,
    };
  }
}

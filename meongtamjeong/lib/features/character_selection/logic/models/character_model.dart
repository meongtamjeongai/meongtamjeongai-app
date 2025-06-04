class CharacterModel {
  final String id;
  final String name;
  final String personality;
  final String specialty;
  final String description;
  final String imagePath; // ex) 'assets/images/characters/example_meong.png'
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
      id: json['id'] as String,
      name: json['name'] as String,
      personality: json['personality'] as String,
      specialty: json['specialty'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      conversationExamples: List<String>.from(
        json['conversationExamples'] ?? [],
      ),
      greeting: json['greeting'] as String,
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

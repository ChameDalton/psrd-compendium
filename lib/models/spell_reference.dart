class SpellReference {
  final int id;
  final String name;
  final String description;
  final String source;
  final String school;
  final String levelText;

  SpellReference({
    required this.id,
    required this.name,
    required this.description,
    required this.source,
    required this.school,
    required this.levelText,
  });

  factory SpellReference.fromMap(Map<String, dynamic> map) {
    return SpellReference(
      id: map['section_id'] as int,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      source: map['source'] as String? ?? '',
      school: map['school'] as String? ?? '',
      levelText: map['level_text'] as String? ?? '',
    );
  }

  String getDescription() => '$name - $description';
}
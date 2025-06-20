class SkillReference {
  final int id;
  final String name;
  final String description;
  final String source;

  SkillReference({
    required this.id,
    required this.name,
    required this.description,
    required this.source,
  });

  factory SkillReference.fromMap(Map<String, dynamic> map) {
    return SkillReference(
      id: map['section_id'] as int,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      source: map['source'] as String? ?? '',
    );
  }

  @override
  String toString() => '$name ($id)';
}
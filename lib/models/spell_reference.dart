import 'package:pathfinder_athenaeum/models/reference_item_base.dart';

class SpellReference extends ReferenceItemBase {
  final String source;
  final String? school;
  final String? levelText;

  SpellReference({
    required super.database,
    required super.sectionId,
    required super.url,
    required super.name,
    required String description,
    required this.source,
    this.school,
    this.levelText,
  }) : super(
          shortDescription: description.length > 50 ? description.substring(0, 50) : description,
          qualities: school ?? '',
        );

  factory SpellReference.fromMap(Map<String, dynamic> map) {
    return SpellReference(
      database: map['database'] as String? ?? 'book-cr.db',
      sectionId: map['section_id']?.toString() ?? '',
      url: map['url'] as String? ?? '',
      name: map['name'] as String? ?? 'Unknown',
      description: map['description'] as String? ?? '',
      source: map['source'] as String? ?? '',
      school: map['school'] as String?,
      levelText: map['level_text'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'database': database,
      'section_id': sectionId,
      'url': url,
      'name': name,
      'description': shortDescription,
      'source': source,
      'school': school,
      'level_text': levelText,
    };
  }

  String getDescription() => '$name - $shortDescription';
}
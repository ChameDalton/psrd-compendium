import 'package:pathfinder_athenaeum/models/reference_item_base.dart';

class SpellReference extends ReferenceItemBase {
  final String source;
  final String? school;
  final String? levelText;

  SpellReference({
    required int id,
    required String name,
    required String description,
    required this.source,
    this.school,
    this.levelText,
  }) : super(
          categoryId: id,
          name: name,
          shortDescription: description.length > 50 ? description.substring(0, 50) : description,
          qualities: school ?? '',
        );

  factory SpellReference.fromMap(Map<String, dynamic> map) {
    return SpellReference(
      id: map['section_id'] as int,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      source: map['source'] as String? ?? '',
      school: map['school'] as String?,
      levelText: map['level_text'] as String?,
    );
  }

  String getDescription() => '$name - $shortDescription';
}
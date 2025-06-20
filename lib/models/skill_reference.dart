import 'package:pathfinder_athenaeum/models/reference_item_base.dart';

class SkillReference extends ReferenceItemBase {
  final String source;
  final String? attribute;
  final String? armorCheckPenalty;
  final String? trainedOnly;

  SkillReference({
    required super.database,
    required super.sectionId,
    required super.url,
    required super.name,
    required String description,
    required this.source,
    this.attribute,
    this.armorCheckPenalty,
    this.trainedOnly,
  }) : super(
          shortDescription: description.length > 50 ? description.substring(0, 50) : description,
          qualities: attribute ?? '',
        );

  factory SkillReference.fromMap(Map<String, dynamic> map) {
    return SkillReference(
      database: map['database'] as String? ?? 'book-cr.db',
      sectionId: map['section_id']?.toString() ?? '',
      url: map['url'] as String? ?? '',
      name: map['name'] as String? ?? 'Unknown',
      description: map['description'] as String? ?? '',
      source: map['source'] as String? ?? '',
      attribute: map['attribute'] as String?,
      armorCheckPenalty: map['armor_check_penalty'] as String?,
      trainedOnly: map['trained_only'] as String?,
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
      'attribute': attribute,
      'armor_check_penalty': armorCheckPenalty,
      'trained_only': trainedOnly,
    };
  }

  @override
  String toString() => '$name ($sectionId)';
}
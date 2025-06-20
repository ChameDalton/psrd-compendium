import 'package:pathfinder_athenaeum/models/reference_item_base.dart';

class SkillReference extends ReferenceItemBase {
  final String source;
  final String? attribute;
  final String? armorCheckPenalty;
  final String? trainedOnly;

  SkillReference({
    required int id,
    required String name,
    required String description,
    required this.source,
    this.attribute,
    this.armorCheckPenalty,
    this.trainedOnly,
  }) : super(
          categoryId: id,
          name: name,
          shortDescription: description.length > 50 ? description.substring(0, 50) : description,
          qualities: attribute ?? '',
        );

  factory SkillReference.fromMap(Map<String, dynamic> map) {
    return SkillReference(
      id: map['section_id'] as int,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      source: map['source'] as String? ?? '',
      attribute: map['attribute'] as String?,
      armorCheckPenalty: map['armor_check_penalty'] as String?,
      trainedOnly: map['trained_only'] as String?,
    );
  }

  @override
  String toString() => '$name ($categoryId)';
}
// lib/models/skill_reference.dart
import 'reference_item_base.dart';

class SkillReference extends ReferenceItemBase {
  final String description;
  final String attribute;
  final bool armorCheckPenalty;
  final bool trainedOnly;

  const SkillReference({
    required super.sectionId,
    required super.database,
    required super.name,
    required super.url,
    required this.description,
    required this.attribute,
    required this.armorCheckPenalty,
    required this.trainedOnly,
  });

  String get qualities {
    final tags = <String>[];
    if (trainedOnly) tags.add('Trained Only');
    if (armorCheckPenalty) tags.add('Armor Check Penalty');
    return tags.isEmpty ? '' : '(${tags.join('; ')})';
  }

  String get shortDescription =>
      description.split('.').first.trim() + '.';

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'description': description,
        'attribute': attribute,
        'armorCheckPenalty': armorCheckPenalty,
        'trainedOnly': trainedOnly,
      };

  factory SkillReference.fromMap(Map<String, dynamic> map) => SkillReference(
        sectionId: map['sectionId'],
        database: map['database'],
        name: map['name'],
        url: map['url'],
        description: map['description'],
        attribute: map['attribute'],
        armorCheckPenalty: map['armorCheckPenalty'],
        trainedOnly: map['trainedOnly'],
      );
}

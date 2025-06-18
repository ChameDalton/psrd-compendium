// lib/models/spell_reference.dart
import 'reference_item_base.dart';

class SpellReference extends ReferenceItemBase {
  final String description;
  final String school;
  final String? subschool;
  final String? descriptor;
  final int? level;
  final String? classes;

  const SpellReference({
    required super.sectionId,
    required super.database,
    required super.name,
    required super.url,
    required this.description,
    required this.school,
    this.subschool,
    this.descriptor,
    this.level,
    this.classes,
  });

  String get schoolLine {
    final parts = <String>[school];
    if (subschool != null) parts.add('($subschool)');
    if (descriptor != null) parts.add('[$descriptor]');
    return parts.join(' ');
  }

  String get shortDescription => description.trim().split('.').first + '.';

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'description': description,
        'school': school,
        'subschool': subschool,
        'descriptor': descriptor,
        'level': level,
        'classes': classes,
      };

  factory SpellReference.fromMap(Map<String, dynamic> map) => SpellReference(
        sectionId: map['sectionId'],
        database: map['database'],
        name: map['name'],
        url: map['url'],
        description: map['description'],
        school: map['school'],
        subschool: map['subschool'],
        descriptor: map['descriptor'],
        level: map['level'],
        classes: map['classes'],
      );
}

import 'package:pathfinder_athenaeum/models/reference_item_base.dart';

class CreatureReference extends ReferenceItemBase {
  CreatureReference({
    required super.database,
    required super.sectionId,
    required super.url,
    required super.name,
    required String description,
  }) : super(
          shortDescription: description.length > 50 ? description.substring(0, 50) : description,
          qualities: '',
        );

  factory CreatureReference.fromMap(Map<String, dynamic> map) {
    return CreatureReference(
      database: map['database'] as String? ?? 'book-cr.db',
      sectionId: map['section_id']?.toString() ?? '',
      url: map['url'] as String? ?? '',
      name: map['name'] as String? ?? 'Unknown',
      description: map['description'] as String? ?? '',
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
    };
  }
}
import 'package:pathfinder_athenaeum/models/reference_item_base.dart';

class FeatReference extends ReferenceItemBase {
  final String? prerequisites;
  final String? type;

  FeatReference({
    required super.database,
    required super.sectionId,
    required super.url,
    required super.name,
    required String description,
    required this.prerequisites,
    required this.type,
  }) : super(
          shortDescription: description.length > 50 ? description.substring(0, 50) : description,
          qualities: type ?? '',
        );

  factory FeatReference.fromMap(Map<String, dynamic> map) {
    return FeatReference(
      database: map['database'] as String? ?? 'book-cr.db',
      sectionId: map['section_id']?.toString() ?? '',
      url: map['url'] as String? ?? '',
      name: map['name'] as String? ?? 'Unknown',
      description: map['description'] as String? ?? '',
      prerequisites: map['prerequisites'] as String?,
      type: map['type'] as String?,
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
      'prerequisites': prerequisites,
      'type': type,
    };
  }

  String get formattedTypeLine => type ?? 'Unknown';
}
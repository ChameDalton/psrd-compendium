// lib/models/feat_reference.dart
import 'reference_item_base.dart';

class FeatReference extends ReferenceItemBase {
  final String description;
  final String typeLine;
  final String? subtype;
  final String? prerequisites;

  const FeatReference({
    required super.sectionId,
    required super.database,
    required super.name,
    required super.url,
    required this.description,
    required this.typeLine,
    this.subtype,
    this.prerequisites,
  });

 String get formattedTypeLine {
  if (typeLine.isNotEmpty && description.isNotEmpty) {
    return "($typeLine) - $description";
  } else if (typeLine.isNotEmpty) {
    return "($typeLine)";
  } else {
    return description.isNotEmpty ? description : "No description available";
  }
}

  String get formattedFeatType => typeLine.isNotEmpty ? "($typeLine)" : "";


  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'description': description,
        'typeLine': typeLine,
        'subtype': subtype,
        'prerequisites': prerequisites,
      };

  factory FeatReference.fromMap(Map<String, dynamic> map) {
    return FeatReference(
      sectionId: map['section_id'] ?? 0,
      database: 'core',
      name: map['name'] ?? 'Unknown Feat',
      url: map['url'] ?? '',
      description: map['description'] ?? '',
      typeLine: map['feat_type'] ?? '',  // ✅ Pulls feat type (e.g., Combat)
      prerequisites: null,  // Placeholder until we identify prerequisites field
    );
  }



}

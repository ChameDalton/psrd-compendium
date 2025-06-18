// lib/models/reference_item_base.dart
abstract class ReferenceItemBase {
  final int sectionId;
  final String database;
  final String name;
  final String url;

  const ReferenceItemBase({
    required this.sectionId,
    required this.database,
    required this.name,
    required this.url,
  });

  // This should no longer be abstract:
  Map<String, dynamic> toMap() => {
        'sectionId': sectionId,
        'database': database,
        'name': name,
        'url': url,
      };
}

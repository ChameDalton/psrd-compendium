abstract class ReferenceItemBase {
  final String database;
  final String sectionId;
  final String url;
  final String name;
  final String shortDescription;
  final String qualities;

  ReferenceItemBase({
    required this.database,
    required this.sectionId,
    required this.url,
    required this.name,
    required this.shortDescription,
    required this.qualities,
  });

  Map<String, dynamic> toMap();
}
// lib/models/saved_item.dart
import 'reference_item_base.dart';

class SavedItem extends ReferenceItemBase {
  final int collectionId;
  final int sourceSectionId;

  const SavedItem({
    required super.sectionId,
    required super.database,
    required super.name,
    required super.url,
    required this.collectionId,
    required this.sourceSectionId,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'collectionId': collectionId,
        'sourceSectionId': sourceSectionId,
      };

  factory SavedItem.fromMap(Map<String, dynamic> map) => SavedItem(
        sectionId: map['sectionId'],
        database: map['database'],
        name: map['name'],
        url: map['url'],
        collectionId: map['collectionId'],
        sourceSectionId: map['sourceSectionId'],
      );
}

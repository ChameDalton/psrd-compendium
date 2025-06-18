// lib/models/viewed_item.dart
import 'reference_item_base.dart';

class ViewedItem extends ReferenceItemBase {
  final DateTime viewedAt;

  const ViewedItem({
    required super.sectionId,
    required super.database,
    required super.name,
    required super.url,
    required this.viewedAt,
  });

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'viewedAt': viewedAt.toIso8601String(),
      };

  factory ViewedItem.fromMap(Map<String, dynamic> map) => ViewedItem(
        sectionId: map['sectionId'],
        database: map['database'],
        name: map['name'],
        url: map['url'],
        viewedAt: DateTime.parse(map['viewedAt']),
      );
}


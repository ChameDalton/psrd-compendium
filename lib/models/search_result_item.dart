// lib/models/search_result_item.dart
import 'reference_item_base.dart';

class SearchResultItem extends ReferenceItemBase {
  final String sourceTitle;
  final String? type;
  final String? subtype;

  const SearchResultItem({
    required super.sectionId,
    required super.database,
    required super.name,
    required super.url,
    required this.sourceTitle,
    this.type,
    this.subtype,
  });

  String get typeLine {
    if (type == null) return '';
    return subtype != null ? '$type/$subtype' : type!;
  }

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'sourceTitle': sourceTitle,
        'type': type,
        'subtype': subtype,
      };

  factory SearchResultItem.fromMap(Map<String, dynamic> map) =>
      SearchResultItem(
        sectionId: map['sectionId'],
        database: map['database'],
        name: map['name'],
        url: map['url'],
        sourceTitle: map['sourceTitle'],
        type: map['type'],
        subtype: map['subtype'],
      );
}


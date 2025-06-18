// lib/models/npc_reference.dart
import 'reference_item_base.dart';

class NpcReference extends ReferenceItemBase {
  final String alignment;
  final String size;
  final String type;
  final String? superRace;

  const NpcReference({
    required super.sectionId,
    required super.database,
    required super.name,
    required super.url,
    required this.alignment,
    required this.size,
    required this.type,
    this.superRace,
  });

  String get typeLine =>
      superRace != null ? '$type/$superRace' : type;

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'alignment': alignment,
        'size': size,
        'type': type,
        'superRace': superRace,
      };

  factory NpcReference.fromMap(Map<String, dynamic> map) => NpcReference(
        sectionId: map['sectionId'],
        database: map['database'],
        name: map['name'],
        url: map['url'],
        alignment: map['alignment'],
        size: map['size'],
        type: map['type'],
        superRace: map['superRace'],
      );
}

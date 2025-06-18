// lib/models/creature_reference.dart
import 'reference_item_base.dart';

class CreatureReference extends ReferenceItemBase {
  final int challengeRating;
  final int experience;
  final String size;
  final String alignment;
  final String type;
  final String? subtype;

  const CreatureReference({
    required super.sectionId,
    required super.database,
    required super.name,
    required super.url,
    required this.challengeRating,
    required this.experience,
    required this.size,
    required this.alignment,
    required this.type,
    this.subtype,
  });

  String get typeLine => subtype != null ? '$type/$subtype' : type;

  @override
  Map<String, dynamic> toMap() => {
        ...super.toMap(),
        'challengeRating': challengeRating,
        'experience': experience,
        'size': size,
        'alignment': alignment,
        'type': type,
        'subtype': subtype,
      };

  factory CreatureReference.fromMap(Map<String, dynamic> map) =>
      CreatureReference(
        sectionId: map['sectionId'],
        database: map['database'],
        name: map['name'],
        url: map['url'],
        challengeRating: map['challengeRating'],
        experience: map['experience'],
        size: map['size'],
        alignment: map['alignment'],
        type: map['type'],
        subtype: map['subtype'],
      );
}

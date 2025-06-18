// lib/models/section_entry.dart
class SectionEntry {
  final int id;
  final String title;
  final String parent;
  final String tag;

  const SectionEntry({
    required this.id,
    required this.title,
    required this.parent,
    required this.tag,
  });

  factory SectionEntry.fromMap(Map<String, dynamic> map) => SectionEntry(
        id: map['id'],
        title: map['title'],
        parent: map['parent'],
        tag: map['tag'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'parent': parent,
        'tag': tag,
      };
}

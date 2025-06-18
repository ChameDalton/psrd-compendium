// lib/models/user_collection.dart
class UserCollection {
  final int id;
  final String name;
  final String description;

  const UserCollection({
    required this.id,
    required this.name,
    required this.description,
  });

  factory UserCollection.fromMap(Map<String, dynamic> map) {
    return UserCollection(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

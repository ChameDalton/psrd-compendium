import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'database_helper.mocks.dart';

// Generate with: `dart run build_runner build --delete-conflicting-outputs`
@GenerateMocks([Database])
void main() {}

// Mock database helper to provide sample data
class MockDatabaseHelper {
  final Database database;

  MockDatabaseHelper(this.database);

  Future<List<Map<String, dynamic>>> querySections(String type) async {
    // Sample data mimicking book-cr.db sections table
    switch (type) {
      case 'creature':
        return [
          {
            'id': '1',
            'name': 'Goblin',
            'type': 'creature',
            'parent_id': null,
            'body': 'A small, vicious creature'
          },
          {
            'id': '2',
            'name': 'Dragon',
            'type': 'creature',
            'parent_id': null,
            'body': 'A large, fire-breathing beast'
          },
        ];
      case 'class':
        return [
          {
            'id': '3',
            'name': 'Fighter',
            'type': 'class',
            'parent_id': null,
            'body': 'A skilled combatant'
          },
          {
            'id': '4',
            'name': 'Wizard',
            'type': 'class',
            'parent_id': null,
            'body': 'A master of arcane magic'
          },
        ];
      case 'feat':
        return [
          {
            'id': '1862',
            'name': 'Power Attack',
            'type': 'feat',
            'parent_id': null,
            'body': 'Trade accuracy for damage'
          },
          {
            'id': '1863',
            'name': 'Dodge',
            'type': 'feat',
            'parent_id': null,
            'body': 'Increase AC'
          },
        ];
      case 'race':
        return [
          {
            'id': '5',
            'name': 'Human',
            'type': 'race',
            'parent_id': null,
            'body': 'Versatile and adaptable'
          },
          {
            'id': '6',
            'name': 'Elf',
            'type': 'race',
            'parent_id': null,
            'body': 'Graceful and long-lived'
          },
        ];
      case 'spell':
        return [
          {
            'id': '454',
            'name': 'Raise Dead',
            'type': 'spell',
            'parent_id': null,
            'body': 'Restores life to a deceased creature'
          },
          {
            'id': '455',
            'name': 'Fireball',
            'type': 'spell',
            'parent_id': null,
            'body': 'Explosive fire'
          },
        ];
      default:
        return [];
    }
  }

  Future<List<Map<String, dynamic>>> queryDetails(String parentId) async {
    // Sample detailed content for parent_id
    return [
      {
        'id': '$parentId-1',
        'name': 'Details for $parentId',
        'body': 'Detailed description for $parentId'
      },
    ];
  }
}
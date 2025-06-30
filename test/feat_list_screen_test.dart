// File: test/feat_list_screen_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pathfinder_athenaeum/models/feat_reference.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize sqflite_ffi for in-memory database
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('DatabaseHelper returns feats', () async {
    // Create in-memory database
    final db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    
    // Create tables matching book-cr.db schema
    await db.execute('''
      CREATE TABLE sections (
        section_id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        body TEXT,
        source TEXT,
        type TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE feat_details (
        section_id TEXT PRIMARY KEY,
        prerequisites TEXT,
        type TEXT
      )
    ''');

    // Insert mock data
    await db.insert('sections', {
      'section_id': 'feat_1',
      'name': 'Power Attack',
      'description': 'Trade attack bonus for damage.',
      'body': '<p>Details here</p>',
      'source': 'Core Rulebook',
      'type': 'feat',
    });
    await db.insert('feat_details', {
      'section_id': 'feat_1',
      'prerequisites': 'Str 13, BAB +1',
      'type': 'Combat',
    });

    // Mock DatabaseHelper
    final dbHelper = DatabaseHelper();
    // Inject in-memory database for testing
    dbHelper.getDatabase = (_) async => db;

    final feats = await dbHelper.getItemsByType('feat', dbName: 'test.db');
    expect(feats.length, 1);
    expect(feats[0]['name'], 'Power Attack');
    expect(feats[0]['prerequisites'], 'Str 13, BAB +1');

    await db.close();
  });
}

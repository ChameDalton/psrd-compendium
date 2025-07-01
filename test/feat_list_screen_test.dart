import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize sqflite_common_ffi for testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('DatabaseHelper returns feats', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // Create an in-memory database for testing
      final db = await databaseFactory.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE sections (
                section_id TEXT PRIMARY KEY,
                name TEXT,
                description TEXT,
                body TEXT,
                source TEXT,
                type TEXT,
                parent_id TEXT
              )
            ''');
            await db.execute('''
              CREATE TABLE feat_details (
                section_id TEXT PRIMARY KEY,
                prerequisites TEXT,
                type TEXT
              )
            ''');
            // Insert sample data
            await db.insert('sections', {
              'section_id': 'feat_1862',
              'name': 'Acrobatic',
              'description': 'You are skilled at leaping, jumping, and flying',
              'body': null,
              'source': 'Core Rulebook',
              'type': 'feat',
              'parent_id': 'details_1862'
            });
            await db.insert('sections', {
              'section_id': 'details_1862',
              'name': 'Acrobatic Benefits',
              'body': '<p>You get a +2 bonus on all Acrobatics and Fly skill checks...</p>',
              'source': 'Core Rulebook',
              'type': 'feat_details',
              'parent_id': null
            });
            await db.insert('feat_details', {
              'section_id': 'feat_1862',
              'prerequisites': 'None',
              'type': 'General'
            });
          },
        ),
      );

      // Inject the in-memory database into DatabaseHelper
      final databaseHelper = DatabaseHelper();
      databaseHelper.setTestDatabase(':memory:', db);

      // Mock getItemsByType to use in-memory database
      final featsFuture = databaseHelper.getItemsByType('feat', dbName: ':memory:');

      // Pump the widget with the test database
      await tester.pumpWidget(
        MaterialApp(
          home: FeatListScreen(databaseHelper: databaseHelper),
        ),
      );

      // Wait for the FutureBuilder to complete
      await tester.pumpAndSettle();

      // Verify the UI
      expect(find.text('Acrobatic'), findsOneWidget);
      expect(find.text('You are skilled at leaping, jumping, and flying'), findsOneWidget);

      // Verify the database query
      final feats = await featsFuture;
      expect(feats, isNotEmpty);
      expect(feats.first['name'], 'Acrobatic');
      expect(feats.first['description'], 'You are skilled at leaping, jumping, and flying');
      expect(feats.first['body'], contains('Acrobatics and Fly skill checks'));
      expect(feats.first['prerequisites'], 'None');
      expect(feats.first['feat_type'], 'General');

      await db.close();
    });
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {
  @override
  Future<Database> get database async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await db.execute('''
      CREATE TABLE sections (
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT,
        source TEXT,
        parent_id TEXT,
        body TEXT
      )
    ''');
    await db.insert('sections', {
      'id': 'feat_1862',
      'name': 'Power Attack',
      'type': 'feat',
      'source': 'Core Rulebook',
      'parent_id': null,
      'body': 'You deal extra damage.'
    });
    return db;
  }

  @override
  Future<List<Map<String, dynamic>>> getSections(String type) async {
    return [
      {
        'id': 'feat_1862',
        'name': 'Power Attack',
        'type': 'feat',
        'source': 'Core Rulebook',
        'parent_id': null,
        'body': 'You deal extra damage.'
      }
    ];
  }
}

void main() {
  setUp(() {
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('FeatListScreen displays feats', (WidgetTester tester) async {
    final mockDbHelper = MockDatabaseHelper();
    DatabaseHelper.instance = mockDbHelper;

    await tester.pumpWidget(const MaterialApp(
      home: FeatListScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Power Attack'), findsOneWidget);
    expect(find.text('Core Rulebook'), findsOneWidget);
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'spell_list_screen_test.mocks.dart';

@GenerateMocks([DbWrangler, DatabaseHelper])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  testWidgets('SpellListScreen displays spells', (WidgetTester tester) async {
    final mockDbWrangler = MockDbWrangler();
    final mockDbHelper = MockDatabaseHelper();
    final mockDatabase = await databaseFactory.openDatabase(inMemoryDatabasePath);

    await mockDatabase.execute('''
      CREATE TABLE central_index (
        Section_id INTEGER PRIMARY KEY,
        Name TEXT,
        Type TEXT,
        Database TEXT
      )
    ''');
    await mockDatabase.execute('''
      CREATE TABLE spells (
        _id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        full_text TEXT
      )
    ''');
    await mockDatabase.insert('central_index', {
      'Section_id': 1,
      'Name': 'Fireball',
      'Type': 'spell',
      'Database': 'book-cr.db',
    });
    await mockDatabase.insert('central_index', {
      'Section_id': 2,
      'Name': 'Magic Missile',
      'Type': 'spell',
      'Database': 'book-cr.db',
    });
    await mockDatabase.insert('spells', {
      '_id': 1,
      'name': 'Fireball',
      'description': 'A fiery explosion',
      'full_text': '<p>Boom!</p>',
    });
    await mockDatabase.insert('spells', {
      '_id': 2,
      'name': 'Magic Missile',
      'description': 'Magic darts',
      'full_text': '<p>Pew pew!</p>',
    });

    when(mockDbWrangler.getIndexDatabase()).thenReturn(mockDatabase);
    when(mockDbWrangler.getBookDatabase(any)).thenReturn(mockDatabase);
    when(mockDbHelper.getSections('index.db', 'spell')).thenAnswer(
      (_) => Future.value([
        {'Section_id': 1, 'Name': 'Fireball', 'Type': 'spell', 'Database': 'book-cr.db'},
        {'Section_id': 2, 'Name': 'Magic Missile', 'Type': 'spell', 'Database': 'book-cr.db'},
      ]),
    );
    when(mockDbHelper.getSpellDetails(any, any)).thenAnswer(
      (_) => Future.value({'description': 'A fiery explosion', 'full_text': '<p>Boom!</p>'}),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SpellListScreen(dbHelper: mockDbWrangler),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Fireball'), findsOneWidget);
    expect(find.text('Magic Missile'), findsOneWidget);
  });
}
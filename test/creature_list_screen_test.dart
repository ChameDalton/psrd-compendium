import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'creature_list_screen_test.mocks.dart';

@GenerateMocks([DbWrangler, DatabaseHelper])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  testWidgets('CreatureListScreen displays creatures', (WidgetTester tester) async {
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
    await mockDatabase.insert('central_index', {
      'Section_id': 1,
      'Name': 'Goblin',
      'Type': 'creature',
      'Database': 'book-b1.db',
    });
    await mockDatabase.insert('central_index', {
      'Section_id': 2,
      'Name': 'Dragon',
      'Type': 'creature',
      'Database': 'book-b1.db',
    });

    when(mockDbWrangler.getIndexDatabase()).thenReturn(mockDatabase);
    when(mockDbWrangler.getBookDatabase(any)).thenReturn(mockDatabase);
    when(mockDbHelper.getDatabase(any)).thenAnswer((_) async => mockDatabase);
    when(mockDbHelper.getSections('index.db', 'creature')).thenAnswer(
      (_) => Future.value([
        {'Section_id': 1, 'Name': 'Goblin', 'Type': 'creature', 'Database': 'book-b1.db'},
        {'Section_id': 2, 'Name': 'Dragon', 'Type': 'creature', 'Database': 'book-b1.db'},
      ]),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: CreatureListScreen(dbHelper: mockDbWrangler),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Goblin'), findsOneWidget);
    expect(find.text('Dragon'), findsOneWidget);
  });
}
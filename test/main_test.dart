import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/db/user_database.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'main_test.mocks.dart';

@GenerateMocks([DbWrangler, DatabaseHelper])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  testWidgets('HomeScreen displays dynamic menu', (WidgetTester tester) async {
    final mockDbWrangler = MockDbWrangler();
    final mockDbHelper = MockDatabaseHelper();
    final mockDatabase = await databaseFactory.openDatabase(inMemoryDatabasePath);

    await mockDatabase.execute('''
      CREATE TABLE Menu (
        Menu_id INTEGER PRIMARY KEY,
        Parent_menu_id INTEGER,
        Name TEXT,
        Type TEXT,
        Url TEXT
      )
    ''');
    await mockDatabase.execute('''
      CREATE TABLE central_index (
        Section_id INTEGER PRIMARY KEY,
        Name TEXT,
        Type TEXT,
        Database TEXT
      )
    ''');
    await mockDatabase.insert('Menu', {
      'Menu_id': 1,
      'Parent_menu_id': null,
      'Name': 'Core Rules',
      'Type': '',
      'Url': '',
    });
    await mockDatabase.insert('Menu', {
      'Menu_id': 2,
      'Parent_menu_id': 1,
      'Name': 'Classes',
      'Type': 'class',
      'Url': '/classes',
    });
    await mockDatabase.insert('Menu', {
      'Menu_id': 3,
      'Parent_menu_id': 1,
      'Name': 'Spells',
      'Type': 'spell',
      'Url': '/spells',
    });

    when(mockDbWrangler.getIndexDatabase()).thenReturn(mockDatabase);
    when(mockDbWrangler.getBookDatabase(any)).thenReturn(mockDatabase);
    when(mockDbWrangler.getUserDatabase()).thenReturn(UserDatabase(mockDatabase));
    when(mockDbWrangler.initializeDatabases()).thenAnswer((_) => Future.value());
    when(mockDbHelper.getMenuItems(parentMenuId: null)).thenAnswer(
      (_) => Future.value([
        {
          'Menu_id': 1,
          'Parent_menu_id': null,
          'Name': 'Core Rules',
          'Type': '',
          'Url': '',
        },
      ]),
    );
    when(mockDbHelper.getMenuItems(parentMenuId: 1)).thenAnswer(
      (_) => Future.value([
        {
          'Menu_id': 2,
          'Parent_menu_id': 1,
          'Name': 'Classes',
          'Type': 'class',
          'Url': '/classes',
        },
        {
          'Menu_id': 3,
          'Parent_menu_id': 1,
          'Name': 'Spells',
          'Type': 'spell',
          'Url': '/spells',
        },
      ]),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(dbWrangler: mockDbWrangler),
        routes: {
          '/classes': (context) => ClassListScreen(dbHelper: mockDbWrangler),
          '/spells': (context) => SpellListScreen(dbHelper: mockDbWrangler),
        },
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Core Rules'), findsOneWidget);
    await tester.tap(find.text('Core Rules'));
    await tester.pumpAndSettle();

    expect(find.text('Classes'), findsOneWidget);
    expect(find.text('Spells'), findsOneWidget);
  });
}
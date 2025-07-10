import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'feat_list_screen_test.mocks.dart';

@GenerateMocks([DbWrangler, DatabaseHelper])
void main() {
  late MockDbWrangler mockDbWrangler;
  late MockDatabaseHelper mockDbHelper;
  late Database mockDatabase;

  setUp() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    mockDbWrangler = MockDbWrangler();
    mockDbHelper = MockDatabaseHelper();
    mockDatabase = await databaseFactory.openDatabase(inMemoryDatabasePath);

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
      'Name': 'Dodge',
      'Type': 'feat',
      'Database': 'book-cr.db',
    });
    await mockDatabase.insert('central_index', {
      'Section_id': 2,
      'Name': 'Power Attack',
      'Type': 'feat',
      'Database': 'book-cr.db',
    });

    when(mockDbWrangler.getIndexDatabase()).thenReturn(mockDatabase);
    when(mockDbWrangler.getBookDatabase(any)).thenReturn(mockDatabase);
    when(mockDbHelper.getSections('index.db', 'feat')).thenAnswer(
      (_) => Future.value([
        {'Section_id': 1, 'Name': 'Dodge', 'Type': 'feat', 'Database': 'book-cr.db'},
        {'Section_id': 2, 'Name': 'Power Attack', 'Type': 'feat', 'Database': 'book-cr.db'},
      ]),
    );
  }

  testWidgets('FeatListScreen displays feats', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FeatListScreen(dbHelper: mockDbWrangler),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Dodge'), findsOneWidget);
    expect(find.text('Power Attack'), findsOneWidget);
  });
}
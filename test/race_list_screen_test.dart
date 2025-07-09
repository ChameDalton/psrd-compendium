import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/race_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'race_list_screen_test.mocks.dart';

@GenerateMocks([DbWrangler, DatabaseHelper])
void main() {
  late MockDbWrangler mockDbWrangler;
  late MockDatabaseHelper mockDbHelper;
  late Database mockDatabase;

  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    mockDbWrangler = MockDbWrangler();
    mockDbHelper = MockDatabaseHelper();
    mockDatabase = await databaseFactory.openDatabase(inMemoryDatabasePath);

    when(mockDbWrangler.getBookDatabase(any)).thenReturn(mockDatabase);
    when(mockDbHelper.getSections(any, any)).thenAnswer(
      (_) async => [
        {'_id': 1, 'name': 'Elf', 'type': 'race'},
        {'_id': 2, 'name': 'Dwarf', 'type': 'race'},
      ],
    );
  });

  testWidgets('RaceListScreen displays races', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RaceListScreen(dbHelper: mockDbWrangler),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Elf'), findsOneWidget);
    expect(find.text('Dwarf'), findsOneWidget);
  });
}
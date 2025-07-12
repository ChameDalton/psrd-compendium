import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/screens/race_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'mocks/database_helper.mocks.dart';

void main() {
  late MockDatabaseHelper mockDbHelper;
  late DbWrangler mockDbWrangler;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    mockDbHelper = MockDatabaseHelper();
    mockDbWrangler = DbWrangler();
    when(mockDbHelper.getSections('index.db', 'race')).thenAnswer(
      (_) async => [
        {'Section_id': 1, 'Name': 'Elf', 'Database': 'book-cr.db'},
        {'Section_id': 2, 'Name': 'Dwarf', 'Database': 'book-cr.db'},
      ],
    );
    when(mockDbHelper.closeDatabase()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await mockDbHelper.closeDatabase();
  });

  testWidgets('displays races', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RaceListScreen(dbHelper: DbWrangler()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Elf'), findsOneWidget);
    expect(find.text('Dwarf'), findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 30)));
}
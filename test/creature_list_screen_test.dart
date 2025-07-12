import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart';
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
    when(mockDbHelper.getSections('index.db', 'creature')).thenAnswer(
      (_) async => [
        {'Section_id': 1, 'Name': 'Dragon', 'Database': 'book-cr.db'},
        {'Section_id': 2, 'Name': 'Goblin', 'Database': 'book-cr.db'},
      ],
    );
  });

  tearDown(() async {
    await DatabaseHelper().closeDatabase();
  });

  testWidgets('displays creatures', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreatureListScreen(dbHelper: mockDbWrangler),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Dragon'), findsOneWidget);
    expect(find.text('Goblin'), findsOneWidget);
  }, timeout: Timeout(Duration(seconds: 30)));
}
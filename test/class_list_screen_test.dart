import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
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
    when(mockDbHelper.getSections('index.db', 'class')).thenAnswer(
      (_) async => [
        {'Section_id': 1, 'Name': 'Fighter', 'Database': 'book-cr.db'},
        {'Section_id': 2, 'Name': 'Wizard', 'Database': 'book-cr.db'},
      ],
    );
    when(mockDbHelper.closeDatabase()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await mockDbHelper.closeDatabase();
  });

  testWidgets('displays classes', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ClassListScreen(dbHelper: DbWrangler()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Fighter'), findsOneWidget);
    expect(find.text('Wizard'), findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 30)));
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
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
    when(mockDbHelper.getSections('index.db', 'feat')).thenAnswer(
      (_) async => [
        {'Section_id': 1, 'Name': 'Power Attack', 'Database': 'book-cr.db'},
        {'Section_id': 2, 'Name': 'Cleave', 'Database': 'book-cr.db'},
      ],
    );
  });

  tearDown(() async {
    await DatabaseHelper().closeDatabase();
  });

  testWidgets('displays feats', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: FeatListScreen(dbHelper: mockDbWrangler),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Power Attack'), findsOneWidget);
    expect(find.text('Cleave'), findsOneWidget);
  }, timeout: Timeout(Duration(seconds: 30)));
}
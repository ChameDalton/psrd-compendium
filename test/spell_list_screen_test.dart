import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
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
    when(mockDbHelper.getSections('index.db', 'spell')).thenAnswer(
      (_) async => [
        {'Section_id': 1, 'Name': 'Magic Missile', 'Database': 'book-cr.db'},
        {'Section_id': 2, 'Name': 'Fireball', 'Database': 'book-cr.db'},
      ],
    );
    when(mockDbHelper.getSpellDetails('book-cr.db', any)).thenAnswer(
      (_) async => {'_id': 1, 'name': 'Magic Missile', 'description': 'A missile of magical energy'},
    );
    when(mockDbHelper.closeDatabase()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await mockDbHelper.closeDatabase();
  });

  testWidgets('displays spells', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SpellListScreen(dbHelper: DbWrangler()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Magic Missile'), findsOneWidget);
    expect(find.text('Fireball'), findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 30)));
}
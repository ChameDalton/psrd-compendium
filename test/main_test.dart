import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/main.dart';
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
    when(mockDbHelper.getMenuItems(parentMenuId: null)).thenAnswer(
      (_) async => [
        {'Menu_id': 1, 'Name': 'Classes', 'Type': '', 'Url': '/classes'},
        {'Menu_id': 2, 'Name': 'Spells', 'Type': '', 'Url': '/spells'},
      ],
    );
    when(mockDbHelper.getMenuItems(parentMenuId: 1)).thenAnswer(
      (_) async => [
        {'Menu_id': 3, 'Name': 'Fighter', 'Type': 'class', 'Url': '/class/1?db=book-cr.db§ion_id=1'},
      ],
    );
    when(mockDbHelper.closeDatabase()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await mockDbHelper.closeDatabase();
  });

  testWidgets('displays menu items', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(dbWrangler: mockDbWrangler),
        routes: {
          '/classes': (context) => const ClassListScreen(dbHelper: DbWrangler()),
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Classes'), findsOneWidget);
    expect(find.text('Spells'), findsOneWidget);
  }, timeout: const Timeout(Duration(seconds: 30)));
}
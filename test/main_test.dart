import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/main.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/bookmark_screen.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'main_test.mocks.dart';

@GenerateMocks([DbWrangler, Database])
void main() {
  late MockDbWrangler mockDbWrangler;
  late MockDatabase mockDatabase;

  setUp(() async {
    mockDbWrangler = MockDbWrangler();
    mockDatabase = MockDatabase();
    when(mockDbWrangler.getDatabase(any)).thenAnswer((_) async => mockDatabase);
    when(mockDbWrangler.userDb).thenReturn(mockDatabase);
  });

  tearDown(() async {
    await mockDbWrangler.closeDatabase();
  });

  testWidgets('MainApp navigates to ClassListScreen', (WidgetTester tester) async {
    when(mockDatabase.query(
      'central_index',
      columns: ['Name', 'Section_id'],
      where: 'Type = ?',
      whereArgs: ['class'],
      orderBy: 'Name',
    )).thenAnswer((_) async => [
          {'Name': 'Fighter', 'Section_id': 1},
          {'Name': 'Wizard', 'Section_id': 2},
        ]);

    await tester.pumpWidget(
      MainApp(dbWrangler: mockDbWrangler),
    );

    await tester.pumpAndSettle();

    expect(find.text('Fighter'), findsOneWidget);
    expect(find.text('Wizard'), findsOneWidget);
  });

  testWidgets('MainApp navigates to BookmarkScreen', (WidgetTester tester) async {
    when(mockDatabase.query(
      'Bookmarks',
      columns: ['name', 'url', 'scroll', 'section_id'],
    )).thenAnswer((_) async => [
          {'name': 'Fighter', 'url': '/classes/1', 'scroll': 0, 'section_id': 1},
        ]);

    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: MainApp.generateRoute(mockDbWrangler),
        initialRoute: '/bookmarks',
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Fighter'), findsOneWidget);
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'class_list_screen_test.mocks.dart';

@GenerateMocks([DbWrangler])
void main() {
  late MockDbWrangler mockDbWrangler;
  late Database mockDatabase;

  setUp(() async {
    mockDbWrangler = MockDbWrangler();
    mockDatabase = MockDatabase();
    when(mockDbWrangler.getDatabase(any)).thenAnswer((_) async => mockDatabase);
  });

  tearDown(() async {
    await mockDbWrangler.closeDatabase();
  });

  testWidgets('ClassListScreen displays classes', (WidgetTester tester) async {
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
      MaterialApp(
        home: ClassListScreen(dbHelper: mockDbWrangler),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Fighter'), findsOneWidget);
    expect(find.text('Wizard'), findsOneWidget);
  });
}
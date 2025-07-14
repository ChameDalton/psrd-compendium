import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/race_list_screen.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'race_list_screen_test.mocks.dart';

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

  testWidgets('RaceListScreen displays races', (WidgetTester tester) async {
    when(mockDatabase.query(
      'central_index',
      columns: ['Name', 'Section_id'],
      where: 'Type = ?',
      whereArgs: ['race'],
      orderBy: 'Name',
    )).thenAnswer((_) async => [
          {'Name': 'Elf', 'Section_id': 1},
          {'Name': 'Dwarf', 'Section_id': 2},
        ]);

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
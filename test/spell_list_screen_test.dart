import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'spell_list_screen_test.mocks.dart';

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

  testWidgets('SpellListScreen displays spells', (WidgetTester tester) async {
    when(mockDatabase.query(
      'central_index',
      columns: ['Name', 'Section_id'],
      where: 'Type = ?',
      whereArgs: ['spell'],
      orderBy: 'Name',
    )).thenAnswer((_) async => [
          {'Name': 'Magic Missile', 'Section_id': 1},
          {'Name': 'Fireball', 'Section_id': 2},
        ]);

    await tester.pumpWidget(
      MaterialApp(
        home: SpellListScreen(dbHelper: mockDbWrangler),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Magic Missile'), findsOneWidget);
    expect(find.text('Fireball'), findsOneWidget);
  });
}
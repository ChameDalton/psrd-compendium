import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'creature_list_screen_test.mocks.dart';

@GenerateMocks([DbWrangler, Database])
void main() {
  setUpAll(() {
    sqfliteFfiInit();
  });

  testWidgets('CreatureListScreen displays creatures', (WidgetTester tester) async {
    final mockDbWrangler = MockDbWrangler();
    final mockDatabase = MockDatabase();

    when(mockDbWrangler.getDatabase('index.db')).thenAnswer((_) async => mockDatabase);
    when(mockDatabase.query(
      'central_index',
      columns: ['name', 'url'],
      where: 'type = ?',
      whereArgs: ['creature'],
    )).thenAnswer((_) async => [
          {'name': 'Dragon', 'url': 'dragon_url'},
          {'name': 'Goblin', 'url': 'goblin_url'},
        ]);

    await tester.pumpWidget(
      MaterialApp(
        home: CreatureListScreen(dbWrangler: mockDbWrangler),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Dragon'), findsOneWidget);
    expect(find.text('Goblin'), findsOneWidget);
  });
}
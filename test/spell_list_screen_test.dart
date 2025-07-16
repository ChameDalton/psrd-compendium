import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'spell_list_screen_test.mocks.dart';

@GenerateMocks([DbWrangler, Database])
void main() {
  setUpAll(() {
    sqfliteFfiInit();
  });

  testWidgets('SpellListScreen displays spells', (WidgetTester tester) async {
    final mockDbWrangler = MockDbWrangler();
    final mockDatabase = MockDatabase();

    when(mockDbWrangler.getDatabase('index.db')).thenAnswer((_) async => mockDatabase);
    when(mockDatabase.query(
      'central_index',
      columns: ['name', 'url'],
      where: 'type = ?',
      whereArgs: ['spell'],
    )).thenAnswer((_) async => [
          {'name': 'Magic Missile', 'url': 'magic_missile_url'},
          {'name': 'Fireball', 'url': 'fireball_url'},
        ]);

    await tester.pumpWidget(
      MaterialApp(
        home: SpellListScreen(dbWrangler: mockDbWrangler),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Magic Missile'), findsOneWidget);
    expect(find.text('Fireball'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/race_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'race_list_screen_test.mocks.dart';

@GenerateMocks([DbWrangler, Database, BuildContext])
void main() {
  setUpAll(() {
    sqfliteFfiInit();
  });

  testWidgets('RaceListScreen displays races', (WidgetTester tester) async {
    final mockDbWrangler = MockDbWrangler();
    final mockDatabase = MockDatabase();
    final mockContext = MockBuildContext();

    when(mockDbWrangler.getDatabase(mockContext, 'index.db')).thenAnswer((_) async => mockDatabase);
    when(mockDatabase.query(
      'central_index',
      columns: ['name', 'url'],
      where: 'type = ?',
      whereArgs: ['race'],
    )).thenAnswer((_) async => [
          {'name': 'Elf', 'url': 'elf_url'},
          {'name': 'Dwarf', 'url': 'dwarf_url'},
        ]);

    await tester.pumpWidget(
      MaterialApp(
        home: RaceListScreen(dbWrangler: mockDbWrangler),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Elf'), findsOneWidget);
    expect(find.text('Dwarf'), findsOneWidget);
  });
}
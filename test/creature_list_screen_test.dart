import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/screens/creature_list_screen.dart'; // Adjust import
import 'mocks/database_helper.dart';
import 'mocks/database_helper.mocks.dart';

void main() {
  late MockDatabase mockDatabase;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() async {
    mockDatabase = MockDatabase();
    mockDatabaseHelper = MockDatabaseHelper(mockDatabase);

    // Mock the sections query for creatures
    when(mockDatabase.query(
      'sections',
      where: 'type = ?',
      whereArgs: ['creature'],
      columns: anyNamed('columns'),
    )).thenAnswer(
      (_) async => [
        {
          'id': '1',
          'name': 'Goblin',
          'type': 'creature',
          'parent_id': null,
          'body': 'A small, vicious creature'
        },
        {
          'id': '2',
          'name': 'Dragon',
          'type': 'creature',
          'parent_id': null,
          'body': 'A large, fire-breathing beast'
        },
      ],
    );
  });

  testWidgets('CreatureListScreen displays creatures', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CreatureListScreen(databaseHelper: mockDatabaseHelper),
      ),
    );

    // Allow async operations to complete
    await tester.pumpAndSettle(Duration(seconds: 1));

    // Verify creature names are displayed
    expect(find.text('Goblin'), findsOneWidget);
    expect(find.text('Dragon'), findsOneWidget);
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_details_screen.dart';

// Create a MockBuildContext
class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late MockDatabaseHelper mockDbHelper;
  late MockBuildContext mockContext;

  setUp(() {
    mockDbHelper = MockDatabaseHelper();
    mockContext = MockBuildContext();
  });

  testWidgets('SpellListScreen displays spells and navigates to details', (WidgetTester tester) async {
    final mockSpells = [
      {'section_id': '1', 'name': 'Magic Missile', 'type': 'spell', 'parent_id': 2},
      {'section_id': '2', 'name': 'Fireball', 'type': 'spell', 'parent_id': 2},
    ];

    when(mockDbHelper.getSections(mockContext, 'spell')).thenAnswer((_) async => mockSpells);

    await tester.pumpWidget(
      MaterialApp(
        home: SpellListScreen(dbHelper: mockDbHelper),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Spells'), findsOneWidget);
    expect(find.text('Magic Missile'), findsOneWidget);
    expect(find.text('Fireball'), findsOneWidget);

    await tester.tap(find.text('Magic Missile'));
    await tester.pumpAndSettle();

    verify(mockDbHelper.getSections(mockContext, 'spell')).called(1);

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SpellDetailsScreen &&
            widget.sectionId == '1' &&
            widget.spellName == 'Magic Missile',
      ),
      findsOneWidget,
    );
  });
}

// Mock DatabaseHelper for testing
class MockDatabaseHelper extends Mock implements DatabaseHelper {}
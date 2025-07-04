import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_details_screen.dart';

// Mock DatabaseHelper for testing
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late MockDatabaseHelper mockDbHelper;

  setUp(() {
    mockDbHelper = MockDatabaseHelper();
  });

  testWidgets('SpellListScreen displays spells and navigates to details', (WidgetTester tester) async {
    final mockSpells = [
      {'section_id': '1', 'name': 'Magic Missile', 'type': 'spell', 'parent_id': 2},
      {'section_id': '2', 'name': 'Fireball', 'type': 'spell', 'parent_id': 2},
    ];

    // StatefulWidget to capture BuildContext
    BuildContext? testContext;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            testContext = context;
            return SpellListScreen(dbHelper: mockDbHelper);
          },
        ),
        // Define navigation route for SpellDetailsScreen
        routes: {
          '/spell_details': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
            return SpellDetailsScreen(
              sectionId: args['sectionId']!,
              spellName: args['spellName']!,
              dbHelper: mockDbHelper,
            );
          },
        },
      ),
    );

    // Ensure context is captured
    expect(testContext, isNotNull);

    // Mock getSections with the captured context
    when(mockDbHelper.getSections(testContext!, 'spell')).thenAnswer((_) async => Future.value(mockSpells));

    // Wait for the FutureBuilder to complete
    await tester.pumpAndSettle();

    // Verify the UI displays the expected spell names
    expect(find.text('Spells'), findsOneWidget);
    expect(find.text('Magic Missile'), findsOneWidget);
    expect(find.text('Fireball'), findsOneWidget);

    // Tap on 'Magic Missile' to trigger navigation
    await tester.tap(find.text('Magic Missile'));
    await tester.pumpAndSettle();

    // Verify that getSections was called with the correct context
    verify(mockDbHelper.getSections(testContext!, 'spell')).called(1);

    // Verify navigation to SpellDetailsScreen with correct parameters
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
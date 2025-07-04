import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_details_screen.dart';

// Generate mocks for DatabaseHelper
@GenerateMocks([DatabaseHelper])
import 'spell_list_screen_test.mocks.dart';

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

    // Mock getSections with any BuildContext
    when(mockDbHelper.getSections(any, 'spell')).thenAnswer((_) async => Future.value(mockSpells));

    await tester.pumpWidget(
      MaterialApp(
        home: SpellListScreen(dbHelper: mockDbHelper),
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

    // Wait for the FutureBuilder to complete
    await tester.pumpAndSettle();

    // Verify the UI displays the expected spell names
    expect(find.text('Spells'), findsOneWidget);
    expect(find.text('Magic Missile'), findsOneWidget);
    expect(find.text('Fireball'), findsOneWidget);

    // Tap on 'Magic Missile' to trigger navigation
    await tester.tap(find.text('Magic Missile'));
    await tester.pumpAndSettle();

    // Verify that getSections was called
    verify(mockDbHelper.getSections(any, 'spell')).called(1);

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
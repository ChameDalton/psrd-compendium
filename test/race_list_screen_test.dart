import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/race_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/race_details_screen.dart';

// Generate mocks for DatabaseHelper
@GenerateMocks([DatabaseHelper])
import 'race_list_screen_test.mocks.dart';

void main() {
  late MockDatabaseHelper mockDbHelper;

  setUp(() {
    mockDbHelper = MockDatabaseHelper();
  });

  testWidgets('RaceListScreen displays races and navigates to details', (WidgetTester tester) async {
    final mockRaces = [
      {'section_id': '1', 'name': 'Elf', 'type': 'race', 'parent_id': 701},
      {'section_id': '2', 'name': 'Dwarf', 'type': 'race', 'parent_id': 701},
    ];

    final mockRaceDetails = {
      'section': {
        'section_id': '1',
        'name': 'Elf',
        'source': 'PFRPG Core',
        'description': 'A graceful and long-lived race',
        'body': '<p>Known for agility and magic affinity.</p>',
      },
      'subsections': <Map<String, dynamic>>[], // Explicitly typed empty list
    };

    // Mock getSections and getSectionWithSubsections with any BuildContext
    when(mockDbHelper.getSections(any, 'race')).thenAnswer((_) async => Future.value(mockRaces));
    when(mockDbHelper.getSectionWithSubsections(any, '1')).thenAnswer((_) async => Future.value(mockRaceDetails));

    await tester.pumpWidget(
      MaterialApp(
        home: RaceListScreen(dbHelper: mockDbHelper),
        routes: {
          '/race_details': (context) => RaceDetailsScreen(
                raceId: ModalRoute.of(context)!.settings.arguments as String,
                dbHelper: mockDbHelper,
              ),
        },
      ),
    );

    // Wait for the FutureBuilder to complete
    await tester.pumpAndSettle();

    // Verify the UI displays the expected race names
    expect(find.text('Races'), findsOneWidget);
    expect(find.text('Elf'), findsOneWidget);
    expect(find.text('Dwarf'), findsOneWidget);

    // Tap on 'Elf' to trigger navigation
    await tester.tap(find.text('Elf'));
    await tester.pump(const Duration(milliseconds: 500)); // Longer delay for navigation
    await tester.pumpAndSettle(); // Wait for RaceDetailsScreen FutureBuilder
    debugPrint('Navigated to RaceDetailsScreen for raceId: 1');

    // Verify that getSections and getSectionWithSubsections were called
    verify(mockDbHelper.getSections(any, 'race')).called(1);
    verify(mockDbHelper.getSectionWithSubsections(any, '1')).called(1);

    // Verify navigation to RaceDetailsScreen with correct parameters
    expect(
      find.byWidgetPredicate(
        (widget) => widget is RaceDetailsScreen && widget.raceId == '1',
      ),
      findsOneWidget,
    );

    // Verify detail fields are displayed
    expect(find.text('Source: PFRPG Core'), findsOneWidget);
    expect(find.text('Description: A graceful and long-lived race'), findsOneWidget);
  });
}
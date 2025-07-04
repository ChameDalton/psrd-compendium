import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_details_screen.dart';

// Generate mocks for DatabaseHelper
@GenerateMocks([DatabaseHelper])
import 'class_list_screen_test.mocks.dart';

void main() {
  late MockDatabaseHelper mockDbHelper;

  setUp(() {
    mockDbHelper = MockDatabaseHelper();
  });

  testWidgets('ClassListScreen displays classes and navigates to details', (WidgetTester tester) async {
    final mockClasses = [
      {'section_id': '1', 'name': 'Bard', 'type': 'class', 'parent_id': 1636},
      {'section_id': '2', 'name': 'Cleric', 'type': 'class', 'parent_id': 1636},
    ];

    final mockClassDetails = {
      'section': {
        'section_id': '1',
        'name': 'Bard',
        'source': 'PFRPG Core',
        'description': 'A versatile performer',
        'body': '<p>Uses performances to inspire allies.</p>',
      },
      'subsections': <Map<String, dynamic>>[], // Explicitly typed empty list
    };

    // Mock getSections and getSectionWithSubsections with any BuildContext
    when(mockDbHelper.getSections(any, 'class')).thenAnswer((_) async => Future.value(mockClasses));
    when(mockDbHelper.getSectionWithSubsections(any, '1')).thenAnswer((_) async => Future.value(mockClassDetails));

    await tester.pumpWidget(
      MaterialApp(
        home: ClassListScreen(dbHelper: mockDbHelper),
        routes: {
          '/class_details': (context) => ClassDetailsScreen(
                classId: ModalRoute.of(context)!.settings.arguments as String,
                dbHelper: mockDbHelper,
              ),
        },
      ),
    );

    // Wait for the FutureBuilder to complete
    await tester.pumpAndSettle();

    // Verify the UI displays the expected class names
    expect(find.text('Classes'), findsOneWidget);
    expect(find.text('Bard'), findsOneWidget);
    expect(find.text('Cleric'), findsOneWidget);

    // Tap on 'Bard' to trigger navigation
    await tester.tap(find.text('Bard'));
    await tester.pump(const Duration(milliseconds: 500)); // Longer delay for navigation
    await tester.pumpAndSettle(); // Wait for ClassDetailsScreen FutureBuilder
    debugPrint('Navigated to ClassDetailsScreen for classId: 1');

    // Verify that getSections and getSectionWithSubsections were called
    verify(mockDbHelper.getSections(any, 'class')).called(1);
    verify(mockDbHelper.getSectionWithSubsections(any, '1')).called(1);

    // Verify navigation to ClassDetailsScreen with correct parameters
    expect(
      find.byWidgetPredicate(
        (widget) => widget is ClassDetailsScreen && widget.classId == '1',
      ),
      findsOneWidget,
    );

    // Verify detail fields are displayed
    expect(find.text('Source: PFRPG Core'), findsOneWidget); // Updated to match ClassDetailsScreen
    expect(find.text('Description: A versatile performer'), findsOneWidget);
  });
}
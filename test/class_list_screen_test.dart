import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_details_screen.dart';

// Mock DatabaseHelper for testing
class MockDatabaseHelper extends Mock implements DatabaseHelper {}

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

    // StatefulWidget to capture BuildContext
    BuildContext? testContext;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            testContext = context;
            return ClassListScreen(dbHelper: mockDbHelper);
          },
        ),
        // Define navigation route for ClassDetailsScreen
        routes: {
          '/class_details': (context) => ClassDetailsScreen(
                classId: ModalRoute.of(context)!.settings.arguments as String,
                dbHelper: mockDbHelper,
              ),
        },
      ),
    );

    // Ensure context is captured
    expect(testContext, isNotNull);

    // Mock getSections with the captured context
    when(mockDbHelper.getSections(testContext!, 'class')).thenAnswer((_) async => Future.value(mockClasses));

    // Wait for the FutureBuilder to complete
    await tester.pumpAndSettle();

    // Verify the UI displays the expected class names
    expect(find.text('Classes'), findsOneWidget);
    expect(find.text('Bard'), findsOneWidget);
    expect(find.text('Cleric'), findsOneWidget);

    // Tap on 'Bard' to trigger navigation
    await tester.tap(find.text('Bard'));
    await tester.pumpAndSettle();

    // Verify that getSections was called with the correct context
    verify(mockDbHelper.getSections(testContext!, 'class')).called(1);

    // Verify navigation to ClassDetailsScreen with correct parameters
    expect(
      find.byWidgetPredicate(
        (widget) => widget is ClassDetailsScreen && widget.classId == '1',
      ),
      findsOneWidget,
    );
  });
}
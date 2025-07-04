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

    // Mock getSections with any BuildContext
    when(mockDbHelper.getSections(any, 'class')).thenAnswer((_) async => Future.value(mockClasses));

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
    await tester.pumpAndSettle();

    // Verify that getSections was called
    verify(mockDbHelper.getSections(any, 'class')).called(1);

    // Verify navigation to ClassDetailsScreen with correct parameters
    expect(
      find.byWidgetPredicate(
        (widget) => widget is ClassDetailsScreen && widget.classId == '1',
      ),
      findsOneWidget,
    );
  });
}
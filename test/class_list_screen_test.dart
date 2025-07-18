import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'class_list_screen_test.mocks.dart';

@GenerateMocks([DbWrangler, Database, BuildContext])
void main() {
  setUpAll(() {
    sqfliteFfiInit();
  });

  testWidgets('ClassListScreen displays classes', (WidgetTester tester) async {
    final mockDbWrangler = MockDbWrangler();
    final mockDatabase = MockDatabase();
    final mockContext = MockBuildContext();

    when(mockDbWrangler.getDatabase(mockContext, 'index.db')).thenAnswer((_) async => mockDatabase);
    when(mockDbWrangler.getSections(any, 'class')).thenAnswer((_) async => [
          {'name': 'Wizard', 'url': 'wizard_url'},
          {'name': 'Fighter', 'url': 'fighter_url'},
        ]);

    await tester.pumpWidget(
      MaterialApp(
        home: ClassListScreen(dbWrangler: mockDbWrangler),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Wizard'), findsOneWidget);
    expect(find.text('Fighter'), findsOneWidget);
  });
}
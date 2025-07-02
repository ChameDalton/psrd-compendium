import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_details_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {
  @override
  Future<List<Map<String, dynamic>>> getSections(String type) async {
    return [
      {
        'section_id': 'class_456',
        'name': 'Fighter',
        'type': 'class',
        'source': 'Core Rulebook',
        'parent_id': null,
        'body': 'A versatile warrior.'
      }
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getSectionDetails(String parentId) async {
    return [
      {
        'section_id': 'detail_3',
        'name': 'Detail',
        'type': 'class_detail',
        'source': 'Core Rulebook',
        'parent_id': parentId,
        'body': 'Proficient with all weapons.'
      }
    ];
  }
}

void main() {
  setUp(() {
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('ClassListScreen displays classes and navigates to details', (WidgetTester tester) async {
    final mockDbHelper = MockDatabaseHelper();

    await tester.pumpWidget(
      const MaterialApp(
        home: ClassListScreen(dbHelper: mockDbHelper),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fighter'), findsOneWidget);
    expect(find.text('Core Rulebook'), findsOneWidget);

    await tester.tap(find.text('Fighter'));
    await tester.pumpAndSettle();

    expect(find.byType(ClassDetailsScreen), findsOneWidget);
    expect(find.text('Proficient with all weapons.'), findsOneWidget);
  });
}
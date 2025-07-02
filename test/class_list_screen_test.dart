import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/class_details_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {
  @override
  Future<List<Map<String, dynamic>>> getSections(BuildContext context, String type) async {
    return [
      {
        'section_id': 456,
        'name': 'Fighter',
        'type': 'class',
        'source': 'Core Rulebook',
        'parent_id': null,
        'body': 'A versatile warrior.'
      }
    ];
  }

  @override
  Future<Map<String, dynamic>> getSectionWithSubsections(BuildContext context, String sectionId) async {
    return {
      'section': {
        'section_id': 456,
        'name': 'Fighter',
        'type': 'class',
        'source': 'Core Rulebook',
        'parent_id': null,
        'body': 'A versatile warrior.'
      },
      'subsections': [
        {
          'section': {
            'section_id': 'detail_3',
            'name': 'Detail',
            'type': 'class_detail',
            'source': 'Core Rulebook',
            'parent_id': sectionId,
            'body': 'Proficient with all weapons.'
          },
          'subsections': [
            {
              'section': {
                'section_id': 'sub_detail_3',
                'name': 'Sub Detail',
                'type': 'class_sub_detail',
                'source': 'Core Rulebook',
                'parent_id': 'detail_3',
                'body': 'Includes martial weapons.'
              },
              'subsections': []
            }
          ]
        }
      ]
    };
  }

  @override
  Future<Database> database(BuildContext context) async {
    return await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  }
}

void main() {
  setUp(() {
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('ClassListScreen displays classes and navigates to details', (WidgetTester tester) async {
    final mockDbHelper = MockDatabaseHelper();

    await tester.pumpWidget(
      MaterialApp(
        home: ClassListScreen(dbHelper: mockDbHelper),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fighter'), findsOneWidget);
    expect(find.text('Core Rulebook'), findsOneWidget);

    await tester.tap(find.text('Fighter'));
    await tester.pumpAndSettle();

    expect(find.byType(ClassDetailsScreen), findsOneWidget);
    expect(find.text('A versatile warrior.'), findsOneWidget);
    expect(find.text('Proficient with all weapons.'), findsOneWidget);
    expect(find.text('Includes martial weapons.'), findsOneWidget);
  });
}
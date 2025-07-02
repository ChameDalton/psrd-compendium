import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/spell_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/spell_details_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {
  @override
  Future<List<Map<String, dynamic>>> getSections(String type) async {
    return [
      {
        'section_id': 123,
        'name': 'Magic Missile',
        'type': 'spell',
        'source': 'Core Rulebook',
        'parent_id': null,
        'body': 'Fires magic missiles.'
      }
    ];
  }

  @override
  Future<Map<String, dynamic>> getSectionWithSubsections(String sectionId) async {
    return {
      'section': {
        'section_id': 123,
        'name': 'Magic Missile',
        'type': 'spell',
        'source': 'Core Rulebook',
        'parent_id': null,
        'body': 'Fires magic missiles.'
      },
      'subsections': [
        {
          'section': {
            'section_id': 'detail_2',
            'name': 'Detail',
            'type': 'spell_detail',
            'source': 'Core Rulebook',
            'parent_id': sectionId,
            'body': 'Deals force damage.'
          },
          'subsections': [
            {
              'section': {
                'section_id': 'sub_detail_2',
                'name': 'Sub Detail',
                'type': 'spell_sub_detail',
                'source': 'Core Rulebook',
                'parent_id': 'detail_2',
                'body': '1d4+1 damage per missile.'
              },
              'subsections': []
            }
          ]
        }
      ]
    };
  }
}

void main() {
  setUp(() {
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('SpellListScreen displays spells and navigates to details', (WidgetTester tester) async {
    final mockDbHelper = MockDatabaseHelper();

    await tester.pumpWidget(
      MaterialApp(
        home: SpellListScreen(dbHelper: mockDbHelper),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Magic Missile'), findsOneWidget);
    expect(find.text('Core Rulebook'), findsOneWidget);

    await tester.tap(find.text('Magic Missile'));
    await tester.pumpAndSettle();

    expect(find.byType(SpellDetailsScreen), findsOneWidget);
    expect(find.text('Fires magic missiles.'), findsOneWidget);
    expect(find.text('Deals force damage.'), findsOneWidget);
    expect(find.text('1d4+1 damage per missile.'), findsOneWidget);
  });
}
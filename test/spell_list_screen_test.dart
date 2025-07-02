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
        'section_id': 'spell_123',
        'name': 'Magic Missile',
        'type': 'spell',
        'source': 'Core Rulebook',
        'parent_id': null,
        'body': 'Fires magic missiles.'
      }
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getSectionDetails(String parentId) async {
    return [
      {
        'section_id': 'detail_2',
        'name': 'Detail',
        'type': 'spell_detail',
        'source': 'Core Rulebook',
        'parent_id': parentId,
        'body': 'Deals force damage.'
      }
    ];
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
        home: SpellListScreen(),
        routes: {
          '/spell_details': (context) => SpellDetailsScreen(
                spellId: (ModalRoute.of(context)!.settings.arguments as Map)['spellId'],
              ),
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Magic Missile'), findsOneWidget);
    expect(find.text('Core Rulebook'), findsOneWidget);

    await tester.tap(find.text('Magic Missile'));
    await tester.pumpAndSettle();

    expect(find.byType(SpellDetailsScreen), findsOneWidget);
    expect(find.text('Deals force damage.'), findsOneWidget);
  });
}
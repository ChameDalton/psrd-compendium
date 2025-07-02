import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_details_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {
  @override
  Future<List<Map<String, dynamic>>> getSections(BuildContext context, String type) async {
    return [
      {
        'section_id': 1862,
        'name': 'Power Attack',
        'type': 'feat',
        'source': 'Core Rulebook',
        'parent_id': null,
        'body': 'You deal extra damage.'
      }
    ];
  }

  @override
  Future<Map<String, dynamic>> getSectionWithSubsections(BuildContext context, String sectionId) async {
    return {
      'section': {
        'section_id': 1862,
        'name': 'Power Attack',
        'type': 'feat',
        'source': 'Core Rulebook',
        'parent_id': null,
        'body': 'You deal extra damage.'
      },
      'subsections': [
        {
          'section': {
            'section_id': 'detail_1',
            'name': 'Detail',
            'type': 'feat_detail',
            'source': 'Core Rulebook',
            'parent_id': sectionId,
            'body': 'Extra damage on attack.'
          },
          'subsections': [
            {
              'section': {
                'section_id': 'sub_detail_1',
                'name': 'Sub Detail',
                'type': 'feat_sub_detail',
                'source': 'Core Rulebook',
                'parent_id': 'detail_1',
                'body': 'Applies to melee attacks.'
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

  testWidgets('FeatListScreen displays feats and navigates to details', (WidgetTester tester) async {
    final mockDbHelper = MockDatabaseHelper();

    await tester.pumpWidget(
      MaterialApp(
        home: FeatListScreen(dbHelper: mockDbHelper),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Power Attack'), findsOneWidget);
    expect(find.text('Core Rulebook'), findsOneWidget);

    await tester.tap(find.text('Power Attack'));
    await tester.pumpAndSettle();

    expect(find.byType(FeatDetailsScreen), findsOneWidget);
    expect(find.text('You deal extra damage.'), findsOneWidget);
    expect(find.text('Extra damage on attack.'), findsOneWidget);
    expect(find.text('Applies to melee attacks.'), findsOneWidget);
  });
}
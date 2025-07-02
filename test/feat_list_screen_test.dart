import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:pathfinder_athenaeum/screens/feat_details_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {
  @override
  Future<List<Map<String, dynamic>>> getSections(String type) async {
    return [
      {
        'section_id': 'feat_1862',
        'name': 'Power Attack',
        'type': 'feat',
        'source': 'Core Rulebook',
        'parent_id': null,
        'body': 'You deal extra damage.'
      }
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getSectionDetails(String parentId) async {
    return [
      {
        'section_id': 'detail_1',
        'name': 'Detail',
        'type': 'feat_detail',
        'source': 'Core Rulebook',
        'parent_id': parentId,
        'body': 'Extra damage on attack.'
      }
    ];
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
        routes: {
          '/feat_details': (context) => FeatDetailsScreen(
                featId: 'feat_1862',
                dbHelper: mockDbHelper,
              ),
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Power Attack'), findsOneWidget);
    expect(find.text('Core Rulebook'), findsOneWidget);

    await tester.tap(find.text('Power Attack'));
    await tester.pumpAndSettle();

    expect(find.byType(FeatDetailsScreen), findsOneWidget);
    expect(find.text('Extra damage on attack.'), findsOneWidget);
  });
}
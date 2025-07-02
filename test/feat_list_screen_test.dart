import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mockito/mockito.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {
  @override
  Future<List<Map<String, dynamic>>> getSections(String type) async {
    return [
      {
        'id': 'feat_1862',
        'name': 'Power Attack',
        'type': 'feat',
        'source': 'Core Rulebook',
        'parent_id': null,
        'body': 'You deal extra damage.'
      }
    ];
  }
}

void main() {
  setUp(() {
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('FeatListScreen displays feats', (WidgetTester tester) async {
    final mockDbHelper = MockDatabaseHelper();

    await tester.pumpWidget(
      MaterialApp(
        home: FeatListScreen(dbHelper: mockDbHelper),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Power Attack'), findsOneWidget);
    expect(find.text('Core Rulebook'), findsOneWidget);
  });
}
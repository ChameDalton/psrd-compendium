import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/db/db_wrangler.dart';
import 'package:pathfinder_athenaeum/screens/feat_list_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'feat_list_screen_test.mocks.dart';

@GenerateMocks([DbWrangler])
void main() {
  late MockDbWrangler mockDbWrangler;
  late Database mockDatabase;

  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    mockDbWrangler = MockDbWrangler();
    mockDatabase = await databaseFactory.openDatabase(inMemoryDatabasePath);

    when(mockDbWrangler.getBookDatabase(any)).thenReturn(mockDatabase);
  });

  testWidgets('FeatListScreen displays feats', (WidgetTester tester) async {
    when(mockDatabase.query('feats', orderBy: 'name')).thenAnswer(
      (_) async => [
        {'_id': 1, 'name': 'Dodge', 'type': 'Combat'},
        {'_id': 2, 'name': 'Power Attack', 'type': 'Combat'},
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: FeatListScreen(dbWrangler: mockDbWrangler),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Dodge'), findsOneWidget);
    expect(find.text('Power Attack'), findsOneWidget);
  });
}
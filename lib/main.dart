import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:pathfinder_athenaeum/main.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/class_list_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'main_test.mocks.dart';

@GenerateMocks([DbWrangler])
void main() {
  setUpAll(() {
    sqfliteFfiInit();
  });

  testWidgets('App navigates to ClassListScreen', (WidgetTester tester) async {
    final mockDbWrangler = MockDbWrangler();
    await tester.pumpWidget(MyApp(dbWrangler: mockDbWrangler));

    await tester.pumpAndSettle();

    expect(find.byType(ClassListScreen), findsOneWidget);
  });
}

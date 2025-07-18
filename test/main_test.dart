import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pathfinder_athenaeum/main.dart';
import 'package:pathfinder_athenaeum/services/database_helper.dart';
import 'package:pathfinder_athenaeum/screens/splash_screen.dart';
import 'package:pathfinder_athenaeum/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_test.mocks.dart';

@GenerateMocks([DbWrangler])
void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({'firstRun': true});
  });

  testWidgets('App navigates from SplashScreen to MainScreen', (WidgetTester tester) async {
    final mockDbWrangler = MockDbWrangler();
    final mockNavigatorObserver = MockNavigatorObserver();

    when(mockDbWrangler.initializeDatabases(any)).thenAnswer((_) async {});
    when(mockDbWrangler.getSections(any, 'class')).thenAnswer((_) async => [
          {'name': 'Wizard', 'url': 'wizard_url'},
          {'name': 'Fighter', 'url': 'fighter_url'},
        ]);

    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockNavigatorObserver],
        home: MyApp(dbWrangler: mockDbWrangler),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(MainScreen), findsOneWidget);
    expect(find.text('Classes'), findsOneWidget);
  });
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
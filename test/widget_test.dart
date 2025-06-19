import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pathfinder_athenaeum/main.dart';

void main() {
  testWidgets('HomeScreen displays categories', (WidgetTester tester) async {
    await tester.pumpWidget(const PathfinderApp());
    expect(find.text('Pathfinder Compendium'), findsOneWidget);
    expect(find.text('Spells'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
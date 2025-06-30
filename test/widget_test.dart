import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pathfinder_athenaeum/main.dart';

void main() {
  testWidgets('PathfinderApp builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(PathfinderApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
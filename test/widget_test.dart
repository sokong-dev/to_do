import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do/main.dart';

void main() {
  testWidgets('App should load and find controller', (
    WidgetTester tester,
  ) async {
    // Ensure bindings are initialized
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that core UI elements are present
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Add Task'), findsOneWidget);
  });
}

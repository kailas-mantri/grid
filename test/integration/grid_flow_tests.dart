import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grid/main.dart';

void gridFlowTests() {
  group('Grid App Integration Tests', () {
    // End to End Test case.
    testWidgets('Complete flow test', (WidgetTester tester) async {
      await tester.pumpWidget(const GridApp());

      // Wait for splash screen
      await tester.pump(const Duration(milliseconds: 5000));
      await tester.pumpAndSettle();

      // Enter grid dimensions
      await tester.enterText(
          find.widgetWithText(TextField, 'Enter number of rows (m)'), '2');
      await tester.enterText(
          find.widgetWithText(TextField, 'Enter number of columns (n)'), '2');
      await tester.tap(find.text('next'));
      await tester.pumpAndSettle();

      // Fill grid
      for (int i = 0; i < 4; i++) {
        await tester.enterText(find.byType(TextField).at(i), 'A');
      }
      await tester.tap(find.text('Create Grid'));
      await tester.pumpAndSettle();

      // Perform search
      await tester.enterText(
          find.widgetWithText(TextField, 'Enter word to search'), 'AA');
      await tester.pumpAndSettle();

      // Verify results
      expect(find.byType(GridView), findsOneWidget);

      // Test reset
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      expect(find.byType(GridScreen), findsOneWidget);
    });
  });
}
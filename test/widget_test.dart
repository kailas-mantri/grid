import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grid/main.dart';

import 'integration/grid_flow_tests.dart';
import 'unit/grid_search_tests.dart';

void main() {
  group("Grid application test", () {
    group("Widget test", () {
      testWidgets("App should load correctly", (tester) async {
        await tester.pumpWidget(const MaterialApp(home: GridApp()));
        expect(find.text('Welcome to Grid Search App'), findsOneWidget);
        expect(find.byType(SplashScreen), findsOneWidget);

        //wait for splash screen durations
        await tester.pump(const Duration(milliseconds: 5000));
        await tester.pumpAndSettle();

        expect(find.byType(GridScreen), findsOneWidget);
      });

      testWidgets('Grid dimension input validation', (tester) async {
        await tester.pumpWidget(const MaterialApp(home: GridScreen()));
        // Find text fields
        final rField =
            find.widgetWithText(TextField, "Enter number of rows (m)");
        final col =
            find.widgetWithText(TextField, "Enter number of columns (n)");

        // Test invalid input: negative and non-numeric
        await tester.enterText(rField, "-1");
        await tester.enterText(col, "3");
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(find.text("Please enter valid numbers for row and columns"),
            findsOneWidget);

        await tester.enterText(rField, "a");
        await tester.enterText(col, "3");
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(find.text("Please enter valid numbers for row and columns"),
            findsOneWidget);

        // Test valid input
        await tester.enterText(rField, "3");
        await tester.enterText(col, "3");
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Verify navigation to GridEntryScreen
        expect(find.byType(GridEntryScreen), findsOneWidget);
      });

      /*gridAppTest();*/
    });

    group('Unit Test', () {
      gridSearchTests(); // Unit tests
    });

    group("Integration Test", () {
      gridFlowTests(); // Integration tests
    });
  });
}

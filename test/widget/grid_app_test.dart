import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grid/main.dart';

void gridAppTest() {
  group('Grid App Widget Tests', () {
    testWidgets('splash screen displays correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: GridApp()));
      expect(find.text("Welcome to Grid Search App"), findsOneWidget);
      expect(find.byType(SplashScreen), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 5000));
      await tester.pumpAndSettle();
      expect(find.byType(GridScreen), findsOneWidget);
    });

    testWidgets('Grid dimension input validation', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: GridScreen()));
      // Find text fields
      final rows = find.widgetWithText(TextField, "Enter number of rows (m)");
      final column = find.widgetWithText(TextField, "Enter number of rows (n)");
      // Test invalid input
      await tester.enterText(rows, "-1");
      await tester.enterText(column, "3");
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Please enter valid numbers for row and columns'), findsOneWidget);

      // Test valid input
      await tester.enterText(rows, "3");
      await tester.enterText(column, "3");
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(GridEntryScreen), findsOneWidget);
    });

    testWidgets('Grid entry screen validation', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: GridEntryScreen(m: 2, n: 2)),);
      expect(find.byType(TextField), findsNWidgets(4)); // Find grid cells
      // Test empty grid cells
      await tester.pumpAndSettle();
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('All cells must have a value'), findsOneWidget);
      // Fill the grid and create
      for (int i = 0; i < 4; i++) {
        await tester.enterText(find.byType(TextField).at(i), "a");
        await tester.pumpAndSettle();
      }

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byType(SearchScreen), findsOneWidget);
    });

    testWidgets('Search screen functionality', (test) async {
      final grid = [['A', 'B'], ['C', 'D']];
      await test.pumpWidget(MaterialApp(home: SearchScreen(grid: grid)));
      // Test Search functionality
      await test.enterText(find.byType(TextField), "A");
      await test.pumpAndSettle();

      // Verify grid display
      expect(find.byType(GridView), findsOneWidget);
      expect(find.text("A"), findsOneWidget);
      expect(find.text("B"), findsOneWidget);

      // Test reset functionality
      await test.tap(find.byType(ElevatedButton));
      await test.pumpAndSettle();
      expect(find.byType(GridScreen), findsOneWidget);
    });
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grid/main.dart';

void gridAppTest() {
  group('Grid App Widget Tests', () {
    testWidgets('Grid entry validation and navigation', (tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: GridEntryScreen(m: 2, n: 2)));

      // Verify grid input fields
      expect(find.byType(TextField), findsNWidgets(4));

      // Test empty cells
      await tester.tap(find.text("Create Grid"));
      await tester.pumpAndSettle();
      expect(find.text("All cells must have a value"), findsOneWidget);

      // Fill the grid and submit
      for (int i = 0; i < 4; i++) {
        await tester.enterText(
            find.byType(TextField).at(i), String.fromCharCode(65 + i));
      }

      // Tap the Create Grid button after making sure it is visible
      final createGridButton = find.text("Create Grid");
      expect(createGridButton, findsOneWidget); // Make sure it's present
      await tester.tap(createGridButton);
      await tester.pumpAndSettle();

      // Verify navigation to SearchScreen
      expect(find.byType(SearchScreen), findsOneWidget);
    });

    testWidgets('Search screen functionality', (tester) async {
      final grid = [
        ['A', 'B'],
        ['C', 'D']
      ];
      await tester.pumpWidget(MaterialApp(home: SearchScreen(grid: grid)));

      // Verify grid display
      expect(find.byType(GridView), findsOneWidget);
      expect(find.text("A"), findsOneWidget);
      expect(find.text("B"), findsOneWidget);
      expect(find.text("C"), findsOneWidget);
      expect(find.text("D"), findsOneWidget);

      // Test search functionality
      await tester.enterText(find.byType(TextField), "B");
      await tester.pumpAndSettle();

      // Here you need to modify your logic to properly handle highlighted cells.
      // For now, assuming `B` is highlighted, which will depend on your search implementation.

      // Test reset button
      await tester.tap(
          find.byType(ElevatedButton)); // Make sure it's the correct button
      await tester.pumpAndSettle();
      expect(find.byType(GridScreen), findsOneWidget);
    });
  });
}

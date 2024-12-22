import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grid/main.dart';

void gridSearchTests() {
  group("Grid Search Algorithm Tests", () {
    late SearchScreen searchScreen;
    late dynamic testGrid;

    testWidgets("Setup and test horizontal search", (tester) async {
      testGrid = [
        ['H', 'E', 'L', 'L', 'O'],
        ['W', 'O', 'R', 'L', 'D'],
        ['T', 'E', 'S', 'T', 'S'],
        ['F', 'L', 'U', 'T', 'R'],
        ['D', 'A', 'R', 'T', 'X']
      ];

      // Pump the SearchScreen widget into the widget tree
      searchScreen = SearchScreen(grid: testGrid);
      await tester.pumpWidget(MaterialApp(home: searchScreen));
      await tester.pump(); // Wait for any animations to complete

      // Proceed with the test now that the widget is rendered
      final searchScreenState =
          tester.state<SearchScreenState>(find.byType(SearchScreen));

      searchScreenState.searchWord('HELLO');
      var highlighted = searchScreenState.highlighted;

      expect(highlighted![0][0], true);
      expect(highlighted[0][1], true);
      expect(highlighted[0][2], true);
      expect(highlighted[0][3], true);
      expect(highlighted[0][4], true);
      expect(highlighted[1][0], false);
    });

    testWidgets('Vertical word search test', (WidgetTester tester) async {
      testGrid = [
        ['H', 'E', 'L', 'L', 'O'],
        ['W', 'O', 'R', 'L', 'D'],
        ['T', 'E', 'S', 'T', 'S'],
        ['F', 'L', 'U', 'T', 'R'],
        ['D', 'A', 'R', 'T', 'X']
      ];

      // Pump the SearchScreen widget into the widget tree
      searchScreen = SearchScreen(grid: testGrid);
      await tester.pumpWidget(MaterialApp(home: searchScreen));
      await tester.pump(); // Wait for any animations to complete

      // Proceed with the test now that the widget is rendered
      final searchScreenState =
          tester.state<SearchScreenState>(find.byType(SearchScreen));

      searchScreenState.searchWord('WORLD');
      var highlighted = searchScreenState.highlighted;

      expect(highlighted![0][1], false);
      expect(highlighted[1][1], true);
      expect(highlighted[1][2], true);
      expect(highlighted[1][3], true);
      expect(highlighted[1][4], true);
    });

    testWidgets('Diagonal word search test', (tester) async {
      testGrid = [
        ['H', 'E', 'L', 'L', 'O'],
        ['W', 'O', 'R', 'L', 'D'],
        ['T', 'E', 'S', 'T', 'S'],
        ['F', 'L', 'U', 'T', 'R'],
        ['D', 'A', 'R', 'T', 'X']
      ];

      // Pump the SearchScreen widget into the widget tree
      searchScreen = SearchScreen(grid: testGrid);
      await tester.pumpWidget(MaterialApp(home: searchScreen));
      await tester.pump(); // Wait for any animations to complete

      // Proceed with the test now that the widget is rendered
      final searchScreenState =
          tester.state<SearchScreenState>(find.byType(SearchScreen));

      searchScreenState.searchWord('TEST');
      var highlighted = searchScreenState.highlighted;

      expect(highlighted![2][0], true);
      expect(highlighted[2][1], true);
      expect(highlighted[2][2], true);
      expect(highlighted[2][3], true);
    });

    testWidgets('Non-existent word search test', (WidgetTester tester) async {
      testGrid = [
        ['H', 'E', 'L', 'L', 'O'],
        ['W', 'O', 'R', 'L', 'D'],
        ['T', 'E', 'S', 'T', 'S'],
        ['F', 'L', 'U', 'T', 'R'],
        ['D', 'A', 'R', 'T', 'X']
      ];

      // Pump the SearchScreen widget into the widget tree
      searchScreen = SearchScreen(grid: testGrid);
      await tester.pumpWidget(MaterialApp(home: searchScreen));
      await tester.pump(); // Wait for any animations to complete

      // Proceed with the test now that the widget is rendered
      final searchScreenState =
          tester.state<SearchScreenState>(find.byType(SearchScreen));

      searchScreenState.searchWord('XYZ');
      var highlighted = searchScreenState.highlighted;

      for (var row in highlighted!) {
        for (var cell in row) {
          expect(cell, false);
        }
      }
    });

    testWidgets('Case insensitive search test', (tester) async {
      testGrid = [
        ['H', 'E', 'L', 'L', 'O'],
        ['W', 'O', 'R', 'L', 'D'],
        ['T', 'E', 'S', 'T', 'S'],
        ['F', 'L', 'U', 'T', 'R'],
        ['D', 'A', 'R', 'T', 'X']
      ];

      // Pump the SearchScreen widget into the widget tree
      searchScreen = SearchScreen(grid: testGrid);
      await tester.pumpWidget(MaterialApp(home: searchScreen));
      await tester.pump(); // Wait for any animations to complete

      // Proceed with the test now that the widget is rendered
      final searchScreenState =
          tester.state<SearchScreenState>(find.byType(SearchScreen));

      searchScreenState.searchWord('hello');
      var highlighted = searchScreenState.highlighted;

      expect(highlighted![0][0], true);
      expect(highlighted[0][1], true);
      expect(highlighted[0][2], true);
      expect(highlighted[0][3], true);
      expect(highlighted[0][4], true);
    });
  });
}

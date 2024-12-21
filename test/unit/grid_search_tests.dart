import 'package:flutter_test/flutter_test.dart';
import 'package:grid/main.dart';

void gridSearchTests() {
  group("Grid Search Algorithm Tests", () {
    late SearchScreenState searchScreenState;
    late List<List<String>> testGrid;

    setUp(() {
      testGrid = [
        ['H', 'E', 'L', 'L', 'O'],
        ['W', 'O', 'R', 'L', 'D'],
        ['T', 'E', 'S', 'T', 'S'],
        ['F', 'L', 'U', 'T', 'R'],
        ['D', 'A', 'R', 'T', 'X']
      ];

      final searchScreen = SearchScreen(grid: testGrid);
      searchScreenState = searchScreen.createState();

      // Manually call initState if necessary
      /* searchScreenState.initState();
      searchScreenState.setState(() {
        searchScreenState.searchWord('');
      });*/
    });

    test('Horizontal word search test', () {
      searchScreenState.searchWord('HELLO');
      var highlighted = searchScreenState.highlighted;

      expect(highlighted![0][0], true);
      expect(highlighted[0][1], true);
      expect(highlighted[0][2], true);
      expect(highlighted[0][3], true);
      expect(highlighted[0][4], true);
      expect(highlighted[1][0], false);
    });

    test('Vertical word search test', () {
      searchScreenState.searchWord('WORLD');
      var highlighted = searchScreenState.highlighted;

      expect(highlighted![0][1], false);
      expect(highlighted[1][1], true);
      expect(highlighted[1][2], true);
      expect(highlighted[1][3], true);
      expect(highlighted[1][4], true);
    });

    test('Diagonal word search test', () {
      searchScreenState.searchWord('TEST');
      var highlighted = searchScreenState.highlighted;

      expect(highlighted![2][0], true);
      expect(highlighted[2][1], true);
      expect(highlighted[2][2], true);
      expect(highlighted[2][3], true);
    });

    test('Non-existent word search test', () {
      searchScreenState.searchWord('XYZ');
      var highlighted = searchScreenState.highlighted;

      for (var row in highlighted!) {
        for (var cell in row) {
          expect(cell, false);
        }
      }
    });

    test('Case insensitive search test', () {
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
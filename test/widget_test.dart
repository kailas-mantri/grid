import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grid/main.dart';

import 'integration/grid_flow_tests.dart';
import 'unit/grid_search_tests.dart';
import 'widget/grid_app_test.dart';


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

      gridAppTest();
    });

    group('Unit Test', () {
      gridSearchTests(); // Unit tests
    });

    group("Integration Test", () {
      gridFlowTests(); // Integration tests
    });
  });
}

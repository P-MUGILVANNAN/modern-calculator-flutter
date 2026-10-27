import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcpro/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget createTestWidget() {
    return const CalcProApp();
  }

  group('CalcPro UI Widget Tests', () {
    testWidgets('App renders title and display initially', (tester) async {
      tester.view.physicalSize = const Size(420, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('CalcPro'), findsOneWidget);
      expect(find.byKey(const Key('calculator_result_text')), findsOneWidget);
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('Tapping digits and operators performs calculation', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(420, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap '5'
      await tester.tap(find.widgetWithText(GestureDetector, '5'));
      await tester.pumpAndSettle();

      // Tap '×'
      await tester.tap(find.widgetWithText(GestureDetector, '×'));
      await tester.pumpAndSettle();

      // Tap '6'
      await tester.tap(find.widgetWithText(GestureDetector, '6'));
      await tester.pumpAndSettle();

      // Tap '='
      await tester.tap(find.widgetWithText(GestureDetector, '='));
      await tester.pumpAndSettle();

      // Result should be 30
      expect(find.text('30'), findsOneWidget);
    });

    testWidgets('Clear button (AC) resets calculation display', (tester) async {
      tester.view.physicalSize = const Size(420, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(GestureDetector, '9'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(GestureDetector, '9'));
      await tester.pumpAndSettle();

      expect(find.text('99'), findsWidgets);

      // Tap 'AC'
      await tester.tap(find.widgetWithText(GestureDetector, 'AC'));
      await tester.pumpAndSettle();

      expect(find.text('99'), findsNothing);
      expect(find.text('0'), findsWidgets);
    });

    testWidgets(
      'Scientific mode toggle switches between scientific and basic modes',
      (tester) async {
        tester.view.physicalSize = const Size(420, 900);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Initially in Basic Mode -> tooltip is 'Scientific Mode'
        expect(find.byTooltip('Scientific Mode'), findsOneWidget);

        // Tap scientific mode toggle in AppBar
        await tester.tap(find.byTooltip('Scientific Mode'));
        await tester.pumpAndSettle();

        // Now mode is Scientific -> tooltip changes to 'Basic Mode'
        expect(find.byTooltip('Basic Mode'), findsOneWidget);

        // Tap again to switch back
        await tester.tap(find.byTooltip('Basic Mode'));
        await tester.pumpAndSettle();

        expect(find.byTooltip('Scientific Mode'), findsOneWidget);
      },
    );

    testWidgets('Theme toggle switches theme dynamically', (tester) async {
      tester.view.physicalSize = const Size(420, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap theme toggle button in AppBar
      await tester.tap(find.byTooltip('Toggle Theme'));
      await tester.pumpAndSettle();

      // Theme toggles without crashing
      expect(find.byType(CalcProApp), findsOneWidget);
    });

    testWidgets('Opening history screen shows empty state initially', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(420, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap history button
      await tester.tap(find.byIcon(Icons.history_rounded));
      await tester.pumpAndSettle();

      expect(find.text('History'), findsOneWidget);
      expect(find.text('No Calculations Yet'), findsOneWidget);
    });

    testWidgets('Responsive test on compact screen (no overflow)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Verify no RenderFlex overflow
      expect(tester.takeException(), isNull);
    });
  });
}

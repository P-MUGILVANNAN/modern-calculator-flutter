import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcpro/app.dart';
import 'package:calcpro/features/history/services/history_storage.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete User Journey: Calculate, Persist History, Recreate State, and Change Theme', (tester) async {
    // Step 0: In-memory mock SharedPreferences for test repeatability
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final storage = HistoryStorage(prefs);

    tester.view.physicalSize = const Size(420, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Step 1: Launch the application
    await tester.pumpWidget(CalcProApp(
      prefs: prefs,
      historyStorage: storage,
    ));
    await tester.pumpAndSettle();

    expect(find.text('CalcPro'), findsOneWidget);
    expect(find.byKey(const Key('calculator_result_text')), findsOneWidget);

    // Step 2: Enter an expression: 12 × 4
    await tester.tap(find.widgetWithText(GestureDetector, '1'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(GestureDetector, '2'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(GestureDetector, '×'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(GestureDetector, '4'));
    await tester.pumpAndSettle();

    // Step 3: Calculate the result (=)
    await tester.tap(find.widgetWithText(GestureDetector, '='));
    await tester.pumpAndSettle();

    // Verify result is 48
    expect(find.text('48'), findsOneWidget);

    // Step 4: View the calculation in history
    await tester.tap(find.byIcon(Icons.history_rounded));
    await tester.pumpAndSettle();

    // Verify history shows 12 × 4 = 48
    expect(find.text('History'), findsOneWidget);
    expect(find.text('12 × 4'), findsOneWidget);
    expect(find.text('= 48'), findsOneWidget);

    // Return to main calculator
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Step 5: Restart or recreate the application state
    await tester.pumpWidget(CalcProApp(
      prefs: prefs,
      historyStorage: storage,
    ));
    await tester.pumpAndSettle();

    // Step 6: Verify persistent history remains available after recreation
    await tester.tap(find.byIcon(Icons.history_rounded));
    await tester.pumpAndSettle();

    expect(find.text('12 × 4'), findsOneWidget);
    expect(find.text('= 48'), findsOneWidget);

    // Return to main calculator
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // Step 7: Change theme and verify setting persists
    await tester.tap(find.byTooltip('Toggle Theme'));
    await tester.pumpAndSettle();

    // Verify preference is persisted to SharedPreferences
    final persistedTheme = prefs.getString('calcpro_pref_theme');
    expect(persistedTheme, isNotNull);
    expect(persistedTheme, 'light');
  });
}

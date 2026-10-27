import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcpro/features/calculator/models/calculator_mode.dart';
import 'package:calcpro/features/calculator/providers/calculator_provider.dart';
import 'package:calcpro/features/history/providers/history_provider.dart';
import 'package:calcpro/features/history/services/history_storage.dart';
import 'package:calcpro/features/settings/providers/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CalculatorProvider', () {
    late SettingsProvider settingsProvider;
    late HistoryProvider historyProvider;
    late CalculatorProvider calculatorProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      settingsProvider = SettingsProvider(prefs);
      final storage = HistoryStorage(prefs);
      historyProvider = HistoryProvider(storage);
      calculatorProvider = CalculatorProvider(
        settingsProvider: settingsProvider,
        historyProvider: historyProvider,
      );
    });

    test('Initial state is empty expression and 0 result', () {
      expect(calculatorProvider.state.expression, '');
      expect(calculatorProvider.state.result, '0');
      expect(calculatorProvider.state.isEvaluated, isFalse);
    });

    test('Input digits and operators', () {
      calculatorProvider.inputDigit('2');
      calculatorProvider.inputOperator('+');
      calculatorProvider.inputDigit('3');
      expect(calculatorProvider.state.expression, '2 + 3');
      expect(calculatorProvider.state.previewResult, '5');
    });

    test('Evaluate calculates result and saves to history', () {
      calculatorProvider.inputDigit('4');
      calculatorProvider.inputOperator('×');
      calculatorProvider.inputDigit('5');
      calculatorProvider.evaluate();

      expect(calculatorProvider.state.result, '20');
      expect(calculatorProvider.state.isEvaluated, isTrue);
      expect(historyProvider.items.length, 1);
      expect(historyProvider.items.first.expression, '4 × 5');
      expect(historyProvider.items.first.result, '20');
    });

    test('Continuous calculation starts from previous result', () {
      calculatorProvider.inputDigit('1');
      calculatorProvider.inputDigit('0');
      calculatorProvider.evaluate();
      expect(calculatorProvider.state.result, '10');

      // Now tap an operator
      calculatorProvider.inputOperator('+');
      calculatorProvider.inputDigit('5');
      calculatorProvider.evaluate();
      expect(calculatorProvider.state.result, '15');
    });

    test('New number after evaluation starts fresh expression', () {
      calculatorProvider.inputDigit('9');
      calculatorProvider.evaluate();
      expect(calculatorProvider.state.result, '9');

      // Type new number
      calculatorProvider.inputDigit('3');
      expect(calculatorProvider.state.expression, '3');
      expect(calculatorProvider.state.isEvaluated, isFalse);
    });

    test('Decimal point prevention of repeated dots', () {
      calculatorProvider.inputDigit('5');
      calculatorProvider.inputDecimal();
      calculatorProvider.inputDigit('2');
      calculatorProvider.inputDecimal(); // should be ignored
      expect(calculatorProvider.state.expression, '5.2');
    });

    test('Backspace removes last character or operator', () {
      calculatorProvider.inputDigit('7');
      calculatorProvider.inputOperator('+');
      calculatorProvider.inputDigit('8');
      calculatorProvider.deleteLast();
      expect(calculatorProvider.state.expression, '7 + ');
      calculatorProvider.deleteLast();
      expect(calculatorProvider.state.expression, '7');
    });

    test('Clear All resets state', () {
      calculatorProvider.inputDigit('9');
      calculatorProvider.inputOperator('×');
      calculatorProvider.inputDigit('9');
      calculatorProvider.clearAll();
      expect(calculatorProvider.state.expression, '');
      expect(calculatorProvider.state.result, '0');
    });

    test('Memory functions (M+, MR, M-, MC)', () {
      calculatorProvider.inputDigit('5');
      calculatorProvider.inputDigit('0');
      calculatorProvider.evaluate();

      calculatorProvider.memoryAdd();
      expect(calculatorProvider.state.hasMemory, isTrue);
      expect(calculatorProvider.state.memoryValue, 50.0);

      calculatorProvider.clearAll();
      calculatorProvider.memoryRecall();
      expect(calculatorProvider.state.expression, '50');

      calculatorProvider.memoryClear();
      expect(calculatorProvider.state.hasMemory, isFalse);
    });

    test('Toggle between basic and scientific mode', () {
      expect(calculatorProvider.mode, CalculatorMode.basic);
      calculatorProvider.toggleMode();
      expect(calculatorProvider.mode, CalculatorMode.scientific);
      calculatorProvider.toggleMode();
      expect(calculatorProvider.mode, CalculatorMode.basic);
    });
  });
}

import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:calcpro/core/constants/app_strings.dart';
import 'package:calcpro/features/calculator/models/angle_mode.dart';
import 'package:calcpro/features/calculator/services/calculation_engine.dart';

void main() {
  group('CalculationEngine - Basic Arithmetic', () {
    test('2 + 3 = 5', () {
      final res = CalculationEngine.evaluate('2 + 3');
      expect(res.isSuccess, isTrue);
      expect(res.value, 5.0);
    });

    test('10 − 4 = 6', () {
      final res = CalculationEngine.evaluate('10 − 4');
      expect(res.isSuccess, isTrue);
      expect(res.value, 6.0);
    });

    test('6 × 7 = 42', () {
      final res = CalculationEngine.evaluate('6 × 7');
      expect(res.isSuccess, isTrue);
      expect(res.value, 42.0);
    });

    test('20 ÷ 4 = 5', () {
      final res = CalculationEngine.evaluate('20 ÷ 4');
      expect(res.isSuccess, isTrue);
      expect(res.value, 5.0);
    });

    test('Operator precedence: 2 + 3 × 4 = 14', () {
      final res = CalculationEngine.evaluate('2 + 3 × 4');
      expect(res.isSuccess, isTrue);
      expect(res.value, 14.0);
    });

    test('Parentheses override: (2 + 3) × 4 = 20', () {
      final res = CalculationEngine.evaluate('(2 + 3) × 4');
      expect(res.isSuccess, isTrue);
      expect(res.value, 20.0);
    });

    test('Unary minus: −5 + 2 = −3', () {
      final res = CalculationEngine.evaluate('−5 + 2');
      expect(res.isSuccess, isTrue);
      expect(res.value, -3.0);
    });

    test('Decimals: 0.1 + 0.2 formatted', () {
      final res = CalculationEngine.evaluate('0.1 + 0.2');
      expect(res.isSuccess, isTrue);
      expect(res.toDisplayString(decimalPrecision: 1), '0.3');
    });

    test('Division by zero produces controlled error', () {
      final res = CalculationEngine.evaluate('20 ÷ 0');
      expect(res.isSuccess, isFalse);
      expect(res.error, AppStrings.errorDivZero);
    });
  });

  group('CalculationEngine - Percentage Calculations', () {
    test('50% * 200 = 100', () {
      final res = CalculationEngine.evaluate('50% * 200');
      expect(res.isSuccess, isTrue);
      expect(res.value, 100.0);
    });

    test('200 * 50% = 100', () {
      final res = CalculationEngine.evaluate('200 * 50%');
      expect(res.isSuccess, isTrue);
      expect(res.value, 100.0);
    });

    test('Additive percentage: 200 + 10% = 220', () {
      final res = CalculationEngine.evaluate('200 + 10%');
      expect(res.isSuccess, isTrue);
      expect(res.value, 220.0);
    });

    test('Subtractive percentage: 200 - 10% = 180', () {
      final res = CalculationEngine.evaluate('200 - 10%');
      expect(res.isSuccess, isTrue);
      expect(res.value, 180.0);
    });

    test('Standalone percentage: 50% = 0.5', () {
      final res = CalculationEngine.evaluate('50%');
      expect(res.isSuccess, isTrue);
      expect(res.value, 0.5);
    });
  });

  group('CalculationEngine - Scientific Functions', () {
    test('Square root: √25 = 5', () {
      final res = CalculationEngine.evaluate('√(25)');
      expect(res.isSuccess, isTrue);
      expect(res.value, 5.0);
    });

    test('Power: 3^2 = 9', () {
      final res = CalculationEngine.evaluate('3^2');
      expect(res.isSuccess, isTrue);
      expect(res.value, 9.0);
    });

    test('Log base 10: log(100) = 2', () {
      final res = CalculationEngine.evaluate('log(100)');
      expect(res.isSuccess, isTrue);
      expect(res.value, closeTo(2.0, 1e-9));
    });

    test('Natural log: ln(e) = 1', () {
      final res = CalculationEngine.evaluate('ln(e)');
      expect(res.isSuccess, isTrue);
      expect(res.value, closeTo(1.0, 1e-9));
    });

    test('Trigonometry Degrees: sin(30) = 0.5, cos(60) = 0.5, tan(45) = 1', () {
      final sinRes = CalculationEngine.evaluate(
        'sin(30)',
        angleMode: AngleMode.degrees,
      );
      expect(sinRes.isSuccess, isTrue);
      expect(sinRes.value, closeTo(0.5, 1e-9));

      final cosRes = CalculationEngine.evaluate(
        'cos(60)',
        angleMode: AngleMode.degrees,
      );
      expect(cosRes.isSuccess, isTrue);
      expect(cosRes.value, closeTo(0.5, 1e-9));

      final tanRes = CalculationEngine.evaluate(
        'tan(45)',
        angleMode: AngleMode.degrees,
      );
      expect(tanRes.isSuccess, isTrue);
      expect(tanRes.value, closeTo(1.0, 1e-9));
    });

    test('Trigonometry Radians: sin(pi / 2) = 1', () {
      final res = CalculationEngine.evaluate(
        'sin(pi / 2)',
        angleMode: AngleMode.radians,
      );
      expect(res.isSuccess, isTrue);
      expect(res.value, closeTo(1.0, 1e-9));
    });

    test('Inverse Trig: asin(0.5) in degrees = 30', () {
      final res = CalculationEngine.evaluate(
        'asin(0.5)',
        angleMode: AngleMode.degrees,
      );
      expect(res.isSuccess, isTrue);
      expect(res.value, closeTo(30.0, 1e-9));
    });

    test('Factorial: 5! = 120 and 0! = 1', () {
      final res5 = CalculationEngine.evaluate('5!');
      expect(res5.isSuccess, isTrue);
      expect(res5.value, 120.0);

      final res0 = CalculationEngine.evaluate('0!');
      expect(res0.isSuccess, isTrue);
      expect(res0.value, 1.0);
    });

    test('Cube root: cbrt(27) = 3 and cbrt(-8) = -2', () {
      final resPos = CalculationEngine.evaluate('cbrt(27)');
      expect(resPos.isSuccess, isTrue);
      expect(resPos.value, closeTo(3.0, 1e-9));

      final resNeg = CalculationEngine.evaluate('cbrt(-8)');
      expect(resNeg.isSuccess, isTrue);
      expect(resNeg.value, closeTo(-2.0, 1e-9));
    });

    test('Constants: pi and e', () {
      final resPi = CalculationEngine.evaluate('pi');
      expect(resPi.value, closeTo(math.pi, 1e-9));

      final resE = CalculationEngine.evaluate('e');
      expect(resE.value, closeTo(math.e, 1e-9));
    });
  });

  group('CalculationEngine - Domain Errors & Validation', () {
    test('Negative square root gives domain error', () {
      final res = CalculationEngine.evaluate('sqrt(-4)');
      expect(res.isSuccess, isFalse);
      expect(res.error, AppStrings.errorDomain);
    });

    test('Logarithm of zero or negative gives domain error', () {
      final resZero = CalculationEngine.evaluate('log(0)');
      expect(resZero.isSuccess, isFalse);
      expect(resZero.error, AppStrings.errorDomain);

      final resNeg = CalculationEngine.evaluate('ln(-5)');
      expect(resNeg.isSuccess, isFalse);
      expect(resNeg.error, AppStrings.errorDomain);
    });

    test('tan(90) in degrees gives division by zero', () {
      final res = CalculationEngine.evaluate(
        'tan(90)',
        angleMode: AngleMode.degrees,
      );
      expect(res.isSuccess, isFalse);
      expect(res.error, AppStrings.errorDivZero);
    });

    test('Factorial of negative or non-integer gives domain error', () {
      final resNeg = CalculationEngine.evaluate('(-3)!');
      expect(resNeg.isSuccess, isFalse);
      expect(resNeg.error, AppStrings.errorDomain);

      final resFloat = CalculationEngine.evaluate('3.5!');
      expect(resFloat.isSuccess, isFalse);
      expect(resFloat.error, AppStrings.errorDomain);
    });

    test('Malformed/invalid expression is rejected', () {
      final res = CalculationEngine.evaluate('2 + * 3');
      expect(res.isSuccess, isFalse);
      expect(res.error, AppStrings.errorInvalid);
    });
  });

  group('CalculationEngine - Live Preview', () {
    test('Previews valid expression while typing', () {
      final preview = CalculationEngine.previewEvaluate('2 + 3 * 4');
      expect(preview, 14.0);
    });

    test('Auto-closes open parentheses during typing', () {
      final preview = CalculationEngine.previewEvaluate('(5 + 5');
      expect(preview, 10.0);
    });

    test('Ignores trailing operator cleanly', () {
      final preview = CalculationEngine.previewEvaluate('10 + 20 +');
      expect(preview, 30.0);
    });
  });
}

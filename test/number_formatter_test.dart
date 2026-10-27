import 'package:flutter_test/flutter_test.dart';
import 'package:calcpro/core/utils/number_formatter.dart';

void main() {
  group('NumberFormatter', () {
    test('Formats integer with thousands separator', () {
      final res = NumberFormatter.format(1234567, useThousandsSeparator: true);
      expect(res, '1,234,567');
    });

    test('Formats integer without thousands separator', () {
      final res = NumberFormatter.format(1234567, useThousandsSeparator: false);
      expect(res, '1234567');
    });

    test('Formats decimals cleanly stripping trailing zeros', () {
      final res = NumberFormatter.format(12.34000);
      expect(res, '12.34');
    });

    test('Cleans floating point noise: 0.30000000000000004 -> 0.3', () {
      final res = NumberFormatter.format(0.1 + 0.2);
      expect(res, '0.3');
    });

    test('Respects user-configured decimal precision', () {
      final res = NumberFormatter.format(mathPiApprox, decimalPrecision: 4);
      expect(res, '3.1416');
    });

    test('Formats very large number with scientific notation', () {
      final res = NumberFormatter.format(1e15);
      expect(res.contains('e'), isTrue);
    });

    test('Formats very small number with scientific notation', () {
      final res = NumberFormatter.format(1e-8);
      expect(res.contains('e'), isTrue);
    });

    test('Handles negative numbers properly', () {
      final res = NumberFormatter.format(-9876.54, useThousandsSeparator: true);
      expect(res, '-9,876.54');
    });

    test('Handles zero', () {
      final res = NumberFormatter.format(0.0);
      expect(res, '0');
    });
  });
}

const double mathPiApprox = 3.1415926535;

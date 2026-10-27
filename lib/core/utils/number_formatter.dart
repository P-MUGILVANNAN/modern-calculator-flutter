import 'package:intl/intl.dart';

/// Formatter for numerical calculation outputs and expressions.
class NumberFormatter {
  NumberFormatter._();

  /// Formats a raw double value into a clean, human-readable string.
  ///
  /// Respects [decimalPrecision] (-1 means automatic/dynamic).
  /// Respects [useThousandsSeparator].
  static String format(
    double value, {
    int decimalPrecision = -1,
    bool useThousandsSeparator = true,
  }) {
    if (value.isNaN) return 'NaN';
    if (value.isInfinite) {
      return value.isNegative ? '-Infinity' : 'Infinity';
    }

    // Treat extremely small values as zero to avoid -0.0
    if (value.abs() < 1e-13 && value != 0.0) {
      value = 0.0;
    }

    final double absVal = value.abs();

    // Very large or extremely small numbers -> Scientific notation
    if ((absVal >= 1e13 || (absVal > 0 && absVal < 1e-6))) {
      final int prec = (decimalPrecision >= 0) ? decimalPrecision : 6;
      String expStr = value.toStringAsExponential(prec);
      // Clean up e.g. 1.2000e+8 -> 1.2e8
      if (decimalPrecision < 0 && expStr.contains('.')) {
        expStr = expStr.replaceAll(RegExp(r'0+(?=e)'), '');
        expStr = expStr.replaceAll('.e', 'e');
      }
      return expStr.replaceAll('+', '');
    }

    // Clean floating point rounding noise (e.g., 0.1 + 0.2 = 0.30000000000000004)
    double roundedVal = value;
    final String fixed12 = value.toStringAsFixed(12);
    final double? parsed12 = double.tryParse(fixed12);
    if (parsed12 != null) {
      roundedVal = parsed12;
    }

    if (decimalPrecision >= 0) {
      // Fixed user-selected decimal precision
      if (useThousandsSeparator) {
        final NumberFormat nf = NumberFormat.currency(
          symbol: '',
          decimalDigits: decimalPrecision,
        );
        return nf.format(roundedVal).trim();
      } else {
        return roundedVal.toStringAsFixed(decimalPrecision);
      }
    }

    // Automatic precision: trim trailing zeros
    // Check if integer
    if (roundedVal == roundedVal.roundToDouble()) {
      final int intVal = roundedVal.round();
      if (useThousandsSeparator) {
        final NumberFormat nf = NumberFormat.decimalPattern();
        return nf.format(intVal);
      }
      return intVal.toString();
    }

    // Has decimals
    String strVal = roundedVal.toString();
    if (strVal.contains('.')) {
      // Remove trailing zeroes
      strVal = strVal.replaceAll(RegExp(r'0+$'), '');
      if (strVal.endsWith('.')) {
        strVal = strVal.substring(0, strVal.length - 1);
      }
    }

    if (useThousandsSeparator) {
      final List<String> parts = strVal.split('.');
      final int? intPart = int.tryParse(parts[0]);
      if (intPart != null) {
        final String formattedInt = NumberFormat.decimalPattern().format(
          intPart,
        );
        if (parts.length > 1) {
          return '$formattedInt.${parts[1]}';
        }
        return formattedInt;
      }
    }

    return strVal;
  }
}

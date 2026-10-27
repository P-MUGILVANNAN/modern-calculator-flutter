import 'dart:math' as math;
import 'package:calcpro/core/constants/app_strings.dart';
import 'package:calcpro/core/utils/number_formatter.dart';
import 'package:calcpro/features/calculator/models/angle_mode.dart';

/// Encapsulates the result of a mathematical evaluation.
class CalculationResult {
  final double? value;
  final String? error;
  final bool isSuccess;

  const CalculationResult.success(this.value) : error = null, isSuccess = true;

  const CalculationResult.error(this.error) : value = null, isSuccess = false;

  String toDisplayString({
    int decimalPrecision = -1,
    bool useThousandsSeparator = true,
  }) {
    if (!isSuccess) return error ?? AppStrings.errorInvalid;
    return NumberFormatter.format(
      value ?? 0.0,
      decimalPrecision: decimalPrecision,
      useThousandsSeparator: useThousandsSeparator,
    );
  }
}

/// High-precision mathematical calculation engine for standard and scientific operations.
class CalculationEngine {
  CalculationEngine._();

  /// Evaluates a math expression string and returns a [CalculationResult].
  static CalculationResult evaluate(
    String expression, {
    AngleMode angleMode = AngleMode.degrees,
  }) {
    final String clean = _normalizeExpression(expression);
    if (clean.trim().isEmpty) {
      return const CalculationResult.success(0.0);
    }

    try {
      final _Parser parser = _Parser(clean, angleMode);
      final double result = parser.parse();

      if (result.isNaN) {
        return const CalculationResult.error(AppStrings.errorDomain);
      }
      if (result.isInfinite) {
        return const CalculationResult.error(AppStrings.errorOverflow);
      }

      return CalculationResult.success(result);
    } on _MathException catch (e) {
      return CalculationResult.error(e.message);
    } catch (_) {
      return const CalculationResult.error(AppStrings.errorInvalid);
    }
  }

  /// Safe evaluation for real-time live preview while user is typing.
  /// Automatically balances unclosed parentheses.
  /// Returns null if the expression is incomplete or invalid.
  static double? previewEvaluate(
    String expression, {
    AngleMode angleMode = AngleMode.degrees,
  }) {
    String clean = _normalizeExpression(expression);
    if (clean.trim().isEmpty) return null;

    // Remove trailing operators or open dots that can't be parsed yet
    clean = clean.replaceAll(RegExp(r'[\+\-\×\÷\*\/\^\(\s\.]+$'), '');
    if (clean.isEmpty) return null;

    // Balance open parentheses
    int openCount = 0;
    for (int i = 0; i < clean.length; i++) {
      if (clean[i] == '(') openCount++;
      if (clean[i] == ')') openCount--;
    }
    if (openCount > 0) {
      clean += ')' * openCount;
    }

    try {
      final _Parser parser = _Parser(clean, angleMode);
      final double result = parser.parse();
      if (result.isNaN || result.isInfinite) return null;
      return result;
    } catch (_) {
      return null;
    }
  }

  /// Standardizes mathematical symbols and notation for the parser.
  static String _normalizeExpression(String input) {
    return input
        .replaceAll('×', '*')
        .replaceAll('✕', '*')
        .replaceAll('·', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .replaceAll('π', 'pi')
        .replaceAll('√', 'sqrt')
        .replaceAll('∛', 'cbrt')
        .replaceAll('sin⁻¹', 'asin')
        .replaceAll('cos⁻¹', 'acos')
        .replaceAll('tan⁻¹', 'atan')
        .replaceAll('mod', '%');
  }
}

class _MathException implements Exception {
  final String message;
  _MathException(this.message);

  @override
  String toString() => message;
}

/// Recursive descent parser for arithmetic, percentage, and scientific functions.
class _Parser {
  final String text;
  final AngleMode angleMode;
  int pos = 0;

  _Parser(this.text, this.angleMode);

  double parse() {
    _skipWhitespace();
    final double result = _parseExpression();
    _skipWhitespace();
    if (pos < text.length) {
      throw _MathException(AppStrings.errorInvalid);
    }
    return result;
  }

  bool _lastFactorHadPercent = false;

  // Expression: Addition & Subtraction (with smart percentage support)
  double _parseExpression() {
    double value = _parseTerm();

    while (true) {
      _skipWhitespace();
      if (_match('+')) {
        _lastFactorHadPercent = false;
        final double next = _parseTerm();
        if (_lastFactorHadPercent) {
          value = value + (value * next);
        } else {
          value = value + next;
        }
      } else if (_match('-')) {
        _lastFactorHadPercent = false;
        final double next = _parseTerm();
        if (_lastFactorHadPercent) {
          value = value - (value * next);
        } else {
          value = value - next;
        }
      } else {
        break;
      }
    }
    return value;
  }

  // Term: Multiplication & Division
  double _parseTerm() {
    double value = _parseFactor();

    while (true) {
      _skipWhitespace();
      if (_match('*')) {
        final double next = _parseFactor();
        value = value * next;
      } else if (_match('/')) {
        final double next = _parseFactor();
        if (next == 0.0) {
          throw _MathException(AppStrings.errorDivZero);
        }
        value = value / next;
      } else if (_peekImplicitMultiply()) {
        final double next = _parseFactor();
        value = value * next;
      } else {
        break;
      }
    }
    return value;
  }

  // Factor: Power (^), Postfix Factorial (!), Postfix Percent (%)
  double _parseFactor() {
    double value = _parsePrimary();

    while (true) {
      _skipWhitespace();
      if (_match('^')) {
        final double exp = _parseFactor(); // Right-associative exponentiation
        if (value < 0 && exp != exp.roundToDouble()) {
          throw _MathException(AppStrings.errorDomain);
        }
        if (value == 0 && exp < 0) {
          throw _MathException(AppStrings.errorDivZero);
        }
        value = math.pow(value, exp).toDouble();
      } else if (_match('!')) {
        value = _factorial(value);
      } else if (_match('%')) {
        _lastFactorHadPercent = true;
        value = value / 100.0;
      } else {
        break;
      }
    }

    return value;
  }

  // Primary: Numbers, Parentheses, Functions, Constants, Unary Operators
  double _parsePrimary() {
    _skipWhitespace();

    if (pos >= text.length) {
      throw _MathException(AppStrings.errorInvalid);
    }

    // Unary plus
    if (_match('+')) {
      return _parsePrimary();
    }

    // Unary minus
    if (_match('-')) {
      return -_parsePrimary();
    }

    // Parentheses
    if (_match('(')) {
      final double val = _parseExpression();
      _skipWhitespace();
      if (!_match(')')) {
        throw _MathException(AppStrings.errorInvalid);
      }
      return val;
    }

    // Functions and Constants
    if (_isAlpha(_peek())) {
      final String id = _parseIdentifier();

      // Constants
      if (id == 'pi') return math.pi;
      if (id == 'e') return math.e;

      // Scientific functions
      return _executeFunction(id);
    }

    // Numbers
    if (_isDigit(_peek()) || _peek() == '.') {
      return _parseNumber();
    }

    throw _MathException(AppStrings.errorInvalid);
  }

  double _executeFunction(String name) {
    _skipWhitespace();
    if (!_match('(')) {
      throw _MathException(AppStrings.errorInvalid);
    }

    final double arg = _parseExpression();
    _skipWhitespace();
    if (!_match(')')) {
      throw _MathException(AppStrings.errorInvalid);
    }

    switch (name.toLowerCase()) {
      case 'sin':
        final double rad = _toRadians(arg);
        // Clean near-zero for multiples of pi
        if ((arg % 180 == 0 && angleMode == AngleMode.degrees) ||
            (rad % math.pi == 0)) {
          return 0.0;
        }
        return math.sin(rad);

      case 'cos':
        final double rad = _toRadians(arg);
        if ((arg - 90) % 180 == 0 && angleMode == AngleMode.degrees) {
          return 0.0;
        }
        return math.cos(rad);

      case 'tan':
        if (angleMode == AngleMode.degrees && (arg - 90) % 180 == 0) {
          throw _MathException(AppStrings.errorDivZero);
        }
        final double rad = _toRadians(arg);
        final double c = math.cos(rad);
        if (c.abs() < 1e-15) {
          throw _MathException(AppStrings.errorDivZero);
        }
        final double t = math.tan(rad);
        if (t.abs() < 1e-15) return 0.0;
        return t;

      case 'asin':
        if (arg < -1.0 || arg > 1.0) {
          throw _MathException(AppStrings.errorDomain);
        }
        final double rad = math.asin(arg);
        return _fromRadians(rad);

      case 'acos':
        if (arg < -1.0 || arg > 1.0) {
          throw _MathException(AppStrings.errorDomain);
        }
        final double rad = math.acos(arg);
        return _fromRadians(rad);

      case 'atan':
        final double rad = math.atan(arg);
        return _fromRadians(rad);

      case 'ln':
        if (arg <= 0) {
          throw _MathException(AppStrings.errorDomain);
        }
        return math.log(arg);

      case 'log':
        if (arg <= 0) {
          throw _MathException(AppStrings.errorDomain);
        }
        return math.log(arg) / math.ln10;

      case 'sqrt':
        if (arg < 0) {
          throw _MathException(AppStrings.errorDomain);
        }
        return math.sqrt(arg);

      case 'cbrt':
        if (arg < 0) {
          return -math.pow(-arg, 1.0 / 3.0).toDouble();
        }
        return math.pow(arg, 1.0 / 3.0).toDouble();

      case 'abs':
        return arg.abs();

      default:
        throw _MathException(AppStrings.errorInvalid);
    }
  }

  double _toRadians(double val) {
    return angleMode == AngleMode.degrees ? (val * math.pi / 180.0) : val;
  }

  double _fromRadians(double rad) {
    return angleMode == AngleMode.degrees ? (rad * 180.0 / math.pi) : rad;
  }

  double _factorial(double n) {
    if (n < 0 || n != n.roundToDouble()) {
      throw _MathException(AppStrings.errorDomain);
    }
    final int intVal = n.round();
    if (intVal > 170) {
      throw _MathException(AppStrings.errorOverflow);
    }
    double result = 1.0;
    for (int i = 2; i <= intVal; i++) {
      result *= i;
    }
    return result;
  }

  double _parseNumber() {
    final int start = pos;
    bool hasDot = false;

    while (pos < text.length) {
      final String ch = text[pos];
      if (_isDigit(ch)) {
        pos++;
      } else if (ch == '.') {
        if (hasDot) {
          throw _MathException(AppStrings.errorInvalid);
        }
        hasDot = true;
        pos++;
      } else {
        break;
      }
    }

    final String numStr = text.substring(start, pos);
    final double? parsed = double.tryParse(numStr);
    if (parsed == null) {
      throw _MathException(AppStrings.errorInvalid);
    }
    return parsed;
  }

  String _parseIdentifier() {
    final int start = pos;
    while (pos < text.length && _isAlpha(text[pos])) {
      pos++;
    }
    return text.substring(start, pos);
  }

  bool _peekImplicitMultiply() {
    if (pos >= text.length) return false;
    final String ch = text[pos];
    // Next token is '(', a letter (pi, e, func), or number token
    return ch == '(' || _isAlpha(ch);
  }

  bool _match(String s) {
    if (pos + s.length <= text.length &&
        text.substring(pos, pos + s.length) == s) {
      pos += s.length;
      return true;
    }
    return false;
  }

  String _peek() {
    if (pos < text.length) return text[pos];
    return '';
  }

  void _skipWhitespace() {
    while (pos < text.length && (text[pos] == ' ' || text[pos] == '\t')) {
      pos++;
    }
  }

  bool _isDigit(String ch) {
    if (ch.isEmpty) return false;
    final int code = ch.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }

  bool _isAlpha(String ch) {
    if (ch.isEmpty) return false;
    final int code = ch.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }
}

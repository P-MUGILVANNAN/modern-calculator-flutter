import 'package:flutter/material.dart';
import 'package:calcpro/core/constants/app_strings.dart';
import 'package:calcpro/core/utils/number_formatter.dart';
import 'package:calcpro/features/calculator/models/calculation_state.dart';
import 'package:calcpro/features/calculator/models/calculator_mode.dart';
import 'package:calcpro/features/calculator/services/calculation_engine.dart';
import 'package:calcpro/features/history/providers/history_provider.dart';
import 'package:calcpro/features/settings/providers/settings_provider.dart';

/// State management for the calculator UI and calculation execution.
class CalculatorProvider extends ChangeNotifier {
  final SettingsProvider _settingsProvider;
  final HistoryProvider? _historyProvider;

  CalculationState _state = const CalculationState();

  CalculatorProvider({
    required SettingsProvider settingsProvider,
    HistoryProvider? historyProvider,
  }) : _settingsProvider = settingsProvider,
       _historyProvider = historyProvider {
    _settingsProvider.addListener(_onSettingsChanged);
  }

  CalculationState get state => _state;
  CalculatorMode get mode => _state.mode;

  void _onSettingsChanged() {
    // If settings like angleMode or precision change, update preview/result
    if (_state.expression.isNotEmpty && !_state.isEvaluated) {
      _updatePreview();
    } else {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _settingsProvider.removeListener(_onSettingsChanged);
    super.dispose();
  }

  // --- Calculator Input Actions ---

  /// Appends a digit (0-9).
  void inputDigit(String digit) {
    if (_state.isEvaluated) {
      // Start a fresh expression if user begins typing a number after evaluation
      _state = _state.copyWith(
        expression: digit,
        result: digit,
        previewResult: '',
        clearError: true,
        isEvaluated: false,
      );
    } else {
      final String newExpr =
          _state.expression == '0' ? digit : _state.expression + digit;
      _state = _state.copyWith(expression: newExpr, clearError: true);
      _updatePreview();
    }
    notifyListeners();
  }

  /// Appends decimal point, ensuring no repeated decimals in the current number token.
  void inputDecimal() {
    if (_state.isEvaluated) {
      _state = _state.copyWith(
        expression: '0.',
        result: '0.',
        previewResult: '',
        clearError: true,
        isEvaluated: false,
      );
      notifyListeners();
      return;
    }

    final String expr = _state.expression;
    if (expr.isEmpty) {
      _state = _state.copyWith(expression: '0.', clearError: true);
      notifyListeners();
      return;
    }

    // Find the last number token
    final RegExp numRegex = RegExp(r'[0-9\.]+$');
    final match = numRegex.firstMatch(expr);

    if (match != null) {
      final String lastNumber = match.group(0)!;
      if (lastNumber.contains('.')) {
        // Disallow second decimal point
        return;
      }
      _state = _state.copyWith(expression: '$expr.', clearError: true);
    } else {
      // Preceded by an operator or open bracket
      final String lastChar = expr.substring(expr.length - 1);
      if (_isOperator(lastChar) || lastChar == '(') {
        _state = _state.copyWith(expression: '${expr}0.', clearError: true);
      } else {
        _state = _state.copyWith(expression: '$expr.', clearError: true);
      }
    }

    _updatePreview();
    notifyListeners();
  }

  /// Appends or replaces an arithmetic operator (+, −, ×, ÷, ^).
  void inputOperator(String op) {
    String expr = _state.expression;

    if (_state.isEvaluated) {
      // Continue continuous calculation using the previous result
      expr = _state.result;
      _state = _state.copyWith(
        expression: '$expr $op ',
        clearError: true,
        isEvaluated: false,
      );
      notifyListeners();
      return;
    }

    if (expr.isEmpty) {
      if (op == '−' || op == '-') {
        // Allow unary minus at start
        _state = _state.copyWith(expression: '−', clearError: true);
        notifyListeners();
      }
      return;
    }

    final String trimmed = expr.trimRight();
    final String lastChar = trimmed.substring(trimmed.length - 1);

    if (_isOperator(lastChar)) {
      // Replace consecutive operator
      final String withoutOp =
          trimmed.substring(0, trimmed.length - 1).trimRight();
      _state = _state.copyWith(expression: '$withoutOp $op ', clearError: true);
    } else {
      _state = _state.copyWith(expression: '$expr $op ', clearError: true);
    }

    _updatePreview();
    notifyListeners();
  }

  /// Appends percentage (%)
  void inputPercentage() {
    if (_state.isEvaluated) {
      _state = _state.copyWith(
        expression: '${_state.result}%',
        clearError: true,
        isEvaluated: false,
      );
      _updatePreview();
      notifyListeners();
      return;
    }

    if (_state.expression.isEmpty) return;
    final String lastChar = _state.expression.substring(
      _state.expression.length - 1,
    );
    if (_isOperator(lastChar) || lastChar == '(') return;

    _state = _state.copyWith(
      expression: '${_state.expression}%',
      clearError: true,
    );
    _updatePreview();
    notifyListeners();
  }

  /// Toggles positive/negative on current number.
  void toggleSign() {
    if (_state.isEvaluated) {
      final double? val = double.tryParse(_state.result.replaceAll(',', ''));
      if (val != null) {
        final double toggled = -val;
        final String formatted = NumberFormatter.format(
          toggled,
          decimalPrecision: _settingsProvider.decimalPrecision,
          useThousandsSeparator: _settingsProvider.useThousandsSeparator,
        );
        _state = _state.copyWith(expression: formatted, result: formatted);
        notifyListeners();
      }
      return;
    }

    final String expr = _state.expression;
    if (expr.isEmpty) {
      _state = _state.copyWith(expression: '−');
      notifyListeners();
      return;
    }

    // Check if ends with a wrapped negative number e.g. (-5)
    final RegExp wrappedNeg = RegExp(r'\((−|\-)[0-9\.]+\)$');
    final matchNeg = wrappedNeg.firstMatch(expr);
    if (matchNeg != null) {
      final String matched = matchNeg.group(0)!;
      final String positive = matched.substring(2, matched.length - 1);
      final String newExpr = expr.substring(0, matchNeg.start) + positive;
      _state = _state.copyWith(expression: newExpr);
      _updatePreview();
      notifyListeners();
      return;
    }

    // Check if ends with regular number e.g. 5
    final RegExp numRegex = RegExp(r'[0-9\.]+$');
    final match = numRegex.firstMatch(expr);
    if (match != null) {
      final String numStr = match.group(0)!;
      final String newExpr = '${expr.substring(0, match.start)}(−$numStr)';
      _state = _state.copyWith(expression: newExpr);
      _updatePreview();
      notifyListeners();
    }
  }

  /// Appends scientific function with open parenthesis. e.g. `sin(`
  void inputFunction(String funcName) {
    if (_state.isEvaluated) {
      _state = _state.copyWith(
        expression: '$funcName(',
        clearError: true,
        isEvaluated: false,
      );
    } else {
      _state = _state.copyWith(
        expression: '${_state.expression}$funcName(',
        clearError: true,
      );
    }
    _updatePreview();
    notifyListeners();
  }

  /// Appends constants (π or e).
  void inputConstant(String constant) {
    if (_state.isEvaluated) {
      _state = _state.copyWith(
        expression: constant,
        clearError: true,
        isEvaluated: false,
      );
    } else {
      _state = _state.copyWith(
        expression: '${_state.expression}$constant',
        clearError: true,
      );
    }
    _updatePreview();
    notifyListeners();
  }

  /// Smart parenthesis insertion.
  void inputParentheses() {
    if (_state.isEvaluated) {
      _state = _state.copyWith(
        expression: '(',
        clearError: true,
        isEvaluated: false,
      );
      notifyListeners();
      return;
    }

    final String expr = _state.expression;
    if (expr.isEmpty) {
      _state = _state.copyWith(expression: '(');
      notifyListeners();
      return;
    }

    int openCount = 0;
    int closeCount = 0;
    for (int i = 0; i < expr.length; i++) {
      if (expr[i] == '(') openCount++;
      if (expr[i] == ')') closeCount++;
    }

    final String lastChar = expr[expr.length - 1];

    if (openCount > closeCount && (_isDigit(lastChar) || lastChar == ')')) {
      _state = _state.copyWith(expression: '$expr)');
    } else {
      if (_isDigit(lastChar) || lastChar == ')') {
        _state = _state.copyWith(expression: '$expr × (');
      } else {
        _state = _state.copyWith(expression: '$expr(');
      }
    }

    _updatePreview();
    notifyListeners();
  }

  /// Appends square (^2).
  void inputSquare() {
    if (_state.isEvaluated) {
      _state = _state.copyWith(
        expression: '${_state.result}^2',
        clearError: true,
        isEvaluated: false,
      );
    } else {
      if (_state.expression.isEmpty) return;
      _state = _state.copyWith(expression: '${_state.expression}^2');
    }
    _updatePreview();
    notifyListeners();
  }

  /// Appends factorial (!).
  void inputFactorial() {
    if (_state.isEvaluated) {
      _state = _state.copyWith(
        expression: '${_state.result}!',
        clearError: true,
        isEvaluated: false,
      );
    } else {
      if (_state.expression.isEmpty) return;
      _state = _state.copyWith(expression: '${_state.expression}!');
    }
    _updatePreview();
    notifyListeners();
  }

  /// Appends reciprocal (1/x).
  void inputReciprocal() {
    if (_state.isEvaluated) {
      _state = _state.copyWith(
        expression: '1/(${_state.result})',
        clearError: true,
        isEvaluated: false,
      );
    } else {
      if (_state.expression.isEmpty) {
        _state = _state.copyWith(expression: '1/(');
      } else {
        _state = _state.copyWith(expression: '1/(${_state.expression})');
      }
    }
    _updatePreview();
    notifyListeners();
  }

  /// Backspace: deletes the last character or scientific function token.
  void deleteLast() {
    if (_state.isEvaluated) {
      clearAll();
      return;
    }

    String expr = _state.expression;
    if (expr.isEmpty) return;

    // Check for trailing multi-character functions (e.g. sin(, cos(, sqrt(, etc.)
    final List<String> funcs = [
      'sin⁻¹(',
      'cos⁻¹(',
      'tan⁻¹(',
      'asin(',
      'acos(',
      'atan(',
      'sinh(',
      'cosh(',
      'tanh(',
      'cbrt(',
      'sqrt(',
      'log(',
      'ln(',
      'abs(',
      'sin(',
      'cos(',
      'tan(',
    ];
    bool deletedFunc = false;
    for (final f in funcs) {
      if (expr.endsWith(f)) {
        expr = expr.substring(0, expr.length - f.length);
        deletedFunc = true;
        break;
      }
    }

    if (!deletedFunc) {
      // Check for operators with surrounding spaces e.g. " + "
      if (expr.endsWith(' ') && expr.length >= 3) {
        expr = expr.substring(0, expr.length - 3);
      } else {
        expr = expr.substring(0, expr.length - 1);
      }
    }

    _state = _state.copyWith(expression: expr, clearError: true);
    _updatePreview();
    notifyListeners();
  }

  /// Clear All (AC).
  void clearAll() {
    _state = _state.copyWith(
      expression: '',
      result: '0',
      previewResult: '',
      clearError: true,
      isEvaluated: false,
    );
    notifyListeners();
  }

  /// Evaluates the complete expression (=).
  void evaluate() {
    final String expr = _state.expression.trim();
    if (expr.isEmpty) return;

    final CalculationResult res = CalculationEngine.evaluate(
      expr,
      angleMode: _settingsProvider.angleMode,
    );

    if (res.isSuccess) {
      final String formatted = res.toDisplayString(
        decimalPrecision: _settingsProvider.decimalPrecision,
        useThousandsSeparator: _settingsProvider.useThousandsSeparator,
      );

      _state = _state.copyWith(
        result: formatted,
        previewResult: '',
        clearError: true,
        isEvaluated: true,
      );

      // Save to calculation history
      _historyProvider?.addHistory(expr, formatted);
    } else {
      _state = _state.copyWith(
        errorMessage: res.error ?? AppStrings.errorInvalid,
        previewResult: '',
        isEvaluated: false,
      );
    }

    notifyListeners();
  }

  // --- Memory Operations ---

  /// MC: Memory Clear.
  void memoryClear() {
    _state = _state.copyWith(memoryValue: 0.0, hasMemory: false);
    notifyListeners();
  }

  /// MR: Memory Recall.
  void memoryRecall() {
    if (!_state.hasMemory) return;
    final String memStr = NumberFormatter.format(
      _state.memoryValue,
      decimalPrecision: _settingsProvider.decimalPrecision,
      useThousandsSeparator: false,
    );

    if (_state.isEvaluated) {
      _state = _state.copyWith(
        expression: memStr,
        result: memStr,
        clearError: true,
        isEvaluated: false,
      );
    } else {
      _state = _state.copyWith(
        expression: '${_state.expression}$memStr',
        clearError: true,
      );
    }
    _updatePreview();
    notifyListeners();
  }

  /// M+: Add current value to memory.
  void memoryAdd() {
    final double? currentVal = _getCurrentValue();
    if (currentVal == null) return;

    final double newVal = _state.memoryValue + currentVal;
    _state = _state.copyWith(memoryValue: newVal, hasMemory: true);
    notifyListeners();
  }

  /// M-: Subtract current value from memory.
  void memorySubtract() {
    final double? currentVal = _getCurrentValue();
    if (currentVal == null) return;

    final double newVal = _state.memoryValue - currentVal;
    _state = _state.copyWith(memoryValue: newVal, hasMemory: true);
    notifyListeners();
  }

  double? _getCurrentValue() {
    if (_state.isEvaluated) {
      return double.tryParse(_state.result.replaceAll(',', ''));
    }
    if (_state.expression.isNotEmpty) {
      final res = CalculationEngine.evaluate(
        _state.expression,
        angleMode: _settingsProvider.angleMode,
      );
      if (res.isSuccess) return res.value;
    }
    return null;
  }

  // --- Mode & History Reuse ---

  /// Toggles between Basic and Scientific calculator mode.
  void toggleMode() {
    final next =
        _state.mode == CalculatorMode.basic
            ? CalculatorMode.scientific
            : CalculatorMode.basic;
    _state = _state.copyWith(mode: next);
    notifyListeners();
  }

  /// Sets calculator mode explicitly.
  void setMode(CalculatorMode mode) {
    if (_state.mode == mode) return;
    _state = _state.copyWith(mode: mode);
    notifyListeners();
  }

  /// Reuses a history expression and result.
  void reuseHistory(String expression, String result) {
    _state = _state.copyWith(
      expression: expression,
      result: result,
      previewResult: '',
      clearError: true,
      isEvaluated: true,
    );
    notifyListeners();
  }

  // --- Helper Methods ---

  void _updatePreview() {
    if (_state.expression.isEmpty) {
      _state = _state.copyWith(previewResult: '');
      return;
    }

    final double? preview = CalculationEngine.previewEvaluate(
      _state.expression,
      angleMode: _settingsProvider.angleMode,
    );

    if (preview != null) {
      final String formatted = NumberFormatter.format(
        preview,
        decimalPrecision: _settingsProvider.decimalPrecision,
        useThousandsSeparator: _settingsProvider.useThousandsSeparator,
      );
      _state = _state.copyWith(previewResult: formatted);
    } else {
      _state = _state.copyWith(previewResult: '');
    }
  }

  bool _isOperator(String ch) {
    return ch == '+' ||
        ch == '−' ||
        ch == '-' ||
        ch == '×' ||
        ch == '*' ||
        ch == '÷' ||
        ch == '/' ||
        ch == '^';
  }

  bool _isDigit(String ch) {
    if (ch.isEmpty) return false;
    final int code = ch.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }
}

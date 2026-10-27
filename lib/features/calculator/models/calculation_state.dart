import 'package:calcpro/features/calculator/models/calculator_mode.dart';

/// State model representing the full calculator status.
class CalculationState {
  final String expression;
  final String result;
  final String previewResult;
  final String? errorMessage;
  final bool isEvaluated;
  final double memoryValue;
  final bool hasMemory;
  final CalculatorMode mode;

  const CalculationState({
    this.expression = '',
    this.result = '0',
    this.previewResult = '',
    this.errorMessage,
    this.isEvaluated = false,
    this.memoryValue = 0.0,
    this.hasMemory = false,
    this.mode = CalculatorMode.basic,
  });

  CalculationState copyWith({
    String? expression,
    String? result,
    String? previewResult,
    String? errorMessage,
    bool clearError = false,
    bool? isEvaluated,
    double? memoryValue,
    bool? hasMemory,
    CalculatorMode? mode,
  }) {
    return CalculationState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      previewResult: previewResult ?? this.previewResult,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isEvaluated: isEvaluated ?? this.isEvaluated,
      memoryValue: memoryValue ?? this.memoryValue,
      hasMemory: hasMemory ?? this.hasMemory,
      mode: mode ?? this.mode,
    );
  }

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
  bool get hasPreview => previewResult.isNotEmpty && previewResult != result;
}

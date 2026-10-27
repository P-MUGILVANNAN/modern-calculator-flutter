import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calcpro/core/constants/app_dimensions.dart';
import 'package:calcpro/features/calculator/models/calculator_key_type.dart';
import 'package:calcpro/features/calculator/providers/calculator_provider.dart';
import 'package:calcpro/features/calculator/widgets/calculator_button.dart';

/// Standard calculator keypad (5x4 grid) with responsive spacing.
class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.read<CalculatorProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: AC, ( ), %, ÷
          Row(
            children: [
              CalculatorButton(
                label: 'AC',
                type: CalculatorKeyType.utility,
                semanticLabel: 'Clear All',
                onTap: calc.clearAll,
              ),
              CalculatorButton(
                label: '( )',
                type: CalculatorKeyType.utility,
                semanticLabel: 'Parentheses',
                onTap: calc.inputParentheses,
              ),
              CalculatorButton(
                label: '%',
                type: CalculatorKeyType.utility,
                semanticLabel: 'Percentage',
                onTap: calc.inputPercentage,
              ),
              CalculatorButton(
                label: '÷',
                type: CalculatorKeyType.operator,
                semanticLabel: 'Divide',
                onTap: () => calc.inputOperator('÷'),
              ),
            ],
          ),

          // Row 2: 7, 8, 9, ×
          Row(
            children: [
              CalculatorButton(
                label: '7',
                type: CalculatorKeyType.number,
                onTap: () => calc.inputDigit('7'),
              ),
              CalculatorButton(
                label: '8',
                type: CalculatorKeyType.number,
                onTap: () => calc.inputDigit('8'),
              ),
              CalculatorButton(
                label: '9',
                type: CalculatorKeyType.number,
                onTap: () => calc.inputDigit('9'),
              ),
              CalculatorButton(
                label: '×',
                type: CalculatorKeyType.operator,
                semanticLabel: 'Multiply',
                onTap: () => calc.inputOperator('×'),
              ),
            ],
          ),

          // Row 3: 4, 5, 6, −
          Row(
            children: [
              CalculatorButton(
                label: '4',
                type: CalculatorKeyType.number,
                onTap: () => calc.inputDigit('4'),
              ),
              CalculatorButton(
                label: '5',
                type: CalculatorKeyType.number,
                onTap: () => calc.inputDigit('5'),
              ),
              CalculatorButton(
                label: '6',
                type: CalculatorKeyType.number,
                onTap: () => calc.inputDigit('6'),
              ),
              CalculatorButton(
                label: '−',
                type: CalculatorKeyType.operator,
                semanticLabel: 'Subtract',
                onTap: () => calc.inputOperator('−'),
              ),
            ],
          ),

          // Row 4: 1, 2, 3, +
          Row(
            children: [
              CalculatorButton(
                label: '1',
                type: CalculatorKeyType.number,
                onTap: () => calc.inputDigit('1'),
              ),
              CalculatorButton(
                label: '2',
                type: CalculatorKeyType.number,
                onTap: () => calc.inputDigit('2'),
              ),
              CalculatorButton(
                label: '3',
                type: CalculatorKeyType.number,
                onTap: () => calc.inputDigit('3'),
              ),
              CalculatorButton(
                label: '+',
                type: CalculatorKeyType.operator,
                semanticLabel: 'Add',
                onTap: () => calc.inputOperator('+'),
              ),
            ],
          ),

          // Row 5: +/−, 0, ., =
          Row(
            children: [
              CalculatorButton(
                label: '+/−',
                type: CalculatorKeyType.utility,
                semanticLabel: 'Toggle Sign',
                onTap: calc.toggleSign,
              ),
              CalculatorButton(
                label: '0',
                type: CalculatorKeyType.number,
                onTap: () => calc.inputDigit('0'),
              ),
              CalculatorButton(
                label: '.',
                type: CalculatorKeyType.number,
                semanticLabel: 'Decimal Point',
                onTap: calc.inputDecimal,
              ),
              CalculatorButton(
                label: '=',
                type: CalculatorKeyType.equals,
                semanticLabel: 'Equals',
                onTap: calc.evaluate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

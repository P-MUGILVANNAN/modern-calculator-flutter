import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calcpro/core/constants/app_colors.dart';
import 'package:calcpro/core/constants/app_dimensions.dart';
import 'package:calcpro/features/calculator/models/calculator_key_type.dart';
import 'package:calcpro/features/calculator/providers/calculator_provider.dart';
import 'package:calcpro/features/calculator/widgets/calculator_button.dart';
import 'package:calcpro/features/settings/providers/settings_provider.dart';

/// Scientific functions keypad with 2nd function toggle and trigonometric/logarithmic operations.
class ScientificKeypad extends StatefulWidget {
  const ScientificKeypad({super.key});

  @override
  State<ScientificKeypad> createState() => _ScientificKeypadState();
}

class _ScientificKeypadState extends State<ScientificKeypad> {
  bool _isSecondMode = false;

  void _toggleSecondMode() {
    setState(() {
      _isSecondMode = !_isSecondMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final calc = context.read<CalculatorProvider>();
    final settings = context.watch<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: DEG/RAD toggle, 2nd, sin/asin, cos/acos
          Row(
            children: [
              CalculatorButton(
                label: settings.angleMode.label,
                type: CalculatorKeyType.scientific,
                semanticLabel: 'Toggle Angle Mode',
                onTap: settings.toggleAngleMode,
              ),
              CalculatorButton(
                label: '2nd',
                type: CalculatorKeyType.scientific,
                icon: Text(
                  '2nd',
                  style: TextStyle(
                    color:
                        _isSecondMode
                            ? (isDark
                                ? AppColors.warning
                                : Colors.orange.shade800)
                            : (isDark
                                ? AppColors.scientificAccent
                                : const Color(0xFF2575DC)),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                semanticLabel: 'Second Function Mode',
                onTap: _toggleSecondMode,
              ),
              CalculatorButton(
                label: _isSecondMode ? 'sin⁻¹' : 'sin',
                type: CalculatorKeyType.scientific,
                semanticLabel: _isSecondMode ? 'Arcsine' : 'Sine',
                onTap: () => calc.inputFunction(_isSecondMode ? 'asin' : 'sin'),
              ),
              CalculatorButton(
                label: _isSecondMode ? 'cos⁻¹' : 'cos',
                type: CalculatorKeyType.scientific,
                semanticLabel: _isSecondMode ? 'Arccosine' : 'Cosine',
                onTap: () => calc.inputFunction(_isSecondMode ? 'acos' : 'cos'),
              ),
            ],
          ),

          // Row 2: tan/atan, ln, log, √/∛
          Row(
            children: [
              CalculatorButton(
                label: _isSecondMode ? 'tan⁻¹' : 'tan',
                type: CalculatorKeyType.scientific,
                semanticLabel: _isSecondMode ? 'Arctangent' : 'Tangent',
                onTap: () => calc.inputFunction(_isSecondMode ? 'atan' : 'tan'),
              ),
              CalculatorButton(
                label: 'ln',
                type: CalculatorKeyType.scientific,
                semanticLabel: 'Natural Logarithm',
                onTap: () => calc.inputFunction('ln'),
              ),
              CalculatorButton(
                label: 'log',
                type: CalculatorKeyType.scientific,
                semanticLabel: 'Logarithm Base 10',
                onTap: () => calc.inputFunction('log'),
              ),
              CalculatorButton(
                label: _isSecondMode ? '∛' : '√',
                type: CalculatorKeyType.scientific,
                semanticLabel: _isSecondMode ? 'Cube Root' : 'Square Root',
                onTap:
                    () => calc.inputFunction(_isSecondMode ? 'cbrt' : 'sqrt'),
              ),
            ],
          ),

          // Row 3: x², xʸ, 1/x, n!
          Row(
            children: [
              CalculatorButton(
                label: 'x²',
                type: CalculatorKeyType.scientific,
                semanticLabel: 'Square',
                onTap: calc.inputSquare,
              ),
              CalculatorButton(
                label: 'xʸ',
                type: CalculatorKeyType.scientific,
                semanticLabel: 'Power',
                onTap: () => calc.inputOperator('^'),
              ),
              CalculatorButton(
                label: '1/x',
                type: CalculatorKeyType.scientific,
                semanticLabel: 'Reciprocal',
                onTap: calc.inputReciprocal,
              ),
              CalculatorButton(
                label: 'n!',
                type: CalculatorKeyType.scientific,
                semanticLabel: 'Factorial',
                onTap: calc.inputFactorial,
              ),
            ],
          ),

          // Row 4: π, e, |x|, mod
          Row(
            children: [
              CalculatorButton(
                label: 'π',
                type: CalculatorKeyType.scientific,
                semanticLabel: 'Pi Constant',
                onTap: () => calc.inputConstant('π'),
              ),
              CalculatorButton(
                label: 'e',
                type: CalculatorKeyType.scientific,
                semanticLabel: 'Euler Number',
                onTap: () => calc.inputConstant('e'),
              ),
              CalculatorButton(
                label: '|x|',
                type: CalculatorKeyType.scientific,
                semanticLabel: 'Absolute Value',
                onTap: () => calc.inputFunction('abs'),
              ),
              CalculatorButton(
                label: 'mod',
                type: CalculatorKeyType.scientific,
                semanticLabel: 'Modulo',
                onTap: () => calc.inputOperator('%'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

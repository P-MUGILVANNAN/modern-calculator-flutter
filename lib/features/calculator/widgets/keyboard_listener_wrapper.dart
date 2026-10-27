import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:calcpro/features/calculator/providers/calculator_provider.dart';

/// Wraps calculator screens to handle physical desktop/web keyboard events.
class CalculatorKeyboardListener extends StatelessWidget {
  final Widget child;

  const CalculatorKeyboardListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;

        final calc = context.read<CalculatorProvider>();
        final key = event.logicalKey;
        final char = event.character;

        if (key == LogicalKeyboardKey.digit0 ||
            key == LogicalKeyboardKey.numpad0) {
          calc.inputDigit('0');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.digit1 ||
            key == LogicalKeyboardKey.numpad1) {
          calc.inputDigit('1');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.digit2 ||
            key == LogicalKeyboardKey.numpad2) {
          calc.inputDigit('2');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.digit3 ||
            key == LogicalKeyboardKey.numpad3) {
          calc.inputDigit('3');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.digit4 ||
            key == LogicalKeyboardKey.numpad4) {
          calc.inputDigit('4');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.digit5 ||
            key == LogicalKeyboardKey.numpad5) {
          calc.inputDigit('5');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.digit6 ||
            key == LogicalKeyboardKey.numpad6) {
          calc.inputDigit('6');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.digit7 ||
            key == LogicalKeyboardKey.numpad7) {
          calc.inputDigit('7');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.digit8 ||
            key == LogicalKeyboardKey.numpad8) {
          calc.inputDigit('8');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.digit9 ||
            key == LogicalKeyboardKey.numpad9) {
          calc.inputDigit('9');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.period ||
            key == LogicalKeyboardKey.numpadDecimal) {
          calc.inputDecimal();
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.numpadAdd || char == '+') {
          calc.inputOperator('+');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.minus ||
            key == LogicalKeyboardKey.numpadSubtract ||
            char == '-') {
          calc.inputOperator('−');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.asterisk ||
            key == LogicalKeyboardKey.numpadMultiply ||
            char == '*') {
          calc.inputOperator('×');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.slash ||
            key == LogicalKeyboardKey.numpadDivide ||
            char == '/') {
          calc.inputOperator('÷');
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.enter ||
            key == LogicalKeyboardKey.numpadEnter ||
            char == '=') {
          calc.evaluate();
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.backspace) {
          calc.deleteLast();
          return KeyEventResult.handled;
        } else if (key == LogicalKeyboardKey.escape ||
            key == LogicalKeyboardKey.delete) {
          calc.clearAll();
          return KeyEventResult.handled;
        } else if (char == '(' || char == ')') {
          calc.inputParentheses();
          return KeyEventResult.handled;
        } else if (char == '%') {
          calc.inputPercentage();
          return KeyEventResult.handled;
        } else if (char == '^') {
          calc.inputOperator('^');
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calcpro/core/constants/app_colors.dart';
import 'package:calcpro/core/constants/app_dimensions.dart';
import 'package:calcpro/core/utils/haptic_feedback_helper.dart';
import 'package:calcpro/features/calculator/models/calculator_key_type.dart';
import 'package:calcpro/features/settings/providers/settings_provider.dart';

/// Interactive calculator key with micro-animations and distinct styles.
class CalculatorButton extends StatefulWidget {
  final String label;
  final Widget? icon;
  final CalculatorKeyType type;
  final VoidCallback onTap;
  final int flex;
  final String? semanticLabel;

  const CalculatorButton({
    super.key,
    required this.label,
    this.icon,
    required this.type,
    required this.onTap,
    this.flex = 1,
    this.semanticLabel,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    _controller.forward();
    final settings = context.read<SettingsProvider>();
    FeedbackHelper.triggerHaptic(settings.hapticEnabled);
    FeedbackHelper.triggerSound(settings.soundEnabled);
  }

  void _handleTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Resolve color styling according to button type and theme
    Color backgroundColor;
    Color foregroundColor;
    Border? border;

    switch (widget.type) {
      case CalculatorKeyType.number:
        backgroundColor =
            isDark ? AppColors.darkNumberButton : AppColors.lightNumberButton;
        foregroundColor =
            isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
        border = Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          width: 0.75,
        );
        break;

      case CalculatorKeyType.operator:
        backgroundColor =
            isDark
                ? AppColors.darkOperatorButton
                : AppColors.lightOperatorButton;
        foregroundColor =
            isDark ? AppColors.darkPrimaryAccent : AppColors.lightPrimaryAccent;
        border = Border.all(
          color: isDark ? const Color(0xFF3F4A67) : const Color(0xFFCED6E8),
          width: 0.75,
        );
        break;

      case CalculatorKeyType.utility:
        backgroundColor =
            isDark ? AppColors.darkUtilityButton : AppColors.lightUtilityButton;
        foregroundColor =
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
        border = Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          width: 0.75,
        );
        break;

      case CalculatorKeyType.equals:
        backgroundColor =
            isDark ? AppColors.darkEqualsButton : AppColors.lightEqualsButton;
        foregroundColor = Colors.white;
        break;

      case CalculatorKeyType.scientific:
        backgroundColor =
            isDark ? const Color(0xFF1E2433) : const Color(0xFFE4EBF7);
        foregroundColor =
            isDark ? AppColors.scientificAccent : const Color(0xFF2575DC);
        border = Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
          width: 0.5,
        );
        break;
    }

    return Expanded(
      flex: widget.flex,
      child: Semantics(
        button: true,
        label: widget.semanticLabel ?? widget.label,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.space4),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder:
                (context, child) =>
                    Transform.scale(scale: _scaleAnimation.value, child: child),
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              behavior: HitTestBehavior.opaque,
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: AppDimensions.buttonMinHeight,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: AppDimensions.roundedMedium,
                  border: border,
                  boxShadow:
                      widget.type == CalculatorKeyType.equals
                          ? [
                            BoxShadow(
                              color: backgroundColor.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                          : [
                            BoxShadow(
                              color:
                                  isDark
                                      ? AppColors.darkShadow
                                      : AppColors.lightShadow,
                              blurRadius: 2,
                              offset: const Offset(0, 1.5),
                            ),
                          ],
                ),
                alignment: Alignment.center,
                child:
                    widget.icon ??
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize:
                            widget.type == CalculatorKeyType.scientific
                                ? 15
                                : (widget.type == CalculatorKeyType.operator
                                    ? 22
                                    : 20),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

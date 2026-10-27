import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:calcpro/core/constants/app_colors.dart';
import 'package:calcpro/core/constants/app_dimensions.dart';
import 'package:calcpro/core/constants/app_strings.dart';
import 'package:calcpro/features/calculator/models/calculation_state.dart';
import 'package:calcpro/features/calculator/providers/calculator_provider.dart';
import 'package:calcpro/features/settings/providers/settings_provider.dart';

/// Calculation display displaying expression, result, live preview, and badges.
class CalculatorDisplay extends StatefulWidget {
  const CalculatorDisplay({super.key});

  @override
  State<CalculatorDisplay> createState() => _CalculatorDisplayState();
}

class _CalculatorDisplayState extends State<CalculatorDisplay> {
  final ScrollController _expressionScrollController = ScrollController();
  final ScrollController _resultScrollController = ScrollController();

  @override
  void dispose() {
    _expressionScrollController.dispose();
    _resultScrollController.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_expressionScrollController.hasClients) {
        _expressionScrollController.animateTo(
          _expressionScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
      if (_resultScrollController.hasClients) {
        _resultScrollController.animateTo(
          _resultScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _copyResult(BuildContext context, String result) {
    if (result.isEmpty) return;
    Clipboard.setData(ClipboardData(text: result));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.success,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(AppStrings.copied),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareCalculation(String expression, String result) {
    final String shareText =
        expression.isNotEmpty
            ? '$expression = $result\n(Calculated with CalcPro)'
            : '$result\n(Calculated with CalcPro)';
    SharePlus.instance.share(ShareParams(text: shareText));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final calcProvider = context.watch<CalculatorProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final CalculationState state = calcProvider.state;

    _scrollToEnd();

    final Color surfaceColor =
        isDark ? AppColors.darkDisplaySurface : AppColors.lightDisplaySurface;
    final Color borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space12,
      ),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: AppDimensions.roundedLarge,
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.darkShadow : AppColors.lightShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Top Badges & Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Angle Mode & Memory Badges
              Row(
                children: [
                  GestureDetector(
                    onTap: () => settingsProvider.toggleAngleMode(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? const Color(0xFF252B3A)
                                : const Color(0xFFE6ECF7),
                        borderRadius: AppDimensions.roundedSmall,
                      ),
                      child: Text(
                        settingsProvider.angleMode.label,
                        style: TextStyle(
                          color:
                              isDark
                                  ? AppColors.darkPrimaryAccent
                                  : AppColors.lightPrimaryAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  if (state.hasMemory) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.memoryActive.withValues(alpha: 0.15),
                        borderRadius: AppDimensions.roundedSmall,
                      ),
                      child: const Text(
                        'M',
                        style: TextStyle(
                          color: AppColors.memoryActive,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              // Copy and Share actions
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined, size: 18),
                    tooltip: AppStrings.share,
                    color: secondaryTextColor,
                    visualDensity: VisualDensity.compact,
                    onPressed:
                        () => _shareCalculation(
                          state.expression,
                          state.hasError ? state.errorMessage! : state.result,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    tooltip: AppStrings.copy,
                    color: secondaryTextColor,
                    visualDensity: VisualDensity.compact,
                    onPressed:
                        () => _copyResult(
                          context,
                          state.hasError ? state.errorMessage! : state.result,
                        ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.space8),

          // Complete Expression (Scrollable horizontally)
          SingleChildScrollView(
            controller: _expressionScrollController,
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(
              state.expression.isEmpty ? '0' : state.expression,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.space4),

          // Primary Result or Error (Large text, horizontally scrollable if needed)
          SingleChildScrollView(
            controller: _resultScrollController,
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(
              state.hasError ? state.errorMessage! : state.result,
              key: const Key('calculator_result_text'),
              style: TextStyle(
                color:
                    state.hasError
                        ? (isDark ? AppColors.darkError : AppColors.lightError)
                        : textColor,
                fontSize:
                    state.hasError
                        ? 24
                        : (state.result.length > 12
                            ? 32
                            : (state.result.length > 8 ? 40 : 48)),
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Live Preview Result (Small text shown while user is typing)
          if (state.hasPreview && !state.hasError && !state.isEvaluated) ...[
            const SizedBox(height: 2),
            Text(
              '= ${state.previewResult}',
              style: TextStyle(
                color:
                    isDark
                        ? AppColors.darkPrimaryAccent.withValues(alpha: 0.9)
                        : AppColors.lightPrimaryAccent.withValues(alpha: 0.9),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

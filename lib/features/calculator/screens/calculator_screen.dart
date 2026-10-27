import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calcpro/core/constants/app_colors.dart';
import 'package:calcpro/core/constants/app_dimensions.dart';
import 'package:calcpro/core/constants/app_strings.dart';
import 'package:calcpro/features/calculator/providers/calculator_provider.dart';
import 'package:calcpro/features/calculator/widgets/calculator_display.dart';
import 'package:calcpro/features/calculator/widgets/calculator_keypad.dart';
import 'package:calcpro/features/calculator/widgets/keyboard_listener_wrapper.dart';
import 'package:calcpro/features/calculator/widgets/memory_bar.dart';
import 'package:calcpro/features/calculator/widgets/scientific_keypad.dart';
import 'package:calcpro/features/history/screens/history_screen.dart';
import 'package:calcpro/features/settings/providers/settings_provider.dart';
import 'package:calcpro/features/settings/screens/settings_screen.dart';

/// Main screen of CalcPro featuring responsive layout and scientific transitions.
class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final calcProvider = context.watch<CalculatorProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    final bool isScientific = calcProvider.mode.isScientific;

    return CalculatorKeyboardListener(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        isDark
                            ? [
                              AppColors.darkPrimaryAccent,
                              AppColors.darkEqualsButton,
                            ]
                            : [
                              AppColors.lightPrimaryAccent,
                              const Color(0xFF8B7CFF),
                            ],
                  ),
                  borderRadius: AppDimensions.roundedSmall,
                ),
                child: const Icon(
                  Icons.calculate_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          leadingWidth: 44,
          titleSpacing: 4,
          title: Text(
            AppStrings.appName,
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.lightTextPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 19,
              letterSpacing: -0.3,
            ),
          ),
          actions: [
            // Scientific Mode Toggle Button
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.science_outlined,
                color:
                    isScientific
                        ? (isDark
                            ? AppColors.darkPrimaryAccent
                            : AppColors.lightPrimaryAccent)
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
              ),
              tooltip: isScientific ? 'Basic Mode' : 'Scientific Mode',
              onPressed: calcProvider.toggleMode,
            ),
            // Theme Toggle Button
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
              tooltip: 'Toggle Theme',
              onPressed: settingsProvider.toggleTheme,
            ),
            // History Button
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.history_rounded,
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
              tooltip: AppStrings.history,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HistoryScreen(),
                  ),
                );
              },
            ),
            // Settings Button
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.settings_outlined,
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
              tooltip: AppStrings.settings,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth =
                  constraints.maxWidth > 650
                      ? (isScientific ? 720 : AppDimensions.maxContentWidth)
                      : constraints.maxWidth;

              return Center(
                child: SizedBox(
                  width: maxWidth,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Calculation Display Area
                        const CalculatorDisplay(),

                        // Memory Functions Bar
                        const MemoryBar(),

                        const SizedBox(height: AppDimensions.space8),

                        // Keypad Area: Scientific + Basic Keypads
                        if (constraints.maxWidth > 650 && isScientific)
                          // Side-by-side layout on wider screens / desktop
                          const Padding(
                            padding: EdgeInsets.only(
                              bottom: AppDimensions.space12,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(flex: 4, child: ScientificKeypad()),
                                Expanded(flex: 5, child: CalculatorKeypad()),
                              ],
                            ),
                          )
                        else
                          // Stacked layout on standard mobile screens
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedCrossFade(
                                duration: const Duration(milliseconds: 200),
                                crossFadeState:
                                    isScientific
                                        ? CrossFadeState.showFirst
                                        : CrossFadeState.showSecond,
                                firstChild: const Padding(
                                  padding: EdgeInsets.only(bottom: 6),
                                  child: ScientificKeypad(),
                                ),
                                secondChild: const SizedBox.shrink(),
                              ),
                              const CalculatorKeypad(),
                              const SizedBox(height: AppDimensions.space12),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

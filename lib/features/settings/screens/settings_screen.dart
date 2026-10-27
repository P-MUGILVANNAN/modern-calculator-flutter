import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calcpro/core/constants/app_colors.dart';
import 'package:calcpro/core/constants/app_dimensions.dart';
import 'package:calcpro/core/constants/app_strings.dart';
import 'package:calcpro/features/calculator/models/angle_mode.dart';
import 'package:calcpro/features/history/providers/history_provider.dart';
import 'package:calcpro/features/history/widgets/clear_history_dialog.dart';
import 'package:calcpro/features/settings/providers/settings_provider.dart';
import 'package:calcpro/features/settings/widgets/settings_tile.dart';

/// Full settings screen for theme, angle mode, precision, haptics, and about info.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showAboutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: AppStrings.appVersion,
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color:
              isDark ? AppColors.darkEqualsButton : AppColors.lightEqualsButton,
          borderRadius: AppDimensions.roundedMedium,
        ),
        child: const Icon(
          Icons.calculate_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      children: [
        const SizedBox(height: 12),
        const Text(
          AppStrings.aboutDescription,
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
      ],
    );
  }

  Future<void> _clearHistory(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const ClearHistoryDialog(),
    );
    if (confirmed == true && context.mounted) {
      await context.read<HistoryProvider>().clearAll();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('History cleared successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color sectionHeaderColor =
        isDark ? AppColors.darkPrimaryAccent : AppColors.lightPrimaryAccent;
    final Color dropdownColor =
        isDark ? AppColors.darkDisplaySurface : AppColors.lightDisplaySurface;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
        children: [
          // Section: Appearance
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space8,
            ),
            child: Text(
              AppStrings.appearance.toUpperCase(),
              style: TextStyle(
                color: sectionHeaderColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),

          SettingsTile(
            icon: Icons.palette_outlined,
            title: AppStrings.theme,
            subtitle:
                settings.themeMode == ThemeMode.system
                    ? AppStrings.themeSystem
                    : (settings.themeMode == ThemeMode.dark
                        ? AppStrings.themeDark
                        : AppStrings.themeLight),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              dropdownColor: dropdownColor,
              underline: const SizedBox(),
              onChanged: (mode) {
                if (mode != null) settings.setThemeMode(mode);
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(AppStrings.themeDark),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(AppStrings.themeLight),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(AppStrings.themeSystem),
                ),
              ],
            ),
          ),

          const Divider(indent: 16, endIndent: 16),

          // Section: Calculations
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space8,
            ),
            child: Text(
              AppStrings.calculations.toUpperCase(),
              style: TextStyle(
                color: sectionHeaderColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),

          SettingsTile(
            icon: Icons.square_foot_rounded,
            title: AppStrings.angleMode,
            subtitle:
                settings.angleMode == AngleMode.degrees
                    ? AppStrings.degrees
                    : AppStrings.radians,
            trailing: DropdownButton<AngleMode>(
              value: settings.angleMode,
              dropdownColor: dropdownColor,
              underline: const SizedBox(),
              onChanged: (mode) {
                if (mode != null) settings.setAngleMode(mode);
              },
              items: const [
                DropdownMenuItem(
                  value: AngleMode.degrees,
                  child: Text('Degrees (DEG)'),
                ),
                DropdownMenuItem(
                  value: AngleMode.radians,
                  child: Text('Radians (RAD)'),
                ),
              ],
            ),
          ),

          SettingsTile(
            icon: Icons.pin_outlined,
            title: AppStrings.decimalPrecision,
            subtitle:
                settings.decimalPrecision == -1
                    ? 'Automatic'
                    : '${settings.decimalPrecision} Decimal Places',
            trailing: DropdownButton<int>(
              value: settings.decimalPrecision,
              dropdownColor: dropdownColor,
              underline: const SizedBox(),
              onChanged: (val) {
                if (val != null) settings.setDecimalPrecision(val);
              },
              items: const [
                DropdownMenuItem(value: -1, child: Text('Auto')),
                DropdownMenuItem(value: 0, child: Text('0')),
                DropdownMenuItem(value: 2, child: Text('2')),
                DropdownMenuItem(value: 4, child: Text('4')),
                DropdownMenuItem(value: 6, child: Text('6')),
                DropdownMenuItem(value: 8, child: Text('8')),
              ],
            ),
          ),

          SettingsTile(
            icon: Icons.format_list_numbered_rounded,
            title: AppStrings.thousandsSeparator,
            subtitle: 'Format numbers as 1,234,567',
            trailing: Switch(
              value: settings.useThousandsSeparator,
              onChanged: (val) => settings.setUseThousandsSeparator(val),
            ),
          ),

          const Divider(indent: 16, endIndent: 16),

          // Section: Feedback
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space8,
            ),
            child: Text(
              AppStrings.feedback.toUpperCase(),
              style: TextStyle(
                color: sectionHeaderColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),

          SettingsTile(
            icon: Icons.vibration_rounded,
            title: AppStrings.hapticFeedback,
            subtitle: 'Vibrate slightly on button press',
            trailing: Switch(
              value: settings.hapticEnabled,
              onChanged: (val) => settings.setHapticEnabled(val),
            ),
          ),

          SettingsTile(
            icon: Icons.volume_up_outlined,
            title: AppStrings.buttonSound,
            subtitle: 'Play audio click on button press',
            trailing: Switch(
              value: settings.soundEnabled,
              onChanged: (val) => settings.setSoundEnabled(val),
            ),
          ),

          const Divider(indent: 16, endIndent: 16),

          // Section: Data & About
          SettingsTile(
            icon: Icons.delete_outline_rounded,
            title: AppStrings.clearHistory,
            subtitle: 'Erase all saved calculations',
            onTap: () => _clearHistory(context),
          ),

          SettingsTile(
            icon: Icons.info_outline_rounded,
            title: AppStrings.about,
            subtitle: 'Version ${AppStrings.appVersion}',
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }
}

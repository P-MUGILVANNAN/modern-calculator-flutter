import 'package:flutter/material.dart';
import 'package:calcpro/core/constants/app_colors.dart';
import 'package:calcpro/core/constants/app_dimensions.dart';
import 'package:calcpro/core/constants/app_strings.dart';

/// Confirmation dialog for clearing all calculation history.
class ClearHistoryDialog extends StatelessWidget {
  const ClearHistoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      title: const Text(
        AppStrings.clearHistory,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text(
        AppStrings.clearHistoryConfirm,
        style: TextStyle(fontSize: 14),
      ),
      shape: RoundedRectangleBorder(borderRadius: AppDimensions.roundedMedium),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            AppStrings.cancel,
            style: TextStyle(
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
            ),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor:
                isDark ? AppColors.darkError : AppColors.lightError,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(AppStrings.clear),
        ),
      ],
    );
  }
}

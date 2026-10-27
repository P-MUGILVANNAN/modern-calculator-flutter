import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calcpro/core/constants/app_colors.dart';
import 'package:calcpro/core/constants/app_dimensions.dart';
import 'package:calcpro/core/constants/app_strings.dart';
import 'package:calcpro/features/history/models/calculation_history_item.dart';

/// Card component presenting a single calculation history item.
class HistoryItemCard extends StatelessWidget {
  final CalculationHistoryItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HistoryItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: item.result));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.copied),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color cardBackground =
        isDark ? AppColors.darkDisplaySurface : AppColors.lightDisplaySurface;
    final Color borderColor =
        isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder;
    final Color textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final Color secondaryTextColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space4,
      ),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: AppDimensions.roundedMedium,
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.darkShadow : AppColors.lightShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppDimensions.roundedMedium,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
              vertical: AppDimensions.space12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: timestamp and action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.formattedTime,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          tooltip: AppStrings.copy,
                          color: secondaryTextColor,
                          visualDensity: VisualDensity.compact,
                          onPressed: () => _copyToClipboard(context),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            size: 16,
                          ),
                          tooltip: AppStrings.delete,
                          color:
                              isDark
                                  ? AppColors.darkError
                                  : AppColors.lightError,
                          visualDensity: VisualDensity.compact,
                          onPressed: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.space4),

                // Expression
                Text(
                  item.expression,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 2),

                // Result (highlighted)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '= ${item.result}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

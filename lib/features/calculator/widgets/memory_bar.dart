import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calcpro/core/constants/app_colors.dart';
import 'package:calcpro/core/constants/app_dimensions.dart';
import 'package:calcpro/features/calculator/providers/calculator_provider.dart';

/// Memory bar providing MC, MR, M+, M- buttons.
class MemoryBar extends StatelessWidget {
  const MemoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final calcProvider = context.watch<CalculatorProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasMemory = calcProvider.state.hasMemory;

    final Color activeColor =
        isDark ? AppColors.darkPrimaryAccent : AppColors.lightPrimaryAccent;
    final Color inactiveColor =
        isDark
            ? AppColors.darkTextSecondary.withValues(alpha: 0.5)
            : AppColors.lightTextSecondary.withValues(alpha: 0.6);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildMemoryButton(
                label: 'MC',
                isEnabled: hasMemory,
                color: hasMemory ? AppColors.darkError : inactiveColor,
                onTap: calcProvider.memoryClear,
              ),
              _buildMemoryButton(
                label: 'MR',
                isEnabled: hasMemory,
                color: hasMemory ? activeColor : inactiveColor,
                onTap: calcProvider.memoryRecall,
              ),
              _buildMemoryButton(
                label: 'M+',
                isEnabled: true,
                color: activeColor,
                onTap: calcProvider.memoryAdd,
              ),
              _buildMemoryButton(
                label: 'M−',
                isEnabled: true,
                color: activeColor,
                onTap: calcProvider.memorySubtract,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.backspace_outlined, size: 20),
            tooltip: 'Backspace',
            color:
                isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
            onPressed: calcProvider.deleteLast,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryButton({
    required String label,
    required bool isEnabled,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TextButton(
      onPressed: isEnabled ? onTap : null,
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 32),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calcpro/core/constants/app_colors.dart';
import 'package:calcpro/core/constants/app_dimensions.dart';
import 'package:calcpro/core/constants/app_strings.dart';
import 'package:calcpro/features/calculator/providers/calculator_provider.dart';
import 'package:calcpro/features/history/providers/history_provider.dart';
import 'package:calcpro/features/history/widgets/clear_history_dialog.dart';
import 'package:calcpro/features/history/widgets/history_item_card.dart';

/// Calculation history screen with persistent list and clear-all action.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const ClearHistoryDialog(),
    );
    if (confirmed == true && context.mounted) {
      await context.read<HistoryProvider>().clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();
    final calcProvider = context.read<CalculatorProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.history),
        actions: [
          if (historyProvider.hasHistory)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              tooltip: AppStrings.clearHistory,
              onPressed: () => _confirmClear(context),
            ),
        ],
      ),
      body:
          historyProvider.items.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_toggle_off_rounded,
                      size: 72,
                      color:
                          isDark
                              ? AppColors.darkCardBorder
                              : AppColors.lightCardBorder,
                    ),
                    const SizedBox(height: AppDimensions.space16),
                    Text(
                      AppStrings.noHistoryTitle,
                      style: TextStyle(
                        color:
                            isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space32,
                      ),
                      child: Text(
                        AppStrings.noHistorySubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.space8,
                ),
                itemCount: historyProvider.items.length,
                itemBuilder: (context, index) {
                  final item = historyProvider.items[index];
                  return HistoryItemCard(
                    key: ValueKey(item.id),
                    item: item,
                    onTap: () {
                      calcProvider.reuseHistory(item.expression, item.result);
                      Navigator.of(context).pop();
                    },
                    onDelete: () => historyProvider.deleteItem(item.id),
                  );
                },
              ),
    );
  }
}

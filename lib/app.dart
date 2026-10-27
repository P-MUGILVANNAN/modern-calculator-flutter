import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcpro/core/constants/app_strings.dart';
import 'package:calcpro/core/theme/app_theme.dart';
import 'package:calcpro/features/calculator/providers/calculator_provider.dart';
import 'package:calcpro/features/calculator/screens/calculator_screen.dart';
import 'package:calcpro/features/history/providers/history_provider.dart';
import 'package:calcpro/features/history/services/history_storage.dart';
import 'package:calcpro/features/settings/providers/settings_provider.dart';

/// Root application widget configuring dependency injection and Material3 themes.
class CalcProApp extends StatelessWidget {
  final SharedPreferences? prefs;
  final HistoryStorage? historyStorage;

  const CalcProApp({super.key, this.prefs, this.historyStorage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
        ChangeNotifierProvider(create: (_) => HistoryProvider(historyStorage)),
        ChangeNotifierProxyProvider2<
          SettingsProvider,
          HistoryProvider,
          CalculatorProvider
        >(
          create:
              (ctx) => CalculatorProvider(
                settingsProvider: ctx.read<SettingsProvider>(),
                historyProvider: ctx.read<HistoryProvider>(),
              ),
          update:
              (ctx, settings, history, previous) =>
                  previous ??
                  CalculatorProvider(
                    settingsProvider: settings,
                    historyProvider: history,
                  ),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settings.themeMode,
            home: const CalculatorScreen(),
          );
        },
      ),
    );
  }
}

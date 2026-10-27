import 'package:flutter/material.dart';
import 'package:calcpro/features/calculator/models/angle_mode.dart';

/// App preferences and configuration.
class AppSettings {
  final ThemeMode themeMode;
  final AngleMode angleMode;
  final bool hapticFeedbackEnabled;
  final bool buttonSoundEnabled;
  final int decimalPrecision; // -1 = Auto
  final bool useThousandsSeparator;

  const AppSettings({
    this.themeMode = ThemeMode.dark,
    this.angleMode = AngleMode.degrees,
    this.hapticFeedbackEnabled = true,
    this.buttonSoundEnabled = false,
    this.decimalPrecision = -1,
    this.useThousandsSeparator = true,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    AngleMode? angleMode,
    bool? hapticFeedbackEnabled,
    bool? buttonSoundEnabled,
    int? decimalPrecision,
    bool? useThousandsSeparator,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      angleMode: angleMode ?? this.angleMode,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      buttonSoundEnabled: buttonSoundEnabled ?? this.buttonSoundEnabled,
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      useThousandsSeparator:
          useThousandsSeparator ?? this.useThousandsSeparator,
    );
  }
}

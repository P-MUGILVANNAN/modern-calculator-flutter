import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcpro/features/calculator/models/angle_mode.dart';
import 'package:calcpro/features/settings/models/app_settings.dart';

/// Provider for managing and persisting user preferences.
class SettingsProvider extends ChangeNotifier {
  static const String _keyThemeMode = 'calcpro_pref_theme';
  static const String _keyAngleMode = 'calcpro_pref_angle';
  static const String _keyHaptic = 'calcpro_pref_haptic';
  static const String _keySound = 'calcpro_pref_sound';
  static const String _keyPrecision = 'calcpro_pref_precision';
  static const String _keyThousands = 'calcpro_pref_thousands';

  final SharedPreferences? _prefs;
  AppSettings _settings;

  SettingsProvider([this._prefs]) : _settings = _loadInitialSettings(_prefs);

  AppSettings get settings => _settings;
  ThemeMode get themeMode => _settings.themeMode;
  AngleMode get angleMode => _settings.angleMode;
  bool get hapticEnabled => _settings.hapticFeedbackEnabled;
  bool get soundEnabled => _settings.buttonSoundEnabled;
  int get decimalPrecision => _settings.decimalPrecision;
  bool get useThousandsSeparator => _settings.useThousandsSeparator;

  static AppSettings _loadInitialSettings(SharedPreferences? prefs) {
    if (prefs == null) return const AppSettings();

    // Theme mode
    final String? themeStr = prefs.getString(_keyThemeMode);
    ThemeMode theme = ThemeMode.dark;
    if (themeStr == 'light') {
      theme = ThemeMode.light;
    } else if (themeStr == 'system') {
      theme = ThemeMode.system;
    }

    // Angle mode
    final String? angleStr = prefs.getString(_keyAngleMode);
    final AngleMode angle =
        (angleStr == 'rad') ? AngleMode.radians : AngleMode.degrees;

    // Toggles
    final bool haptic = prefs.getBool(_keyHaptic) ?? true;
    final bool sound = prefs.getBool(_keySound) ?? false;
    final int precision = prefs.getInt(_keyPrecision) ?? -1;
    final bool thousands = prefs.getBool(_keyThousands) ?? true;

    return AppSettings(
      themeMode: theme,
      angleMode: angle,
      hapticFeedbackEnabled: haptic,
      buttonSoundEnabled: sound,
      decimalPrecision: precision,
      useThousandsSeparator: thousands,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_settings.themeMode == mode) return;
    _settings = _settings.copyWith(themeMode: mode);
    notifyListeners();

    final String val =
        mode == ThemeMode.light
            ? 'light'
            : mode == ThemeMode.system
            ? 'system'
            : 'dark';
    await _prefs?.setString(_keyThemeMode, val);
  }

  Future<void> toggleTheme() async {
    final next =
        _settings.themeMode == ThemeMode.dark
            ? ThemeMode.light
            : ThemeMode.dark;
    await setThemeMode(next);
  }

  Future<void> setAngleMode(AngleMode mode) async {
    if (_settings.angleMode == mode) return;
    _settings = _settings.copyWith(angleMode: mode);
    notifyListeners();

    await _prefs?.setString(
      _keyAngleMode,
      mode == AngleMode.radians ? 'rad' : 'deg',
    );
  }

  Future<void> toggleAngleMode() async {
    final next =
        _settings.angleMode == AngleMode.degrees
            ? AngleMode.radians
            : AngleMode.degrees;
    await setAngleMode(next);
  }

  Future<void> setHapticEnabled(bool enabled) async {
    _settings = _settings.copyWith(hapticFeedbackEnabled: enabled);
    notifyListeners();
    await _prefs?.setBool(_keyHaptic, enabled);
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _settings = _settings.copyWith(buttonSoundEnabled: enabled);
    notifyListeners();
    await _prefs?.setBool(_keySound, enabled);
  }

  Future<void> setDecimalPrecision(int precision) async {
    _settings = _settings.copyWith(decimalPrecision: precision);
    notifyListeners();
    await _prefs?.setInt(_keyPrecision, precision);
  }

  Future<void> setUseThousandsSeparator(bool enabled) async {
    _settings = _settings.copyWith(useThousandsSeparator: enabled);
    notifyListeners();
    await _prefs?.setBool(_keyThousands, enabled);
  }
}

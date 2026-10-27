/// Application string constants.
class AppStrings {
  AppStrings._();

  static const String appName = 'CalcPro';
  static const String appSubtitle = 'Modern Smart Calculator';
  static const String appVersion = '1.0.0';

  // Navigation & Screen Titles
  static const String history = 'History';
  static const String settings = 'Settings';
  static const String clearHistory = 'Clear History';
  static const String clearHistoryConfirm =
      'Are you sure you want to delete all calculation history? This action cannot be undone.';
  static const String noHistoryTitle = 'No Calculations Yet';
  static const String noHistorySubtitle =
      'Your calculation history will appear here once you perform calculations.';

  // Actions
  static const String copy = 'Copy';
  static const String copied = 'Result copied to clipboard';
  static const String share = 'Share';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String clear = 'Clear';

  // Settings
  static const String appearance = 'Appearance';
  static const String theme = 'Theme';
  static const String themeSystem = 'System Default';
  static const String themeDark = 'Dark Theme';
  static const String themeLight = 'Light Theme';
  static const String calculations = 'Calculations';
  static const String angleMode = 'Angle Mode';
  static const String degrees = 'Degrees (DEG)';
  static const String radians = 'Radians (RAD)';
  static const String decimalPrecision = 'Decimal Precision';
  static const String thousandsSeparator = 'Thousands Separator (,)';
  static const String feedback = 'Feedback';
  static const String hapticFeedback = 'Haptic Feedback';
  static const String buttonSound = 'Button Sound';
  static const String about = 'About CalcPro';
  static const String aboutDescription =
      'CalcPro is a modern, high-precision scientific calculator crafted with Flutter. It delivers elegant dark and light themes, continuous arithmetic, trigonometric & logarithmic functions, memory storage, persistent history, and desktop keyboard shortcuts.';

  // Errors
  static const String errorInvalid = 'Invalid expression';
  static const String errorDivZero = 'Cannot divide by zero';
  static const String errorDomain = 'Math domain error';
  static const String errorOverflow = 'Result is too large';
}

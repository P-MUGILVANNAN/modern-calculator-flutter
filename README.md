# CalcPro — Modern Smart Calculator Using Flutter

[![Flutter](https://img.shields.io/badge/Flutter-3.29.1-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7.0-0175C2?logo=dart)](https://dart.dev)
[![Tests](https://img.shields.io/badge/Tests-63%20passed-brightgreen)](#automated-testing)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**CalcPro** is a modern, high-precision, responsive scientific calculator application built with Flutter and Dart. Designed with a premium dark and light aesthetic inspired by top mobile utility apps, it provides smooth animations, continuous mathematical calculations, comprehensive scientific operations, persistent calculation history, and extensive settings.

---

## Key Features

### 1. Calculation Engine & Mathematical Precision
- **Operator Precedence & Parentheses**: Evaluates complex expressions respecting algebraic hierarchy: `2 + 3 × 4 = 14`, `(2 + 3) × 4 = 20`.
- **Continuous Calculations**: Automatically continues evaluating from the previous result when an operator is tapped.
- **Smart Percentage Logic**:
  - Additive: `200 + 10% = 220`
  - Subtractive: `200 - 10% = 180`
  - Multiplicative & Standalone: `200 × 50% = 100`, `50% = 0.5`
- **Real-Time Live Preview**: Computes intermediate results on-the-fly while typing without blocking the UI or throwing errors.
- **Floating-Point Sanitation**: Cleans IEEE 754 precision noise (e.g. `0.1 + 0.2` formats as `0.3`).
- **Domain Error Handling**: Rejects math errors with friendly error messages:
  - *Cannot divide by zero*
  - *Math domain error* (e.g., $\sqrt{-1}$, $\ln(0)$, $\arcsin(2)$)
  - *Result is too large* (e.g., overflow beyond double limits)
  - *Invalid expression*

### 2. Scientific Calculator Mode
- **Trigonometry**: `sin`, `cos`, `tan`
- **Inverse Trigonometry (`2nd` toggle)**: $\sin^{-1}$, $\cos^{-1}$, $\tan^{-1}$
- **Angle Modes**: Toggle between **Degrees (DEG)** and **Radians (RAD)** with persistent state.
- **Logarithms & Exponents**: Natural log ($\ln$), Log base 10 ($\log$), Power ($x^y$), Square ($x^2$), Reciprocal ($1/x$).
- **Roots**: Square root ($\sqrt{x}$), Cube root ($\sqrt[3]{x}$).
- **Factorial ($n!$)**: Factorial calculation with integer domain validation and overflow limits ($n \le 170$).
- **Mathematical Constants**: $\pi$ (`3.14159...`) and $e$ (`2.71828...`).
- **Absolute Value & Modulo**: $|x|$, $\text{mod}$.

### 3. Memory Functions
- **MC**: Clear calculator memory.
- **MR**: Recall stored memory value into active expression.
- **M+**: Add current expression/result to memory.
- **M−**: Subtract current expression/result from memory.
- **Active Memory Badge**: Visual `M` indicator appears on display when memory is stored.

### 4. Calculation History
- **Persistent Local Storage**: Calculations persist across app restarts via `SharedPreferences`.
- **Chronological Ordering**: Most recent calculations listed first with relative timestamps.
- **Tap-to-Reuse**: Tap any history item to immediately load its expression and result back into the calculator.
- **Clipboard Copy & Deletion**: Quick copy button and individual item deletion.
- **Clear All with Confirmation**: Modal confirmation dialog before clearing all history.

### 5. Theme & User Preferences
- **Dark Theme (Default)**: Deep slate aesthetic (`#10131C` background, `#191E2B` display surface, `#8B7CFF` accent, `#7C5CFC` equals button).
- **Light Theme**: Clean, bright contrast palette (`#F3F5FA` background, `#FFFFFF` surface, `#6C52EE` accent).
- **System Default**: Follows OS theme automatically.
- **Decimal Precision**: Configure Auto or fixed precision (0, 2, 4, 6, 8 decimal places).
- **Thousands Separator**: Optional comma separators (e.g., `1,234,567.89`).
- **Tactile Feedback**: Haptic vibrations on button taps.
- **Button Sound**: Optional audio click toggle (disabled by default).

### 6. Desktop & Web Keyboard Shortcuts
Full physical keyboard support when running on Desktop or Web:
- Digits: `0` – `9`
- Decimal: `.`
- Operators: `+`, `-`, `*`, `/`
- Parentheses: `(`, `)`
- Percentage: `%`
- Power: `^`
- Equals: `Enter`, `=`, `Numpad Enter`
- Delete: `Backspace`
- Clear All: `Escape`, `Delete`

### 7. Responsive Layout
- **Mobile Phones**: Responsive keypad with expandable scientific drawer and zero vertical overflow.
- **Tablets & Desktop**: Automatically expands into a side-by-side scientific + standard layout centered within a max-width container.

---

## Architecture & Code Organization

CalcPro adheres to a modular, feature-oriented architecture:

```
lib/
├── app.dart                                # MultiProvider and MaterialApp root
├── main.dart                               # Entrypoint and storage initialization
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart                 # Dark and Light color palettes
│   │   ├── app_dimensions.dart             # Layout metrics, radii, and spacing
│   │   └── app_strings.dart                # Localization and UI strings
│   ├── theme/
│   │   └── app_theme.dart                  # Material 3 theme data definitions
│   └── utils/
│       ├── haptic_feedback_helper.dart     # System tactile and click audio wrapper
│       └── number_formatter.dart           # Precision and thousands separator formatter
│
└── features/
    ├── calculator/
    │   ├── models/
    │   │   ├── angle_mode.dart             # Degrees vs Radians enum
    │   │   ├── calculation_state.dart      # Immutable calculator state model
    │   │   ├── calculator_key_type.dart    # Key style category enum
    │   │   └── calculator_mode.dart        # Basic vs Scientific mode enum
    │   ├── providers/
    │   │   └── calculator_provider.dart    # Calculation state controller
    │   ├── services/
    │   │   └── calculation_engine.dart     # High-precision math parser & evaluator
    │   ├── widgets/
    │   │   ├── calculator_button.dart      # Micro-animated interactive key
    │   │   ├── calculator_display.dart     # Expression, result, and badges display
    │   │   ├── calculator_keypad.dart      # Standard 5x4 keypad
    │   │   ├── keyboard_listener_wrapper.dart # Desktop/Web physical keyboard shortcuts
    │   │   ├── memory_bar.dart             # MC, MR, M+, M- and Backspace bar
    │   │   └── scientific_keypad.dart      # Trigonometric & logarithmic keypad
    │   └── screens/
    │       └── calculator_screen.dart      # Primary responsive calculator screen
    │
    ├── history/
    │   ├── models/
    │   │   └── calculation_history_item.dart # History item model with JSON serialization
    │   ├── providers/
    │   │   └── history_provider.dart       # History state management
    │   ├── services/
    │   │   └── history_storage.dart        # SharedPreferences persistence layer
    │   ├── screens/
    │   │   └── history_screen.dart         # Calculation history viewer
    │   └── widgets/
    │       ├── clear_history_dialog.dart   # Confirmation modal
    │       └── history_item_card.dart      # Individual history record card
    │
    └── settings/
        ├── models/
        │   └── app_settings.dart           # Preferences state model
        ├── providers/
        │   └── settings_provider.dart      # Preference change listener and storage
        ├── screens/
        │   └── settings_screen.dart        # Preferences and About screen
        └── widgets/
            └── settings_tile.dart          # Reusable settings list tile
```

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.29+ recommended)
- [Dart SDK](https://dart.dev/get-dart) (version 3.7+ included with Flutter)
- Chrome or Edge browser (for Web) or Android Studio / SDK (for Android)

### Setup Commands

1. **Clone or navigate to the project directory**:
   ```bash
   cd "Modern Calculator"
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Format Dart code**:
   ```bash
   dart format .
   ```

4. **Run static analysis**:
   ```bash
   flutter analyze
   ```

5. **Run test suite**:
   ```bash
   flutter test
   ```

---

## Automated Testing

CalcPro includes a comprehensive automated test suite with **63 automated tests** covering calculation accuracy, precedence, error handling, formatting, state management, UI widgets, and full end-to-end user journeys:

```bash
# Run all unit, widget, and integration flow tests
flutter test

# Run individual test files
flutter test test/calculation_engine_test.dart
flutter test test/number_formatter_test.dart
flutter test test/calculator_provider_test.dart
flutter test test/history_storage_test.dart
flutter test test/widget_test.dart
flutter test test/calculator_flow_test.dart
```

### Verified Test Cases
- Basic Arithmetic: `2 + 3 = 5`, `10 − 4 = 6`, `6 × 7 = 42`, `20 ÷ 4 = 5`
- Algebraic Precedence: `2 + 3 × 4 = 14`, `(2 + 3) × 4 = 20`
- Percentage Arithmetic: `200 + 10% = 220`, `200 - 10% = 180`, `200 × 50% = 100`
- Scientific Trigonometry: $\sin(30^\circ) = 0.5$, $\cos(60^\circ) = 0.5$, $\tan(45^\circ) = 1.0$, $\arcsin(0.5) = 30^\circ$
- Logarithms & Powers: $\log_{10}(100) = 2$, $\ln(e) = 1$, $3^2 = 9$, $\sqrt{25} = 5$, $\sqrt[3]{27} = 3$
- Factorials: $5! = 120$, $0! = 1$
- Error Conditions: Division by zero (`Cannot divide by zero`), negative roots and invalid logs (`Math domain error`)
- History persistence: Save, load, recreate state, delete, clear
- UI Widget tests: Button input, clear, mode toggling, theme switching, responsive compact layout

---

## Running on Target Platforms

### Running on Web (Chrome / Edge)
To run in the browser without fetching CanvasKit binaries from external CDNs (preventing `TypeError: Failed to fetch` on firewalls, adblockers, or restricted connections):

```bash
# Run on Google Chrome (recommended, uses local CanvasKit)
flutter run -d chrome --no-web-resources-cdn

# Run on Microsoft Edge
flutter run -d edge --no-web-resources-cdn
```

### Running on Android Device or Emulator

1. Connect your Android device via USB with **USB Debugging** enabled, or start an Android Virtual Device (AVD) from Android Studio.
2. Check connected devices:
   ```bash
   flutter devices
   ```
3. Run the application:
   ```bash
   flutter run -d <device-id>
   ```

---

## Building a Release APK (Android)

To compile an optimized, standalone release APK for distribution:

```bash
flutter build apk --release
```

### Output Location
Upon completion, the release APK file is generated at:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Installing the APK
- **Via ADB command-line**:
  ```bash
  adb install -r build/app/outputs/flutter-apk/app-release.apk
  ```
- **Direct installation**: Copy `app-release.apk` to an Android phone, open the file using any File Manager, and confirm the installation.

---

## Troubleshooting

- **CanvasKit `Failed to fetch` Error**: When running on Chrome, if browser privacy extensions, adblockers, or firewall rules block Google's CDN (`gstatic.com`), pass the `--no-web-resources-cdn` flag to serve CanvasKit locally from your machine:
  ```bash
  flutter run -d chrome --no-web-resources-cdn
  ```
- **Dependency Issues**: Run `flutter clean && flutter pub get` to reset local caches.
- **Android SDK Tools Missing**: Install `Android SDK Command-line Tools (latest)` via Android Studio > SDK Manager > SDK Tools.
- **Device Detection**: Run `flutter doctor -v` and `adb devices` to verify Android device connectivity.

---

## License

This project is licensed under the MIT License.

import 'package:flutter/material.dart';

/// Centralized dimensions and spacing for CalcPro.
class AppDimensions {
  AppDimensions._();

  // Spacing
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;

  // Radii
  static const double radiusSmall = 10.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 22.0;
  static const double radiusPill = 999.0;

  // Border Radii
  static final BorderRadius roundedSmall = BorderRadius.circular(radiusSmall);
  static final BorderRadius roundedMedium = BorderRadius.circular(radiusMedium);
  static final BorderRadius roundedLarge = BorderRadius.circular(radiusLarge);
  static final BorderRadius roundedPill = BorderRadius.circular(radiusPill);

  // Button Dimensions
  static const double buttonMinHeight = 60.0;
  static const double buttonGap = 10.0;
  static const double maxContentWidth = 460.0;

  // Elevation & Blur
  static const double defaultElevation = 3.0;
}

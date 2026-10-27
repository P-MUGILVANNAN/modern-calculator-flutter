import 'package:flutter/services.dart';

/// Centralized utility for haptics and button audio feedback.
class FeedbackHelper {
  FeedbackHelper._();

  /// Triggers a subtle tactile pulse if enabled.
  static void triggerHaptic(bool enabled) {
    if (!enabled) return;
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
  }

  /// Triggers a click sound if enabled.
  static void triggerSound(bool enabled) {
    if (!enabled) return;
    try {
      SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }
}

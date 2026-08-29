import 'package:flutter/services.dart';

/// Haptic and sound feedback engine for tactile interactions
class HapticService {
  HapticService._();

  /// Standard button press / selection feedback
  static Future<void> light() async {
    try {
      await HapticFeedback.lightImpact();
      await SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  /// Calculation completed / Save action
  static Future<void> success() async {
    try {
      await HapticFeedback.mediumImpact();
      await SystemSound.play(SystemSoundType.click);
    } catch (_) {}
  }

  /// Item deleted / Warning
  static Future<void> warning() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  /// Tab switched / Segment changed
  static Future<void> selection() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {}
  }
}

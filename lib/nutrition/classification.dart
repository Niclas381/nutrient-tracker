/// Bar colour classification.
library;

import 'models.dart';
import 'targets.dart';

enum BarState { green, yellow, red, none }

/// Why a bar is red; drives "eat X" vs. "main contributors" hints.
enum RedReason { tooLow, tooHigh }

class Classification {
  const Classification(this.state, [this.reason]);

  final BarState state;
  final RedReason? reason;

  static const none = Classification(BarState.none);
}

/// [value] is the daily average; [ulValue] the daily average of the UL basis
/// (total, supplement-only, or another nutrient), defaulting to [value].
Classification classify(Target t, double value, {double? ulValue}) {
  switch (t.type) {
    case TargetType.energy:
      final e = t.energy!;
      final dev = (value - e) / e;
      if (dev.abs() <= energyGreenTolerance) return const Classification(BarState.green);
      if (dev.abs() > energyRedTolerance) {
        return Classification(BarState.red, dev < 0 ? RedReason.tooLow : RedReason.tooHigh);
      }
      return const Classification(BarState.yellow);

    case TargetType.limit:
      return value <= t.limit!
          ? const Classification(BarState.green)
          : const Classification(BarState.red, RedReason.tooHigh);

    case TargetType.pctRange:
      if (value < t.low!) return const Classification(BarState.red, RedReason.tooLow);
      if (value > t.high!) return const Classification(BarState.red, RedReason.tooHigh);
      return const Classification(BarState.green);

    case TargetType.minimum:
    case TargetType.range:
      // A UL only exists for range nutrients; no UL (or only a safe level) never turns a bar red from high intake.
      if (t.ul != null && (ulValue ?? value) > t.ul!) {
        return const Classification(BarState.red, RedReason.tooHigh);
      }
      if (value < t.redBelow!) return const Classification(BarState.red, RedReason.tooLow);
      if (value < t.green!) return const Classification(BarState.yellow);
      return const Classification(BarState.green);

    case TargetType.none:
      return Classification.none;
  }
}

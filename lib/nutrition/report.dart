/// Combines averages, targets and classification into the rows shown on the home screen.
library;

import 'aggregation.dart';
import 'classification.dart';
import 'models.dart';
import 'suggestions.dart';
import 'targets.dart';

class NutrientStatus {
  const NutrientStatus({
    required this.nutrient,
    required this.average,
    required this.target,
    required this.classification,
    this.suggestions = const [],
    this.contributors = const [],
  });

  final NutrientDef nutrient;
  final double average;
  final Target? target;
  final Classification classification;

  /// When red because too low: common foods rich in this nutrient.
  final List<Suggestion> suggestions;

  /// When red because too high: (food id, average amount) of the main contributors from the log.
  final List<MapEntry<int, double>> contributors;
}

class NutrientReport {
  const NutrientReport({required this.window, required this.averages, required this.rows});

  final int window;
  final WindowAverages averages;

  /// In importance order.
  final List<NutrientStatus> rows;

  Iterable<NutrientStatus> get low =>
      rows.where((r) => r.classification.state == BarState.red && r.classification.reason == RedReason.tooLow);

  Iterable<NutrientStatus> get high =>
      rows.where((r) => r.classification.state == BarState.red && r.classification.reason == RedReason.tooHigh);
}

/// Builds the report. Rows are every nutrient with data in the window or with a bar, ordered by importance.
NutrientReport buildReport({
  required Profile profile,
  required List<NutrientDef> nutrients,
  required TargetResolver resolver,
  required WindowAverages averages,
  required SuggestionEngine suggestions,
  required int windowDays,
}) {
  final byCode = {for (final n in nutrients) n.code: n};
  final energyId = byCode['ENERC_KCAL']?.id;
  final avgEnergy = energyId == null ? null : averages.averages[energyId];
  final targets = resolver.resolve(profile, avgEnergyKcal: avgEnergy);

  final rows = <NutrientStatus>[];
  final ordered = [...nutrients]..sort((a, b) => a.importanceRank.compareTo(b.importanceRank));
  for (final n in ordered) {
    final avg = averages.average(n.id);
    final hasData = averages.averages.containsKey(n.id);
    final target = targets[n.id];
    if (!hasData && target == null) continue;

    var cls = Classification.none;
    if (target != null && !averages.isEmpty) {
      final ulValue = switch (target.ulBasis) {
        UlTotal() => avg,
        UlSupplementOnly() => averages.supplementAverages[n.id] ?? 0,
        UlOtherNutrient(:final code) => byCode[code] == null ? avg : averages.average(byCode[code]!.id),
      };
      cls = classify(target, avg, ulValue: ulValue);
    }
    rows.add(NutrientStatus(
      nutrient: n,
      average: avg,
      target: target,
      classification: cls,
      suggestions:
          cls.reason == RedReason.tooLow ? suggestions.richestFoods(n.id) : const [],
      contributors: cls.reason == RedReason.tooHigh
          ? mainContributors(averages.contributions,
              target?.ulBasis is UlOtherNutrient ? byCode[(target!.ulBasis as UlOtherNutrient).code]?.id ?? n.id : n.id)
          : const [],
    ));
  }
  return NutrientReport(window: windowDays, averages: averages, rows: rows);
}

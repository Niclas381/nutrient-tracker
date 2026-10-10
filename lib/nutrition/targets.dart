/// Resolves official reference values into concrete per-day targets for a profile.
library;

import 'dart:math' as math;

import 'models.dart';

/// Where the UL is checked against.
sealed class UlBasis {
  const UlBasis();

  static UlBasis parse(String s) {
    if (s == 'supplement') return const UlSupplementOnly();
    if (s.startsWith('nutrient:')) return UlOtherNutrient(s.substring('nutrient:'.length));
    return const UlTotal();
  }
}

class UlTotal extends UlBasis {
  const UlTotal();
}

/// Only intake from supplement foods counts (e.g. magnesium salts, niacin).
class UlSupplementOnly extends UlBasis {
  const UlSupplementOnly();
}

/// The UL applies to another nutrient (e.g. vitamin A UL -> retinol, folate UL -> folic acid).
class UlOtherNutrient extends UlBasis {
  const UlOtherNutrient(this.code);
  final String code;
}

class Target {
  const Target({
    required this.type,
    this.green,
    this.redBelow,
    this.ul,
    this.ulBasis = const UlTotal(),
    this.limit,
    this.low,
    this.high,
    this.energy,
    this.sources = const [],
  });

  final TargetType type;

  /// minimum/range: green at or above this value.
  final double? green;

  /// minimum/range: red below this value (AR, or 2/3 of [green] when there is no AR).
  final double? redBelow;

  /// range: red above this value (EFSA UL), checked against [ulBasis].
  final double? ul;
  final UlBasis ulBasis;

  /// limit: green at or below, red above.
  final double? limit;

  /// pctRange: green between [low] and [high] (in the nutrient's unit), red outside.
  final double? low;
  final double? high;

  /// energy: the DGE energy guide value in kcal.
  final double? energy;

  final List<String> sources;

  /// The number shown as "current / target".
  double? get displayValue => switch (type) {
        TargetType.energy => energy,
        TargetType.minimum || TargetType.range => green,
        TargetType.limit => limit,
        TargetType.pctRange => low != null && high != null ? (low! + high!) / 2 : null,
        TargetType.none => null,
      };
}

/// Energy content used to turn % of energy into grams (DGE/WHO convention).
const Map<String, double> kcalPerGram = {
  'FAT': 9,
  'FASAT': 9,
  'FATRN': 9,
  'F18:2CN6': 9,
  'F18:3CN3': 9,
  'CHO': 4,
  'FSUGAR': 4,
  'PROT': 4,
};

/// Energy bar thresholds (decided 2026-10-10): green within ±5 %, red beyond ±15 %.
const double energyGreenTolerance = 0.05;
const double energyRedTolerance = 0.15;

/// Without an average requirement, red starts below 2/3 of the target (decided 2026-10-10).
const double redFractionWithoutAr = 2 / 3;

const double kcalToMj = 0.004184;

/// Body weight used for per-kg values: DGE uses normal weight when BMI > 25.
double referenceWeightKg(Profile p) {
  final h = p.heightCm / 100;
  return math.min(p.weightKg, 25 * h * h);
}

class TargetResolver {
  TargetResolver({required this.nutrients, required this.references});

  final List<NutrientDef> nutrients;
  final List<ReferenceRow> references;

  late final Map<String, NutrientDef> _byCode = {for (final n in nutrients) n.code: n};

  /// DGE energy guide value in kcal for the profile, or null if no row applies.
  double? energyTarget(Profile p) {
    final energy = _byCode['ENERC_KCAL'];
    if (energy == null) return null;
    for (final r in references) {
      if (r.nutrientId == energy.id && r.type == ValueType.energy && r.appliesTo(p)) return r.amount;
    }
    return null;
  }

  /// Targets for every nutrient with a bar.
  ///
  /// [avgEnergyKcal] is the user's actual average energy intake in the window; percent-of-energy values
  /// are converted with it. Without energy intake those nutrients get no target.
  Map<int, Target> resolve(Profile p, {double? avgEnergyKcal}) {
    final result = <int, Target>{};
    final energy = energyTarget(p);
    for (final n in nutrients) {
      if (!n.hasBar) continue;
      final rows = references.where((r) => r.nutrientId == n.id && r.appliesTo(p)).toList();
      final t = _resolveOne(n, rows, p, energy, avgEnergyKcal);
      if (t != null) result[n.id] = t;
    }
    return result;
  }

  Target? _resolveOne(NutrientDef n, List<ReferenceRow> rows, Profile p, double? energy, double? avgEnergy) {
    double? amountOf(ReferenceRow r) => switch (r.basis) {
          Basis.abs => r.amount,
          Basis.perKgBw => r.amount * referenceWeightKg(p),
          Basis.perMj => energy == null ? null : r.amount * energy * kcalToMj,
          Basis.pctEnergy => (avgEnergy == null || avgEnergy <= 0)
              ? null
              : r.amount / 100 * avgEnergy / (kcalPerGram[n.code] ?? double.nan),
        };
    ReferenceRow? first(ValueType t) {
      for (final r in rows) {
        if (r.type == t) return r;
      }
      return null;
    }

    final sources = rows.map((r) => r.source).toSet().toList();

    switch (n.targetType) {
      case TargetType.energy:
        return energy == null ? null : Target(type: TargetType.energy, energy: energy, sources: sources);

      case TargetType.limit:
        final r = first(ValueType.limit);
        final v = r == null ? null : amountOf(r);
        return v == null || v.isNaN ? null : Target(type: TargetType.limit, limit: v, sources: sources);

      case TargetType.pctRange:
        final lo = first(ValueType.rangeLow), hi = first(ValueType.rangeHigh);
        final l = lo == null ? null : amountOf(lo), h = hi == null ? null : amountOf(hi);
        if (l == null || h == null || l.isNaN || h.isNaN) return null;
        return Target(type: TargetType.pctRange, low: l, high: h, sources: sources);

      case TargetType.minimum:
      case TargetType.range:
        // DGE value: recommended intake, else estimated value, else guide value.
        final dge = first(ValueType.ri) ?? first(ValueType.ev) ?? first(ValueType.gv);
        var green = dge == null ? null : amountOf(dge);
        if (green == null || green.isNaN) return null;
        final arRow = first(ValueType.ar);
        final ar = arRow == null ? null : amountOf(arRow);
        double redBelow;
        if (ar == null) {
          redBelow = green * redFractionWithoutAr;
        } else if (ar < green) {
          redBelow = ar;
        } else {
          // EFSA AR at or above the DGE value: use EFSA's PRI as the target (decided 2026-10-10).
          final priRow = first(ValueType.pri);
          final pri = priRow == null ? null : amountOf(priRow);
          green = pri ?? green;
          redBelow = ar < green ? ar : green * redFractionWithoutAr;
        }
        double? ul;
        UlBasis ulBasis = const UlTotal();
        if (n.targetType == TargetType.range) {
          final ulRow = first(ValueType.ul);
          if (ulRow != null) {
            ul = amountOf(ulRow);
            ulBasis = UlBasis.parse(ulRow.ulBasis);
          }
        }
        return Target(
          type: n.targetType,
          green: green,
          redBelow: redBelow,
          ul: ul,
          ulBasis: ulBasis,
          sources: sources,
        );

      case TargetType.none:
        return null;
    }
  }
}

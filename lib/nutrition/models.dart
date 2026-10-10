/// Plain data types shared by the nutrition logic. Pure Dart, no Flutter imports.
library;

enum Sex {
  male('m'),
  female('f');

  const Sex(this.code);
  final String code;

  static Sex fromCode(String code) => values.firstWhere((s) => s.code == code);
}

/// DGE physical activity levels for which DGE publishes energy guide values.
enum Pal {
  pal14('1.4', 'Mostly sitting, little activity (PAL 1.4)'),
  pal16('1.6', 'Sitting work with some walking or standing (PAL 1.6)'),
  pal18('1.8', 'Mostly standing or walking work (PAL 1.8)');

  const Pal(this.code, this.label);
  final String code;
  final String label;

  static Pal fromCode(String code) => values.firstWhere((p) => p.code == code);
}

/// Women's iron reference value depends on menstruation (DGE footnote d).
enum IronStatus {
  menstruating('menstruating', 'Menstruating'),
  notMenstruating('not_menstruating', 'Not menstruating (before menopause)'),
  postmenopausal('postmenopausal', 'Postmenopausal');

  const IronStatus(this.code, this.label);
  final String code;
  final String label;

  static IronStatus fromCode(String code) => values.firstWhere((s) => s.code == code);
}

/// Dietary phytate level for zinc reference values.
enum Phytate {
  low('low', 'Low (mostly animal protein, little whole grain or legumes)'),
  medium('medium', 'Medium (mixed diet)'),
  high('high', 'High (mostly plant-based, much whole grain or legumes)');

  const Phytate(this.code, this.label);
  final String code;
  final String label;

  static Phytate fromCode(String code) => values.firstWhere((p) => p.code == code);
}

class Profile {
  const Profile({
    required this.sex,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.pal,
    this.ironStatus = IronStatus.menstruating,
    this.phytate = Phytate.medium,
  });

  final Sex sex;
  final int age;
  final double heightCm;
  final double weightKg;
  final Pal pal;

  /// Only used for women.
  final IronStatus ironStatus;
  final Phytate phytate;

  /// Value of a reference-value condition key, e.g. `pal` -> `1.6`.
  String? conditionValue(String key) => switch (key) {
        'pal' => pal.code,
        'iron_status' => sex == Sex.female ? ironStatus.code : null,
        'phytate' => phytate.code,
        _ => null,
      };
}

enum TargetType {
  energy('energy'),
  minimum('minimum'),
  range('range'),
  pctRange('pct_range'),
  limit('limit'),
  none('none');

  const TargetType(this.code);
  final String code;

  static TargetType fromCode(String code) => values.firstWhere((t) => t.code == code);
}

class NutrientDef {
  const NutrientDef({
    required this.id,
    required this.code,
    required this.name,
    required this.unit,
    required this.importanceRank,
    required this.targetType,
    required this.hasBar,
    this.claudeFills = false,
  });

  final int id;
  final String code;
  final String name;
  final String unit;
  final int importanceRank;
  final TargetType targetType;
  final bool hasBar;

  /// Missing values are estimated by Claude on first use of a food.
  final bool claudeFills;
}

enum ValueType {
  ri('RI'),
  ev('EV'),
  gv('GV'),
  ar('AR'),
  pri('PRI'),
  ul('UL'),
  limit('LIMIT'),
  rangeLow('RANGE_LOW'),
  rangeHigh('RANGE_HIGH'),
  energy('ENERGY');

  const ValueType(this.code);
  final String code;

  static ValueType fromCode(String code) => values.firstWhere((t) => t.code == code);
}

enum Basis {
  abs('abs'),
  perKgBw('per_kg_bw'),
  pctEnergy('pct_energy'),
  perMj('per_mj');

  const Basis(this.code);
  final String code;

  static Basis fromCode(String code) => values.firstWhere((b) => b.code == code);
}

class ReferenceRow {
  const ReferenceRow({
    required this.nutrientId,
    required this.sex,
    required this.ageMin,
    required this.ageMax,
    required this.type,
    required this.amount,
    this.basis = Basis.abs,
    this.condition = '',
    this.ulBasis = '',
    this.source = '',
  });

  final int nutrientId;

  /// 'm', 'f' or 'any'.
  final String sex;
  final int ageMin;
  final int ageMax;
  final ValueType type;
  final double amount;
  final Basis basis;

  /// '' or 'key=value'.
  final String condition;

  /// For UL rows: 'total', 'supplement' or 'nutrient:<CODE>'.
  final String ulBasis;
  final String source;

  bool appliesTo(Profile p) {
    if (sex != 'any' && sex != p.sex.code) return false;
    if (p.age < ageMin || p.age > ageMax) return false;
    if (condition.isEmpty) return true;
    final i = condition.indexOf('=');
    return p.conditionValue(condition.substring(0, i)) == condition.substring(i + 1);
  }
}

/// One logged amount of a food, as seen by the aggregation.
class LoggedItem {
  const LoggedItem({
    required this.timestamp,
    required this.foodId,
    required this.amount,
    this.isSupplementAuto = false,
    this.isSupplementFood = false,
  });

  final DateTime timestamp;
  final int foodId;

  /// Grams, ml, or pieces (for supplements); nutrient values are per 100 of this unit.
  final double amount;

  /// Added automatically from the daily supplement plan.
  final bool isSupplementAuto;

  /// The food is a supplement (counts toward supplement-only UL bases).
  final bool isSupplementFood;
}

/// A food as needed for suggestions and the Nutri-Score.
class FoodInfo {
  const FoodInfo({
    required this.id,
    required this.name,
    this.servingAmount,
    this.servingLabel,
    this.isCommon = false,
  });

  final int id;
  final String name;
  final double? servingAmount;
  final String? servingLabel;
  final bool isCommon;
}

/// Nutrient values per 100 g/ml/pieces, keyed by food id then nutrient id.
typedef NutrientTable = Map<int, Map<int, double>>;

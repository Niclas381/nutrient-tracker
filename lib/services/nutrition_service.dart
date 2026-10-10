import '../data/database.dart';
import '../nutrition/aggregation.dart';
import '../nutrition/models.dart';
import '../nutrition/report.dart';
import '../nutrition/suggestions.dart';
import '../nutrition/targets.dart';

Profile profileFromRow(ProfileRow p) => Profile(
      sex: Sex.fromCode(p.sex),
      age: p.age,
      heightCm: p.heightCm,
      weightKg: p.weightKg,
      pal: Pal.fromCode(p.activityLevel),
      ironStatus: IronStatus.fromCode(p.ironStatus),
      phytate: Phytate.fromCode(p.phytate),
    );

NutrientDef nutrientFromRow(NutrientRow n) => NutrientDef(
      id: n.id,
      code: n.code,
      name: n.name,
      unit: n.unit,
      importanceRank: n.importanceRank,
      targetType: TargetType.fromCode(n.targetType),
      hasBar: n.hasBar,
      claudeFills: n.claudeFills,
    );

ReferenceRow referenceFromRow(ReferenceValueRow r) => ReferenceRow(
      nutrientId: r.nutrientId,
      sex: r.sex,
      ageMin: r.ageMin,
      ageMax: r.ageMax,
      type: ValueType.fromCode(r.valueType),
      amount: r.amount,
      basis: Basis.fromCode(r.basis),
      condition: r.condition,
      ulBasis: r.ulBasis,
      source: r.source,
    );

/// Ranking row: a food eaten in the window.
class RankedFood {
  const RankedFood({required this.food, required this.totalAmount, required this.count, this.note});
  final FoodRow food;
  final double totalAmount;
  final int count;
  final FoodNoteRow? note;
}

/// Loads data from the database and runs the pure nutrition logic. Derived values are computed on demand and
/// cached in memory; nothing derived is stored.
class NutritionService {
  NutritionService(this.db);

  final AppDatabase db;

  List<NutrientDef>? _nutrients;
  TargetResolver? _resolver;
  SuggestionEngine? _suggestions;

  Future<List<NutrientDef>> nutrients() async =>
      _nutrients ??= (await db.allNutrients()).map(nutrientFromRow).toList();

  Future<TargetResolver> resolver() async => _resolver ??= TargetResolver(
        nutrients: await nutrients(),
        references: (await db.allReferenceValues()).map(referenceFromRow).toList(),
      );

  /// Common grocery foods and their values; rebuilt when food values change (e.g. after a DB update).
  Future<SuggestionEngine> suggestions() async {
    if (_suggestions != null) return _suggestions!;
    final common = await db.commonFoods();
    final table = await db.nutrientTable(common.map((f) => f.id));
    return _suggestions = SuggestionEngine(
      commonFoods: [
        for (final f in common)
          FoodInfo(id: f.id, name: f.name, servingAmount: f.defaultServingG, servingLabel: f.servingLabel, isCommon: true),
      ],
      nutrients: table,
    );
  }

  void invalidateStatic() {
    _nutrients = null;
    _resolver = null;
    _suggestions = null;
  }

  Future<(List<LoggedItem>, NutrientTable, Map<int, FoodRow>)> _load(DateTime from, DateTime to) async {
    final entries = await db.entriesBetween(from, to);
    final foodIds = entries.map((e) => e.foodId).toSet();
    final foods = {for (final f in await db.foodsByIds(foodIds)) f.id: f};
    final table = await db.nutrientTable(foodIds);
    final items = [
      for (final e in entries)
        LoggedItem(
          timestamp: e.timestamp,
          foodId: e.foodId,
          amount: e.grams,
          isSupplementAuto: e.inputSource == 'supplement_auto',
          isSupplementFood: foods[e.foodId]?.source == 'supplement',
        ),
    ];
    return (items, table, foods);
  }

  /// Report for the [days] calendar days ending with [today].
  Future<NutrientReport?> report({required int days, DateTime? today}) async {
    final profileRow = await db.getProfile();
    if (profileRow == null) return null;
    final end = dayOf(today ?? DateTime.now());
    final from = end.subtract(Duration(days: days - 1));
    final (items, table, _) = await _load(from, end.add(const Duration(days: 1)));
    final averages = averageWindow(items: items, nutrients: table, today: end, days: days);
    return buildReport(
      profile: profileFromRow(profileRow),
      nutrients: await nutrients(),
      resolver: await resolver(),
      averages: averages,
      suggestions: await suggestions(),
      windowDays: days,
    );
  }

  /// Foods eaten in the window with total amount and number of entries.
  Future<List<RankedFood>> ranking({required int days, DateTime? today}) async {
    final end = dayOf(today ?? DateTime.now()).add(const Duration(days: 1));
    final entries = await db.entriesBetween(end.subtract(Duration(days: days)), end);
    final totals = <int, double>{};
    final counts = <int, int>{};
    for (final e in entries) {
      totals[e.foodId] = (totals[e.foodId] ?? 0) + e.grams;
      counts[e.foodId] = (counts[e.foodId] ?? 0) + 1;
    }
    final foods = await db.foodsByIds(totals.keys);
    final notes = {for (final n in await db.notesFor(totals.keys)) n.foodId: n};
    return [
      for (final f in foods) RankedFood(food: f, totalAmount: totals[f.id]!, count: counts[f.id]!, note: notes[f.id]),
    ];
  }
}

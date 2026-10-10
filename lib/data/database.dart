import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'database.g.dart';

/// First id for foods created in the app (bundled foods are below).
const userFoodIdStart = 100000000;

@DriftDatabase(tables: [
  Nutrients,
  Foods,
  FoodNutrients,
  LogEntries,
  Requests,
  SupplementPlans,
  Profiles,
  ReferenceValues,
  FoodNotes,
  Meta,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'nutrient_tracker'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement('CREATE INDEX log_entries_timestamp ON log_entries(timestamp)');
          await customStatement('CREATE INDEX foods_barcode ON foods(barcode)');
          await customStatement('CREATE INDEX log_entries_request ON log_entries(request_id)');
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = OFF');
        },
      );

  // ---------------------------------------------------------------------------
  // Meta
  // ---------------------------------------------------------------------------

  Future<String?> getMeta(String key) async =>
      (await (select(meta)..where((m) => m.key.equals(key))).getSingleOrNull())?.value;

  Future<void> setMeta(String key, String value) =>
      into(meta).insertOnConflictUpdate(MetaCompanion.insert(key: key, value: value));

  // ---------------------------------------------------------------------------
  // Bundled nutrient DB import
  // ---------------------------------------------------------------------------

  /// Imports nutrients, reference values, foods and their values from the bundled SQLite file at [path].
  ///
  /// Safe to run again with a newer bundled DB: foods keep their ids, values from the bundled DB replace
  /// earlier bundled values and Claude estimates for the same nutrient (DB > estimate), user-created foods and
  /// estimates for nutrients the DB still lacks are kept.
  Future<void> importBundled(File file, String dbVersion) async {
    await customStatement('ATTACH DATABASE ? AS b', [file.path]);
    try {
      await transaction(() async {
        await customStatement('DELETE FROM nutrients');
        await customStatement('INSERT INTO nutrients(id, code, name, unit, importance_rank, target_type, has_bar, '
            'claude_fills) SELECT id, code, name, unit, importance_rank, target_type, has_bar, claude_fills '
            'FROM b.nutrient');
        await customStatement('DELETE FROM reference_values');
        await customStatement('INSERT INTO reference_values(id, nutrient_id, sex, age_min, age_max, value_type, '
            'amount, basis, condition, ul_basis, source) SELECT id, nutrient_id, sex, age_min, age_max, value_type, '
            'amount, basis, condition, ul_basis, source FROM b.reference_value');
        await customStatement('INSERT INTO foods(id, name, name_de, source, source_ref, food_group, '
            'default_serving_g, serving_label, amount_unit, is_common, nutriscore_category, fvl_percent) '
            "SELECT id, name, name_de, source, source_ref, food_group, default_serving_g, serving_label, "
            "CASE WHEN is_liquid = 1 THEN 'ml' ELSE 'g' END, is_common, nutriscore_category, fvl_percent "
            'FROM b.food WHERE true ON CONFLICT(id) DO UPDATE SET name = excluded.name, '
            'name_de = excluded.name_de, source_ref = excluded.source_ref, food_group = excluded.food_group, '
            'default_serving_g = excluded.default_serving_g, serving_label = excluded.serving_label, '
            'amount_unit = excluded.amount_unit, is_common = excluded.is_common, '
            'nutriscore_category = COALESCE(excluded.nutriscore_category, foods.nutriscore_category), '
            'fvl_percent = COALESCE(excluded.fvl_percent, foods.fvl_percent)');
        await customStatement(
            'DELETE FROM food_nutrients WHERE source IS NULL AND food_id IN (SELECT id FROM b.food)');
        await customStatement('INSERT INTO food_nutrients(food_id, nutrient_id, amount_per100, source) '
            'SELECT food_id, nutrient_id, amount_per_100, NULL FROM b.food_nutrient WHERE true '
            'ON CONFLICT(food_id, nutrient_id) DO UPDATE SET amount_per100 = excluded.amount_per100, source = NULL');
        await setMeta('db_version', dbVersion);
      });
    } finally {
      await customStatement('DETACH DATABASE b');
    }
  }

  // ---------------------------------------------------------------------------
  // Nutrients, reference values, profile
  // ---------------------------------------------------------------------------

  Future<List<NutrientRow>> allNutrients() =>
      (select(nutrients)..orderBy([(n) => OrderingTerm.asc(n.importanceRank)])).get();

  Future<List<ReferenceValueRow>> allReferenceValues() => select(referenceValues).get();

  Stream<ProfileRow?> watchProfile() => (select(profiles)..where((p) => p.id.equals(1))).watchSingleOrNull();

  Future<ProfileRow?> getProfile() => (select(profiles)..where((p) => p.id.equals(1))).getSingleOrNull();

  Future<void> saveProfile(ProfilesCompanion p) =>
      into(profiles).insertOnConflictUpdate(p.copyWith(id: const Value(1), updatedAt: Value(DateTime.now())));

  // ---------------------------------------------------------------------------
  // Foods
  // ---------------------------------------------------------------------------

  Future<FoodRow?> foodById(int id) => (select(foods)..where((f) => f.id.equals(id))).getSingleOrNull();

  Future<List<FoodRow>> foodsByIds(Iterable<int> ids) => (select(foods)..where((f) => f.id.isIn(ids))).get();

  Future<FoodRow?> foodByBarcode(String barcode) =>
      (select(foods)..where((f) => f.barcode.equals(barcode))..limit(1)).getSingleOrNull();

  Future<List<FoodRow>> commonFoods() => (select(foods)..where((f) => f.isCommon.equals(true))).get();

  /// Simple local name search (English and German names). Every word must match.
  Future<List<FoodRow>> searchFoods(String query, {int limit = 40}) {
    final words = query.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return Future.value(const []);
    final q = select(foods);
    for (final w in words) {
      final like = '%${w.replaceAll('%', '').replaceAll('_', '')}%';
      q.where((f) => f.name.like(like) | f.nameDe.like(like));
    }
    q
      ..orderBy([
        (f) => OrderingTerm.desc(f.isCommon),
        (f) => OrderingTerm.asc(CustomExpression<int>(
            "CASE source WHEN 'bls' THEN 0 WHEN 'usda' THEN 1 ELSE 2 END")),
        (f) => OrderingTerm.asc(f.name.length),
      ])
      ..limit(limit);
    return q.get();
  }

  Future<int> _nextUserFoodId() async {
    final row = await customSelect('SELECT MAX(id) AS m FROM foods WHERE id >= ?',
        variables: [Variable.withInt(userFoodIdStart)]).getSingle();
    final max = row.read<int?>('m');
    return max == null ? userFoodIdStart : max + 1;
  }

  /// Creates a food with values per 100 (keyed by nutrient id). Returns its id.
  Future<int> createFood(FoodsCompanion food, Map<int, double> valuesPer100, {String? valueSource}) =>
      transaction(() async {
        final id = await _nextUserFoodId();
        await into(foods).insert(food.copyWith(id: Value(id)));
        await batch((b) => b.insertAll(foodNutrients, [
              for (final e in valuesPer100.entries)
                FoodNutrientsCompanion.insert(
                    foodId: id, nutrientId: e.key, amountPer100: e.value, source: Value(valueSource)),
            ]));
        return id;
      });

  Future<void> updateFood(int id, FoodsCompanion changes) =>
      (update(foods)..where((f) => f.id.equals(id))).write(changes);

  Future<List<FoodNutrientRow>> valuesOf(int foodId) =>
      (select(foodNutrients)..where((v) => v.foodId.equals(foodId))).get();

  /// food id -> nutrient id -> amount per 100.
  Future<Map<int, Map<int, double>>> nutrientTable(Iterable<int> foodIds) async {
    final ids = foodIds.toSet().toList();
    final table = <int, Map<int, double>>{};
    for (var i = 0; i < ids.length; i += 500) {
      final chunk = ids.sublist(i, i + 500 > ids.length ? ids.length : i + 500);
      final rows = await (select(foodNutrients)..where((v) => v.foodId.isIn(chunk))).get();
      for (final r in rows) {
        (table[r.foodId] ??= {})[r.nutrientId] = r.amountPer100;
      }
    }
    return table;
  }

  /// Adds values with provenance [source] without overriding higher-priority values
  /// (label > generic database > Claude estimate).
  Future<void> addValues(int foodId, Map<int, double> valuesPer100, String source) async {
    const rank = {'off': 3, 'bls': 2, 'usda': 2, 'supplement': 3, 'claude_estimate': 1};
    final food = await foodById(foodId);
    if (food == null) return;
    final existing = {for (final v in await valuesOf(foodId)) v.nutrientId: v};
    await batch((b) {
      for (final e in valuesPer100.entries) {
        final old = existing[e.key];
        if (old != null && (rank[old.source ?? food.source] ?? 0) >= (rank[source] ?? 0)) continue;
        b.insert(
            foodNutrients,
            FoodNutrientsCompanion.insert(
                foodId: foodId,
                nutrientId: e.key,
                amountPer100: e.value,
                source: Value(source == food.source ? null : source)),
            mode: InsertMode.insertOrReplace);
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Log entries
  // ---------------------------------------------------------------------------

  Stream<List<LogEntryRow>> watchEntriesBetween(DateTime from, DateTime to) => (select(logEntries)
        ..where((e) => e.timestamp.isBiggerOrEqualValue(from) & e.timestamp.isSmallerThanValue(to))
        ..orderBy([(e) => OrderingTerm.asc(e.timestamp)]))
      .watch();

  Future<List<LogEntryRow>> entriesBetween(DateTime from, DateTime to) => (select(logEntries)
        ..where((e) => e.timestamp.isBiggerOrEqualValue(from) & e.timestamp.isSmallerThanValue(to)))
      .get();

  Future<List<LogEntryRow>> entriesForRequest(String requestId) =>
      (select(logEntries)..where((e) => e.requestId.equals(requestId))).get();

  Stream<List<LogEntryRow>> watchEntriesForRequest(String requestId) =>
      (select(logEntries)..where((e) => e.requestId.equals(requestId))).watch();

  Future<int> addEntry(LogEntriesCompanion e) => into(logEntries).insert(e);

  Future<void> updateEntry(int id, LogEntriesCompanion changes) =>
      (update(logEntries)..where((e) => e.id.equals(id))).write(changes);

  Future<void> deleteEntry(int id) => (delete(logEntries)..where((e) => e.id.equals(id))).go();

  Future<LogEntryRow?> entryById(int id) => (select(logEntries)..where((e) => e.id.equals(id))).getSingleOrNull();

  /// Number of log entries per food (all time) — used to decide first use.
  Future<int> entryCountForFood(int foodId) async {
    final c = logEntries.id.count();
    final q = selectOnly(logEntries)
      ..addColumns([c])
      ..where(logEntries.foodId.equals(foodId));
    return (await q.getSingle()).read(c) ?? 0;
  }

  // ---------------------------------------------------------------------------
  // Requests
  // ---------------------------------------------------------------------------

  Future<void> insertRequest(RequestsCompanion r) => into(requests).insert(r);

  Future<RequestRow?> requestById(String id) => (select(requests)..where((r) => r.id.equals(id))).getSingleOrNull();

  Future<void> updateRequest(String id, RequestsCompanion changes) =>
      (update(requests)..where((r) => r.id.equals(id))).write(changes);

  /// Requests that still need work from the backend.
  Future<List<RequestRow>> openRequests() =>
      (select(requests)..where((r) => r.status.isIn(['queued', 'uploaded', 'fired']))).get();

  /// Chat cards: user-visible requests (not background enrichment) that were not dismissed.
  Stream<List<RequestRow>> watchChatRequests() => (select(requests)
        ..where((r) => r.dismissed.equals(false) & r.type.isIn(['log_text', 'log_photo']))
        ..orderBy([(r) => OrderingTerm.asc(r.createdAt)]))
      .watch();

  /// Hides finished chat cards older than [age]. Failed requests stay visible until retried or dismissed.
  Future<void> dismissOldDone(Duration age) => (update(requests)
        ..where((r) => r.status.equals('done') & r.createdAt.isSmallerThanValue(DateTime.now().subtract(age))))
      .write(const RequestsCompanion(dismissed: Value(true)));

  Stream<List<RequestRow>> watchRequestsOfType(String type) =>
      (select(requests)..where((r) => r.type.equals(type))..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
          .watch();

  // ---------------------------------------------------------------------------
  // Supplements
  // ---------------------------------------------------------------------------

  Stream<List<SupplementPlanRow>> watchSupplementPlans() => select(supplementPlans).watch();

  Future<List<SupplementPlanRow>> activeSupplementPlans() =>
      (select(supplementPlans)..where((p) => p.active.equals(true))).get();

  Future<int> addSupplementPlan(SupplementPlansCompanion p) => into(supplementPlans).insert(p);

  Future<void> updateSupplementPlan(int id, SupplementPlansCompanion changes) =>
      (update(supplementPlans)..where((p) => p.id.equals(id))).write(changes);

  Future<void> deleteSupplementPlan(int id) => (delete(supplementPlans)..where((p) => p.id.equals(id))).go();

  /// Timestamp of the latest automatic entry of a supplement plan.
  Future<DateTime?> lastAutoEntry(int planId) async {
    final m = logEntries.timestamp.max();
    final q = selectOnly(logEntries)
      ..addColumns([m])
      ..where(logEntries.supplementPlanId.equals(planId));
    return (await q.getSingle()).read(m);
  }

  Future<bool> hasAutoEntry(int planId, DateTime dayStart) async {
    final rows = await (select(logEntries)
          ..where((e) =>
              e.supplementPlanId.equals(planId) &
              e.timestamp.isBiggerOrEqualValue(dayStart) &
              e.timestamp.isSmallerThanValue(dayStart.add(const Duration(days: 1)))))
        .get();
    return rows.isNotEmpty;
  }

  // ---------------------------------------------------------------------------
  // Food notes
  // ---------------------------------------------------------------------------

  Future<FoodNoteRow?> noteFor(int foodId) =>
      (select(foodNotes)..where((n) => n.foodId.equals(foodId))).getSingleOrNull();

  Future<List<FoodNoteRow>> notesFor(Iterable<int> foodIds) =>
      (select(foodNotes)..where((n) => n.foodId.isIn(foodIds))).get();

  Future<void> saveNote(FoodNotesCompanion n) => into(foodNotes).insertOnConflictUpdate(n);
}

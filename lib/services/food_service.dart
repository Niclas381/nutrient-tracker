import 'package:drift/drift.dart';

import '../data/database.dart';
import '../input/open_food_facts.dart';
import '../nutrition/aggregation.dart';
import '../nutrition/nutriscore.dart';
import 'request_service.dart';

/// Food-level operations: first-use enrichment, Nutri-Score, barcode products, supplement plans.
class FoodService {
  FoodService({required this.db, required this.requests});

  final AppDatabase db;
  final RequestService requests;

  Map<String, int>? _ids;
  Map<int, NutrientRow>? _byId;

  Future<Map<String, int>> nutrientIds() async {
    if (_ids == null) {
      final all = await db.allNutrients();
      _ids = {for (final n in all) n.code: n.id};
      _byId = {for (final n in all) n.id: n};
    }
    return _ids!;
  }

  Future<Map<int, NutrientRow>> nutrientsById() async {
    await nutrientIds();
    return _byId!;
  }

  /// Converts code -> amount into nutrient id -> amount, dropping unknown codes.
  Future<Map<int, double>> byId(Map<String, double> byCode) async {
    final ids = await nutrientIds();
    return {
      for (final e in byCode.entries)
        if (ids[e.key] != null) ids[e.key]!: e.value,
    };
  }

  // ---------------------------------------------------------------------------
  // Enrichment on first use
  // ---------------------------------------------------------------------------

  /// Sends the one-time enrich_food request for [foodId] unless it was already sent.
  /// [product] adds label context for barcode products.
  Future<void> ensureEnriched(int foodId, {OffProduct? product}) async {
    final food = await db.foodById(foodId);
    if (food == null || food.enrichment != 'none') return;
    if (food.source == 'supplement') {
      // Supplements carry their label values; there is nothing to estimate or rate.
      await db.updateFood(foodId, const FoodsCompanion(enrichment: Value('done')));
      return;
    }
    final byId = await nutrientsById();
    final values = await db.valuesOf(foodId);
    final have = {for (final v in values) v.nutrientId};
    final missing = [
      for (final n in byId.values)
        if (n.claudeFills && !have.contains(n.id)) n.code,
    ];
    final note = await db.noteFor(foodId);
    final want = <String>[
      if (note?.novaGroup == null) 'nova',
      'health',
      if (food.nutriscoreCategory == null || food.fvlPercent == null) 'nutriscore_inputs',
      if (food.source == 'off') 'db_match',
    ];
    final payload = {
      'food': {
        if (food.source == 'bls' || food.source == 'usda') 'food_id': food.id,
        'name': food.name,
        'source': food.source,
        'barcode': ?food.barcode,
        if (product?.brand != null) 'brand': product!.brand,
        if (product?.categories != null) 'categories': product!.categories,
        if (product?.ingredientsText != null) 'ingredients_text': product!.ingredientsText,
        'unit': food.amountUnit,
        'values_per_100': {for (final v in values) byId[v.nutrientId]!.code: v.amountPer100},
      },
      'missing_nutrients': missing,
      'want': want,
    };
    await db.updateFood(foodId, const FoodsCompanion(enrichment: Value('pending')));
    await requests.enrichFood(foodId, payload);
  }

  // ---------------------------------------------------------------------------
  // Nutri-Score
  // ---------------------------------------------------------------------------

  /// Computes the Nutri-Score from the food's values; null when inputs are unknown or it doesn't apply.
  Future<NutriScore?> nutriScoreFor(FoodRow food, Map<int, double> values) async {
    final cat = NutriScoreCategory.fromCode(food.nutriscoreCategory);
    if (cat == null) return null;
    if (cat != NutriScoreCategory.water && cat != NutriScoreCategory.notApplicable && food.fvlPercent == null) {
      return null;
    }
    final ids = await nutrientIds();
    double v(String code) => values[ids[code]] ?? 0;
    if (!values.containsKey(ids['ENERC_KCAL'])) return null;
    return computeNutriScore(NutriScoreInput(
      category: cat,
      energyKcal: v('ENERC_KCAL'),
      sugars: v('SUGAR'),
      saturatedFat: v('FASAT'),
      fat: v('FAT'),
      salt: v('NACL'),
      fiber: v('FIBT'),
      protein: v('PROT'),
      fvlPercent: food.fvlPercent ?? 0,
      nonNutritiveSweeteners: food.nonNutritiveSweeteners ?? false,
    ));
  }

  Future<void> refreshNutriScore(int foodId) async {
    final food = await db.foodById(foodId);
    if (food == null) return;
    final values = (await db.nutrientTable([foodId]))[foodId] ?? const {};
    final ns = await nutriScoreFor(food, values);
    final note = await db.noteFor(foodId);
    await db.saveNote(FoodNotesCompanion(
      foodId: Value(foodId),
      nutriScore: Value(ns?.grade),
      novaGroup: Value(note?.novaGroup),
      healthRating: Value(note?.healthRating),
      healthReason: Value(note?.healthReason),
      warningText: Value(note?.warningText),
      generatedAt: Value(note?.generatedAt),
    ));
  }

  // ---------------------------------------------------------------------------
  // Barcode products
  // ---------------------------------------------------------------------------

  /// Returns the food for [product], creating it from the label values on first scan.
  Future<int> foodForProduct(OffProduct product) async {
    final existing = await db.foodByBarcode(product.barcode);
    if (existing != null) return existing.id;
    final name = product.brand == null || product.name.toLowerCase().contains(product.brand!.toLowerCase())
        ? product.name
        : '${product.name} (${product.brand})';
    final id = await db.createFood(
      FoodsCompanion.insert(
        name: name,
        source: 'off',
        sourceRef: Value('off:${product.barcode}'),
        barcode: Value(product.barcode),
        packageQuantity: Value(product.package.packageAmount),
        packageUnit: Value(product.package.unit),
        defaultServingG: Value(product.package.servingAmount),
        amountUnit: Value(product.package.unit),
        nutriscoreCategory: Value(product.isBeverage ? 'beverage' : null),
        nonNutritiveSweeteners: Value(product.nonNutritiveSweeteners),
      ),
      await byId(product.valuesPer100),
    );
    if (product.novaGroup != null) {
      await db.saveNote(FoodNotesCompanion(foodId: Value(id), novaGroup: Value(product.novaGroup)));
    }
    return id;
  }

  // ---------------------------------------------------------------------------
  // Supplements
  // ---------------------------------------------------------------------------

  /// Adds today's (and any missed days') automatic entries for active supplement plans.
  Future<void> autoLogSupplements(DateTime now) async {
    final today = dayOf(now);
    for (final plan in await db.activeSupplementPlans()) {
      final last = await db.lastAutoEntry(plan.id);
      var day = last == null ? dayOf(plan.startDate) : dayOf(last).add(const Duration(days: 1));
      if (today.difference(day).inDays > 400) day = today.subtract(const Duration(days: 400));
      while (!day.isAfter(today)) {
        if (!await db.hasAutoEntry(plan.id, day)) {
          await db.addEntry(LogEntriesCompanion.insert(
            timestamp: day.add(const Duration(hours: 8)),
            foodId: plan.foodId,
            grams: plan.amount,
            inputSource: 'supplement_auto',
            rawInput: Value(plan.rawInput),
            supplementPlanId: Value(plan.id),
          ));
        }
        day = DateTime(day.year, day.month, day.day + 1);
      }
    }
  }
}

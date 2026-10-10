import 'dart:convert';

import 'package:drift/drift.dart';

import '../claude/backend.dart';
import '../data/database.dart';
import 'food_service.dart';

/// Imports validated results into the database. Idempotent by request id.
class ResultImporter {
  ResultImporter({required this.db, required this.foods});

  final AppDatabase db;
  final FoodService foods;

  /// Health ratings at or below this get a warning on the ranking page (decided 2026-10-10: ratings 1–2).
  static const warnAtOrBelow = 2;

  Future<void> import(ClaudeResult r) async {
    final req = await db.requestById(r.requestId);
    if (req == null || req.status == RequestStatus.done.code) return; // duplicate
    if (!r.ok) {
      await db.updateRequest(r.requestId,
          RequestsCompanion(status: const Value('failed'), lastError: Value(r.errorMessage ?? 'Routine error')));
      if (r.type == RequestType.enrichFood && req.foodId != null) {
        await db.updateFood(req.foodId!, const FoodsCompanion(enrichment: Value('failed')));
      }
      return;
    }
    try {
      switch (r.type) {
        case RequestType.logText || RequestType.logPhoto:
          await _importLog(req, r.result!);
        case RequestType.enrichFood:
          await _importEnrich(req, r.result!);
        case RequestType.ping:
          break;
      }
      await db.updateRequest(r.requestId, const RequestsCompanion(status: Value('done'), lastError: Value(null)));
    } catch (e) {
      await db.updateRequest(
          r.requestId, RequestsCompanion(status: const Value('failed'), lastError: Value('Import failed: $e')));
    }
  }

  // ---------------------------------------------------------------------------

  Future<void> _importLog(RequestRow req, Map<String, dynamic> result) async {
    if ((await db.entriesForRequest(req.id)).isNotEmpty) return;
    final payload = ((jsonDecode(req.payload) as Map)['payload'] as Map).cast<String, dynamic>();
    final purpose = payload['purpose'] as String? ?? 'log';
    final barcode = payload['barcode'] as String?;
    final items = (result['items'] as List).cast<Map<String, dynamic>>();
    final skipped = <String>[];
    final usedFoods = <int>{};

    await db.transaction(() async {
      for (final item in items) {
        final foodId = await _resolveFood(item, barcode: barcode);
        if (foodId == null) {
          skipped.add(item['label'] as String);
          continue;
        }
        final amount = (item['amount'] as num).toDouble();
        if (purpose == 'supplement_plan') {
          final food = await db.foodById(foodId);
          await db.addSupplementPlan(SupplementPlansCompanion.insert(
            foodId: foodId,
            amount: amount,
            unit: item['unit'] as String? ?? food?.amountUnit ?? 'piece',
            startDate: DateTime.now(),
            rawInput: Value(req.rawInput),
          ));
        } else {
          await db.addEntry(LogEntriesCompanion.insert(
            timestamp: req.logAt ?? req.createdAt,
            foodId: foodId,
            grams: amount,
            inputSource: req.inputSource ?? 'text',
            rawInput: Value(req.rawInput),
            confidence: Value((item['confidence'] as num?)?.toDouble()),
            requestId: Value(req.id),
          ));
        }
        usedFoods.add(foodId);
      }
      final notes = [
        if (result['note'] is String) result['note'] as String,
        if (skipped.isNotEmpty) 'Not found in the local database: ${skipped.join(', ')}',
      ];
      if (notes.isNotEmpty) await db.updateRequest(req.id, RequestsCompanion(resultNote: Value(notes.join(' '))));
    });

    if (purpose == 'supplement_plan') await foods.autoLogSupplements(DateTime.now());
    for (final id in usedFoods) {
      await foods.ensureEnriched(id);
    }
  }

  /// Food id for a log item: an existing database food, or a newly created dish/supplement/food.
  Future<int?> _resolveFood(Map<String, dynamic> item, {String? barcode}) async {
    if (item['food_id'] != null) {
      final id = item['food_id'] as int;
      return await db.foodById(id) == null ? null : id;
    }
    final nf = (item['new_food'] as Map).cast<String, dynamic>();
    final name = nf['name'] as String;
    List<Map<String, dynamic>> list(String key) => ((nf[key] as List?) ?? const []).cast<Map<String, dynamic>>();
    Map<String, double> codes(String key, {double factor = 1}) =>
        {for (final a in list(key)) a['code'] as String: (a['amount'] as num).toDouble() * factor};

    switch (nf['kind']) {
      case 'supplement':
        final existing = await (db.select(db.foods)
              ..where((f) => f.source.equals('supplement') & f.name.lower().equals(name.toLowerCase())))
            .get();
        if (existing.isNotEmpty) return existing.first.id;
        // Values per 1 piece -> per 100 pieces.
        return db.createFood(
          FoodsCompanion.insert(name: name, source: 'supplement', amountUnit: const Value('piece')),
          await foods.byId(codes('nutrients_per_unit', factor: 100)),
        );

      case 'dish':
        final ingredients = list('ingredients');
        final table = await db.nutrientTable(ingredients.map((i) => i['food_id'] as int));
        final total = <int, double>{};
        var grams = 0.0;
        for (final ing in ingredients) {
          final g = (ing['grams'] as num).toDouble();
          final per100 = table[ing['food_id'] as int];
          if (per100 == null) continue; // ingredient id not in local DB
          grams += g;
          per100.forEach((nid, v) => total[nid] = (total[nid] ?? 0) + v * g / 100);
        }
        if (grams <= 0) return null;
        return db.createFood(
          FoodsCompanion.insert(
            name: name,
            source: 'claude_estimate',
            sourceRef: Value('dish: ${ingredients.map((i) => '${i['food_id']}:${i['grams']}g').join(', ')}'),
            defaultServingG: Value(grams),
          ),
          total.map((k, v) => MapEntry(k, v / grams * 100)),
        );

      default: // 'food'
        final fromLabel = nf['label_nutrients_per_100'] != null;
        if (fromLabel && barcode != null) {
          final existing = await db.foodByBarcode(barcode);
          if (existing != null) return existing.id;
        }
        return db.createFood(
          FoodsCompanion.insert(
            name: name,
            source: fromLabel ? 'off' : 'claude_estimate',
            sourceRef: Value(fromLabel ? 'label photo' : null),
            barcode: Value(fromLabel ? barcode : null),
            packageQuantity: Value((nf['package_amount'] as num?)?.toDouble()),
            amountUnit: Value(item['unit'] == 'ml' ? 'ml' : 'g'),
          ),
          await foods.byId(codes(fromLabel ? 'label_nutrients_per_100' : 'estimated_nutrients_per_100')),
        );
    }
  }

  Future<void> _importEnrich(RequestRow req, Map<String, dynamic> result) async {
    final foodId = req.foodId;
    if (foodId == null) return;
    final food = await db.foodById(foodId);
    if (food == null) return;
    final ids = await foods.nutrientIds();

    final matched = result['matched_food_id'] as int?;
    final matchedSource = matched == null ? null : (await db.foodById(matched))?.source;
    final fromDb = <int, double>{};
    final estimates = <int, double>{};
    for (final a in ((result['nutrients_per_100'] as List?) ?? const []).cast<Map<String, dynamic>>()) {
      final id = ids[a['code']];
      if (id == null) continue;
      final v = (a['amount'] as num).toDouble();
      if (a['origin'] == 'db' && matchedSource != null) {
        fromDb[id] = v;
      } else {
        estimates[id] = v;
      }
    }
    // Label > generic database > Claude estimate (enforced in addValues).
    if (fromDb.isNotEmpty) await db.addValues(foodId, fromDb, matchedSource!);
    if (estimates.isNotEmpty) await db.addValues(foodId, estimates, 'claude_estimate');

    final ns = (result['nutriscore_inputs'] as Map?)?.cast<String, dynamic>();
    await db.updateFood(
      foodId,
      FoodsCompanion(
        enrichment: const Value('done'),
        nutriscoreCategory:
            food.nutriscoreCategory == null && ns != null ? Value(ns['category'] as String) : const Value.absent(),
        fvlPercent: food.fvlPercent == null && ns != null
            ? Value((ns['fvl_percent'] as num).toDouble())
            : const Value.absent(),
        nonNutritiveSweeteners: food.nonNutritiveSweeteners == null && ns?['non_nutritive_sweeteners'] != null
            ? Value(ns!['non_nutritive_sweeteners'] as bool)
            : const Value.absent(),
      ),
    );

    final old = await db.noteFor(foodId);
    final rating = result['health_rating'] as int?;
    final reason = result['health_reason'] as String?;
    await db.saveNote(FoodNotesCompanion(
      foodId: Value(foodId),
      novaGroup: Value(old?.novaGroup ?? result['nova_group'] as int?),
      healthRating: Value(rating ?? old?.healthRating),
      healthReason: Value(reason ?? old?.healthReason),
      warningText: Value(rating != null && rating <= warnAtOrBelow ? reason : old?.warningText),
      nutriScore: Value(old?.nutriScore),
      generatedAt: Value(DateTime.now()),
    ));
    await foods.refreshNutriScore(foodId);
  }
}

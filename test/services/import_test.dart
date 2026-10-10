import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nutrient_tracker/claude/backend.dart';
import 'package:nutrient_tracker/data/database.dart';
import 'package:nutrient_tracker/nutrition/classification.dart';
import 'package:nutrient_tracker/services/food_service.dart';
import 'package:nutrient_tracker/services/nutrition_service.dart';
import 'package:nutrient_tracker/services/request_service.dart';
import 'package:nutrient_tracker/services/result_importer.dart';

/// Uses the real bundled database (assets/db/nutrients.sqlite).
void main() {
  late AppDatabase db;
  late RequestService requests;
  late FoodService foods;
  late ResultImporter importer;

  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.importBundled(File('assets/db/nutrients.sqlite'), 'test');
    requests = RequestService(db: db, backend: () => null, dbVersion: () => 'test');
    foods = FoodService(db: db, requests: requests);
    importer = ResultImporter(db: db, foods: foods);
    await db.saveProfile(ProfilesCompanion.insert(
        sex: 'm', age: 30, heightCm: 180, weightKg: 75, activityLevel: '1.4', updatedAt: DateTime.now()));
  });

  tearDown(() => db.close());

  test('bundled import', () async {
    expect((await db.allNutrients()).length, greaterThan(100));
    expect((await db.allReferenceValues()).length, greaterThan(200));
    final banana = await db.foodById(10001166);
    expect(banana!.name, 'Banana raw');
    expect(banana.isCommon, isTrue);
    expect((await db.searchFoods('Banane roh')).first.id, 10001166);
  });

  test('log result creates entries, a dish, a supplement and enrichment requests; duplicates are ignored', () async {
    final id = await requests.logText('banana, curry and vitamin D', inputSource: 'text');
    final result = ClaudeResult.fromJson({
      'request_id': id,
      'type': 'log_text',
      'db_version': 'test',
      'status': 'ok',
      'result': {
        'items': [
          {'label': 'banana', 'food_id': 10001166, 'amount': 120, 'unit': 'g', 'confidence': 0.9},
          {
            'label': 'chicken with rice',
            'amount': 300,
            'unit': 'g',
            'confidence': 0.6,
            'new_food': {
              'name': 'Chicken with rice',
              'kind': 'dish',
              'ingredients': [
                {'food_id': 10004369, 'grams': 150},
                {'food_id': 10000313, 'grams': 150},
              ],
            },
          },
          {
            'label': 'vitamin D',
            'amount': 1,
            'unit': 'piece',
            'confidence': 0.95,
            'new_food': {
              'name': 'Vitamin D3 1000 IU',
              'kind': 'supplement',
              'nutrients_per_unit': [
                {'code': 'VITD', 'amount': 25},
              ],
            },
          },
        ],
      },
    });
    await importer.import(result);
    await importer.import(result); // duplicate

    final entries = await db.entriesForRequest(id);
    expect(entries, hasLength(3));
    expect((await db.requestById(id))!.status, 'done');

    final dish = await db.foodById(entries[1].foodId);
    expect(dish!.source, 'claude_estimate');
    expect(dish.defaultServingG, 300);

    final supp = await db.foodById(entries[2].foodId);
    expect(supp!.source, 'supplement');
    expect(supp.amountUnit, 'piece');

    // first use -> one enrich_food request per non-supplement food
    final open = await db.openRequests();
    final enrich = open.where((r) => r.type == 'enrich_food').toList();
    expect(enrich.map((r) => r.foodId).toSet(), {10001166, dish.id});
    final payload = jsonDecode(enrich.firstWhere((r) => r.foodId == 10001166).payload) as Map;
    expect((payload['payload']['missing_nutrients'] as List), contains('FSUGAR'));
    expect((payload['payload']['missing_nutrients'] as List), contains('SE')); // BLS has no selenium

    final nutrition = NutritionService(db);
    final report = (await nutrition.report(days: 1))!;
    final vitD = report.rows.firstWhere((r) => r.nutrient.code == 'VITD');
    expect(vitD.average, greaterThanOrEqualTo(25));
    expect(vitD.classification.state, BarState.green);
  });

  test('enrich result: estimates never override database values, health warning cached', () async {
    final logId = await requests.logText('banana', inputSource: 'text');
    await importer.import(ClaudeResult.fromJson({
      'request_id': logId,
      'type': 'log_text',
      'db_version': 'test',
      'status': 'ok',
      'result': {
        'items': [
          {'label': 'banana', 'food_id': 10001166, 'amount': 120, 'unit': 'g', 'confidence': 0.9},
        ],
      },
    }));
    final enrich = (await db.openRequests()).firstWhere((r) => r.type == 'enrich_food');
    final ids = await foods.nutrientIds();
    final before = (await db.nutrientTable([10001166]))[10001166]![ids['VITC']];

    await importer.import(ClaudeResult.fromJson({
      'request_id': enrich.id,
      'type': 'enrich_food',
      'db_version': 'test',
      'status': 'ok',
      'result': {
        'nutrients_per_100': [
          {'code': 'FSUGAR', 'amount': 0, 'origin': 'estimate'},
          {'code': 'SE', 'amount': 1.0, 'origin': 'estimate'},
          {'code': 'VITC', 'amount': 999, 'origin': 'estimate'},
        ],
        'nova_group': 1,
        'health_rating': 5,
        'health_reason': 'Whole fruit.',
      },
    }));
    final values = (await db.nutrientTable([10001166]))[10001166]!;
    expect(values[ids['SE']], 1.0);
    expect(values[ids['FSUGAR']], 0);
    expect(values[ids['VITC']], before);
    final note = await db.noteFor(10001166);
    expect(note!.novaGroup, 1);
    expect(note.healthRating, 5);
    expect(note.warningText, isNull);
    expect(note.nutriScore, 'A'); // BLS heuristics: raw fruit, general, FVL 100
    expect((await db.foodById(10001166))!.enrichment, 'done');
  });

  test('supplement plan result creates a plan and auto-logs today', () async {
    final id = await requests.supplementPlan('Magnesium 300 mg');
    await importer.import(ClaudeResult.fromJson({
      'request_id': id,
      'type': 'log_text',
      'db_version': 'test',
      'status': 'ok',
      'result': {
        'items': [
          {
            'label': 'magnesium',
            'amount': 1,
            'unit': 'piece',
            'confidence': 0.9,
            'new_food': {
              'name': 'Magnesium 300 mg',
              'kind': 'supplement',
              'nutrients_per_unit': [
                {'code': 'MG', 'amount': 300},
              ],
            },
          },
        ],
      },
    }));
    final plans = await db.activeSupplementPlans();
    expect(plans, hasLength(1));
    final now = DateTime.now();
    expect(await db.hasAutoEntry(plans.first.id, DateTime(now.year, now.month, now.day)), isTrue);
    await foods.autoLogSupplements(now); // idempotent
    final all = await db.entriesBetween(DateTime(2000), DateTime(2100));
    expect(all.where((e) => e.inputSource == 'supplement_auto'), hasLength(1));
    expect(await db.entriesForRequest(id), isEmpty);

    // Supplement-only day doesn't count; with food it does and Mg UL (supplements only) is exceeded.
    final nutrition = NutritionService(db);
    expect((await nutrition.report(days: 1))!.averages.countedDays, 0);
    await db.addEntry(LogEntriesCompanion.insert(
        timestamp: now, foodId: 10001166, grams: 100, inputSource: 'text', rawInput: const Value('banana')));
    final mg = (await nutrition.report(days: 1))!.rows.firstWhere((r) => r.nutrient.code == 'MG');
    expect(mg.classification.state, BarState.red);
    expect(mg.classification.reason, RedReason.tooHigh);
  });

  test('error results mark the request failed with the message', () async {
    final id = await requests.logText('???', inputSource: 'text');
    await importer.import(ClaudeResult.fromJson({
      'request_id': id,
      'type': 'log_text',
      'db_version': 'test',
      'status': 'error',
      'error_message': 'Could not read the image',
    }));
    final r = (await db.requestById(id))!;
    expect(r.status, 'failed');
    expect(r.lastError, 'Could not read the image');
    expect(r.rawInput, '???');
  });
}

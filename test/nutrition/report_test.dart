import 'package:flutter_test/flutter_test.dart';
import 'package:nutrient_tracker/nutrition/aggregation.dart';
import 'package:nutrient_tracker/nutrition/classification.dart';
import 'package:nutrient_tracker/nutrition/models.dart';
import 'package:nutrient_tracker/nutrition/report.dart';
import 'package:nutrient_tracker/nutrition/status_answers.dart';
import 'package:nutrient_tracker/nutrition/suggestions.dart';
import 'package:nutrient_tracker/nutrition/targets.dart';

import 'fixtures.dart';

void main() {
  const bread = 100, orange = 101, pepper = 102, chips = 103;
  final table = <int, Map<int, double>>{
    bread: {energy.id: 250, salt.id: 1.2, protein.id: 8},
    orange: {energy.id: 47, vitC.id: 50},
    pepper: {energy.id: 30, vitC.id: 140},
    chips: {energy.id: 540, salt.id: 1.5, fat.id: 34},
  };
  final engine = SuggestionEngine(commonFoods: const [
    FoodInfo(id: orange, name: 'Orange', servingAmount: 150, isCommon: true),
    FoodInfo(id: pepper, name: 'Red pepper', servingAmount: 150, isCommon: true),
  ], nutrients: table);
  final today = DateTime(2026, 10, 10, 12);

  NutrientReport report(List<LoggedItem> items, {int days = 7}) => buildReport(
        profile: man30,
        nutrients: nutrients,
        resolver: TargetResolver(nutrients: nutrients, references: references),
        averages: averageWindow(items: items, nutrients: table, today: today, days: days),
        suggestions: engine,
        windowDays: days,
      );

  test('rows in importance order; low bars get food suggestions, high bars get contributors', () {
    final r = report([
      LoggedItem(timestamp: today, foodId: bread, amount: 300),
      LoggedItem(timestamp: today, foodId: chips, amount: 200),
    ]);
    final ranks = r.rows.map((s) => s.nutrient.importanceRank).toList();
    expect(ranks, [...ranks]..sort());

    final c = r.rows.firstWhere((s) => s.nutrient.id == vitC.id);
    expect(c.classification.state, BarState.red);
    expect(c.suggestions.map((s) => s.food.name), ['Red pepper', 'Orange']);

    final s = r.rows.firstWhere((s) => s.nutrient.id == salt.id);
    expect(s.average, closeTo(3.6 + 3.0, 1e-9));
    expect(s.classification.reason, RedReason.tooHigh);
    expect(s.contributors.first.key, bread);
  });

  test('status answer lists low and high nutrients', () {
    final r = report([LoggedItem(timestamp: today, foodId: chips, amount: 400)], days: 1);
    final text = statusAnswer(r, StatusPeriod.today);
    expect(text, contains('Low today'));
    expect(text, contains('Protein'));
    expect(text, contains('Too high'));
    expect(text, contains('Salt'));
  });

  test('status answer with nothing logged', () {
    expect(statusAnswer(report(const []), StatusPeriod.week), 'Nothing logged in the last 7 days yet.');
  });

  group('chat intent', () {
    test('status questions', () {
      expect(classifyChatInput('what am I low on today?'), isA<StatusIntent>());
      expect((classifyChatInput('What am I lacking this week?') as StatusIntent).period, StatusPeriod.week);
      expect((classifyChatInput('was fehlt mir diesen monat') as StatusIntent).period, StatusPeriod.month);
      expect((classifyChatInput('this week?', previousWasStatus: true) as StatusIntent).period, StatusPeriod.week);
    });

    test('food logs', () {
      for (final t in ['banana', 'rice small', '200 g chicken breast', 'vitamin D 1000 IU', 'zwei Brötchen mit Käse']) {
        expect(classifyChatInput(t), isA<LogIntent>(), reason: t);
      }
    });

    test('other questions are out of scope', () {
      expect(classifyChatInput('Is coffee healthy?'), isA<OutOfScopeIntent>());
      expect(classifyChatInput('how do I lose weight'), isA<OutOfScopeIntent>());
      expect(classifyChatInput('this week?'), isA<OutOfScopeIntent>());
    });
  });
}

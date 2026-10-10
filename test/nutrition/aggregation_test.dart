import 'package:flutter_test/flutter_test.dart';
import 'package:nutrient_tracker/nutrition/aggregation.dart';
import 'package:nutrient_tracker/nutrition/models.dart';

void main() {
  const apple = 1, supplement = 2;
  const vitC = 31, energy = 1;
  final table = <int, Map<int, double>>{
    apple: {energy: 50, vitC: 10},
    supplement: {vitC: 100}, // per 100 pieces -> 1 piece = 1 mg
  };
  final today = DateTime(2026, 10, 10, 18);

  LoggedItem item(int daysAgo, int food, double amount, {bool auto = false, bool supp = false}) => LoggedItem(
      timestamp: today.subtract(Duration(days: daysAgo)),
      foodId: food,
      amount: amount,
      isSupplementAuto: auto,
      isSupplementFood: supp);

  test('averages over days with entries only', () {
    final r = averageWindow(
      items: [item(0, apple, 200), item(2, apple, 100)],
      nutrients: table,
      today: today,
      days: 7,
    );
    expect(r.countedDays, 2);
    expect(r.average(vitC), closeTo((20 + 10) / 2, 1e-9));
    expect(r.average(energy), closeTo((100 + 50) / 2, 1e-9));
  });

  test('window boundaries are inclusive calendar days', () {
    final r = averageWindow(
      items: [item(0, apple, 100), item(2, apple, 100), item(3, apple, 100)],
      nutrients: table,
      today: today,
      days: 3,
    );
    expect(r.countedDays, 2);
  });

  test('days with only automatic supplement entries do not count', () {
    final r = averageWindow(
      items: [
        item(0, apple, 100),
        item(0, supplement, 1, auto: true, supp: true),
        item(1, supplement, 1, auto: true, supp: true), // forgotten day
      ],
      nutrients: table,
      today: today,
      days: 7,
    );
    expect(r.countedDays, 1);
    expect(r.average(vitC), closeTo(10 + 1, 1e-9));
    expect(r.supplementAverages[vitC], closeTo(1, 1e-9));
  });

  test('manual supplement entries count as a logged day', () {
    final r = averageWindow(
      items: [item(1, supplement, 1, supp: true)],
      nutrients: table,
      today: today,
      days: 7,
    );
    expect(r.countedDays, 1);
  });

  test('contributions per food', () {
    final r = averageWindow(
      items: [item(0, apple, 100), item(0, supplement, 5, supp: true)],
      nutrients: table,
      today: today,
      days: 1,
    );
    expect(r.contributions[vitC]![apple], closeTo(10, 1e-9));
    expect(r.contributions[vitC]![supplement], closeTo(5, 1e-9));
  });

  test('empty window', () {
    final r = averageWindow(items: const [], nutrients: table, today: today, days: 7);
    expect(r.isEmpty, isTrue);
    expect(r.average(vitC), 0);
  });
}

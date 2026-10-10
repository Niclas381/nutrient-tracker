/// Daily averages over a time window.
library;

import 'models.dart';

enum TimeWindow {
  days3(3, '3 days'),
  days7(7, '7 days'),
  month(30, '1 month'),
  year(365, '1 year');

  const TimeWindow(this.days, this.label);
  final int days;
  final String label;
}

DateTime dayOf(DateTime t) => DateTime(t.year, t.month, t.day);

class WindowAverages {
  const WindowAverages({
    required this.countedDays,
    required this.averages,
    required this.supplementAverages,
    required this.contributions,
  });

  /// Days in the window with at least one entry (supplement auto-entries alone don't count).
  final int countedDays;

  /// nutrient id -> average per counted day.
  final Map<int, double> averages;

  /// nutrient id -> average per counted day from supplement foods only.
  final Map<int, double> supplementAverages;

  /// nutrient id -> food id -> average per counted day.
  final Map<int, Map<int, double>> contributions;

  double average(int nutrientId) => averages[nutrientId] ?? 0;

  bool get isEmpty => countedDays == 0;
}

/// Averages [items] over the [days] calendar days ending with [today] (inclusive).
///
/// Daily average = total ÷ number of days with at least one log entry. Days without entries are excluded so a
/// forgotten day doesn't look like a deficiency. Days that only contain automatic supplement entries count as
/// empty (otherwise the daily supplement plan would make every forgotten day count); their supplement entries are
/// excluded too.
WindowAverages averageWindow({
  required Iterable<LoggedItem> items,
  required NutrientTable nutrients,
  required DateTime today,
  required int days,
}) {
  final end = dayOf(today);
  final start = end.subtract(Duration(days: days - 1));
  bool inWindow(DateTime t) {
    final d = dayOf(t);
    return !d.isBefore(start) && !d.isAfter(end);
  }

  final windowItems = items.where((i) => inWindow(i.timestamp)).toList();
  final countedDays = windowItems.where((i) => !i.isSupplementAuto).map((i) => dayOf(i.timestamp)).toSet();

  final totals = <int, double>{};
  final suppTotals = <int, double>{};
  final contrib = <int, Map<int, double>>{};
  for (final item in windowItems) {
    if (!countedDays.contains(dayOf(item.timestamp))) continue;
    final per100 = nutrients[item.foodId];
    if (per100 == null) continue;
    final factor = item.amount / 100;
    per100.forEach((nid, v) {
      final amount = v * factor;
      totals[nid] = (totals[nid] ?? 0) + amount;
      if (item.isSupplementFood) suppTotals[nid] = (suppTotals[nid] ?? 0) + amount;
      final byFood = contrib.putIfAbsent(nid, () => {});
      byFood[item.foodId] = (byFood[item.foodId] ?? 0) + amount;
    });
  }

  final n = countedDays.length;
  Map<int, double> avg(Map<int, double> m) => n == 0 ? {} : m.map((k, v) => MapEntry(k, v / n));
  return WindowAverages(
    countedDays: n,
    averages: avg(totals),
    supplementAverages: avg(suppTotals),
    contributions: {for (final e in contrib.entries) e.key: avg(e.value)},
  );
}

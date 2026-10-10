/// Food suggestions for red bars, computed locally (no API call).
library;

import 'models.dart';

class Suggestion {
  const Suggestion(this.food, this.amountPerServing);

  final FoodInfo food;

  /// Nutrient amount in one typical serving of the food.
  final double amountPerServing;
}

/// Ranks common grocery foods by the nutrient amount per typical serving.
class SuggestionEngine {
  SuggestionEngine({required this.commonFoods, required this.nutrients});

  /// Single buyable foods with a typical serving (flagged `is_common`).
  final List<FoodInfo> commonFoods;
  final NutrientTable nutrients;

  final Map<int, List<Suggestion>> _cache = {};

  /// Top [count] common foods for [nutrientId], highest amount per serving first.
  List<Suggestion> richestFoods(int nutrientId, {int count = 2}) {
    final ranked = _cache.putIfAbsent(nutrientId, () {
      final list = <Suggestion>[];
      for (final f in commonFoods) {
        final serving = f.servingAmount;
        final per100 = nutrients[f.id]?[nutrientId];
        if (serving == null || per100 == null || per100 <= 0) continue;
        list.add(Suggestion(f, per100 * serving / 100));
      }
      list.sort((a, b) => b.amountPerServing.compareTo(a.amountPerServing));
      return list;
    });
    return ranked.take(count).toList();
  }
}

/// The logged foods contributing most to [nutrientId] in the window, highest first.
List<MapEntry<int, double>> mainContributors(Map<int, Map<int, double>> contributions, int nutrientId,
    {int count = 2}) {
  final byFood = contributions[nutrientId];
  if (byFood == null) return const [];
  final list = byFood.entries.where((e) => e.value > 0).toList()..sort((a, b) => b.value.compareTo(a.value));
  return list.take(count).toList();
}

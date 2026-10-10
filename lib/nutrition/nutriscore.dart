/// Nutri-Score, updated algorithm (2023 version for foods and 2023 version for beverages).
///
/// Thresholds follow the Nutri-Score Scientific Committee update reports (2022 foods, 2023 beverages), as also
/// implemented by Open Food Facts.
library;

enum NutriScoreCategory {
  general('general'),
  beverage('beverage'),
  water('water'),
  fatOilNutsSeeds('fat_oil_nuts_seeds'),
  cheese('cheese'),
  redMeat('red_meat'),

  /// e.g. alcoholic drinks: no Nutri-Score.
  notApplicable('not_applicable');

  const NutriScoreCategory(this.code);
  final String code;

  static NutriScoreCategory? fromCode(String? code) {
    if (code == null) return null;
    for (final c in values) {
      if (c.code == code) return c;
    }
    return null;
  }
}

/// Inputs per 100 g (or 100 ml for beverages).
class NutriScoreInput {
  const NutriScoreInput({
    required this.category,
    required this.energyKcal,
    required this.sugars,
    required this.saturatedFat,
    required this.fat,
    required this.salt,
    required this.fiber,
    required this.protein,
    required this.fvlPercent,
    this.nonNutritiveSweeteners = false,
  });

  final NutriScoreCategory category;
  final double energyKcal;
  final double sugars;
  final double saturatedFat;
  final double fat;
  final double salt;
  final double fiber;
  final double protein;

  /// % fruit, vegetables and legumes.
  final double fvlPercent;
  final bool nonNutritiveSweeteners;
}

class NutriScore {
  const NutriScore(this.score, this.grade);
  final int score;

  /// 'A'..'E'
  final String grade;
}

const List<double> _energy = [335.0, 670, 1005, 1340, 1675, 2010, 2345, 2680, 3015, 3350];
const List<double> _energyBeverages = [30.0, 90, 150, 210, 240, 270, 300, 330, 360, 390];
const List<double> _sugars = [3.4, 6.8, 10, 14, 17, 20, 24, 27, 31, 34, 37, 41, 44, 48, 51];
const List<double> _sugarsBeverages = [0.5, 2, 3.5, 5, 6, 7, 8, 9, 10, 11];
const List<double> _saturatedFat = [1.0, 2, 3, 4, 5, 6, 7, 8, 9, 10];
const List<double> _salt = [0.2, 0.4, 0.6, 0.8, 1, 1.2, 1.4, 1.6, 1.8, 2, 2.2, 2.4, 2.6, 2.8, 3, 3.2, 3.4, 3.6, 3.8, 4];
const List<double> _energyFromSatFat = [120.0, 240, 360, 480, 600, 720, 840, 960, 1080, 1200];
const List<double> _satFatRatio = [10.0, 16, 22, 28, 34, 40, 46, 52, 58, 64];
const List<double> _fvl = [40.0, 60, 80, 80, 80];
const List<double> _fvlBeverages = [40.0, 40, 60, 60, 80, 80];
const List<double> _fiber = [3.0, 4.1, 5.2, 6.3, 7.4];
const List<double> _protein = [2.4, 4.8, 7.2, 9.6, 12, 14, 17];
const List<double> _proteinBeverages = [1.2, 1.5, 1.8, 2.1, 2.4, 2.7, 3.0];

/// Points = number of thresholds strictly exceeded.
int _points(double value, List<double> thresholds) => thresholds.where((t) => value > t).length;

/// Returns null when the Nutri-Score does not apply (e.g. alcoholic drinks).
NutriScore? computeNutriScore(NutriScoreInput i) {
  if (i.category == NutriScoreCategory.notApplicable) return null;
  if (i.category == NutriScoreCategory.water) return const NutriScore(0, 'A');

  final beverage = i.category == NutriScoreCategory.beverage;
  final fats = i.category == NutriScoreCategory.fatOilNutsSeeds;
  final energyKj = i.energyKcal * 4.184;

  int negative;
  if (fats) {
    final ratio = i.fat > 0 ? i.saturatedFat / i.fat * 100 : 0.0;
    negative = _points(i.saturatedFat * 37, _energyFromSatFat) +
        _points(i.sugars, _sugars) +
        _satFatRatio.where((t) => ratio >= t).length +
        _points(i.salt, _salt);
  } else {
    negative = _points(energyKj, beverage ? _energyBeverages : _energy) +
        _points(i.sugars, beverage ? _sugarsBeverages : _sugars) +
        _points(i.saturatedFat, _saturatedFat) +
        _points(i.salt, _salt);
    if (beverage && i.nonNutritiveSweeteners) negative += 4;
  }

  var proteinPoints = _points(i.protein, beverage ? _proteinBeverages : _protein);
  if (i.category == NutriScoreCategory.redMeat && proteinPoints > 2) proteinPoints = 2;

  final bool countProtein;
  if (beverage || i.category == NutriScoreCategory.cheese) {
    countProtein = true;
  } else if (fats) {
    countProtein = negative < 7;
  } else {
    countProtein = negative < 11;
  }

  final positive = _points(i.fiber, _fiber) +
      _points(i.fvlPercent, beverage ? _fvlBeverages : _fvl) +
      (countProtein ? proteinPoints : 0);
  final score = negative - positive;

  final String grade;
  if (beverage) {
    grade = score <= 2 ? 'B' : score <= 6 ? 'C' : score <= 9 ? 'D' : 'E';
  } else if (fats) {
    grade = score <= -6 ? 'A' : score <= 2 ? 'B' : score <= 10 ? 'C' : score <= 18 ? 'D' : 'E';
  } else {
    grade = score <= 0 ? 'A' : score <= 2 ? 'B' : score <= 10 ? 'C' : score <= 18 ? 'D' : 'E';
  }
  return NutriScore(score, grade);
}

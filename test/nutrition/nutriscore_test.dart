import 'package:flutter_test/flutter_test.dart';
import 'package:nutrient_tracker/nutrition/nutriscore.dart';

NutriScoreInput input(NutriScoreCategory c,
        {double kcal = 0,
        double sugars = 0,
        double sat = 0,
        double fat = 0,
        double salt = 0,
        double fiber = 0,
        double protein = 0,
        double fvl = 0,
        bool sweeteners = false}) =>
    NutriScoreInput(
        category: c,
        energyKcal: kcal,
        sugars: sugars,
        saturatedFat: sat,
        fat: fat,
        salt: salt,
        fiber: fiber,
        protein: protein,
        fvlPercent: fvl,
        nonNutritiveSweeteners: sweeteners);

void main() {
  test('hazelnut spread-like product is E (protein not counted at >= 11 negative points)', () {
    final s = computeNutriScore(input(NutriScoreCategory.general,
        kcal: 539, sugars: 56.3, sat: 10.6, fat: 30.9, salt: 0.107, protein: 6.3))!;
    // energy 2255 kJ -> 6, sugars -> 15, saturated fat -> 10, salt -> 0
    expect(s.score, 31);
    expect(s.grade, 'E');
  });

  test('raw apple is A', () {
    final s = computeNutriScore(
        input(NutriScoreCategory.general, kcal: 54, sugars: 10.3, sat: 0, fat: 0.1, salt: 0, fiber: 2.0, protein: 0.3, fvl: 100))!;
    // energy 226 kJ -> 0, sugars 10.3 -> 3; fvl 100 -> 5
    expect(s.score, -2);
    expect(s.grade, 'A');
  });

  test('cola is E', () {
    final s = computeNutriScore(input(NutriScoreCategory.beverage, kcal: 43, sugars: 10.6))!;
    // energy 180 kJ -> 3, sugars 10.6 -> 9
    expect(s.score, 12);
    expect(s.grade, 'E');
  });

  test('diet cola gets 4 sweetener points', () {
    final s = computeNutriScore(input(NutriScoreCategory.beverage, kcal: 0.4, sweeteners: true))!;
    expect(s.score, 4);
    expect(s.grade, 'C');
  });

  test('whole milk is C (beverage, protein counted)', () {
    final s = computeNutriScore(
        input(NutriScoreCategory.beverage, kcal: 64, sugars: 4.7, sat: 2.3, fat: 3.5, salt: 0.1, protein: 3.3))!;
    // energy 268 kJ -> 5, sugars -> 3, sat -> 2, salt -> 0 = 10; protein 3.3 -> 7
    expect(s.score, 3);
    expect(s.grade, 'C');
  });

  test('water is A, alcohol has no score', () {
    expect(computeNutriScore(input(NutriScoreCategory.water))!.grade, 'A');
    expect(computeNutriScore(input(NutriScoreCategory.notApplicable)), isNull);
  });

  test('fats use energy from saturates and the saturated-fat ratio', () {
    final s = computeNutriScore(input(NutriScoreCategory.fatOilNutsSeeds, kcal: 884, sat: 14, fat: 100))!;
    // 14 g * 37 = 518 kJ -> 4 points; ratio 14 % -> 1 point
    expect(s.score, 5);
    expect(s.grade, 'C');
  });

  test('red meat protein points are capped at 2', () {
    final beef = input(NutriScoreCategory.redMeat, kcal: 250, sat: 6, fat: 15, salt: 0.15, protein: 26);
    final generic = input(NutriScoreCategory.general, kcal: 250, sat: 6, fat: 15, salt: 0.15, protein: 26);
    // negative: energy 1046 kJ -> 3, sat 6 -> 5 = 8
    expect(computeNutriScore(beef)!.score, 8 - 2);
    expect(computeNutriScore(generic)!.score, 8 - 7);
  });

  test('cheese always counts protein', () {
    final s = computeNutriScore(input(NutriScoreCategory.cheese, kcal: 400, sat: 20, fat: 33, salt: 1.8, protein: 25))!;
    // energy 1674 kJ -> 4, sat -> 10, salt 1.8 -> 8 = 22; protein -> 7
    expect(s.score, 15);
    expect(s.grade, 'D');
  });
}

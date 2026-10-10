import 'package:flutter_test/flutter_test.dart';
import 'package:nutrient_tracker/nutrition/classification.dart';
import 'package:nutrient_tracker/nutrition/models.dart';
import 'package:nutrient_tracker/nutrition/targets.dart';

import 'fixtures.dart';

void main() {
  final resolver = TargetResolver(nutrients: nutrients, references: references);

  BarState state(Profile p, NutrientDef n, double value, {double? avgEnergy, double? ulValue}) =>
      classify(resolver.resolve(p, avgEnergyKcal: avgEnergy)[n.id]!, value, ulValue: ulValue).state;

  group('energy', () {
    test('DGE value by PAL', () {
      expect(resolver.energyTarget(man30), 2300);
      expect(resolver.energyTarget(const Profile(sex: Sex.male, age: 30, heightCm: 180, weightKg: 75, pal: Pal.pal18)),
          3000);
    });

    test('green within ±5 %, yellow to ±15 %, red beyond', () {
      expect(state(man30, energy, 2300 * 1.05), BarState.green);
      expect(state(man30, energy, 2300 * 0.95), BarState.green);
      expect(state(man30, energy, 2300 * 1.10), BarState.yellow);
      expect(state(man30, energy, 2300 * 0.86), BarState.yellow);
      expect(state(man30, energy, 2300 * 1.16), BarState.red);
      expect(state(man30, energy, 2300 * 0.80), BarState.red);
    });
  });

  group('minimum with EFSA AR', () {
    test('vitamin C: red below AR, yellow up to RI, green above, never red from high', () {
      expect(state(man30, vitC, 85), BarState.red);
      expect(state(man30, vitC, 100), BarState.yellow);
      expect(state(man30, vitC, 110), BarState.green);
      expect(state(man30, vitC, 5000), BarState.green);
    });

    test('protein per kg body weight, weight capped at BMI 25', () {
      final t = resolver.resolve(man30)[protein.id]!;
      expect(t.green, closeTo(0.8 * 75, 1e-9));
      expect(t.redBelow, closeTo(0.66 * 75, 1e-9));
      const heavy = Profile(sex: Sex.male, age: 30, heightCm: 180, weightKg: 110, pal: Pal.pal14);
      expect(resolver.resolve(heavy)[protein.id]!.green, closeTo(0.8 * 25 * 1.8 * 1.8, 1e-9));
    });

    test('per-MJ AR uses the energy target', () {
      final t = resolver.resolve(man30)[thiamin.id]!;
      expect(t.green, 1.2);
      expect(t.redBelow, closeTo(0.072 * 2300 * 0.004184, 1e-9));
    });

    test('AR >= DGE RI switches to the EFSA PRI as target', () {
      final t = resolver.resolve(woman30)[riboflavin.id]!;
      expect(t.green, 1.6);
      expect(t.redBelow, 1.3);
    });
  });

  group('estimated values without AR (2/3 rule)', () {
    test('vitamin D: red below 2/3, yellow below 20, red above UL', () {
      expect(state(man30, vitD, 13), BarState.red);
      expect(state(man30, vitD, 14), BarState.yellow);
      expect(state(man30, vitD, 20), BarState.green);
      expect(state(man30, vitD, 100), BarState.green);
      expect(state(man30, vitD, 101), BarState.red);
    });
  });

  group('UL bases', () {
    test('magnesium UL applies to supplements only', () {
      expect(state(man30, magnesium, 600, ulValue: 0), BarState.green);
      expect(state(man30, magnesium, 600, ulValue: 300), BarState.red);
    });

    test('vitamin A UL is checked against retinol', () {
      final t = resolver.resolve(man30)[vitA.id]!;
      expect(t.ulBasis, isA<UlOtherNutrient>());
      expect((t.ulBasis as UlOtherNutrient).code, 'RETOL');
      expect(classify(t, 4000, ulValue: 500).state, BarState.green);
      expect(classify(t, 4000, ulValue: 3500).classificationReason, RedReason.tooHigh);
    });
  });

  group('profile conditions', () {
    test('iron by menstruation status', () {
      expect(resolver.resolve(woman30)[iron.id]!.green, 16);
      const post = Profile(
          sex: Sex.female, age: 30, heightCm: 165, weightKg: 60, pal: Pal.pal14, ironStatus: IronStatus.postmenopausal);
      expect(resolver.resolve(post)[iron.id]!.green, 14);
      expect(resolver.resolve(post)[iron.id]!.redBelow, 6);
      const notM = Profile(
          sex: Sex.female, age: 30, heightCm: 165, weightKg: 60, pal: Pal.pal14, ironStatus: IronStatus.notMenstruating);
      final t = resolver.resolve(notM)[iron.id]!;
      expect(t.green, 11);
      // no EFSA AR row for this status in the fixture -> 2/3 rule
      expect(t.redBelow, closeTo(11 * 2 / 3, 1e-9));
      expect(resolver.resolve(man30)[iron.id]!.green, 11);
    });

    test('zinc by phytate level', () {
      expect(resolver.resolve(man30)[zinc.id]!.green, 14);
      const low = Profile(sex: Sex.male, age: 30, heightCm: 180, weightKg: 75, pal: Pal.pal14, phytate: Phytate.low);
      expect(resolver.resolve(low)[zinc.id]!.green, 11);
    });
  });

  group('percent of energy', () {
    test('fat range uses actual average energy intake', () {
      final t = resolver.resolve(man30, avgEnergyKcal: 2000)[fat.id]!;
      expect(t.low, closeTo(0.20 * 2000 / 9, 1e-9));
      expect(t.high, closeTo(0.35 * 2000 / 9, 1e-9));
      expect(classify(t, 40).state, BarState.red);
      expect(classify(t, 60).state, BarState.green);
      expect(classify(t, 80).state, BarState.red);
    });

    test('free sugars WHO limit', () {
      final t = resolver.resolve(man30, avgEnergyKcal: 2000)[freeSugars.id]!;
      expect(t.limit, closeTo(50, 1e-9));
      expect(classify(t, 50).state, BarState.green);
      expect(classify(t, 51).state, BarState.red);
    });

    test('no energy intake -> no percent-based target', () {
      expect(resolver.resolve(man30)[fat.id], isNull);
    });
  });

  test('salt limit', () {
    expect(state(man30, salt, 5), BarState.green);
    expect(state(man30, salt, 5.1), BarState.red);
  });

  test('nutrients without reference values get no target', () {
    expect(resolver.resolve(man30).containsKey(sugar.id), isFalse);
  });
}

extension on Classification {
  RedReason? get classificationReason => state == BarState.red ? reason : null;
}

import 'package:flutter_test/flutter_test.dart';
import 'package:nutrient_tracker/input/open_food_facts.dart';
import 'package:nutrient_tracker/input/package_amount.dart';

void main() {
  group('package size', () {
    test('whole package by default', () {
      final p = parsePackage(quantity: '1 l', productQuantity: 1000, productQuantityUnit: 'ml', servingQuantity: 250);
      expect(p.unit, 'ml');
      expect(p.packageAmount, 1000);
      expect(p.defaultAmount, 1000);
    });

    test('multipack defaults to one unit', () {
      final p = parsePackage(quantity: '6 x 250 ml', productQuantity: 1500, productQuantityUnit: 'ml');
      expect(p.isMultipack, isTrue);
      expect(p.multipackCount, 6);
      expect(p.unitAmount, 250);
      expect(p.packageAmount, 1500);
      expect(p.defaultAmount, 250);
    });

    test('multipack in litres and grams', () {
      expect(parsePackage(quantity: '4×1,5 l').unitAmount, 1500);
      expect(parsePackage(quantity: '10 x 25g').defaultAmount, 25);
    });

    test('falls back to serving, then to asking', () {
      expect(parsePackage(servingQuantity: 30).defaultAmount, 30);
      expect(parsePackage(quantity: 'one bag').defaultAmount, isNull);
    });

    test('quantity text when the normalized size is missing', () {
      final p = parsePackage(quantity: '500 g');
      expect(p.packageAmount, 500);
      expect(p.unit, 'g');
    });
  });

  test('parses OFF product nutrients into app units', () {
    final p = parseOffProduct('4000000000000', {
      'status': 1,
      'product': {
        'product_name': 'Orange juice',
        'brands': 'Brand A, Brand B',
        'quantity': '1 l',
        'product_quantity': 1000,
        'product_quantity_unit': 'ml',
        'nova_group': 1,
        'nutriscore_data': {'is_beverage': 1},
        'nutriments': {
          'energy-kcal_100g': 45,
          'sugars_100g': 9,
          'vitamin-c_100g': 0.032,
          'sodium_100g': 0.004,
          'vitamin-d_100g': 0.0000015,
        },
      },
    })!;
    expect(p.name, 'Orange juice');
    expect(p.brand, 'Brand A');
    expect(p.isBeverage, isTrue);
    expect(p.valuesPer100['VITC'], closeTo(32, 1e-9));
    expect(p.valuesPer100['NA'], closeTo(4, 1e-9));
    expect(p.valuesPer100['NACL'], closeTo(0.01, 1e-9));
    expect(p.valuesPer100['VITD'], closeTo(1.5, 1e-9));
    expect(p.package.defaultAmount, 1000);
  });

  test('unknown product', () {
    expect(parseOffProduct('1', {'status': 0}), isNull);
  });
}

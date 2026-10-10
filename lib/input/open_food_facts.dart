/// Open Food Facts product lookup (barcode scans only).
library;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package_amount.dart';

class OffProduct {
  const OffProduct({
    required this.barcode,
    required this.name,
    required this.package,
    required this.valuesPer100,
    this.brand,
    this.categories,
    this.ingredientsText,
    this.novaGroup,
    this.isBeverage = false,
    this.nonNutritiveSweeteners,
  });

  final String barcode;
  final String name;
  final String? brand;
  final String? categories;
  final String? ingredientsText;
  final PackageAmount package;

  /// Nutrient code -> amount per 100 g/ml in the app's units (label values).
  final Map<String, double> valuesPer100;
  final int? novaGroup;
  final bool isBeverage;
  final bool? nonNutritiveSweeteners;
}

/// OFF `<key>_100g` (always grams, or kcal / % vol) -> (nutrient code, factor to the app's unit).
const Map<String, (String, double)> offNutrients = {
  'energy-kcal': ('ENERC_KCAL', 1),
  'proteins': ('PROT', 1),
  'fat': ('FAT', 1),
  'carbohydrates': ('CHO', 1),
  'sugars': ('SUGAR', 1),
  'fiber': ('FIBT', 1),
  'saturated-fat': ('FASAT', 1),
  'trans-fat': ('FATRN', 1),
  'monounsaturated-fat': ('FAMS', 1),
  'polyunsaturated-fat': ('FAPU', 1),
  'omega-3-fat': ('FAPUN3', 1),
  'omega-6-fat': ('FAPUN6', 1),
  'salt': ('NACL', 1),
  'sodium': ('NA', 1000),
  'starch': ('STARCH', 1),
  'lactose': ('LACS', 1),
  'polyols': ('POLYL', 1),
  'cholesterol': ('CHORL', 1000),
  'caffeine': ('CAFFN', 1000),
  'vitamin-a': ('VITA', 1e6),
  'vitamin-d': ('VITD', 1e6),
  'vitamin-e': ('VITE', 1000),
  'vitamin-k': ('VITK', 1e6),
  'vitamin-c': ('VITC', 1000),
  'vitamin-b1': ('THIA', 1000),
  'vitamin-b2': ('RIBF', 1000),
  'vitamin-pp': ('NIAEQ', 1000), // EU labels state niacin in mg NE
  'vitamin-b6': ('VITB6', 1000),
  'vitamin-b9': ('FOL', 1e6),
  'folates': ('FOL', 1e6),
  'vitamin-b12': ('VITB12', 1e6),
  'biotin': ('BIOT', 1e6),
  'pantothenic-acid': ('PANTAC', 1000),
  'potassium': ('K', 1000),
  'chloride': ('CLD', 1000),
  'calcium': ('CA', 1000),
  'phosphorus': ('P', 1000),
  'iron': ('FE', 1000),
  'magnesium': ('MG', 1000),
  'zinc': ('ZN', 1000),
  'copper': ('CU', 1000),
  'manganese': ('MN', 1000),
  'fluoride': ('FD', 1000),
  'selenium': ('SE', 1e6),
  'chromium': ('CR', 1e6),
  'molybdenum': ('MO', 1e6),
  'iodine': ('ID', 1e6),
};

/// Parses an OFF v2 product response. Returns null when the product is unknown.
OffProduct? parseOffProduct(String barcode, Map<String, dynamic> json) {
  if (json['status'] != 1 || json['product'] is! Map) return null;
  final p = json['product'] as Map<String, dynamic>;
  final n = (p['nutriments'] as Map?)?.cast<String, dynamic>() ?? const {};
  double? toNum(Object? v) => v is num ? v.toDouble() : (v is String ? double.tryParse(v.replaceAll(',', '.')) : null);

  final values = <String, double>{};
  for (final e in offNutrients.entries) {
    final v = toNum(n['${e.key}_100g']);
    if (v != null && v >= 0) values[e.value.$1] ??= v * e.value.$2;
  }
  if (!values.containsKey('ENERC_KCAL')) {
    final kj = toNum(n['energy-kj_100g']) ?? toNum(n['energy_100g']);
    if (kj != null) values['ENERC_KCAL'] = kj / 4.184;
  }
  final alcohol = toNum(n['alcohol_100g']);
  if (alcohol != null) values['ALC'] = alcohol * 0.789; // % vol -> g per 100 ml
  if (!values.containsKey('NACL') && values.containsKey('NA')) values['NACL'] = values['NA']! * 2.5 / 1000;

  final nsData = (p['nutriscore_data'] as Map?)?.cast<String, dynamic>();
  final isBeverage = nsData?['is_beverage'] == 1 || nsData?['is_beverage'] == true;
  final unit = (p['product_quantity_unit'] as String?) ?? '';

  return OffProduct(
    barcode: barcode,
    name: ((p['product_name'] as String?)?.trim().isNotEmpty ?? false)
        ? (p['product_name'] as String).trim()
        : 'Product $barcode',
    brand: (p['brands'] as String?)?.split(',').first.trim(),
    categories: p['categories'] as String?,
    ingredientsText: p['ingredients_text'] as String?,
    novaGroup: (toNum(p['nova_group']))?.toInt(),
    isBeverage: isBeverage,
    nonNutritiveSweeteners: nsData == null ? null : (toNum(nsData['non_nutritive_sweeteners']) ?? 0) > 0,
    valuesPer100: values,
    package: parsePackage(
      quantity: p['quantity'] as String?,
      productQuantity: toNum(p['product_quantity']),
      productQuantityUnit: unit,
      servingQuantity: toNum(p['serving_quantity']),
      liquidHint: isBeverage,
    ),
  );
}

class OpenFoodFactsClient {
  OpenFoodFactsClient({http.Client? client}) : _http = client ?? http.Client();
  final http.Client _http;

  static const _fields = 'product_name,brands,quantity,product_quantity,product_quantity_unit,serving_quantity,'
      'nutriments,nova_group,categories,ingredients_text,nutriscore_data';

  /// Returns null for unknown barcodes. Throws on network errors.
  Future<OffProduct?> lookup(String barcode) async {
    final r = await _http.get(
      Uri.parse('https://world.openfoodfacts.org/api/v2/product/$barcode.json?fields=$_fields'),
      headers: {'User-Agent': 'NutrientTracker/1.0 (personal Android app)'},
    );
    if (r.statusCode == 404) return null;
    if (r.statusCode != 200) throw Exception('Open Food Facts: HTTP ${r.statusCode}');
    return parseOffProduct(barcode, jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>);
  }
}

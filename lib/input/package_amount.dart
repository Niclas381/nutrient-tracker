/// Package size parsing for barcode products. Pure Dart.
library;

class PackageAmount {
  const PackageAmount({
    required this.unit,
    this.packageAmount,
    this.multipackCount,
    this.unitAmount,
    this.servingAmount,
  });

  /// g or ml
  final String unit;

  /// Whole package (all units of a multipack).
  final double? packageAmount;

  /// "6 x 250 ml" -> 6
  final int? multipackCount;

  /// "6 x 250 ml" -> 250
  final double? unitAmount;
  final double? servingAmount;

  bool get isMultipack => multipackCount != null && multipackCount! > 1;

  /// Default amount to log: one unit of a multipack, else the whole package, else one serving.
  /// Null means the user has to enter the amount.
  double? get defaultAmount => isMultipack ? unitAmount : (packageAmount ?? servingAmount);
}

final _multipack = RegExp(r'(\d+)\s*[x×\*]\s*(\d+(?:[.,]\d+)?)\s*(kg|g|ml|cl|dl|l)\b', caseSensitive: false);
final _single = RegExp(r'(\d+(?:[.,]\d+)?)\s*(kg|g|ml|cl|dl|l)\b', caseSensitive: false);

(double, String) _normalize(double v, String unit) => switch (unit.toLowerCase()) {
      'kg' => (v * 1000, 'g'),
      'l' => (v * 1000, 'ml'),
      'dl' => (v * 100, 'ml'),
      'cl' => (v * 10, 'ml'),
      'ml' => (v, 'ml'),
      _ => (v, 'g'),
    };

double _num(String s) => double.parse(s.replaceAll(',', '.'));

/// [quantity] is Open Food Facts' free-text `quantity` (e.g. "6 x 250 ml", "1 l"); [productQuantity] and
/// [productQuantityUnit] are its normalized total; [servingQuantity] is one serving in the same unit.
PackageAmount parsePackage({
  String? quantity,
  double? productQuantity,
  String? productQuantityUnit,
  double? servingQuantity,
  bool liquidHint = false,
}) {
  final q = quantity ?? '';
  final mp = _multipack.firstMatch(q);
  if (mp != null) {
    final count = int.parse(mp.group(1)!);
    final (each, unit) = _normalize(_num(mp.group(2)!), mp.group(3)!);
    return PackageAmount(
      unit: unit,
      packageAmount: productQuantity ?? count * each,
      multipackCount: count,
      unitAmount: each,
      servingAmount: servingQuantity,
    );
  }
  var unit = (productQuantityUnit ?? '').toLowerCase();
  double? total = productQuantity;
  if (unit.isNotEmpty && total != null) {
    final n = _normalize(total, unit);
    total = n.$1;
    unit = n.$2;
  } else {
    final m = _single.firstMatch(q);
    if (m != null) {
      final n = _normalize(_num(m.group(1)!), m.group(2)!);
      total = n.$1;
      unit = n.$2;
    }
  }
  if (unit.isEmpty) unit = liquidHint ? 'ml' : 'g';
  return PackageAmount(
    unit: unit,
    packageAmount: (total != null && total > 0) ? total : null,
    servingAmount: (servingQuantity != null && servingQuantity > 0) ? servingQuantity : null,
  );
}

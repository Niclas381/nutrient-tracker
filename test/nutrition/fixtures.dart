import 'package:nutrient_tracker/nutrition/models.dart';

/// A small subset of the real catalogue and reference values (see tool/reference_values.py).
const energy = NutrientDef(
    id: 1, code: 'ENERC_KCAL', name: 'Energy', unit: 'kcal', importanceRank: 1000, targetType: TargetType.energy, hasBar: true);
const protein = NutrientDef(
    id: 2, code: 'PROT', name: 'Protein', unit: 'g', importanceRank: 1001, targetType: TargetType.minimum, hasBar: true);
const fat = NutrientDef(
    id: 3, code: 'FAT', name: 'Fat', unit: 'g', importanceRank: 1002, targetType: TargetType.pctRange, hasBar: true);
const freeSugars = NutrientDef(
    id: 7, code: 'FSUGAR', name: 'Free sugars', unit: 'g', importanceRank: 2002, targetType: TargetType.limit, hasBar: true);
const salt = NutrientDef(
    id: 10, code: 'NACL', name: 'Salt', unit: 'g', importanceRank: 2005, targetType: TargetType.limit, hasBar: true);
const vitD = NutrientDef(
    id: 11, code: 'VITD', name: 'Vitamin D', unit: 'µg', importanceRank: 3000, targetType: TargetType.range, hasBar: true);
const iron = NutrientDef(
    id: 15, code: 'FE', name: 'Iron', unit: 'mg', importanceRank: 3004, targetType: TargetType.minimum, hasBar: true);
const magnesium = NutrientDef(
    id: 18, code: 'MG', name: 'Magnesium', unit: 'mg', importanceRank: 3007, targetType: TargetType.range, hasBar: true);
const zinc = NutrientDef(
    id: 19, code: 'ZN', name: 'Zinc', unit: 'mg', importanceRank: 3008, targetType: TargetType.range, hasBar: true);
const vitA = NutrientDef(
    id: 22, code: 'VITA', name: 'Vitamin A', unit: 'µg', importanceRank: 4000, targetType: TargetType.range, hasBar: true);
const thiamin = NutrientDef(
    id: 25, code: 'THIA', name: 'Vitamin B1', unit: 'mg', importanceRank: 4003, targetType: TargetType.minimum, hasBar: true);
const riboflavin = NutrientDef(
    id: 26, code: 'RIBF', name: 'Vitamin B2', unit: 'mg', importanceRank: 4004, targetType: TargetType.minimum, hasBar: true);
const vitC = NutrientDef(
    id: 31, code: 'VITC', name: 'Vitamin C', unit: 'mg', importanceRank: 4009, targetType: TargetType.minimum, hasBar: true);
const retinol = NutrientDef(
    id: 41, code: 'RETOL', name: 'Retinol', unit: 'µg', importanceRank: 4019, targetType: TargetType.none, hasBar: false);
const sugar = NutrientDef(
    id: 6, code: 'SUGAR', name: 'Sugar (total)', unit: 'g', importanceRank: 2001, targetType: TargetType.none, hasBar: false);

const nutrients = [energy, protein, fat, sugar, freeSugars, salt, vitD, iron, magnesium, zinc, vitA, thiamin, riboflavin, vitC, retinol];

const adult = (19, 130);

ReferenceRow row(NutrientDef n, String sex, (int, int) ages, ValueType t, double amount,
        {Basis basis = Basis.abs, String cond = '', String ul = ''}) =>
    ReferenceRow(
        nutrientId: n.id,
        sex: sex,
        ageMin: ages.$1,
        ageMax: ages.$2,
        type: t,
        amount: amount,
        basis: basis,
        condition: cond,
        ulBasis: ul);

final references = <ReferenceRow>[
  row(energy, 'm', (25, 50), ValueType.energy, 2300, cond: 'pal=1.4'),
  row(energy, 'm', (25, 50), ValueType.energy, 2700, cond: 'pal=1.6'),
  row(energy, 'm', (25, 50), ValueType.energy, 3000, cond: 'pal=1.8'),
  row(energy, 'f', (25, 50), ValueType.energy, 1800, cond: 'pal=1.4'),
  row(energy, 'f', (25, 50), ValueType.energy, 2100, cond: 'pal=1.6'),
  row(protein, 'm', (19, 64), ValueType.ri, 0.8, basis: Basis.perKgBw),
  row(protein, 'm', adult, ValueType.ar, 0.66, basis: Basis.perKgBw),
  row(fat, 'any', adult, ValueType.rangeLow, 20, basis: Basis.pctEnergy),
  row(fat, 'any', adult, ValueType.rangeHigh, 35, basis: Basis.pctEnergy),
  row(freeSugars, 'any', adult, ValueType.limit, 10, basis: Basis.pctEnergy),
  row(salt, 'any', adult, ValueType.limit, 5),
  row(vitD, 'm', adult, ValueType.ev, 20),
  row(vitD, 'f', adult, ValueType.ev, 20),
  row(vitD, 'any', adult, ValueType.ul, 100, ul: 'total'),
  row(iron, 'm', adult, ValueType.ri, 11),
  row(iron, 'f', (25, 50), ValueType.ri, 16, cond: 'iron_status=menstruating'),
  row(iron, 'f', (25, 50), ValueType.ri, 11, cond: 'iron_status=not_menstruating'),
  row(iron, 'f', (25, 50), ValueType.ri, 14, cond: 'iron_status=postmenopausal'),
  row(iron, 'm', adult, ValueType.ar, 6),
  row(iron, 'f', adult, ValueType.ar, 7, cond: 'iron_status=menstruating'),
  row(iron, 'f', adult, ValueType.ar, 6, cond: 'iron_status=postmenopausal'),
  row(magnesium, 'm', adult, ValueType.ev, 350),
  row(magnesium, 'any', adult, ValueType.ul, 250, ul: 'supplement'),
  row(zinc, 'm', adult, ValueType.ri, 11, cond: 'phytate=low'),
  row(zinc, 'm', adult, ValueType.ri, 14, cond: 'phytate=medium'),
  row(zinc, 'm', adult, ValueType.ri, 16, cond: 'phytate=high'),
  row(zinc, 'm', adult, ValueType.ar, 9.3, cond: 'phytate=medium'),
  row(zinc, 'any', adult, ValueType.ul, 25, ul: 'total'),
  row(vitA, 'm', adult, ValueType.ri, 850),
  row(vitA, 'm', adult, ValueType.ar, 570),
  row(vitA, 'any', adult, ValueType.ul, 3000, ul: 'nutrient:RETOL'),
  row(thiamin, 'm', (25, 50), ValueType.ri, 1.2),
  row(thiamin, 'any', adult, ValueType.ar, 0.072, basis: Basis.perMj),
  row(riboflavin, 'f', (25, 50), ValueType.ri, 1.1),
  row(riboflavin, 'any', adult, ValueType.ar, 1.3),
  row(riboflavin, 'any', adult, ValueType.pri, 1.6),
  row(vitC, 'm', adult, ValueType.ri, 110),
  row(vitC, 'm', adult, ValueType.ar, 90),
];

const man30 = Profile(sex: Sex.male, age: 30, heightCm: 180, weightKg: 75, pal: Pal.pal14);
const woman30 = Profile(sex: Sex.female, age: 30, heightCm: 165, weightKg: 60, pal: Pal.pal14);

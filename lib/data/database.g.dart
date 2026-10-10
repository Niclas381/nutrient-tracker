// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NutrientsTable extends Nutrients
    with TableInfo<$NutrientsTable, NutrientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutrientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importanceRankMeta = const VerificationMeta(
    'importanceRank',
  );
  @override
  late final GeneratedColumn<int> importanceRank = GeneratedColumn<int>(
    'importance_rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetTypeMeta = const VerificationMeta(
    'targetType',
  );
  @override
  late final GeneratedColumn<String> targetType = GeneratedColumn<String>(
    'target_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasBarMeta = const VerificationMeta('hasBar');
  @override
  late final GeneratedColumn<bool> hasBar = GeneratedColumn<bool>(
    'has_bar',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_bar" IN (0, 1))',
    ),
  );
  static const VerificationMeta _claudeFillsMeta = const VerificationMeta(
    'claudeFills',
  );
  @override
  late final GeneratedColumn<bool> claudeFills = GeneratedColumn<bool>(
    'claude_fills',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("claude_fills" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    unit,
    importanceRank,
    targetType,
    hasBar,
    claudeFills,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrients';
  @override
  VerificationContext validateIntegrity(
    Insertable<NutrientRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('importance_rank')) {
      context.handle(
        _importanceRankMeta,
        importanceRank.isAcceptableOrUnknown(
          data['importance_rank']!,
          _importanceRankMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_importanceRankMeta);
    }
    if (data.containsKey('target_type')) {
      context.handle(
        _targetTypeMeta,
        targetType.isAcceptableOrUnknown(data['target_type']!, _targetTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_targetTypeMeta);
    }
    if (data.containsKey('has_bar')) {
      context.handle(
        _hasBarMeta,
        hasBar.isAcceptableOrUnknown(data['has_bar']!, _hasBarMeta),
      );
    } else if (isInserting) {
      context.missing(_hasBarMeta);
    }
    if (data.containsKey('claude_fills')) {
      context.handle(
        _claudeFillsMeta,
        claudeFills.isAcceptableOrUnknown(
          data['claude_fills']!,
          _claudeFillsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NutrientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutrientRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      importanceRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}importance_rank'],
      )!,
      targetType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_type'],
      )!,
      hasBar: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_bar'],
      )!,
      claudeFills: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}claude_fills'],
      )!,
    );
  }

  @override
  $NutrientsTable createAlias(String alias) {
    return $NutrientsTable(attachedDatabase, alias);
  }
}

class NutrientRow extends DataClass implements Insertable<NutrientRow> {
  final int id;
  final String code;
  final String name;
  final String unit;
  final int importanceRank;
  final String targetType;
  final bool hasBar;

  /// Missing values are estimated by Claude on first use.
  final bool claudeFills;
  const NutrientRow({
    required this.id,
    required this.code,
    required this.name,
    required this.unit,
    required this.importanceRank,
    required this.targetType,
    required this.hasBar,
    required this.claudeFills,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    map['importance_rank'] = Variable<int>(importanceRank);
    map['target_type'] = Variable<String>(targetType);
    map['has_bar'] = Variable<bool>(hasBar);
    map['claude_fills'] = Variable<bool>(claudeFills);
    return map;
  }

  NutrientsCompanion toCompanion(bool nullToAbsent) {
    return NutrientsCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      unit: Value(unit),
      importanceRank: Value(importanceRank),
      targetType: Value(targetType),
      hasBar: Value(hasBar),
      claudeFills: Value(claudeFills),
    );
  }

  factory NutrientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutrientRow(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      importanceRank: serializer.fromJson<int>(json['importanceRank']),
      targetType: serializer.fromJson<String>(json['targetType']),
      hasBar: serializer.fromJson<bool>(json['hasBar']),
      claudeFills: serializer.fromJson<bool>(json['claudeFills']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'importanceRank': serializer.toJson<int>(importanceRank),
      'targetType': serializer.toJson<String>(targetType),
      'hasBar': serializer.toJson<bool>(hasBar),
      'claudeFills': serializer.toJson<bool>(claudeFills),
    };
  }

  NutrientRow copyWith({
    int? id,
    String? code,
    String? name,
    String? unit,
    int? importanceRank,
    String? targetType,
    bool? hasBar,
    bool? claudeFills,
  }) => NutrientRow(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    importanceRank: importanceRank ?? this.importanceRank,
    targetType: targetType ?? this.targetType,
    hasBar: hasBar ?? this.hasBar,
    claudeFills: claudeFills ?? this.claudeFills,
  );
  NutrientRow copyWithCompanion(NutrientsCompanion data) {
    return NutrientRow(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      importanceRank: data.importanceRank.present
          ? data.importanceRank.value
          : this.importanceRank,
      targetType: data.targetType.present
          ? data.targetType.value
          : this.targetType,
      hasBar: data.hasBar.present ? data.hasBar.value : this.hasBar,
      claudeFills: data.claudeFills.present
          ? data.claudeFills.value
          : this.claudeFills,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutrientRow(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('importanceRank: $importanceRank, ')
          ..write('targetType: $targetType, ')
          ..write('hasBar: $hasBar, ')
          ..write('claudeFills: $claudeFills')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    name,
    unit,
    importanceRank,
    targetType,
    hasBar,
    claudeFills,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutrientRow &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.importanceRank == this.importanceRank &&
          other.targetType == this.targetType &&
          other.hasBar == this.hasBar &&
          other.claudeFills == this.claudeFills);
}

class NutrientsCompanion extends UpdateCompanion<NutrientRow> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String> unit;
  final Value<int> importanceRank;
  final Value<String> targetType;
  final Value<bool> hasBar;
  final Value<bool> claudeFills;
  const NutrientsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.importanceRank = const Value.absent(),
    this.targetType = const Value.absent(),
    this.hasBar = const Value.absent(),
    this.claudeFills = const Value.absent(),
  });
  NutrientsCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    required String unit,
    required int importanceRank,
    required String targetType,
    required bool hasBar,
    this.claudeFills = const Value.absent(),
  }) : code = Value(code),
       name = Value(name),
       unit = Value(unit),
       importanceRank = Value(importanceRank),
       targetType = Value(targetType),
       hasBar = Value(hasBar);
  static Insertable<NutrientRow> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<int>? importanceRank,
    Expression<String>? targetType,
    Expression<bool>? hasBar,
    Expression<bool>? claudeFills,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (importanceRank != null) 'importance_rank': importanceRank,
      if (targetType != null) 'target_type': targetType,
      if (hasBar != null) 'has_bar': hasBar,
      if (claudeFills != null) 'claude_fills': claudeFills,
    });
  }

  NutrientsCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String>? unit,
    Value<int>? importanceRank,
    Value<String>? targetType,
    Value<bool>? hasBar,
    Value<bool>? claudeFills,
  }) {
    return NutrientsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      importanceRank: importanceRank ?? this.importanceRank,
      targetType: targetType ?? this.targetType,
      hasBar: hasBar ?? this.hasBar,
      claudeFills: claudeFills ?? this.claudeFills,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (importanceRank.present) {
      map['importance_rank'] = Variable<int>(importanceRank.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(targetType.value);
    }
    if (hasBar.present) {
      map['has_bar'] = Variable<bool>(hasBar.value);
    }
    if (claudeFills.present) {
      map['claude_fills'] = Variable<bool>(claudeFills.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutrientsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('importanceRank: $importanceRank, ')
          ..write('targetType: $targetType, ')
          ..write('hasBar: $hasBar, ')
          ..write('claudeFills: $claudeFills')
          ..write(')'))
        .toString();
  }
}

class $FoodsTable extends Foods with TableInfo<$FoodsTable, FoodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameDeMeta = const VerificationMeta('nameDe');
  @override
  late final GeneratedColumn<String> nameDe = GeneratedColumn<String>(
    'name_de',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceRefMeta = const VerificationMeta(
    'sourceRef',
  );
  @override
  late final GeneratedColumn<String> sourceRef = GeneratedColumn<String>(
    'source_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _foodGroupMeta = const VerificationMeta(
    'foodGroup',
  );
  @override
  late final GeneratedColumn<String> foodGroup = GeneratedColumn<String>(
    'food_group',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultServingGMeta = const VerificationMeta(
    'defaultServingG',
  );
  @override
  late final GeneratedColumn<double> defaultServingG = GeneratedColumn<double>(
    'default_serving_g',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servingLabelMeta = const VerificationMeta(
    'servingLabel',
  );
  @override
  late final GeneratedColumn<String> servingLabel = GeneratedColumn<String>(
    'serving_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _packageQuantityMeta = const VerificationMeta(
    'packageQuantity',
  );
  @override
  late final GeneratedColumn<double> packageQuantity = GeneratedColumn<double>(
    'package_quantity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _packageUnitMeta = const VerificationMeta(
    'packageUnit',
  );
  @override
  late final GeneratedColumn<String> packageUnit = GeneratedColumn<String>(
    'package_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountUnitMeta = const VerificationMeta(
    'amountUnit',
  );
  @override
  late final GeneratedColumn<String> amountUnit = GeneratedColumn<String>(
    'amount_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('g'),
  );
  static const VerificationMeta _isCommonMeta = const VerificationMeta(
    'isCommon',
  );
  @override
  late final GeneratedColumn<bool> isCommon = GeneratedColumn<bool>(
    'is_common',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_common" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nutriscoreCategoryMeta =
      const VerificationMeta('nutriscoreCategory');
  @override
  late final GeneratedColumn<String> nutriscoreCategory =
      GeneratedColumn<String>(
        'nutriscore_category',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _fvlPercentMeta = const VerificationMeta(
    'fvlPercent',
  );
  @override
  late final GeneratedColumn<double> fvlPercent = GeneratedColumn<double>(
    'fvl_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nonNutritiveSweetenersMeta =
      const VerificationMeta('nonNutritiveSweeteners');
  @override
  late final GeneratedColumn<bool> nonNutritiveSweeteners =
      GeneratedColumn<bool>(
        'non_nutritive_sweeteners',
        aliasedName,
        true,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("non_nutritive_sweeteners" IN (0, 1))',
        ),
      );
  static const VerificationMeta _enrichmentMeta = const VerificationMeta(
    'enrichment',
  );
  @override
  late final GeneratedColumn<String> enrichment = GeneratedColumn<String>(
    'enrichment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    nameDe,
    source,
    sourceRef,
    barcode,
    foodGroup,
    defaultServingG,
    servingLabel,
    packageQuantity,
    packageUnit,
    amountUnit,
    isCommon,
    nutriscoreCategory,
    fvlPercent,
    nonNutritiveSweeteners,
    enrichment,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('name_de')) {
      context.handle(
        _nameDeMeta,
        nameDe.isAcceptableOrUnknown(data['name_de']!, _nameDeMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('source_ref')) {
      context.handle(
        _sourceRefMeta,
        sourceRef.isAcceptableOrUnknown(data['source_ref']!, _sourceRefMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('food_group')) {
      context.handle(
        _foodGroupMeta,
        foodGroup.isAcceptableOrUnknown(data['food_group']!, _foodGroupMeta),
      );
    }
    if (data.containsKey('default_serving_g')) {
      context.handle(
        _defaultServingGMeta,
        defaultServingG.isAcceptableOrUnknown(
          data['default_serving_g']!,
          _defaultServingGMeta,
        ),
      );
    }
    if (data.containsKey('serving_label')) {
      context.handle(
        _servingLabelMeta,
        servingLabel.isAcceptableOrUnknown(
          data['serving_label']!,
          _servingLabelMeta,
        ),
      );
    }
    if (data.containsKey('package_quantity')) {
      context.handle(
        _packageQuantityMeta,
        packageQuantity.isAcceptableOrUnknown(
          data['package_quantity']!,
          _packageQuantityMeta,
        ),
      );
    }
    if (data.containsKey('package_unit')) {
      context.handle(
        _packageUnitMeta,
        packageUnit.isAcceptableOrUnknown(
          data['package_unit']!,
          _packageUnitMeta,
        ),
      );
    }
    if (data.containsKey('amount_unit')) {
      context.handle(
        _amountUnitMeta,
        amountUnit.isAcceptableOrUnknown(data['amount_unit']!, _amountUnitMeta),
      );
    }
    if (data.containsKey('is_common')) {
      context.handle(
        _isCommonMeta,
        isCommon.isAcceptableOrUnknown(data['is_common']!, _isCommonMeta),
      );
    }
    if (data.containsKey('nutriscore_category')) {
      context.handle(
        _nutriscoreCategoryMeta,
        nutriscoreCategory.isAcceptableOrUnknown(
          data['nutriscore_category']!,
          _nutriscoreCategoryMeta,
        ),
      );
    }
    if (data.containsKey('fvl_percent')) {
      context.handle(
        _fvlPercentMeta,
        fvlPercent.isAcceptableOrUnknown(data['fvl_percent']!, _fvlPercentMeta),
      );
    }
    if (data.containsKey('non_nutritive_sweeteners')) {
      context.handle(
        _nonNutritiveSweetenersMeta,
        nonNutritiveSweeteners.isAcceptableOrUnknown(
          data['non_nutritive_sweeteners']!,
          _nonNutritiveSweetenersMeta,
        ),
      );
    }
    if (data.containsKey('enrichment')) {
      context.handle(
        _enrichmentMeta,
        enrichment.isAcceptableOrUnknown(data['enrichment']!, _enrichmentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      nameDe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_de'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      sourceRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_ref'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      foodGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_group'],
      ),
      defaultServingG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_serving_g'],
      ),
      servingLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serving_label'],
      ),
      packageQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}package_quantity'],
      ),
      packageUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_unit'],
      ),
      amountUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}amount_unit'],
      )!,
      isCommon: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_common'],
      )!,
      nutriscoreCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nutriscore_category'],
      ),
      fvlPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fvl_percent'],
      ),
      nonNutritiveSweeteners: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}non_nutritive_sweeteners'],
      ),
      enrichment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enrichment'],
      )!,
    );
  }

  @override
  $FoodsTable createAlias(String alias) {
    return $FoodsTable(attachedDatabase, alias);
  }
}

class FoodRow extends DataClass implements Insertable<FoodRow> {
  final int id;
  final String name;
  final String? nameDe;

  /// bls | usda | off | claude_estimate | supplement
  final String source;
  final String? sourceRef;
  final String? barcode;
  final String? foodGroup;
  final double? defaultServingG;
  final String? servingLabel;
  final double? packageQuantity;
  final String? packageUnit;

  /// Unit amounts are logged in: g | ml | piece. Nutrient values are per 100 of this unit.
  final String amountUnit;
  final bool isCommon;

  /// Nutri-Score inputs: category (null = unknown) and % fruit/vegetables/legumes.
  final String? nutriscoreCategory;
  final double? fvlPercent;
  final bool? nonNutritiveSweeteners;

  /// none | pending | done | failed — the one-time enrich_food request on first use.
  final String enrichment;
  const FoodRow({
    required this.id,
    required this.name,
    this.nameDe,
    required this.source,
    this.sourceRef,
    this.barcode,
    this.foodGroup,
    this.defaultServingG,
    this.servingLabel,
    this.packageQuantity,
    this.packageUnit,
    required this.amountUnit,
    required this.isCommon,
    this.nutriscoreCategory,
    this.fvlPercent,
    this.nonNutritiveSweeteners,
    required this.enrichment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nameDe != null) {
      map['name_de'] = Variable<String>(nameDe);
    }
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || sourceRef != null) {
      map['source_ref'] = Variable<String>(sourceRef);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || foodGroup != null) {
      map['food_group'] = Variable<String>(foodGroup);
    }
    if (!nullToAbsent || defaultServingG != null) {
      map['default_serving_g'] = Variable<double>(defaultServingG);
    }
    if (!nullToAbsent || servingLabel != null) {
      map['serving_label'] = Variable<String>(servingLabel);
    }
    if (!nullToAbsent || packageQuantity != null) {
      map['package_quantity'] = Variable<double>(packageQuantity);
    }
    if (!nullToAbsent || packageUnit != null) {
      map['package_unit'] = Variable<String>(packageUnit);
    }
    map['amount_unit'] = Variable<String>(amountUnit);
    map['is_common'] = Variable<bool>(isCommon);
    if (!nullToAbsent || nutriscoreCategory != null) {
      map['nutriscore_category'] = Variable<String>(nutriscoreCategory);
    }
    if (!nullToAbsent || fvlPercent != null) {
      map['fvl_percent'] = Variable<double>(fvlPercent);
    }
    if (!nullToAbsent || nonNutritiveSweeteners != null) {
      map['non_nutritive_sweeteners'] = Variable<bool>(nonNutritiveSweeteners);
    }
    map['enrichment'] = Variable<String>(enrichment);
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      id: Value(id),
      name: Value(name),
      nameDe: nameDe == null && nullToAbsent
          ? const Value.absent()
          : Value(nameDe),
      source: Value(source),
      sourceRef: sourceRef == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceRef),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      foodGroup: foodGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(foodGroup),
      defaultServingG: defaultServingG == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultServingG),
      servingLabel: servingLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(servingLabel),
      packageQuantity: packageQuantity == null && nullToAbsent
          ? const Value.absent()
          : Value(packageQuantity),
      packageUnit: packageUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(packageUnit),
      amountUnit: Value(amountUnit),
      isCommon: Value(isCommon),
      nutriscoreCategory: nutriscoreCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(nutriscoreCategory),
      fvlPercent: fvlPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(fvlPercent),
      nonNutritiveSweeteners: nonNutritiveSweeteners == null && nullToAbsent
          ? const Value.absent()
          : Value(nonNutritiveSweeteners),
      enrichment: Value(enrichment),
    );
  }

  factory FoodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nameDe: serializer.fromJson<String?>(json['nameDe']),
      source: serializer.fromJson<String>(json['source']),
      sourceRef: serializer.fromJson<String?>(json['sourceRef']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      foodGroup: serializer.fromJson<String?>(json['foodGroup']),
      defaultServingG: serializer.fromJson<double?>(json['defaultServingG']),
      servingLabel: serializer.fromJson<String?>(json['servingLabel']),
      packageQuantity: serializer.fromJson<double?>(json['packageQuantity']),
      packageUnit: serializer.fromJson<String?>(json['packageUnit']),
      amountUnit: serializer.fromJson<String>(json['amountUnit']),
      isCommon: serializer.fromJson<bool>(json['isCommon']),
      nutriscoreCategory: serializer.fromJson<String?>(
        json['nutriscoreCategory'],
      ),
      fvlPercent: serializer.fromJson<double?>(json['fvlPercent']),
      nonNutritiveSweeteners: serializer.fromJson<bool?>(
        json['nonNutritiveSweeteners'],
      ),
      enrichment: serializer.fromJson<String>(json['enrichment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nameDe': serializer.toJson<String?>(nameDe),
      'source': serializer.toJson<String>(source),
      'sourceRef': serializer.toJson<String?>(sourceRef),
      'barcode': serializer.toJson<String?>(barcode),
      'foodGroup': serializer.toJson<String?>(foodGroup),
      'defaultServingG': serializer.toJson<double?>(defaultServingG),
      'servingLabel': serializer.toJson<String?>(servingLabel),
      'packageQuantity': serializer.toJson<double?>(packageQuantity),
      'packageUnit': serializer.toJson<String?>(packageUnit),
      'amountUnit': serializer.toJson<String>(amountUnit),
      'isCommon': serializer.toJson<bool>(isCommon),
      'nutriscoreCategory': serializer.toJson<String?>(nutriscoreCategory),
      'fvlPercent': serializer.toJson<double?>(fvlPercent),
      'nonNutritiveSweeteners': serializer.toJson<bool?>(
        nonNutritiveSweeteners,
      ),
      'enrichment': serializer.toJson<String>(enrichment),
    };
  }

  FoodRow copyWith({
    int? id,
    String? name,
    Value<String?> nameDe = const Value.absent(),
    String? source,
    Value<String?> sourceRef = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    Value<String?> foodGroup = const Value.absent(),
    Value<double?> defaultServingG = const Value.absent(),
    Value<String?> servingLabel = const Value.absent(),
    Value<double?> packageQuantity = const Value.absent(),
    Value<String?> packageUnit = const Value.absent(),
    String? amountUnit,
    bool? isCommon,
    Value<String?> nutriscoreCategory = const Value.absent(),
    Value<double?> fvlPercent = const Value.absent(),
    Value<bool?> nonNutritiveSweeteners = const Value.absent(),
    String? enrichment,
  }) => FoodRow(
    id: id ?? this.id,
    name: name ?? this.name,
    nameDe: nameDe.present ? nameDe.value : this.nameDe,
    source: source ?? this.source,
    sourceRef: sourceRef.present ? sourceRef.value : this.sourceRef,
    barcode: barcode.present ? barcode.value : this.barcode,
    foodGroup: foodGroup.present ? foodGroup.value : this.foodGroup,
    defaultServingG: defaultServingG.present
        ? defaultServingG.value
        : this.defaultServingG,
    servingLabel: servingLabel.present ? servingLabel.value : this.servingLabel,
    packageQuantity: packageQuantity.present
        ? packageQuantity.value
        : this.packageQuantity,
    packageUnit: packageUnit.present ? packageUnit.value : this.packageUnit,
    amountUnit: amountUnit ?? this.amountUnit,
    isCommon: isCommon ?? this.isCommon,
    nutriscoreCategory: nutriscoreCategory.present
        ? nutriscoreCategory.value
        : this.nutriscoreCategory,
    fvlPercent: fvlPercent.present ? fvlPercent.value : this.fvlPercent,
    nonNutritiveSweeteners: nonNutritiveSweeteners.present
        ? nonNutritiveSweeteners.value
        : this.nonNutritiveSweeteners,
    enrichment: enrichment ?? this.enrichment,
  );
  FoodRow copyWithCompanion(FoodsCompanion data) {
    return FoodRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nameDe: data.nameDe.present ? data.nameDe.value : this.nameDe,
      source: data.source.present ? data.source.value : this.source,
      sourceRef: data.sourceRef.present ? data.sourceRef.value : this.sourceRef,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      foodGroup: data.foodGroup.present ? data.foodGroup.value : this.foodGroup,
      defaultServingG: data.defaultServingG.present
          ? data.defaultServingG.value
          : this.defaultServingG,
      servingLabel: data.servingLabel.present
          ? data.servingLabel.value
          : this.servingLabel,
      packageQuantity: data.packageQuantity.present
          ? data.packageQuantity.value
          : this.packageQuantity,
      packageUnit: data.packageUnit.present
          ? data.packageUnit.value
          : this.packageUnit,
      amountUnit: data.amountUnit.present
          ? data.amountUnit.value
          : this.amountUnit,
      isCommon: data.isCommon.present ? data.isCommon.value : this.isCommon,
      nutriscoreCategory: data.nutriscoreCategory.present
          ? data.nutriscoreCategory.value
          : this.nutriscoreCategory,
      fvlPercent: data.fvlPercent.present
          ? data.fvlPercent.value
          : this.fvlPercent,
      nonNutritiveSweeteners: data.nonNutritiveSweeteners.present
          ? data.nonNutritiveSweeteners.value
          : this.nonNutritiveSweeteners,
      enrichment: data.enrichment.present
          ? data.enrichment.value
          : this.enrichment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameDe: $nameDe, ')
          ..write('source: $source, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('barcode: $barcode, ')
          ..write('foodGroup: $foodGroup, ')
          ..write('defaultServingG: $defaultServingG, ')
          ..write('servingLabel: $servingLabel, ')
          ..write('packageQuantity: $packageQuantity, ')
          ..write('packageUnit: $packageUnit, ')
          ..write('amountUnit: $amountUnit, ')
          ..write('isCommon: $isCommon, ')
          ..write('nutriscoreCategory: $nutriscoreCategory, ')
          ..write('fvlPercent: $fvlPercent, ')
          ..write('nonNutritiveSweeteners: $nonNutritiveSweeteners, ')
          ..write('enrichment: $enrichment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    nameDe,
    source,
    sourceRef,
    barcode,
    foodGroup,
    defaultServingG,
    servingLabel,
    packageQuantity,
    packageUnit,
    amountUnit,
    isCommon,
    nutriscoreCategory,
    fvlPercent,
    nonNutritiveSweeteners,
    enrichment,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.nameDe == this.nameDe &&
          other.source == this.source &&
          other.sourceRef == this.sourceRef &&
          other.barcode == this.barcode &&
          other.foodGroup == this.foodGroup &&
          other.defaultServingG == this.defaultServingG &&
          other.servingLabel == this.servingLabel &&
          other.packageQuantity == this.packageQuantity &&
          other.packageUnit == this.packageUnit &&
          other.amountUnit == this.amountUnit &&
          other.isCommon == this.isCommon &&
          other.nutriscoreCategory == this.nutriscoreCategory &&
          other.fvlPercent == this.fvlPercent &&
          other.nonNutritiveSweeteners == this.nonNutritiveSweeteners &&
          other.enrichment == this.enrichment);
}

class FoodsCompanion extends UpdateCompanion<FoodRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> nameDe;
  final Value<String> source;
  final Value<String?> sourceRef;
  final Value<String?> barcode;
  final Value<String?> foodGroup;
  final Value<double?> defaultServingG;
  final Value<String?> servingLabel;
  final Value<double?> packageQuantity;
  final Value<String?> packageUnit;
  final Value<String> amountUnit;
  final Value<bool> isCommon;
  final Value<String?> nutriscoreCategory;
  final Value<double?> fvlPercent;
  final Value<bool?> nonNutritiveSweeteners;
  final Value<String> enrichment;
  const FoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nameDe = const Value.absent(),
    this.source = const Value.absent(),
    this.sourceRef = const Value.absent(),
    this.barcode = const Value.absent(),
    this.foodGroup = const Value.absent(),
    this.defaultServingG = const Value.absent(),
    this.servingLabel = const Value.absent(),
    this.packageQuantity = const Value.absent(),
    this.packageUnit = const Value.absent(),
    this.amountUnit = const Value.absent(),
    this.isCommon = const Value.absent(),
    this.nutriscoreCategory = const Value.absent(),
    this.fvlPercent = const Value.absent(),
    this.nonNutritiveSweeteners = const Value.absent(),
    this.enrichment = const Value.absent(),
  });
  FoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nameDe = const Value.absent(),
    required String source,
    this.sourceRef = const Value.absent(),
    this.barcode = const Value.absent(),
    this.foodGroup = const Value.absent(),
    this.defaultServingG = const Value.absent(),
    this.servingLabel = const Value.absent(),
    this.packageQuantity = const Value.absent(),
    this.packageUnit = const Value.absent(),
    this.amountUnit = const Value.absent(),
    this.isCommon = const Value.absent(),
    this.nutriscoreCategory = const Value.absent(),
    this.fvlPercent = const Value.absent(),
    this.nonNutritiveSweeteners = const Value.absent(),
    this.enrichment = const Value.absent(),
  }) : name = Value(name),
       source = Value(source);
  static Insertable<FoodRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nameDe,
    Expression<String>? source,
    Expression<String>? sourceRef,
    Expression<String>? barcode,
    Expression<String>? foodGroup,
    Expression<double>? defaultServingG,
    Expression<String>? servingLabel,
    Expression<double>? packageQuantity,
    Expression<String>? packageUnit,
    Expression<String>? amountUnit,
    Expression<bool>? isCommon,
    Expression<String>? nutriscoreCategory,
    Expression<double>? fvlPercent,
    Expression<bool>? nonNutritiveSweeteners,
    Expression<String>? enrichment,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nameDe != null) 'name_de': nameDe,
      if (source != null) 'source': source,
      if (sourceRef != null) 'source_ref': sourceRef,
      if (barcode != null) 'barcode': barcode,
      if (foodGroup != null) 'food_group': foodGroup,
      if (defaultServingG != null) 'default_serving_g': defaultServingG,
      if (servingLabel != null) 'serving_label': servingLabel,
      if (packageQuantity != null) 'package_quantity': packageQuantity,
      if (packageUnit != null) 'package_unit': packageUnit,
      if (amountUnit != null) 'amount_unit': amountUnit,
      if (isCommon != null) 'is_common': isCommon,
      if (nutriscoreCategory != null) 'nutriscore_category': nutriscoreCategory,
      if (fvlPercent != null) 'fvl_percent': fvlPercent,
      if (nonNutritiveSweeteners != null)
        'non_nutritive_sweeteners': nonNutritiveSweeteners,
      if (enrichment != null) 'enrichment': enrichment,
    });
  }

  FoodsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? nameDe,
    Value<String>? source,
    Value<String?>? sourceRef,
    Value<String?>? barcode,
    Value<String?>? foodGroup,
    Value<double?>? defaultServingG,
    Value<String?>? servingLabel,
    Value<double?>? packageQuantity,
    Value<String?>? packageUnit,
    Value<String>? amountUnit,
    Value<bool>? isCommon,
    Value<String?>? nutriscoreCategory,
    Value<double?>? fvlPercent,
    Value<bool?>? nonNutritiveSweeteners,
    Value<String>? enrichment,
  }) {
    return FoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nameDe: nameDe ?? this.nameDe,
      source: source ?? this.source,
      sourceRef: sourceRef ?? this.sourceRef,
      barcode: barcode ?? this.barcode,
      foodGroup: foodGroup ?? this.foodGroup,
      defaultServingG: defaultServingG ?? this.defaultServingG,
      servingLabel: servingLabel ?? this.servingLabel,
      packageQuantity: packageQuantity ?? this.packageQuantity,
      packageUnit: packageUnit ?? this.packageUnit,
      amountUnit: amountUnit ?? this.amountUnit,
      isCommon: isCommon ?? this.isCommon,
      nutriscoreCategory: nutriscoreCategory ?? this.nutriscoreCategory,
      fvlPercent: fvlPercent ?? this.fvlPercent,
      nonNutritiveSweeteners:
          nonNutritiveSweeteners ?? this.nonNutritiveSweeteners,
      enrichment: enrichment ?? this.enrichment,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nameDe.present) {
      map['name_de'] = Variable<String>(nameDe.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (sourceRef.present) {
      map['source_ref'] = Variable<String>(sourceRef.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (foodGroup.present) {
      map['food_group'] = Variable<String>(foodGroup.value);
    }
    if (defaultServingG.present) {
      map['default_serving_g'] = Variable<double>(defaultServingG.value);
    }
    if (servingLabel.present) {
      map['serving_label'] = Variable<String>(servingLabel.value);
    }
    if (packageQuantity.present) {
      map['package_quantity'] = Variable<double>(packageQuantity.value);
    }
    if (packageUnit.present) {
      map['package_unit'] = Variable<String>(packageUnit.value);
    }
    if (amountUnit.present) {
      map['amount_unit'] = Variable<String>(amountUnit.value);
    }
    if (isCommon.present) {
      map['is_common'] = Variable<bool>(isCommon.value);
    }
    if (nutriscoreCategory.present) {
      map['nutriscore_category'] = Variable<String>(nutriscoreCategory.value);
    }
    if (fvlPercent.present) {
      map['fvl_percent'] = Variable<double>(fvlPercent.value);
    }
    if (nonNutritiveSweeteners.present) {
      map['non_nutritive_sweeteners'] = Variable<bool>(
        nonNutritiveSweeteners.value,
      );
    }
    if (enrichment.present) {
      map['enrichment'] = Variable<String>(enrichment.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nameDe: $nameDe, ')
          ..write('source: $source, ')
          ..write('sourceRef: $sourceRef, ')
          ..write('barcode: $barcode, ')
          ..write('foodGroup: $foodGroup, ')
          ..write('defaultServingG: $defaultServingG, ')
          ..write('servingLabel: $servingLabel, ')
          ..write('packageQuantity: $packageQuantity, ')
          ..write('packageUnit: $packageUnit, ')
          ..write('amountUnit: $amountUnit, ')
          ..write('isCommon: $isCommon, ')
          ..write('nutriscoreCategory: $nutriscoreCategory, ')
          ..write('fvlPercent: $fvlPercent, ')
          ..write('nonNutritiveSweeteners: $nonNutritiveSweeteners, ')
          ..write('enrichment: $enrichment')
          ..write(')'))
        .toString();
  }
}

class $FoodNutrientsTable extends FoodNutrients
    with TableInfo<$FoodNutrientsTable, FoodNutrientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodNutrientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nutrientIdMeta = const VerificationMeta(
    'nutrientId',
  );
  @override
  late final GeneratedColumn<int> nutrientId = GeneratedColumn<int>(
    'nutrient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPer100Meta = const VerificationMeta(
    'amountPer100',
  );
  @override
  late final GeneratedColumn<double> amountPer100 = GeneratedColumn<double>(
    'amount_per100',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    foodId,
    nutrientId,
    amountPer100,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_nutrients';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodNutrientRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('nutrient_id')) {
      context.handle(
        _nutrientIdMeta,
        nutrientId.isAcceptableOrUnknown(data['nutrient_id']!, _nutrientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nutrientIdMeta);
    }
    if (data.containsKey('amount_per100')) {
      context.handle(
        _amountPer100Meta,
        amountPer100.isAcceptableOrUnknown(
          data['amount_per100']!,
          _amountPer100Meta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountPer100Meta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {foodId, nutrientId};
  @override
  FoodNutrientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodNutrientRow(
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      )!,
      nutrientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nutrient_id'],
      )!,
      amountPer100: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_per100'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
    );
  }

  @override
  $FoodNutrientsTable createAlias(String alias) {
    return $FoodNutrientsTable(attachedDatabase, alias);
  }
}

class FoodNutrientRow extends DataClass implements Insertable<FoodNutrientRow> {
  final int foodId;
  final int nutrientId;
  final double amountPer100;

  /// Provenance of this value: null = same as the food's source; otherwise off | bls | usda | claude_estimate.
  /// Priority when values conflict: product label (off) > generic database > Claude estimate.
  final String? source;
  const FoodNutrientRow({
    required this.foodId,
    required this.nutrientId,
    required this.amountPer100,
    this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['food_id'] = Variable<int>(foodId);
    map['nutrient_id'] = Variable<int>(nutrientId);
    map['amount_per100'] = Variable<double>(amountPer100);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    return map;
  }

  FoodNutrientsCompanion toCompanion(bool nullToAbsent) {
    return FoodNutrientsCompanion(
      foodId: Value(foodId),
      nutrientId: Value(nutrientId),
      amountPer100: Value(amountPer100),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
    );
  }

  factory FoodNutrientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodNutrientRow(
      foodId: serializer.fromJson<int>(json['foodId']),
      nutrientId: serializer.fromJson<int>(json['nutrientId']),
      amountPer100: serializer.fromJson<double>(json['amountPer100']),
      source: serializer.fromJson<String?>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'foodId': serializer.toJson<int>(foodId),
      'nutrientId': serializer.toJson<int>(nutrientId),
      'amountPer100': serializer.toJson<double>(amountPer100),
      'source': serializer.toJson<String?>(source),
    };
  }

  FoodNutrientRow copyWith({
    int? foodId,
    int? nutrientId,
    double? amountPer100,
    Value<String?> source = const Value.absent(),
  }) => FoodNutrientRow(
    foodId: foodId ?? this.foodId,
    nutrientId: nutrientId ?? this.nutrientId,
    amountPer100: amountPer100 ?? this.amountPer100,
    source: source.present ? source.value : this.source,
  );
  FoodNutrientRow copyWithCompanion(FoodNutrientsCompanion data) {
    return FoodNutrientRow(
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      nutrientId: data.nutrientId.present
          ? data.nutrientId.value
          : this.nutrientId,
      amountPer100: data.amountPer100.present
          ? data.amountPer100.value
          : this.amountPer100,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodNutrientRow(')
          ..write('foodId: $foodId, ')
          ..write('nutrientId: $nutrientId, ')
          ..write('amountPer100: $amountPer100, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(foodId, nutrientId, amountPer100, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodNutrientRow &&
          other.foodId == this.foodId &&
          other.nutrientId == this.nutrientId &&
          other.amountPer100 == this.amountPer100 &&
          other.source == this.source);
}

class FoodNutrientsCompanion extends UpdateCompanion<FoodNutrientRow> {
  final Value<int> foodId;
  final Value<int> nutrientId;
  final Value<double> amountPer100;
  final Value<String?> source;
  final Value<int> rowid;
  const FoodNutrientsCompanion({
    this.foodId = const Value.absent(),
    this.nutrientId = const Value.absent(),
    this.amountPer100 = const Value.absent(),
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodNutrientsCompanion.insert({
    required int foodId,
    required int nutrientId,
    required double amountPer100,
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : foodId = Value(foodId),
       nutrientId = Value(nutrientId),
       amountPer100 = Value(amountPer100);
  static Insertable<FoodNutrientRow> custom({
    Expression<int>? foodId,
    Expression<int>? nutrientId,
    Expression<double>? amountPer100,
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (foodId != null) 'food_id': foodId,
      if (nutrientId != null) 'nutrient_id': nutrientId,
      if (amountPer100 != null) 'amount_per100': amountPer100,
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodNutrientsCompanion copyWith({
    Value<int>? foodId,
    Value<int>? nutrientId,
    Value<double>? amountPer100,
    Value<String?>? source,
    Value<int>? rowid,
  }) {
    return FoodNutrientsCompanion(
      foodId: foodId ?? this.foodId,
      nutrientId: nutrientId ?? this.nutrientId,
      amountPer100: amountPer100 ?? this.amountPer100,
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (nutrientId.present) {
      map['nutrient_id'] = Variable<int>(nutrientId.value);
    }
    if (amountPer100.present) {
      map['amount_per100'] = Variable<double>(amountPer100.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodNutrientsCompanion(')
          ..write('foodId: $foodId, ')
          ..write('nutrientId: $nutrientId, ')
          ..write('amountPer100: $amountPer100, ')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LogEntriesTable extends LogEntries
    with TableInfo<$LogEntriesTable, LogEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gramsMeta = const VerificationMeta('grams');
  @override
  late final GeneratedColumn<double> grams = GeneratedColumn<double>(
    'grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inputSourceMeta = const VerificationMeta(
    'inputSource',
  );
  @override
  late final GeneratedColumn<String> inputSource = GeneratedColumn<String>(
    'input_source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawInputMeta = const VerificationMeta(
    'rawInput',
  );
  @override
  late final GeneratedColumn<String> rawInput = GeneratedColumn<String>(
    'raw_input',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<double> confidence = GeneratedColumn<double>(
    'confidence',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requestIdMeta = const VerificationMeta(
    'requestId',
  );
  @override
  late final GeneratedColumn<String> requestId = GeneratedColumn<String>(
    'request_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplementPlanIdMeta = const VerificationMeta(
    'supplementPlanId',
  );
  @override
  late final GeneratedColumn<int> supplementPlanId = GeneratedColumn<int>(
    'supplement_plan_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    foodId,
    grams,
    inputSource,
    rawInput,
    confidence,
    requestId,
    supplementPlanId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'log_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LogEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('grams')) {
      context.handle(
        _gramsMeta,
        grams.isAcceptableOrUnknown(data['grams']!, _gramsMeta),
      );
    } else if (isInserting) {
      context.missing(_gramsMeta);
    }
    if (data.containsKey('input_source')) {
      context.handle(
        _inputSourceMeta,
        inputSource.isAcceptableOrUnknown(
          data['input_source']!,
          _inputSourceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inputSourceMeta);
    }
    if (data.containsKey('raw_input')) {
      context.handle(
        _rawInputMeta,
        rawInput.isAcceptableOrUnknown(data['raw_input']!, _rawInputMeta),
      );
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    }
    if (data.containsKey('request_id')) {
      context.handle(
        _requestIdMeta,
        requestId.isAcceptableOrUnknown(data['request_id']!, _requestIdMeta),
      );
    }
    if (data.containsKey('supplement_plan_id')) {
      context.handle(
        _supplementPlanIdMeta,
        supplementPlanId.isAcceptableOrUnknown(
          data['supplement_plan_id']!,
          _supplementPlanIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LogEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      )!,
      grams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grams'],
      )!,
      inputSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_source'],
      )!,
      rawInput: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_input'],
      ),
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}confidence'],
      ),
      requestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_id'],
      ),
      supplementPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}supplement_plan_id'],
      ),
    );
  }

  @override
  $LogEntriesTable createAlias(String alias) {
    return $LogEntriesTable(attachedDatabase, alias);
  }
}

class LogEntryRow extends DataClass implements Insertable<LogEntryRow> {
  final int id;
  final DateTime timestamp;
  final int foodId;

  /// Amount in the food's unit (g, ml or pieces).
  final double grams;

  /// text | voice | photo | barcode | supplement_auto
  final String inputSource;
  final String? rawInput;
  final double? confidence;
  final String? requestId;

  /// For supplement_auto entries: the plan that created it.
  final int? supplementPlanId;
  const LogEntryRow({
    required this.id,
    required this.timestamp,
    required this.foodId,
    required this.grams,
    required this.inputSource,
    this.rawInput,
    this.confidence,
    this.requestId,
    this.supplementPlanId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['food_id'] = Variable<int>(foodId);
    map['grams'] = Variable<double>(grams);
    map['input_source'] = Variable<String>(inputSource);
    if (!nullToAbsent || rawInput != null) {
      map['raw_input'] = Variable<String>(rawInput);
    }
    if (!nullToAbsent || confidence != null) {
      map['confidence'] = Variable<double>(confidence);
    }
    if (!nullToAbsent || requestId != null) {
      map['request_id'] = Variable<String>(requestId);
    }
    if (!nullToAbsent || supplementPlanId != null) {
      map['supplement_plan_id'] = Variable<int>(supplementPlanId);
    }
    return map;
  }

  LogEntriesCompanion toCompanion(bool nullToAbsent) {
    return LogEntriesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      foodId: Value(foodId),
      grams: Value(grams),
      inputSource: Value(inputSource),
      rawInput: rawInput == null && nullToAbsent
          ? const Value.absent()
          : Value(rawInput),
      confidence: confidence == null && nullToAbsent
          ? const Value.absent()
          : Value(confidence),
      requestId: requestId == null && nullToAbsent
          ? const Value.absent()
          : Value(requestId),
      supplementPlanId: supplementPlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplementPlanId),
    );
  }

  factory LogEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogEntryRow(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      foodId: serializer.fromJson<int>(json['foodId']),
      grams: serializer.fromJson<double>(json['grams']),
      inputSource: serializer.fromJson<String>(json['inputSource']),
      rawInput: serializer.fromJson<String?>(json['rawInput']),
      confidence: serializer.fromJson<double?>(json['confidence']),
      requestId: serializer.fromJson<String?>(json['requestId']),
      supplementPlanId: serializer.fromJson<int?>(json['supplementPlanId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'foodId': serializer.toJson<int>(foodId),
      'grams': serializer.toJson<double>(grams),
      'inputSource': serializer.toJson<String>(inputSource),
      'rawInput': serializer.toJson<String?>(rawInput),
      'confidence': serializer.toJson<double?>(confidence),
      'requestId': serializer.toJson<String?>(requestId),
      'supplementPlanId': serializer.toJson<int?>(supplementPlanId),
    };
  }

  LogEntryRow copyWith({
    int? id,
    DateTime? timestamp,
    int? foodId,
    double? grams,
    String? inputSource,
    Value<String?> rawInput = const Value.absent(),
    Value<double?> confidence = const Value.absent(),
    Value<String?> requestId = const Value.absent(),
    Value<int?> supplementPlanId = const Value.absent(),
  }) => LogEntryRow(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    foodId: foodId ?? this.foodId,
    grams: grams ?? this.grams,
    inputSource: inputSource ?? this.inputSource,
    rawInput: rawInput.present ? rawInput.value : this.rawInput,
    confidence: confidence.present ? confidence.value : this.confidence,
    requestId: requestId.present ? requestId.value : this.requestId,
    supplementPlanId: supplementPlanId.present
        ? supplementPlanId.value
        : this.supplementPlanId,
  );
  LogEntryRow copyWithCompanion(LogEntriesCompanion data) {
    return LogEntryRow(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      grams: data.grams.present ? data.grams.value : this.grams,
      inputSource: data.inputSource.present
          ? data.inputSource.value
          : this.inputSource,
      rawInput: data.rawInput.present ? data.rawInput.value : this.rawInput,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      requestId: data.requestId.present ? data.requestId.value : this.requestId,
      supplementPlanId: data.supplementPlanId.present
          ? data.supplementPlanId.value
          : this.supplementPlanId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LogEntryRow(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('foodId: $foodId, ')
          ..write('grams: $grams, ')
          ..write('inputSource: $inputSource, ')
          ..write('rawInput: $rawInput, ')
          ..write('confidence: $confidence, ')
          ..write('requestId: $requestId, ')
          ..write('supplementPlanId: $supplementPlanId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    foodId,
    grams,
    inputSource,
    rawInput,
    confidence,
    requestId,
    supplementPlanId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogEntryRow &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.foodId == this.foodId &&
          other.grams == this.grams &&
          other.inputSource == this.inputSource &&
          other.rawInput == this.rawInput &&
          other.confidence == this.confidence &&
          other.requestId == this.requestId &&
          other.supplementPlanId == this.supplementPlanId);
}

class LogEntriesCompanion extends UpdateCompanion<LogEntryRow> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<int> foodId;
  final Value<double> grams;
  final Value<String> inputSource;
  final Value<String?> rawInput;
  final Value<double?> confidence;
  final Value<String?> requestId;
  final Value<int?> supplementPlanId;
  const LogEntriesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.foodId = const Value.absent(),
    this.grams = const Value.absent(),
    this.inputSource = const Value.absent(),
    this.rawInput = const Value.absent(),
    this.confidence = const Value.absent(),
    this.requestId = const Value.absent(),
    this.supplementPlanId = const Value.absent(),
  });
  LogEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required int foodId,
    required double grams,
    required String inputSource,
    this.rawInput = const Value.absent(),
    this.confidence = const Value.absent(),
    this.requestId = const Value.absent(),
    this.supplementPlanId = const Value.absent(),
  }) : timestamp = Value(timestamp),
       foodId = Value(foodId),
       grams = Value(grams),
       inputSource = Value(inputSource);
  static Insertable<LogEntryRow> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? foodId,
    Expression<double>? grams,
    Expression<String>? inputSource,
    Expression<String>? rawInput,
    Expression<double>? confidence,
    Expression<String>? requestId,
    Expression<int>? supplementPlanId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (foodId != null) 'food_id': foodId,
      if (grams != null) 'grams': grams,
      if (inputSource != null) 'input_source': inputSource,
      if (rawInput != null) 'raw_input': rawInput,
      if (confidence != null) 'confidence': confidence,
      if (requestId != null) 'request_id': requestId,
      if (supplementPlanId != null) 'supplement_plan_id': supplementPlanId,
    });
  }

  LogEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<int>? foodId,
    Value<double>? grams,
    Value<String>? inputSource,
    Value<String?>? rawInput,
    Value<double?>? confidence,
    Value<String?>? requestId,
    Value<int?>? supplementPlanId,
  }) {
    return LogEntriesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      foodId: foodId ?? this.foodId,
      grams: grams ?? this.grams,
      inputSource: inputSource ?? this.inputSource,
      rawInput: rawInput ?? this.rawInput,
      confidence: confidence ?? this.confidence,
      requestId: requestId ?? this.requestId,
      supplementPlanId: supplementPlanId ?? this.supplementPlanId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (grams.present) {
      map['grams'] = Variable<double>(grams.value);
    }
    if (inputSource.present) {
      map['input_source'] = Variable<String>(inputSource.value);
    }
    if (rawInput.present) {
      map['raw_input'] = Variable<String>(rawInput.value);
    }
    if (confidence.present) {
      map['confidence'] = Variable<double>(confidence.value);
    }
    if (requestId.present) {
      map['request_id'] = Variable<String>(requestId.value);
    }
    if (supplementPlanId.present) {
      map['supplement_plan_id'] = Variable<int>(supplementPlanId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('foodId: $foodId, ')
          ..write('grams: $grams, ')
          ..write('inputSource: $inputSource, ')
          ..write('rawInput: $rawInput, ')
          ..write('confidence: $confidence, ')
          ..write('requestId: $requestId, ')
          ..write('supplementPlanId: $supplementPlanId')
          ..write(')'))
        .toString();
  }
}

class $RequestsTable extends Requests
    with TableInfo<$RequestsTable, RequestRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RequestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rawInputMeta = const VerificationMeta(
    'rawInput',
  );
  @override
  late final GeneratedColumn<String> rawInput = GeneratedColumn<String>(
    'raw_input',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inputSourceMeta = const VerificationMeta(
    'inputSource',
  );
  @override
  late final GeneratedColumn<String> inputSource = GeneratedColumn<String>(
    'input_source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firedAtMeta = const VerificationMeta(
    'firedAt',
  );
  @override
  late final GeneratedColumn<DateTime> firedAt = GeneratedColumn<DateTime>(
    'fired_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _logAtMeta = const VerificationMeta('logAt');
  @override
  late final GeneratedColumn<DateTime> logAt = GeneratedColumn<DateTime>(
    'log_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _resultNoteMeta = const VerificationMeta(
    'resultNote',
  );
  @override
  late final GeneratedColumn<String> resultNote = GeneratedColumn<String>(
    'result_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dismissedMeta = const VerificationMeta(
    'dismissed',
  );
  @override
  late final GeneratedColumn<bool> dismissed = GeneratedColumn<bool>(
    'dismissed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dismissed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    createdAt,
    status,
    attempts,
    lastError,
    rawInput,
    imagePath,
    payload,
    inputSource,
    firedAt,
    nextAttemptAt,
    foodId,
    logAt,
    resultNote,
    dismissed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'requests';
  @override
  VerificationContext validateIntegrity(
    Insertable<RequestRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('raw_input')) {
      context.handle(
        _rawInputMeta,
        rawInput.isAcceptableOrUnknown(data['raw_input']!, _rawInputMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('input_source')) {
      context.handle(
        _inputSourceMeta,
        inputSource.isAcceptableOrUnknown(
          data['input_source']!,
          _inputSourceMeta,
        ),
      );
    }
    if (data.containsKey('fired_at')) {
      context.handle(
        _firedAtMeta,
        firedAt.isAcceptableOrUnknown(data['fired_at']!, _firedAtMeta),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    }
    if (data.containsKey('log_at')) {
      context.handle(
        _logAtMeta,
        logAt.isAcceptableOrUnknown(data['log_at']!, _logAtMeta),
      );
    }
    if (data.containsKey('result_note')) {
      context.handle(
        _resultNoteMeta,
        resultNote.isAcceptableOrUnknown(data['result_note']!, _resultNoteMeta),
      );
    }
    if (data.containsKey('dismissed')) {
      context.handle(
        _dismissedMeta,
        dismissed.isAcceptableOrUnknown(data['dismissed']!, _dismissedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RequestRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RequestRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      rawInput: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_input'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      inputSource: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_source'],
      ),
      firedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fired_at'],
      ),
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      ),
      logAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_at'],
      ),
      resultNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_note'],
      ),
      dismissed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dismissed'],
      )!,
    );
  }

  @override
  $RequestsTable createAlias(String alias) {
    return $RequestsTable(attachedDatabase, alias);
  }
}

class RequestRow extends DataClass implements Insertable<RequestRow> {
  final String id;

  /// log_text | log_photo | enrich_food | ping
  final String type;
  final DateTime createdAt;

  /// queued | uploaded | fired | done | failed
  final String status;
  final int attempts;
  final String? lastError;
  final String? rawInput;
  final String? imagePath;

  /// Request JSON (as written to `inbox/<id>.json`).
  final String payload;

  /// text | voice | photo | barcode — how the user entered it (for log entries).
  final String? inputSource;
  final DateTime? firedAt;
  final DateTime? nextAttemptAt;

  /// Food the request is about (enrich_food).
  final int? foodId;

  /// Time the resulting log entries get (past-day logging from the calendar); null = createdAt.
  final DateTime? logAt;

  /// Short note from Claude shown on the card (e.g. nothing edible recognised).
  final String? resultNote;

  /// The result card was dismissed in the chat.
  final bool dismissed;
  const RequestRow({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.status,
    required this.attempts,
    this.lastError,
    this.rawInput,
    this.imagePath,
    required this.payload,
    this.inputSource,
    this.firedAt,
    this.nextAttemptAt,
    this.foodId,
    this.logAt,
    this.resultNote,
    required this.dismissed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    if (!nullToAbsent || rawInput != null) {
      map['raw_input'] = Variable<String>(rawInput);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['payload'] = Variable<String>(payload);
    if (!nullToAbsent || inputSource != null) {
      map['input_source'] = Variable<String>(inputSource);
    }
    if (!nullToAbsent || firedAt != null) {
      map['fired_at'] = Variable<DateTime>(firedAt);
    }
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || foodId != null) {
      map['food_id'] = Variable<int>(foodId);
    }
    if (!nullToAbsent || logAt != null) {
      map['log_at'] = Variable<DateTime>(logAt);
    }
    if (!nullToAbsent || resultNote != null) {
      map['result_note'] = Variable<String>(resultNote);
    }
    map['dismissed'] = Variable<bool>(dismissed);
    return map;
  }

  RequestsCompanion toCompanion(bool nullToAbsent) {
    return RequestsCompanion(
      id: Value(id),
      type: Value(type),
      createdAt: Value(createdAt),
      status: Value(status),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      rawInput: rawInput == null && nullToAbsent
          ? const Value.absent()
          : Value(rawInput),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      payload: Value(payload),
      inputSource: inputSource == null && nullToAbsent
          ? const Value.absent()
          : Value(inputSource),
      firedAt: firedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(firedAt),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      foodId: foodId == null && nullToAbsent
          ? const Value.absent()
          : Value(foodId),
      logAt: logAt == null && nullToAbsent
          ? const Value.absent()
          : Value(logAt),
      resultNote: resultNote == null && nullToAbsent
          ? const Value.absent()
          : Value(resultNote),
      dismissed: Value(dismissed),
    );
  }

  factory RequestRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RequestRow(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      rawInput: serializer.fromJson<String?>(json['rawInput']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      payload: serializer.fromJson<String>(json['payload']),
      inputSource: serializer.fromJson<String?>(json['inputSource']),
      firedAt: serializer.fromJson<DateTime?>(json['firedAt']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      foodId: serializer.fromJson<int?>(json['foodId']),
      logAt: serializer.fromJson<DateTime?>(json['logAt']),
      resultNote: serializer.fromJson<String?>(json['resultNote']),
      dismissed: serializer.fromJson<bool>(json['dismissed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'rawInput': serializer.toJson<String?>(rawInput),
      'imagePath': serializer.toJson<String?>(imagePath),
      'payload': serializer.toJson<String>(payload),
      'inputSource': serializer.toJson<String?>(inputSource),
      'firedAt': serializer.toJson<DateTime?>(firedAt),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'foodId': serializer.toJson<int?>(foodId),
      'logAt': serializer.toJson<DateTime?>(logAt),
      'resultNote': serializer.toJson<String?>(resultNote),
      'dismissed': serializer.toJson<bool>(dismissed),
    };
  }

  RequestRow copyWith({
    String? id,
    String? type,
    DateTime? createdAt,
    String? status,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    Value<String?> rawInput = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    String? payload,
    Value<String?> inputSource = const Value.absent(),
    Value<DateTime?> firedAt = const Value.absent(),
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    Value<int?> foodId = const Value.absent(),
    Value<DateTime?> logAt = const Value.absent(),
    Value<String?> resultNote = const Value.absent(),
    bool? dismissed,
  }) => RequestRow(
    id: id ?? this.id,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    rawInput: rawInput.present ? rawInput.value : this.rawInput,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    payload: payload ?? this.payload,
    inputSource: inputSource.present ? inputSource.value : this.inputSource,
    firedAt: firedAt.present ? firedAt.value : this.firedAt,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    foodId: foodId.present ? foodId.value : this.foodId,
    logAt: logAt.present ? logAt.value : this.logAt,
    resultNote: resultNote.present ? resultNote.value : this.resultNote,
    dismissed: dismissed ?? this.dismissed,
  );
  RequestRow copyWithCompanion(RequestsCompanion data) {
    return RequestRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      rawInput: data.rawInput.present ? data.rawInput.value : this.rawInput,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      payload: data.payload.present ? data.payload.value : this.payload,
      inputSource: data.inputSource.present
          ? data.inputSource.value
          : this.inputSource,
      firedAt: data.firedAt.present ? data.firedAt.value : this.firedAt,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      logAt: data.logAt.present ? data.logAt.value : this.logAt,
      resultNote: data.resultNote.present
          ? data.resultNote.value
          : this.resultNote,
      dismissed: data.dismissed.present ? data.dismissed.value : this.dismissed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RequestRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('rawInput: $rawInput, ')
          ..write('imagePath: $imagePath, ')
          ..write('payload: $payload, ')
          ..write('inputSource: $inputSource, ')
          ..write('firedAt: $firedAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('foodId: $foodId, ')
          ..write('logAt: $logAt, ')
          ..write('resultNote: $resultNote, ')
          ..write('dismissed: $dismissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    createdAt,
    status,
    attempts,
    lastError,
    rawInput,
    imagePath,
    payload,
    inputSource,
    firedAt,
    nextAttemptAt,
    foodId,
    logAt,
    resultNote,
    dismissed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RequestRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.rawInput == this.rawInput &&
          other.imagePath == this.imagePath &&
          other.payload == this.payload &&
          other.inputSource == this.inputSource &&
          other.firedAt == this.firedAt &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.foodId == this.foodId &&
          other.logAt == this.logAt &&
          other.resultNote == this.resultNote &&
          other.dismissed == this.dismissed);
}

class RequestsCompanion extends UpdateCompanion<RequestRow> {
  final Value<String> id;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<String?> rawInput;
  final Value<String?> imagePath;
  final Value<String> payload;
  final Value<String?> inputSource;
  final Value<DateTime?> firedAt;
  final Value<DateTime?> nextAttemptAt;
  final Value<int?> foodId;
  final Value<DateTime?> logAt;
  final Value<String?> resultNote;
  final Value<bool> dismissed;
  final Value<int> rowid;
  const RequestsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rawInput = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.payload = const Value.absent(),
    this.inputSource = const Value.absent(),
    this.firedAt = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.foodId = const Value.absent(),
    this.logAt = const Value.absent(),
    this.resultNote = const Value.absent(),
    this.dismissed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RequestsCompanion.insert({
    required String id,
    required String type,
    required DateTime createdAt,
    required String status,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rawInput = const Value.absent(),
    this.imagePath = const Value.absent(),
    required String payload,
    this.inputSource = const Value.absent(),
    this.firedAt = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.foodId = const Value.absent(),
    this.logAt = const Value.absent(),
    this.resultNote = const Value.absent(),
    this.dismissed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       createdAt = Value(createdAt),
       status = Value(status),
       payload = Value(payload);
  static Insertable<RequestRow> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<String>? rawInput,
    Expression<String>? imagePath,
    Expression<String>? payload,
    Expression<String>? inputSource,
    Expression<DateTime>? firedAt,
    Expression<DateTime>? nextAttemptAt,
    Expression<int>? foodId,
    Expression<DateTime>? logAt,
    Expression<String>? resultNote,
    Expression<bool>? dismissed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (rawInput != null) 'raw_input': rawInput,
      if (imagePath != null) 'image_path': imagePath,
      if (payload != null) 'payload': payload,
      if (inputSource != null) 'input_source': inputSource,
      if (firedAt != null) 'fired_at': firedAt,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (foodId != null) 'food_id': foodId,
      if (logAt != null) 'log_at': logAt,
      if (resultNote != null) 'result_note': resultNote,
      if (dismissed != null) 'dismissed': dismissed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RequestsCompanion copyWith({
    Value<String>? id,
    Value<String>? type,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<String?>? rawInput,
    Value<String?>? imagePath,
    Value<String>? payload,
    Value<String?>? inputSource,
    Value<DateTime?>? firedAt,
    Value<DateTime?>? nextAttemptAt,
    Value<int?>? foodId,
    Value<DateTime?>? logAt,
    Value<String?>? resultNote,
    Value<bool>? dismissed,
    Value<int>? rowid,
  }) {
    return RequestsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      rawInput: rawInput ?? this.rawInput,
      imagePath: imagePath ?? this.imagePath,
      payload: payload ?? this.payload,
      inputSource: inputSource ?? this.inputSource,
      firedAt: firedAt ?? this.firedAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      foodId: foodId ?? this.foodId,
      logAt: logAt ?? this.logAt,
      resultNote: resultNote ?? this.resultNote,
      dismissed: dismissed ?? this.dismissed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rawInput.present) {
      map['raw_input'] = Variable<String>(rawInput.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (inputSource.present) {
      map['input_source'] = Variable<String>(inputSource.value);
    }
    if (firedAt.present) {
      map['fired_at'] = Variable<DateTime>(firedAt.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (logAt.present) {
      map['log_at'] = Variable<DateTime>(logAt.value);
    }
    if (resultNote.present) {
      map['result_note'] = Variable<String>(resultNote.value);
    }
    if (dismissed.present) {
      map['dismissed'] = Variable<bool>(dismissed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RequestsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('rawInput: $rawInput, ')
          ..write('imagePath: $imagePath, ')
          ..write('payload: $payload, ')
          ..write('inputSource: $inputSource, ')
          ..write('firedAt: $firedAt, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('foodId: $foodId, ')
          ..write('logAt: $logAt, ')
          ..write('resultNote: $resultNote, ')
          ..write('dismissed: $dismissed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SupplementPlansTable extends SupplementPlans
    with TableInfo<$SupplementPlansTable, SupplementPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplementPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rawInputMeta = const VerificationMeta(
    'rawInput',
  );
  @override
  late final GeneratedColumn<String> rawInput = GeneratedColumn<String>(
    'raw_input',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    foodId,
    amount,
    unit,
    active,
    startDate,
    rawInput,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplement_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplementPlanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('raw_input')) {
      context.handle(
        _rawInputMeta,
        rawInput.isAcceptableOrUnknown(data['raw_input']!, _rawInputMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplementPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplementPlanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      rawInput: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}raw_input'],
      ),
    );
  }

  @override
  $SupplementPlansTable createAlias(String alias) {
    return $SupplementPlansTable(attachedDatabase, alias);
  }
}

class SupplementPlanRow extends DataClass
    implements Insertable<SupplementPlanRow> {
  final int id;
  final int foodId;
  final double amount;

  /// g | ml | piece
  final String unit;
  final bool active;

  /// First day the plan is auto-logged.
  final DateTime startDate;
  final String? rawInput;
  const SupplementPlanRow({
    required this.id,
    required this.foodId,
    required this.amount,
    required this.unit,
    required this.active,
    required this.startDate,
    this.rawInput,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['food_id'] = Variable<int>(foodId);
    map['amount'] = Variable<double>(amount);
    map['unit'] = Variable<String>(unit);
    map['active'] = Variable<bool>(active);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || rawInput != null) {
      map['raw_input'] = Variable<String>(rawInput);
    }
    return map;
  }

  SupplementPlansCompanion toCompanion(bool nullToAbsent) {
    return SupplementPlansCompanion(
      id: Value(id),
      foodId: Value(foodId),
      amount: Value(amount),
      unit: Value(unit),
      active: Value(active),
      startDate: Value(startDate),
      rawInput: rawInput == null && nullToAbsent
          ? const Value.absent()
          : Value(rawInput),
    );
  }

  factory SupplementPlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplementPlanRow(
      id: serializer.fromJson<int>(json['id']),
      foodId: serializer.fromJson<int>(json['foodId']),
      amount: serializer.fromJson<double>(json['amount']),
      unit: serializer.fromJson<String>(json['unit']),
      active: serializer.fromJson<bool>(json['active']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      rawInput: serializer.fromJson<String?>(json['rawInput']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'foodId': serializer.toJson<int>(foodId),
      'amount': serializer.toJson<double>(amount),
      'unit': serializer.toJson<String>(unit),
      'active': serializer.toJson<bool>(active),
      'startDate': serializer.toJson<DateTime>(startDate),
      'rawInput': serializer.toJson<String?>(rawInput),
    };
  }

  SupplementPlanRow copyWith({
    int? id,
    int? foodId,
    double? amount,
    String? unit,
    bool? active,
    DateTime? startDate,
    Value<String?> rawInput = const Value.absent(),
  }) => SupplementPlanRow(
    id: id ?? this.id,
    foodId: foodId ?? this.foodId,
    amount: amount ?? this.amount,
    unit: unit ?? this.unit,
    active: active ?? this.active,
    startDate: startDate ?? this.startDate,
    rawInput: rawInput.present ? rawInput.value : this.rawInput,
  );
  SupplementPlanRow copyWithCompanion(SupplementPlansCompanion data) {
    return SupplementPlanRow(
      id: data.id.present ? data.id.value : this.id,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      active: data.active.present ? data.active.value : this.active,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      rawInput: data.rawInput.present ? data.rawInput.value : this.rawInput,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplementPlanRow(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('active: $active, ')
          ..write('startDate: $startDate, ')
          ..write('rawInput: $rawInput')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, foodId, amount, unit, active, startDate, rawInput);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplementPlanRow &&
          other.id == this.id &&
          other.foodId == this.foodId &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.active == this.active &&
          other.startDate == this.startDate &&
          other.rawInput == this.rawInput);
}

class SupplementPlansCompanion extends UpdateCompanion<SupplementPlanRow> {
  final Value<int> id;
  final Value<int> foodId;
  final Value<double> amount;
  final Value<String> unit;
  final Value<bool> active;
  final Value<DateTime> startDate;
  final Value<String?> rawInput;
  const SupplementPlansCompanion({
    this.id = const Value.absent(),
    this.foodId = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.active = const Value.absent(),
    this.startDate = const Value.absent(),
    this.rawInput = const Value.absent(),
  });
  SupplementPlansCompanion.insert({
    this.id = const Value.absent(),
    required int foodId,
    required double amount,
    required String unit,
    this.active = const Value.absent(),
    required DateTime startDate,
    this.rawInput = const Value.absent(),
  }) : foodId = Value(foodId),
       amount = Value(amount),
       unit = Value(unit),
       startDate = Value(startDate);
  static Insertable<SupplementPlanRow> custom({
    Expression<int>? id,
    Expression<int>? foodId,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<bool>? active,
    Expression<DateTime>? startDate,
    Expression<String>? rawInput,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodId != null) 'food_id': foodId,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (active != null) 'active': active,
      if (startDate != null) 'start_date': startDate,
      if (rawInput != null) 'raw_input': rawInput,
    });
  }

  SupplementPlansCompanion copyWith({
    Value<int>? id,
    Value<int>? foodId,
    Value<double>? amount,
    Value<String>? unit,
    Value<bool>? active,
    Value<DateTime>? startDate,
    Value<String?>? rawInput,
  }) {
    return SupplementPlansCompanion(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      active: active ?? this.active,
      startDate: startDate ?? this.startDate,
      rawInput: rawInput ?? this.rawInput,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (rawInput.present) {
      map['raw_input'] = Variable<String>(rawInput.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplementPlansCompanion(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('active: $active, ')
          ..write('startDate: $startDate, ')
          ..write('rawInput: $rawInput')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ironStatusMeta = const VerificationMeta(
    'ironStatus',
  );
  @override
  late final GeneratedColumn<String> ironStatus = GeneratedColumn<String>(
    'iron_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('menstruating'),
  );
  static const VerificationMeta _phytateMeta = const VerificationMeta(
    'phytate',
  );
  @override
  late final GeneratedColumn<String> phytate = GeneratedColumn<String>(
    'phytate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sex,
    age,
    heightCm,
    weightKg,
    activityLevel,
    ironStatus,
    phytate,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityLevelMeta);
    }
    if (data.containsKey('iron_status')) {
      context.handle(
        _ironStatusMeta,
        ironStatus.isAcceptableOrUnknown(data['iron_status']!, _ironStatusMeta),
      );
    }
    if (data.containsKey('phytate')) {
      context.handle(
        _phytateMeta,
        phytate.isAcceptableOrUnknown(data['phytate']!, _phytateMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_level'],
      )!,
      ironStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}iron_status'],
      )!,
      phytate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phytate'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final int id;

  /// m | f
  final String sex;
  final int age;
  final double heightCm;
  final double weightKg;

  /// DGE PAL: 1.4 | 1.6 | 1.8
  final String activityLevel;
  final String ironStatus;
  final String phytate;
  final DateTime updatedAt;
  const ProfileRow({
    required this.id,
    required this.sex,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
    required this.ironStatus,
    required this.phytate,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sex'] = Variable<String>(sex);
    map['age'] = Variable<int>(age);
    map['height_cm'] = Variable<double>(heightCm);
    map['weight_kg'] = Variable<double>(weightKg);
    map['activity_level'] = Variable<String>(activityLevel);
    map['iron_status'] = Variable<String>(ironStatus);
    map['phytate'] = Variable<String>(phytate);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      sex: Value(sex),
      age: Value(age),
      heightCm: Value(heightCm),
      weightKg: Value(weightKg),
      activityLevel: Value(activityLevel),
      ironStatus: Value(ironStatus),
      phytate: Value(phytate),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<int>(json['id']),
      sex: serializer.fromJson<String>(json['sex']),
      age: serializer.fromJson<int>(json['age']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      activityLevel: serializer.fromJson<String>(json['activityLevel']),
      ironStatus: serializer.fromJson<String>(json['ironStatus']),
      phytate: serializer.fromJson<String>(json['phytate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sex': serializer.toJson<String>(sex),
      'age': serializer.toJson<int>(age),
      'heightCm': serializer.toJson<double>(heightCm),
      'weightKg': serializer.toJson<double>(weightKg),
      'activityLevel': serializer.toJson<String>(activityLevel),
      'ironStatus': serializer.toJson<String>(ironStatus),
      'phytate': serializer.toJson<String>(phytate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProfileRow copyWith({
    int? id,
    String? sex,
    int? age,
    double? heightCm,
    double? weightKg,
    String? activityLevel,
    String? ironStatus,
    String? phytate,
    DateTime? updatedAt,
  }) => ProfileRow(
    id: id ?? this.id,
    sex: sex ?? this.sex,
    age: age ?? this.age,
    heightCm: heightCm ?? this.heightCm,
    weightKg: weightKg ?? this.weightKg,
    activityLevel: activityLevel ?? this.activityLevel,
    ironStatus: ironStatus ?? this.ironStatus,
    phytate: phytate ?? this.phytate,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      sex: data.sex.present ? data.sex.value : this.sex,
      age: data.age.present ? data.age.value : this.age,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      ironStatus: data.ironStatus.present
          ? data.ironStatus.value
          : this.ironStatus,
      phytate: data.phytate.present ? data.phytate.value : this.phytate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('sex: $sex, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('ironStatus: $ironStatus, ')
          ..write('phytate: $phytate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sex,
    age,
    heightCm,
    weightKg,
    activityLevel,
    ironStatus,
    phytate,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.sex == this.sex &&
          other.age == this.age &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.activityLevel == this.activityLevel &&
          other.ironStatus == this.ironStatus &&
          other.phytate == this.phytate &&
          other.updatedAt == this.updatedAt);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<int> id;
  final Value<String> sex;
  final Value<int> age;
  final Value<double> heightCm;
  final Value<double> weightKg;
  final Value<String> activityLevel;
  final Value<String> ironStatus;
  final Value<String> phytate;
  final Value<DateTime> updatedAt;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.sex = const Value.absent(),
    this.age = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.ironStatus = const Value.absent(),
    this.phytate = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String sex,
    required int age,
    required double heightCm,
    required double weightKg,
    required String activityLevel,
    this.ironStatus = const Value.absent(),
    this.phytate = const Value.absent(),
    required DateTime updatedAt,
  }) : sex = Value(sex),
       age = Value(age),
       heightCm = Value(heightCm),
       weightKg = Value(weightKg),
       activityLevel = Value(activityLevel),
       updatedAt = Value(updatedAt);
  static Insertable<ProfileRow> custom({
    Expression<int>? id,
    Expression<String>? sex,
    Expression<int>? age,
    Expression<double>? heightCm,
    Expression<double>? weightKg,
    Expression<String>? activityLevel,
    Expression<String>? ironStatus,
    Expression<String>? phytate,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sex != null) 'sex': sex,
      if (age != null) 'age': age,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (ironStatus != null) 'iron_status': ironStatus,
      if (phytate != null) 'phytate': phytate,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? sex,
    Value<int>? age,
    Value<double>? heightCm,
    Value<double>? weightKg,
    Value<String>? activityLevel,
    Value<String>? ironStatus,
    Value<String>? phytate,
    Value<DateTime>? updatedAt,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      ironStatus: ironStatus ?? this.ironStatus,
      phytate: phytate ?? this.phytate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<String>(activityLevel.value);
    }
    if (ironStatus.present) {
      map['iron_status'] = Variable<String>(ironStatus.value);
    }
    if (phytate.present) {
      map['phytate'] = Variable<String>(phytate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('sex: $sex, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('ironStatus: $ironStatus, ')
          ..write('phytate: $phytate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReferenceValuesTable extends ReferenceValues
    with TableInfo<$ReferenceValuesTable, ReferenceValueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReferenceValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nutrientIdMeta = const VerificationMeta(
    'nutrientId',
  );
  @override
  late final GeneratedColumn<int> nutrientId = GeneratedColumn<int>(
    'nutrient_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMinMeta = const VerificationMeta('ageMin');
  @override
  late final GeneratedColumn<int> ageMin = GeneratedColumn<int>(
    'age_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMaxMeta = const VerificationMeta('ageMax');
  @override
  late final GeneratedColumn<int> ageMax = GeneratedColumn<int>(
    'age_max',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueTypeMeta = const VerificationMeta(
    'valueType',
  );
  @override
  late final GeneratedColumn<String> valueType = GeneratedColumn<String>(
    'value_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _basisMeta = const VerificationMeta('basis');
  @override
  late final GeneratedColumn<String> basis = GeneratedColumn<String>(
    'basis',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ulBasisMeta = const VerificationMeta(
    'ulBasis',
  );
  @override
  late final GeneratedColumn<String> ulBasis = GeneratedColumn<String>(
    'ul_basis',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nutrientId,
    sex,
    ageMin,
    ageMax,
    valueType,
    amount,
    basis,
    condition,
    ulBasis,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reference_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReferenceValueRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nutrient_id')) {
      context.handle(
        _nutrientIdMeta,
        nutrientId.isAcceptableOrUnknown(data['nutrient_id']!, _nutrientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_nutrientIdMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('age_min')) {
      context.handle(
        _ageMinMeta,
        ageMin.isAcceptableOrUnknown(data['age_min']!, _ageMinMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMinMeta);
    }
    if (data.containsKey('age_max')) {
      context.handle(
        _ageMaxMeta,
        ageMax.isAcceptableOrUnknown(data['age_max']!, _ageMaxMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMaxMeta);
    }
    if (data.containsKey('value_type')) {
      context.handle(
        _valueTypeMeta,
        valueType.isAcceptableOrUnknown(data['value_type']!, _valueTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_valueTypeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('basis')) {
      context.handle(
        _basisMeta,
        basis.isAcceptableOrUnknown(data['basis']!, _basisMeta),
      );
    } else if (isInserting) {
      context.missing(_basisMeta);
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    } else if (isInserting) {
      context.missing(_conditionMeta);
    }
    if (data.containsKey('ul_basis')) {
      context.handle(
        _ulBasisMeta,
        ulBasis.isAcceptableOrUnknown(data['ul_basis']!, _ulBasisMeta),
      );
    } else if (isInserting) {
      context.missing(_ulBasisMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReferenceValueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReferenceValueRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nutrientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nutrient_id'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      )!,
      ageMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age_min'],
      )!,
      ageMax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age_max'],
      )!,
      valueType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      basis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}basis'],
      )!,
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      )!,
      ulBasis: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ul_basis'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  $ReferenceValuesTable createAlias(String alias) {
    return $ReferenceValuesTable(attachedDatabase, alias);
  }
}

class ReferenceValueRow extends DataClass
    implements Insertable<ReferenceValueRow> {
  final int id;
  final int nutrientId;
  final String sex;
  final int ageMin;
  final int ageMax;
  final String valueType;
  final double amount;
  final String basis;
  final String condition;
  final String ulBasis;
  final String source;
  const ReferenceValueRow({
    required this.id,
    required this.nutrientId,
    required this.sex,
    required this.ageMin,
    required this.ageMax,
    required this.valueType,
    required this.amount,
    required this.basis,
    required this.condition,
    required this.ulBasis,
    required this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nutrient_id'] = Variable<int>(nutrientId);
    map['sex'] = Variable<String>(sex);
    map['age_min'] = Variable<int>(ageMin);
    map['age_max'] = Variable<int>(ageMax);
    map['value_type'] = Variable<String>(valueType);
    map['amount'] = Variable<double>(amount);
    map['basis'] = Variable<String>(basis);
    map['condition'] = Variable<String>(condition);
    map['ul_basis'] = Variable<String>(ulBasis);
    map['source'] = Variable<String>(source);
    return map;
  }

  ReferenceValuesCompanion toCompanion(bool nullToAbsent) {
    return ReferenceValuesCompanion(
      id: Value(id),
      nutrientId: Value(nutrientId),
      sex: Value(sex),
      ageMin: Value(ageMin),
      ageMax: Value(ageMax),
      valueType: Value(valueType),
      amount: Value(amount),
      basis: Value(basis),
      condition: Value(condition),
      ulBasis: Value(ulBasis),
      source: Value(source),
    );
  }

  factory ReferenceValueRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReferenceValueRow(
      id: serializer.fromJson<int>(json['id']),
      nutrientId: serializer.fromJson<int>(json['nutrientId']),
      sex: serializer.fromJson<String>(json['sex']),
      ageMin: serializer.fromJson<int>(json['ageMin']),
      ageMax: serializer.fromJson<int>(json['ageMax']),
      valueType: serializer.fromJson<String>(json['valueType']),
      amount: serializer.fromJson<double>(json['amount']),
      basis: serializer.fromJson<String>(json['basis']),
      condition: serializer.fromJson<String>(json['condition']),
      ulBasis: serializer.fromJson<String>(json['ulBasis']),
      source: serializer.fromJson<String>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nutrientId': serializer.toJson<int>(nutrientId),
      'sex': serializer.toJson<String>(sex),
      'ageMin': serializer.toJson<int>(ageMin),
      'ageMax': serializer.toJson<int>(ageMax),
      'valueType': serializer.toJson<String>(valueType),
      'amount': serializer.toJson<double>(amount),
      'basis': serializer.toJson<String>(basis),
      'condition': serializer.toJson<String>(condition),
      'ulBasis': serializer.toJson<String>(ulBasis),
      'source': serializer.toJson<String>(source),
    };
  }

  ReferenceValueRow copyWith({
    int? id,
    int? nutrientId,
    String? sex,
    int? ageMin,
    int? ageMax,
    String? valueType,
    double? amount,
    String? basis,
    String? condition,
    String? ulBasis,
    String? source,
  }) => ReferenceValueRow(
    id: id ?? this.id,
    nutrientId: nutrientId ?? this.nutrientId,
    sex: sex ?? this.sex,
    ageMin: ageMin ?? this.ageMin,
    ageMax: ageMax ?? this.ageMax,
    valueType: valueType ?? this.valueType,
    amount: amount ?? this.amount,
    basis: basis ?? this.basis,
    condition: condition ?? this.condition,
    ulBasis: ulBasis ?? this.ulBasis,
    source: source ?? this.source,
  );
  ReferenceValueRow copyWithCompanion(ReferenceValuesCompanion data) {
    return ReferenceValueRow(
      id: data.id.present ? data.id.value : this.id,
      nutrientId: data.nutrientId.present
          ? data.nutrientId.value
          : this.nutrientId,
      sex: data.sex.present ? data.sex.value : this.sex,
      ageMin: data.ageMin.present ? data.ageMin.value : this.ageMin,
      ageMax: data.ageMax.present ? data.ageMax.value : this.ageMax,
      valueType: data.valueType.present ? data.valueType.value : this.valueType,
      amount: data.amount.present ? data.amount.value : this.amount,
      basis: data.basis.present ? data.basis.value : this.basis,
      condition: data.condition.present ? data.condition.value : this.condition,
      ulBasis: data.ulBasis.present ? data.ulBasis.value : this.ulBasis,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReferenceValueRow(')
          ..write('id: $id, ')
          ..write('nutrientId: $nutrientId, ')
          ..write('sex: $sex, ')
          ..write('ageMin: $ageMin, ')
          ..write('ageMax: $ageMax, ')
          ..write('valueType: $valueType, ')
          ..write('amount: $amount, ')
          ..write('basis: $basis, ')
          ..write('condition: $condition, ')
          ..write('ulBasis: $ulBasis, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nutrientId,
    sex,
    ageMin,
    ageMax,
    valueType,
    amount,
    basis,
    condition,
    ulBasis,
    source,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReferenceValueRow &&
          other.id == this.id &&
          other.nutrientId == this.nutrientId &&
          other.sex == this.sex &&
          other.ageMin == this.ageMin &&
          other.ageMax == this.ageMax &&
          other.valueType == this.valueType &&
          other.amount == this.amount &&
          other.basis == this.basis &&
          other.condition == this.condition &&
          other.ulBasis == this.ulBasis &&
          other.source == this.source);
}

class ReferenceValuesCompanion extends UpdateCompanion<ReferenceValueRow> {
  final Value<int> id;
  final Value<int> nutrientId;
  final Value<String> sex;
  final Value<int> ageMin;
  final Value<int> ageMax;
  final Value<String> valueType;
  final Value<double> amount;
  final Value<String> basis;
  final Value<String> condition;
  final Value<String> ulBasis;
  final Value<String> source;
  const ReferenceValuesCompanion({
    this.id = const Value.absent(),
    this.nutrientId = const Value.absent(),
    this.sex = const Value.absent(),
    this.ageMin = const Value.absent(),
    this.ageMax = const Value.absent(),
    this.valueType = const Value.absent(),
    this.amount = const Value.absent(),
    this.basis = const Value.absent(),
    this.condition = const Value.absent(),
    this.ulBasis = const Value.absent(),
    this.source = const Value.absent(),
  });
  ReferenceValuesCompanion.insert({
    this.id = const Value.absent(),
    required int nutrientId,
    required String sex,
    required int ageMin,
    required int ageMax,
    required String valueType,
    required double amount,
    required String basis,
    required String condition,
    required String ulBasis,
    required String source,
  }) : nutrientId = Value(nutrientId),
       sex = Value(sex),
       ageMin = Value(ageMin),
       ageMax = Value(ageMax),
       valueType = Value(valueType),
       amount = Value(amount),
       basis = Value(basis),
       condition = Value(condition),
       ulBasis = Value(ulBasis),
       source = Value(source);
  static Insertable<ReferenceValueRow> custom({
    Expression<int>? id,
    Expression<int>? nutrientId,
    Expression<String>? sex,
    Expression<int>? ageMin,
    Expression<int>? ageMax,
    Expression<String>? valueType,
    Expression<double>? amount,
    Expression<String>? basis,
    Expression<String>? condition,
    Expression<String>? ulBasis,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nutrientId != null) 'nutrient_id': nutrientId,
      if (sex != null) 'sex': sex,
      if (ageMin != null) 'age_min': ageMin,
      if (ageMax != null) 'age_max': ageMax,
      if (valueType != null) 'value_type': valueType,
      if (amount != null) 'amount': amount,
      if (basis != null) 'basis': basis,
      if (condition != null) 'condition': condition,
      if (ulBasis != null) 'ul_basis': ulBasis,
      if (source != null) 'source': source,
    });
  }

  ReferenceValuesCompanion copyWith({
    Value<int>? id,
    Value<int>? nutrientId,
    Value<String>? sex,
    Value<int>? ageMin,
    Value<int>? ageMax,
    Value<String>? valueType,
    Value<double>? amount,
    Value<String>? basis,
    Value<String>? condition,
    Value<String>? ulBasis,
    Value<String>? source,
  }) {
    return ReferenceValuesCompanion(
      id: id ?? this.id,
      nutrientId: nutrientId ?? this.nutrientId,
      sex: sex ?? this.sex,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      valueType: valueType ?? this.valueType,
      amount: amount ?? this.amount,
      basis: basis ?? this.basis,
      condition: condition ?? this.condition,
      ulBasis: ulBasis ?? this.ulBasis,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nutrientId.present) {
      map['nutrient_id'] = Variable<int>(nutrientId.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (ageMin.present) {
      map['age_min'] = Variable<int>(ageMin.value);
    }
    if (ageMax.present) {
      map['age_max'] = Variable<int>(ageMax.value);
    }
    if (valueType.present) {
      map['value_type'] = Variable<String>(valueType.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (basis.present) {
      map['basis'] = Variable<String>(basis.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (ulBasis.present) {
      map['ul_basis'] = Variable<String>(ulBasis.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReferenceValuesCompanion(')
          ..write('id: $id, ')
          ..write('nutrientId: $nutrientId, ')
          ..write('sex: $sex, ')
          ..write('ageMin: $ageMin, ')
          ..write('ageMax: $ageMax, ')
          ..write('valueType: $valueType, ')
          ..write('amount: $amount, ')
          ..write('basis: $basis, ')
          ..write('condition: $condition, ')
          ..write('ulBasis: $ulBasis, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

class $FoodNotesTable extends FoodNotes
    with TableInfo<$FoodNotesTable, FoodNoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nutriScoreMeta = const VerificationMeta(
    'nutriScore',
  );
  @override
  late final GeneratedColumn<String> nutriScore = GeneratedColumn<String>(
    'nutri_score',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _novaGroupMeta = const VerificationMeta(
    'novaGroup',
  );
  @override
  late final GeneratedColumn<int> novaGroup = GeneratedColumn<int>(
    'nova_group',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _healthRatingMeta = const VerificationMeta(
    'healthRating',
  );
  @override
  late final GeneratedColumn<int> healthRating = GeneratedColumn<int>(
    'health_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _healthReasonMeta = const VerificationMeta(
    'healthReason',
  );
  @override
  late final GeneratedColumn<String> healthReason = GeneratedColumn<String>(
    'health_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _warningTextMeta = const VerificationMeta(
    'warningText',
  );
  @override
  late final GeneratedColumn<String> warningText = GeneratedColumn<String>(
    'warning_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    foodId,
    nutriScore,
    novaGroup,
    healthRating,
    healthReason,
    warningText,
    generatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodNoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    }
    if (data.containsKey('nutri_score')) {
      context.handle(
        _nutriScoreMeta,
        nutriScore.isAcceptableOrUnknown(data['nutri_score']!, _nutriScoreMeta),
      );
    }
    if (data.containsKey('nova_group')) {
      context.handle(
        _novaGroupMeta,
        novaGroup.isAcceptableOrUnknown(data['nova_group']!, _novaGroupMeta),
      );
    }
    if (data.containsKey('health_rating')) {
      context.handle(
        _healthRatingMeta,
        healthRating.isAcceptableOrUnknown(
          data['health_rating']!,
          _healthRatingMeta,
        ),
      );
    }
    if (data.containsKey('health_reason')) {
      context.handle(
        _healthReasonMeta,
        healthReason.isAcceptableOrUnknown(
          data['health_reason']!,
          _healthReasonMeta,
        ),
      );
    }
    if (data.containsKey('warning_text')) {
      context.handle(
        _warningTextMeta,
        warningText.isAcceptableOrUnknown(
          data['warning_text']!,
          _warningTextMeta,
        ),
      );
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {foodId};
  @override
  FoodNoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodNoteRow(
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      )!,
      nutriScore: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nutri_score'],
      ),
      novaGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}nova_group'],
      ),
      healthRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}health_rating'],
      ),
      healthReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}health_reason'],
      ),
      warningText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}warning_text'],
      ),
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      ),
    );
  }

  @override
  $FoodNotesTable createAlias(String alias) {
    return $FoodNotesTable(attachedDatabase, alias);
  }
}

class FoodNoteRow extends DataClass implements Insertable<FoodNoteRow> {
  final int foodId;
  final String? nutriScore;

  /// NOVA group 1–4 (4 = ultra-processed).
  final int? novaGroup;

  /// Claude's absolute health rating 1 (very unhealthy) – 5 (very healthy).
  final int? healthRating;
  final String? healthReason;

  /// Shown on the ranking page when the health rating is poor.
  final String? warningText;
  final DateTime? generatedAt;
  const FoodNoteRow({
    required this.foodId,
    this.nutriScore,
    this.novaGroup,
    this.healthRating,
    this.healthReason,
    this.warningText,
    this.generatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['food_id'] = Variable<int>(foodId);
    if (!nullToAbsent || nutriScore != null) {
      map['nutri_score'] = Variable<String>(nutriScore);
    }
    if (!nullToAbsent || novaGroup != null) {
      map['nova_group'] = Variable<int>(novaGroup);
    }
    if (!nullToAbsent || healthRating != null) {
      map['health_rating'] = Variable<int>(healthRating);
    }
    if (!nullToAbsent || healthReason != null) {
      map['health_reason'] = Variable<String>(healthReason);
    }
    if (!nullToAbsent || warningText != null) {
      map['warning_text'] = Variable<String>(warningText);
    }
    if (!nullToAbsent || generatedAt != null) {
      map['generated_at'] = Variable<DateTime>(generatedAt);
    }
    return map;
  }

  FoodNotesCompanion toCompanion(bool nullToAbsent) {
    return FoodNotesCompanion(
      foodId: Value(foodId),
      nutriScore: nutriScore == null && nullToAbsent
          ? const Value.absent()
          : Value(nutriScore),
      novaGroup: novaGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(novaGroup),
      healthRating: healthRating == null && nullToAbsent
          ? const Value.absent()
          : Value(healthRating),
      healthReason: healthReason == null && nullToAbsent
          ? const Value.absent()
          : Value(healthReason),
      warningText: warningText == null && nullToAbsent
          ? const Value.absent()
          : Value(warningText),
      generatedAt: generatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(generatedAt),
    );
  }

  factory FoodNoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodNoteRow(
      foodId: serializer.fromJson<int>(json['foodId']),
      nutriScore: serializer.fromJson<String?>(json['nutriScore']),
      novaGroup: serializer.fromJson<int?>(json['novaGroup']),
      healthRating: serializer.fromJson<int?>(json['healthRating']),
      healthReason: serializer.fromJson<String?>(json['healthReason']),
      warningText: serializer.fromJson<String?>(json['warningText']),
      generatedAt: serializer.fromJson<DateTime?>(json['generatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'foodId': serializer.toJson<int>(foodId),
      'nutriScore': serializer.toJson<String?>(nutriScore),
      'novaGroup': serializer.toJson<int?>(novaGroup),
      'healthRating': serializer.toJson<int?>(healthRating),
      'healthReason': serializer.toJson<String?>(healthReason),
      'warningText': serializer.toJson<String?>(warningText),
      'generatedAt': serializer.toJson<DateTime?>(generatedAt),
    };
  }

  FoodNoteRow copyWith({
    int? foodId,
    Value<String?> nutriScore = const Value.absent(),
    Value<int?> novaGroup = const Value.absent(),
    Value<int?> healthRating = const Value.absent(),
    Value<String?> healthReason = const Value.absent(),
    Value<String?> warningText = const Value.absent(),
    Value<DateTime?> generatedAt = const Value.absent(),
  }) => FoodNoteRow(
    foodId: foodId ?? this.foodId,
    nutriScore: nutriScore.present ? nutriScore.value : this.nutriScore,
    novaGroup: novaGroup.present ? novaGroup.value : this.novaGroup,
    healthRating: healthRating.present ? healthRating.value : this.healthRating,
    healthReason: healthReason.present ? healthReason.value : this.healthReason,
    warningText: warningText.present ? warningText.value : this.warningText,
    generatedAt: generatedAt.present ? generatedAt.value : this.generatedAt,
  );
  FoodNoteRow copyWithCompanion(FoodNotesCompanion data) {
    return FoodNoteRow(
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      nutriScore: data.nutriScore.present
          ? data.nutriScore.value
          : this.nutriScore,
      novaGroup: data.novaGroup.present ? data.novaGroup.value : this.novaGroup,
      healthRating: data.healthRating.present
          ? data.healthRating.value
          : this.healthRating,
      healthReason: data.healthReason.present
          ? data.healthReason.value
          : this.healthReason,
      warningText: data.warningText.present
          ? data.warningText.value
          : this.warningText,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodNoteRow(')
          ..write('foodId: $foodId, ')
          ..write('nutriScore: $nutriScore, ')
          ..write('novaGroup: $novaGroup, ')
          ..write('healthRating: $healthRating, ')
          ..write('healthReason: $healthReason, ')
          ..write('warningText: $warningText, ')
          ..write('generatedAt: $generatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    foodId,
    nutriScore,
    novaGroup,
    healthRating,
    healthReason,
    warningText,
    generatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodNoteRow &&
          other.foodId == this.foodId &&
          other.nutriScore == this.nutriScore &&
          other.novaGroup == this.novaGroup &&
          other.healthRating == this.healthRating &&
          other.healthReason == this.healthReason &&
          other.warningText == this.warningText &&
          other.generatedAt == this.generatedAt);
}

class FoodNotesCompanion extends UpdateCompanion<FoodNoteRow> {
  final Value<int> foodId;
  final Value<String?> nutriScore;
  final Value<int?> novaGroup;
  final Value<int?> healthRating;
  final Value<String?> healthReason;
  final Value<String?> warningText;
  final Value<DateTime?> generatedAt;
  const FoodNotesCompanion({
    this.foodId = const Value.absent(),
    this.nutriScore = const Value.absent(),
    this.novaGroup = const Value.absent(),
    this.healthRating = const Value.absent(),
    this.healthReason = const Value.absent(),
    this.warningText = const Value.absent(),
    this.generatedAt = const Value.absent(),
  });
  FoodNotesCompanion.insert({
    this.foodId = const Value.absent(),
    this.nutriScore = const Value.absent(),
    this.novaGroup = const Value.absent(),
    this.healthRating = const Value.absent(),
    this.healthReason = const Value.absent(),
    this.warningText = const Value.absent(),
    this.generatedAt = const Value.absent(),
  });
  static Insertable<FoodNoteRow> custom({
    Expression<int>? foodId,
    Expression<String>? nutriScore,
    Expression<int>? novaGroup,
    Expression<int>? healthRating,
    Expression<String>? healthReason,
    Expression<String>? warningText,
    Expression<DateTime>? generatedAt,
  }) {
    return RawValuesInsertable({
      if (foodId != null) 'food_id': foodId,
      if (nutriScore != null) 'nutri_score': nutriScore,
      if (novaGroup != null) 'nova_group': novaGroup,
      if (healthRating != null) 'health_rating': healthRating,
      if (healthReason != null) 'health_reason': healthReason,
      if (warningText != null) 'warning_text': warningText,
      if (generatedAt != null) 'generated_at': generatedAt,
    });
  }

  FoodNotesCompanion copyWith({
    Value<int>? foodId,
    Value<String?>? nutriScore,
    Value<int?>? novaGroup,
    Value<int?>? healthRating,
    Value<String?>? healthReason,
    Value<String?>? warningText,
    Value<DateTime?>? generatedAt,
  }) {
    return FoodNotesCompanion(
      foodId: foodId ?? this.foodId,
      nutriScore: nutriScore ?? this.nutriScore,
      novaGroup: novaGroup ?? this.novaGroup,
      healthRating: healthRating ?? this.healthRating,
      healthReason: healthReason ?? this.healthReason,
      warningText: warningText ?? this.warningText,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (nutriScore.present) {
      map['nutri_score'] = Variable<String>(nutriScore.value);
    }
    if (novaGroup.present) {
      map['nova_group'] = Variable<int>(novaGroup.value);
    }
    if (healthRating.present) {
      map['health_rating'] = Variable<int>(healthRating.value);
    }
    if (healthReason.present) {
      map['health_reason'] = Variable<String>(healthReason.value);
    }
    if (warningText.present) {
      map['warning_text'] = Variable<String>(warningText.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodNotesCompanion(')
          ..write('foodId: $foodId, ')
          ..write('nutriScore: $nutriScore, ')
          ..write('novaGroup: $novaGroup, ')
          ..write('healthRating: $healthRating, ')
          ..write('healthReason: $healthReason, ')
          ..write('warningText: $warningText, ')
          ..write('generatedAt: $generatedAt')
          ..write(')'))
        .toString();
  }
}

class $MetaTable extends Meta with TableInfo<$MetaTable, MetaRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetaRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetaRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetaRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $MetaTable createAlias(String alias) {
    return $MetaTable(attachedDatabase, alias);
  }
}

class MetaRow extends DataClass implements Insertable<MetaRow> {
  final String key;
  final String value;
  const MetaRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  MetaCompanion toCompanion(bool nullToAbsent) {
    return MetaCompanion(key: Value(key), value: Value(value));
  }

  factory MetaRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetaRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  MetaRow copyWith({String? key, String? value}) =>
      MetaRow(key: key ?? this.key, value: value ?? this.value);
  MetaRow copyWithCompanion(MetaCompanion data) {
    return MetaRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetaRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetaRow && other.key == this.key && other.value == this.value);
}

class MetaCompanion extends UpdateCompanion<MetaRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const MetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MetaRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return MetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NutrientsTable nutrients = $NutrientsTable(this);
  late final $FoodsTable foods = $FoodsTable(this);
  late final $FoodNutrientsTable foodNutrients = $FoodNutrientsTable(this);
  late final $LogEntriesTable logEntries = $LogEntriesTable(this);
  late final $RequestsTable requests = $RequestsTable(this);
  late final $SupplementPlansTable supplementPlans = $SupplementPlansTable(
    this,
  );
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $ReferenceValuesTable referenceValues = $ReferenceValuesTable(
    this,
  );
  late final $FoodNotesTable foodNotes = $FoodNotesTable(this);
  late final $MetaTable meta = $MetaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    nutrients,
    foods,
    foodNutrients,
    logEntries,
    requests,
    supplementPlans,
    profiles,
    referenceValues,
    foodNotes,
    meta,
  ];
}

typedef $$NutrientsTableCreateCompanionBuilder =
    NutrientsCompanion Function({
      Value<int> id,
      required String code,
      required String name,
      required String unit,
      required int importanceRank,
      required String targetType,
      required bool hasBar,
      Value<bool> claudeFills,
    });
typedef $$NutrientsTableUpdateCompanionBuilder =
    NutrientsCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> name,
      Value<String> unit,
      Value<int> importanceRank,
      Value<String> targetType,
      Value<bool> hasBar,
      Value<bool> claudeFills,
    });

class $$NutrientsTableFilterComposer
    extends Composer<_$AppDatabase, $NutrientsTable> {
  $$NutrientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get importanceRank => $composableBuilder(
    column: $table.importanceRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasBar => $composableBuilder(
    column: $table.hasBar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get claudeFills => $composableBuilder(
    column: $table.claudeFills,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NutrientsTableOrderingComposer
    extends Composer<_$AppDatabase, $NutrientsTable> {
  $$NutrientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get importanceRank => $composableBuilder(
    column: $table.importanceRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasBar => $composableBuilder(
    column: $table.hasBar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get claudeFills => $composableBuilder(
    column: $table.claudeFills,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NutrientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutrientsTable> {
  $$NutrientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get importanceRank => $composableBuilder(
    column: $table.importanceRank,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetType => $composableBuilder(
    column: $table.targetType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasBar =>
      $composableBuilder(column: $table.hasBar, builder: (column) => column);

  GeneratedColumn<bool> get claudeFills => $composableBuilder(
    column: $table.claudeFills,
    builder: (column) => column,
  );
}

class $$NutrientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NutrientsTable,
          NutrientRow,
          $$NutrientsTableFilterComposer,
          $$NutrientsTableOrderingComposer,
          $$NutrientsTableAnnotationComposer,
          $$NutrientsTableCreateCompanionBuilder,
          $$NutrientsTableUpdateCompanionBuilder,
          (
            NutrientRow,
            BaseReferences<_$AppDatabase, $NutrientsTable, NutrientRow>,
          ),
          NutrientRow,
          PrefetchHooks Function()
        > {
  $$NutrientsTableTableManager(_$AppDatabase db, $NutrientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutrientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NutrientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutrientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> importanceRank = const Value.absent(),
                Value<String> targetType = const Value.absent(),
                Value<bool> hasBar = const Value.absent(),
                Value<bool> claudeFills = const Value.absent(),
              }) => NutrientsCompanion(
                id: id,
                code: code,
                name: name,
                unit: unit,
                importanceRank: importanceRank,
                targetType: targetType,
                hasBar: hasBar,
                claudeFills: claudeFills,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String name,
                required String unit,
                required int importanceRank,
                required String targetType,
                required bool hasBar,
                Value<bool> claudeFills = const Value.absent(),
              }) => NutrientsCompanion.insert(
                id: id,
                code: code,
                name: name,
                unit: unit,
                importanceRank: importanceRank,
                targetType: targetType,
                hasBar: hasBar,
                claudeFills: claudeFills,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NutrientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NutrientsTable,
      NutrientRow,
      $$NutrientsTableFilterComposer,
      $$NutrientsTableOrderingComposer,
      $$NutrientsTableAnnotationComposer,
      $$NutrientsTableCreateCompanionBuilder,
      $$NutrientsTableUpdateCompanionBuilder,
      (
        NutrientRow,
        BaseReferences<_$AppDatabase, $NutrientsTable, NutrientRow>,
      ),
      NutrientRow,
      PrefetchHooks Function()
    >;
typedef $$FoodsTableCreateCompanionBuilder =
    FoodsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> nameDe,
      required String source,
      Value<String?> sourceRef,
      Value<String?> barcode,
      Value<String?> foodGroup,
      Value<double?> defaultServingG,
      Value<String?> servingLabel,
      Value<double?> packageQuantity,
      Value<String?> packageUnit,
      Value<String> amountUnit,
      Value<bool> isCommon,
      Value<String?> nutriscoreCategory,
      Value<double?> fvlPercent,
      Value<bool?> nonNutritiveSweeteners,
      Value<String> enrichment,
    });
typedef $$FoodsTableUpdateCompanionBuilder =
    FoodsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> nameDe,
      Value<String> source,
      Value<String?> sourceRef,
      Value<String?> barcode,
      Value<String?> foodGroup,
      Value<double?> defaultServingG,
      Value<String?> servingLabel,
      Value<double?> packageQuantity,
      Value<String?> packageUnit,
      Value<String> amountUnit,
      Value<bool> isCommon,
      Value<String?> nutriscoreCategory,
      Value<double?> fvlPercent,
      Value<bool?> nonNutritiveSweeteners,
      Value<String> enrichment,
    });

class $$FoodsTableFilterComposer extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameDe => $composableBuilder(
    column: $table.nameDe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceRef => $composableBuilder(
    column: $table.sourceRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodGroup => $composableBuilder(
    column: $table.foodGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultServingG => $composableBuilder(
    column: $table.defaultServingG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get servingLabel => $composableBuilder(
    column: $table.servingLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get packageQuantity => $composableBuilder(
    column: $table.packageQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageUnit => $composableBuilder(
    column: $table.packageUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get amountUnit => $composableBuilder(
    column: $table.amountUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCommon => $composableBuilder(
    column: $table.isCommon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nutriscoreCategory => $composableBuilder(
    column: $table.nutriscoreCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fvlPercent => $composableBuilder(
    column: $table.fvlPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get nonNutritiveSweeteners => $composableBuilder(
    column: $table.nonNutritiveSweeteners,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enrichment => $composableBuilder(
    column: $table.enrichment,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameDe => $composableBuilder(
    column: $table.nameDe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceRef => $composableBuilder(
    column: $table.sourceRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodGroup => $composableBuilder(
    column: $table.foodGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultServingG => $composableBuilder(
    column: $table.defaultServingG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get servingLabel => $composableBuilder(
    column: $table.servingLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get packageQuantity => $composableBuilder(
    column: $table.packageQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageUnit => $composableBuilder(
    column: $table.packageUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get amountUnit => $composableBuilder(
    column: $table.amountUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCommon => $composableBuilder(
    column: $table.isCommon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nutriscoreCategory => $composableBuilder(
    column: $table.nutriscoreCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fvlPercent => $composableBuilder(
    column: $table.fvlPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get nonNutritiveSweeteners => $composableBuilder(
    column: $table.nonNutritiveSweeteners,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enrichment => $composableBuilder(
    column: $table.enrichment,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nameDe =>
      $composableBuilder(column: $table.nameDe, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get sourceRef =>
      $composableBuilder(column: $table.sourceRef, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get foodGroup =>
      $composableBuilder(column: $table.foodGroup, builder: (column) => column);

  GeneratedColumn<double> get defaultServingG => $composableBuilder(
    column: $table.defaultServingG,
    builder: (column) => column,
  );

  GeneratedColumn<String> get servingLabel => $composableBuilder(
    column: $table.servingLabel,
    builder: (column) => column,
  );

  GeneratedColumn<double> get packageQuantity => $composableBuilder(
    column: $table.packageQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get packageUnit => $composableBuilder(
    column: $table.packageUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get amountUnit => $composableBuilder(
    column: $table.amountUnit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCommon =>
      $composableBuilder(column: $table.isCommon, builder: (column) => column);

  GeneratedColumn<String> get nutriscoreCategory => $composableBuilder(
    column: $table.nutriscoreCategory,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fvlPercent => $composableBuilder(
    column: $table.fvlPercent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get nonNutritiveSweeteners => $composableBuilder(
    column: $table.nonNutritiveSweeteners,
    builder: (column) => column,
  );

  GeneratedColumn<String> get enrichment => $composableBuilder(
    column: $table.enrichment,
    builder: (column) => column,
  );
}

class $$FoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodsTable,
          FoodRow,
          $$FoodsTableFilterComposer,
          $$FoodsTableOrderingComposer,
          $$FoodsTableAnnotationComposer,
          $$FoodsTableCreateCompanionBuilder,
          $$FoodsTableUpdateCompanionBuilder,
          (FoodRow, BaseReferences<_$AppDatabase, $FoodsTable, FoodRow>),
          FoodRow,
          PrefetchHooks Function()
        > {
  $$FoodsTableTableManager(_$AppDatabase db, $FoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nameDe = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> sourceRef = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> foodGroup = const Value.absent(),
                Value<double?> defaultServingG = const Value.absent(),
                Value<String?> servingLabel = const Value.absent(),
                Value<double?> packageQuantity = const Value.absent(),
                Value<String?> packageUnit = const Value.absent(),
                Value<String> amountUnit = const Value.absent(),
                Value<bool> isCommon = const Value.absent(),
                Value<String?> nutriscoreCategory = const Value.absent(),
                Value<double?> fvlPercent = const Value.absent(),
                Value<bool?> nonNutritiveSweeteners = const Value.absent(),
                Value<String> enrichment = const Value.absent(),
              }) => FoodsCompanion(
                id: id,
                name: name,
                nameDe: nameDe,
                source: source,
                sourceRef: sourceRef,
                barcode: barcode,
                foodGroup: foodGroup,
                defaultServingG: defaultServingG,
                servingLabel: servingLabel,
                packageQuantity: packageQuantity,
                packageUnit: packageUnit,
                amountUnit: amountUnit,
                isCommon: isCommon,
                nutriscoreCategory: nutriscoreCategory,
                fvlPercent: fvlPercent,
                nonNutritiveSweeteners: nonNutritiveSweeteners,
                enrichment: enrichment,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> nameDe = const Value.absent(),
                required String source,
                Value<String?> sourceRef = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> foodGroup = const Value.absent(),
                Value<double?> defaultServingG = const Value.absent(),
                Value<String?> servingLabel = const Value.absent(),
                Value<double?> packageQuantity = const Value.absent(),
                Value<String?> packageUnit = const Value.absent(),
                Value<String> amountUnit = const Value.absent(),
                Value<bool> isCommon = const Value.absent(),
                Value<String?> nutriscoreCategory = const Value.absent(),
                Value<double?> fvlPercent = const Value.absent(),
                Value<bool?> nonNutritiveSweeteners = const Value.absent(),
                Value<String> enrichment = const Value.absent(),
              }) => FoodsCompanion.insert(
                id: id,
                name: name,
                nameDe: nameDe,
                source: source,
                sourceRef: sourceRef,
                barcode: barcode,
                foodGroup: foodGroup,
                defaultServingG: defaultServingG,
                servingLabel: servingLabel,
                packageQuantity: packageQuantity,
                packageUnit: packageUnit,
                amountUnit: amountUnit,
                isCommon: isCommon,
                nutriscoreCategory: nutriscoreCategory,
                fvlPercent: fvlPercent,
                nonNutritiveSweeteners: nonNutritiveSweeteners,
                enrichment: enrichment,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodsTable,
      FoodRow,
      $$FoodsTableFilterComposer,
      $$FoodsTableOrderingComposer,
      $$FoodsTableAnnotationComposer,
      $$FoodsTableCreateCompanionBuilder,
      $$FoodsTableUpdateCompanionBuilder,
      (FoodRow, BaseReferences<_$AppDatabase, $FoodsTable, FoodRow>),
      FoodRow,
      PrefetchHooks Function()
    >;
typedef $$FoodNutrientsTableCreateCompanionBuilder =
    FoodNutrientsCompanion Function({
      required int foodId,
      required int nutrientId,
      required double amountPer100,
      Value<String?> source,
      Value<int> rowid,
    });
typedef $$FoodNutrientsTableUpdateCompanionBuilder =
    FoodNutrientsCompanion Function({
      Value<int> foodId,
      Value<int> nutrientId,
      Value<double> amountPer100,
      Value<String?> source,
      Value<int> rowid,
    });

class $$FoodNutrientsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodNutrientsTable> {
  $$FoodNutrientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nutrientId => $composableBuilder(
    column: $table.nutrientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountPer100 => $composableBuilder(
    column: $table.amountPer100,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodNutrientsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodNutrientsTable> {
  $$FoodNutrientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nutrientId => $composableBuilder(
    column: $table.nutrientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountPer100 => $composableBuilder(
    column: $table.amountPer100,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodNutrientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodNutrientsTable> {
  $$FoodNutrientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<int> get nutrientId => $composableBuilder(
    column: $table.nutrientId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountPer100 => $composableBuilder(
    column: $table.amountPer100,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$FoodNutrientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodNutrientsTable,
          FoodNutrientRow,
          $$FoodNutrientsTableFilterComposer,
          $$FoodNutrientsTableOrderingComposer,
          $$FoodNutrientsTableAnnotationComposer,
          $$FoodNutrientsTableCreateCompanionBuilder,
          $$FoodNutrientsTableUpdateCompanionBuilder,
          (
            FoodNutrientRow,
            BaseReferences<_$AppDatabase, $FoodNutrientsTable, FoodNutrientRow>,
          ),
          FoodNutrientRow,
          PrefetchHooks Function()
        > {
  $$FoodNutrientsTableTableManager(_$AppDatabase db, $FoodNutrientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodNutrientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodNutrientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodNutrientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> foodId = const Value.absent(),
                Value<int> nutrientId = const Value.absent(),
                Value<double> amountPer100 = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodNutrientsCompanion(
                foodId: foodId,
                nutrientId: nutrientId,
                amountPer100: amountPer100,
                source: source,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int foodId,
                required int nutrientId,
                required double amountPer100,
                Value<String?> source = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodNutrientsCompanion.insert(
                foodId: foodId,
                nutrientId: nutrientId,
                amountPer100: amountPer100,
                source: source,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodNutrientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodNutrientsTable,
      FoodNutrientRow,
      $$FoodNutrientsTableFilterComposer,
      $$FoodNutrientsTableOrderingComposer,
      $$FoodNutrientsTableAnnotationComposer,
      $$FoodNutrientsTableCreateCompanionBuilder,
      $$FoodNutrientsTableUpdateCompanionBuilder,
      (
        FoodNutrientRow,
        BaseReferences<_$AppDatabase, $FoodNutrientsTable, FoodNutrientRow>,
      ),
      FoodNutrientRow,
      PrefetchHooks Function()
    >;
typedef $$LogEntriesTableCreateCompanionBuilder =
    LogEntriesCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required int foodId,
      required double grams,
      required String inputSource,
      Value<String?> rawInput,
      Value<double?> confidence,
      Value<String?> requestId,
      Value<int?> supplementPlanId,
    });
typedef $$LogEntriesTableUpdateCompanionBuilder =
    LogEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<int> foodId,
      Value<double> grams,
      Value<String> inputSource,
      Value<String?> rawInput,
      Value<double?> confidence,
      Value<String?> requestId,
      Value<int?> supplementPlanId,
    });

class $$LogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LogEntriesTable> {
  $$LogEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputSource => $composableBuilder(
    column: $table.inputSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawInput => $composableBuilder(
    column: $table.rawInput,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestId => $composableBuilder(
    column: $table.requestId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get supplementPlanId => $composableBuilder(
    column: $table.supplementPlanId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LogEntriesTable> {
  $$LogEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputSource => $composableBuilder(
    column: $table.inputSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawInput => $composableBuilder(
    column: $table.rawInput,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestId => $composableBuilder(
    column: $table.requestId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get supplementPlanId => $composableBuilder(
    column: $table.supplementPlanId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LogEntriesTable> {
  $$LogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<double> get grams =>
      $composableBuilder(column: $table.grams, builder: (column) => column);

  GeneratedColumn<String> get inputSource => $composableBuilder(
    column: $table.inputSource,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rawInput =>
      $composableBuilder(column: $table.rawInput, builder: (column) => column);

  GeneratedColumn<double> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requestId =>
      $composableBuilder(column: $table.requestId, builder: (column) => column);

  GeneratedColumn<int> get supplementPlanId => $composableBuilder(
    column: $table.supplementPlanId,
    builder: (column) => column,
  );
}

class $$LogEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LogEntriesTable,
          LogEntryRow,
          $$LogEntriesTableFilterComposer,
          $$LogEntriesTableOrderingComposer,
          $$LogEntriesTableAnnotationComposer,
          $$LogEntriesTableCreateCompanionBuilder,
          $$LogEntriesTableUpdateCompanionBuilder,
          (
            LogEntryRow,
            BaseReferences<_$AppDatabase, $LogEntriesTable, LogEntryRow>,
          ),
          LogEntryRow,
          PrefetchHooks Function()
        > {
  $$LogEntriesTableTableManager(_$AppDatabase db, $LogEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LogEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LogEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LogEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> foodId = const Value.absent(),
                Value<double> grams = const Value.absent(),
                Value<String> inputSource = const Value.absent(),
                Value<String?> rawInput = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> requestId = const Value.absent(),
                Value<int?> supplementPlanId = const Value.absent(),
              }) => LogEntriesCompanion(
                id: id,
                timestamp: timestamp,
                foodId: foodId,
                grams: grams,
                inputSource: inputSource,
                rawInput: rawInput,
                confidence: confidence,
                requestId: requestId,
                supplementPlanId: supplementPlanId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required int foodId,
                required double grams,
                required String inputSource,
                Value<String?> rawInput = const Value.absent(),
                Value<double?> confidence = const Value.absent(),
                Value<String?> requestId = const Value.absent(),
                Value<int?> supplementPlanId = const Value.absent(),
              }) => LogEntriesCompanion.insert(
                id: id,
                timestamp: timestamp,
                foodId: foodId,
                grams: grams,
                inputSource: inputSource,
                rawInput: rawInput,
                confidence: confidence,
                requestId: requestId,
                supplementPlanId: supplementPlanId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LogEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LogEntriesTable,
      LogEntryRow,
      $$LogEntriesTableFilterComposer,
      $$LogEntriesTableOrderingComposer,
      $$LogEntriesTableAnnotationComposer,
      $$LogEntriesTableCreateCompanionBuilder,
      $$LogEntriesTableUpdateCompanionBuilder,
      (
        LogEntryRow,
        BaseReferences<_$AppDatabase, $LogEntriesTable, LogEntryRow>,
      ),
      LogEntryRow,
      PrefetchHooks Function()
    >;
typedef $$RequestsTableCreateCompanionBuilder =
    RequestsCompanion Function({
      required String id,
      required String type,
      required DateTime createdAt,
      required String status,
      Value<int> attempts,
      Value<String?> lastError,
      Value<String?> rawInput,
      Value<String?> imagePath,
      required String payload,
      Value<String?> inputSource,
      Value<DateTime?> firedAt,
      Value<DateTime?> nextAttemptAt,
      Value<int?> foodId,
      Value<DateTime?> logAt,
      Value<String?> resultNote,
      Value<bool> dismissed,
      Value<int> rowid,
    });
typedef $$RequestsTableUpdateCompanionBuilder =
    RequestsCompanion Function({
      Value<String> id,
      Value<String> type,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<int> attempts,
      Value<String?> lastError,
      Value<String?> rawInput,
      Value<String?> imagePath,
      Value<String> payload,
      Value<String?> inputSource,
      Value<DateTime?> firedAt,
      Value<DateTime?> nextAttemptAt,
      Value<int?> foodId,
      Value<DateTime?> logAt,
      Value<String?> resultNote,
      Value<bool> dismissed,
      Value<int> rowid,
    });

class $$RequestsTableFilterComposer
    extends Composer<_$AppDatabase, $RequestsTable> {
  $$RequestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawInput => $composableBuilder(
    column: $table.rawInput,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputSource => $composableBuilder(
    column: $table.inputSource,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firedAt => $composableBuilder(
    column: $table.firedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get logAt => $composableBuilder(
    column: $table.logAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultNote => $composableBuilder(
    column: $table.resultNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dismissed => $composableBuilder(
    column: $table.dismissed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RequestsTableOrderingComposer
    extends Composer<_$AppDatabase, $RequestsTable> {
  $$RequestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawInput => $composableBuilder(
    column: $table.rawInput,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputSource => $composableBuilder(
    column: $table.inputSource,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firedAt => $composableBuilder(
    column: $table.firedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get logAt => $composableBuilder(
    column: $table.logAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultNote => $composableBuilder(
    column: $table.resultNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dismissed => $composableBuilder(
    column: $table.dismissed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RequestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RequestsTable> {
  $$RequestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get rawInput =>
      $composableBuilder(column: $table.rawInput, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get inputSource => $composableBuilder(
    column: $table.inputSource,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get firedAt =>
      $composableBuilder(column: $table.firedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<DateTime> get logAt =>
      $composableBuilder(column: $table.logAt, builder: (column) => column);

  GeneratedColumn<String> get resultNote => $composableBuilder(
    column: $table.resultNote,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dismissed =>
      $composableBuilder(column: $table.dismissed, builder: (column) => column);
}

class $$RequestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RequestsTable,
          RequestRow,
          $$RequestsTableFilterComposer,
          $$RequestsTableOrderingComposer,
          $$RequestsTableAnnotationComposer,
          $$RequestsTableCreateCompanionBuilder,
          $$RequestsTableUpdateCompanionBuilder,
          (
            RequestRow,
            BaseReferences<_$AppDatabase, $RequestsTable, RequestRow>,
          ),
          RequestRow,
          PrefetchHooks Function()
        > {
  $$RequestsTableTableManager(_$AppDatabase db, $RequestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RequestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RequestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RequestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> rawInput = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String?> inputSource = const Value.absent(),
                Value<DateTime?> firedAt = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<int?> foodId = const Value.absent(),
                Value<DateTime?> logAt = const Value.absent(),
                Value<String?> resultNote = const Value.absent(),
                Value<bool> dismissed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RequestsCompanion(
                id: id,
                type: type,
                createdAt: createdAt,
                status: status,
                attempts: attempts,
                lastError: lastError,
                rawInput: rawInput,
                imagePath: imagePath,
                payload: payload,
                inputSource: inputSource,
                firedAt: firedAt,
                nextAttemptAt: nextAttemptAt,
                foodId: foodId,
                logAt: logAt,
                resultNote: resultNote,
                dismissed: dismissed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String type,
                required DateTime createdAt,
                required String status,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String?> rawInput = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                required String payload,
                Value<String?> inputSource = const Value.absent(),
                Value<DateTime?> firedAt = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<int?> foodId = const Value.absent(),
                Value<DateTime?> logAt = const Value.absent(),
                Value<String?> resultNote = const Value.absent(),
                Value<bool> dismissed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RequestsCompanion.insert(
                id: id,
                type: type,
                createdAt: createdAt,
                status: status,
                attempts: attempts,
                lastError: lastError,
                rawInput: rawInput,
                imagePath: imagePath,
                payload: payload,
                inputSource: inputSource,
                firedAt: firedAt,
                nextAttemptAt: nextAttemptAt,
                foodId: foodId,
                logAt: logAt,
                resultNote: resultNote,
                dismissed: dismissed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RequestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RequestsTable,
      RequestRow,
      $$RequestsTableFilterComposer,
      $$RequestsTableOrderingComposer,
      $$RequestsTableAnnotationComposer,
      $$RequestsTableCreateCompanionBuilder,
      $$RequestsTableUpdateCompanionBuilder,
      (RequestRow, BaseReferences<_$AppDatabase, $RequestsTable, RequestRow>),
      RequestRow,
      PrefetchHooks Function()
    >;
typedef $$SupplementPlansTableCreateCompanionBuilder =
    SupplementPlansCompanion Function({
      Value<int> id,
      required int foodId,
      required double amount,
      required String unit,
      Value<bool> active,
      required DateTime startDate,
      Value<String?> rawInput,
    });
typedef $$SupplementPlansTableUpdateCompanionBuilder =
    SupplementPlansCompanion Function({
      Value<int> id,
      Value<int> foodId,
      Value<double> amount,
      Value<String> unit,
      Value<bool> active,
      Value<DateTime> startDate,
      Value<String?> rawInput,
    });

class $$SupplementPlansTableFilterComposer
    extends Composer<_$AppDatabase, $SupplementPlansTable> {
  $$SupplementPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rawInput => $composableBuilder(
    column: $table.rawInput,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupplementPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplementPlansTable> {
  $$SupplementPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawInput => $composableBuilder(
    column: $table.rawInput,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplementPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplementPlansTable> {
  $$SupplementPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get rawInput =>
      $composableBuilder(column: $table.rawInput, builder: (column) => column);
}

class $$SupplementPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplementPlansTable,
          SupplementPlanRow,
          $$SupplementPlansTableFilterComposer,
          $$SupplementPlansTableOrderingComposer,
          $$SupplementPlansTableAnnotationComposer,
          $$SupplementPlansTableCreateCompanionBuilder,
          $$SupplementPlansTableUpdateCompanionBuilder,
          (
            SupplementPlanRow,
            BaseReferences<
              _$AppDatabase,
              $SupplementPlansTable,
              SupplementPlanRow
            >,
          ),
          SupplementPlanRow,
          PrefetchHooks Function()
        > {
  $$SupplementPlansTableTableManager(
    _$AppDatabase db,
    $SupplementPlansTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplementPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplementPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplementPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> foodId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<String?> rawInput = const Value.absent(),
              }) => SupplementPlansCompanion(
                id: id,
                foodId: foodId,
                amount: amount,
                unit: unit,
                active: active,
                startDate: startDate,
                rawInput: rawInput,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int foodId,
                required double amount,
                required String unit,
                Value<bool> active = const Value.absent(),
                required DateTime startDate,
                Value<String?> rawInput = const Value.absent(),
              }) => SupplementPlansCompanion.insert(
                id: id,
                foodId: foodId,
                amount: amount,
                unit: unit,
                active: active,
                startDate: startDate,
                rawInput: rawInput,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SupplementPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplementPlansTable,
      SupplementPlanRow,
      $$SupplementPlansTableFilterComposer,
      $$SupplementPlansTableOrderingComposer,
      $$SupplementPlansTableAnnotationComposer,
      $$SupplementPlansTableCreateCompanionBuilder,
      $$SupplementPlansTableUpdateCompanionBuilder,
      (
        SupplementPlanRow,
        BaseReferences<_$AppDatabase, $SupplementPlansTable, SupplementPlanRow>,
      ),
      SupplementPlanRow,
      PrefetchHooks Function()
    >;
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      required String sex,
      required int age,
      required double heightCm,
      required double weightKg,
      required String activityLevel,
      Value<String> ironStatus,
      Value<String> phytate,
      required DateTime updatedAt,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      Value<String> sex,
      Value<int> age,
      Value<double> heightCm,
      Value<double> weightKg,
      Value<String> activityLevel,
      Value<String> ironStatus,
      Value<String> phytate,
      Value<DateTime> updatedAt,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ironStatus => $composableBuilder(
    column: $table.ironStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phytate => $composableBuilder(
    column: $table.phytate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ironStatus => $composableBuilder(
    column: $table.ironStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phytate => $composableBuilder(
    column: $table.phytate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ironStatus => $composableBuilder(
    column: $table.ironStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phytate =>
      $composableBuilder(column: $table.phytate, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<String> activityLevel = const Value.absent(),
                Value<String> ironStatus = const Value.absent(),
                Value<String> phytate = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                sex: sex,
                age: age,
                heightCm: heightCm,
                weightKg: weightKg,
                activityLevel: activityLevel,
                ironStatus: ironStatus,
                phytate: phytate,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sex,
                required int age,
                required double heightCm,
                required double weightKg,
                required String activityLevel,
                Value<String> ironStatus = const Value.absent(),
                Value<String> phytate = const Value.absent(),
                required DateTime updatedAt,
              }) => ProfilesCompanion.insert(
                id: id,
                sex: sex,
                age: age,
                heightCm: heightCm,
                weightKg: weightKg,
                activityLevel: activityLevel,
                ironStatus: ironStatus,
                phytate: phytate,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow>),
      ProfileRow,
      PrefetchHooks Function()
    >;
typedef $$ReferenceValuesTableCreateCompanionBuilder =
    ReferenceValuesCompanion Function({
      Value<int> id,
      required int nutrientId,
      required String sex,
      required int ageMin,
      required int ageMax,
      required String valueType,
      required double amount,
      required String basis,
      required String condition,
      required String ulBasis,
      required String source,
    });
typedef $$ReferenceValuesTableUpdateCompanionBuilder =
    ReferenceValuesCompanion Function({
      Value<int> id,
      Value<int> nutrientId,
      Value<String> sex,
      Value<int> ageMin,
      Value<int> ageMax,
      Value<String> valueType,
      Value<double> amount,
      Value<String> basis,
      Value<String> condition,
      Value<String> ulBasis,
      Value<String> source,
    });

class $$ReferenceValuesTableFilterComposer
    extends Composer<_$AppDatabase, $ReferenceValuesTable> {
  $$ReferenceValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nutrientId => $composableBuilder(
    column: $table.nutrientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ageMin => $composableBuilder(
    column: $table.ageMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ageMax => $composableBuilder(
    column: $table.ageMax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get basis => $composableBuilder(
    column: $table.basis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ulBasis => $composableBuilder(
    column: $table.ulBasis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReferenceValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReferenceValuesTable> {
  $$ReferenceValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nutrientId => $composableBuilder(
    column: $table.nutrientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ageMin => $composableBuilder(
    column: $table.ageMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ageMax => $composableBuilder(
    column: $table.ageMax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get basis => $composableBuilder(
    column: $table.basis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ulBasis => $composableBuilder(
    column: $table.ulBasis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReferenceValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReferenceValuesTable> {
  $$ReferenceValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get nutrientId => $composableBuilder(
    column: $table.nutrientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<int> get ageMin =>
      $composableBuilder(column: $table.ageMin, builder: (column) => column);

  GeneratedColumn<int> get ageMax =>
      $composableBuilder(column: $table.ageMax, builder: (column) => column);

  GeneratedColumn<String> get valueType =>
      $composableBuilder(column: $table.valueType, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get basis =>
      $composableBuilder(column: $table.basis, builder: (column) => column);

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<String> get ulBasis =>
      $composableBuilder(column: $table.ulBasis, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$ReferenceValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReferenceValuesTable,
          ReferenceValueRow,
          $$ReferenceValuesTableFilterComposer,
          $$ReferenceValuesTableOrderingComposer,
          $$ReferenceValuesTableAnnotationComposer,
          $$ReferenceValuesTableCreateCompanionBuilder,
          $$ReferenceValuesTableUpdateCompanionBuilder,
          (
            ReferenceValueRow,
            BaseReferences<
              _$AppDatabase,
              $ReferenceValuesTable,
              ReferenceValueRow
            >,
          ),
          ReferenceValueRow,
          PrefetchHooks Function()
        > {
  $$ReferenceValuesTableTableManager(
    _$AppDatabase db,
    $ReferenceValuesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReferenceValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReferenceValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReferenceValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> nutrientId = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<int> ageMin = const Value.absent(),
                Value<int> ageMax = const Value.absent(),
                Value<String> valueType = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> basis = const Value.absent(),
                Value<String> condition = const Value.absent(),
                Value<String> ulBasis = const Value.absent(),
                Value<String> source = const Value.absent(),
              }) => ReferenceValuesCompanion(
                id: id,
                nutrientId: nutrientId,
                sex: sex,
                ageMin: ageMin,
                ageMax: ageMax,
                valueType: valueType,
                amount: amount,
                basis: basis,
                condition: condition,
                ulBasis: ulBasis,
                source: source,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int nutrientId,
                required String sex,
                required int ageMin,
                required int ageMax,
                required String valueType,
                required double amount,
                required String basis,
                required String condition,
                required String ulBasis,
                required String source,
              }) => ReferenceValuesCompanion.insert(
                id: id,
                nutrientId: nutrientId,
                sex: sex,
                ageMin: ageMin,
                ageMax: ageMax,
                valueType: valueType,
                amount: amount,
                basis: basis,
                condition: condition,
                ulBasis: ulBasis,
                source: source,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReferenceValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReferenceValuesTable,
      ReferenceValueRow,
      $$ReferenceValuesTableFilterComposer,
      $$ReferenceValuesTableOrderingComposer,
      $$ReferenceValuesTableAnnotationComposer,
      $$ReferenceValuesTableCreateCompanionBuilder,
      $$ReferenceValuesTableUpdateCompanionBuilder,
      (
        ReferenceValueRow,
        BaseReferences<_$AppDatabase, $ReferenceValuesTable, ReferenceValueRow>,
      ),
      ReferenceValueRow,
      PrefetchHooks Function()
    >;
typedef $$FoodNotesTableCreateCompanionBuilder =
    FoodNotesCompanion Function({
      Value<int> foodId,
      Value<String?> nutriScore,
      Value<int?> novaGroup,
      Value<int?> healthRating,
      Value<String?> healthReason,
      Value<String?> warningText,
      Value<DateTime?> generatedAt,
    });
typedef $$FoodNotesTableUpdateCompanionBuilder =
    FoodNotesCompanion Function({
      Value<int> foodId,
      Value<String?> nutriScore,
      Value<int?> novaGroup,
      Value<int?> healthRating,
      Value<String?> healthReason,
      Value<String?> warningText,
      Value<DateTime?> generatedAt,
    });

class $$FoodNotesTableFilterComposer
    extends Composer<_$AppDatabase, $FoodNotesTable> {
  $$FoodNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nutriScore => $composableBuilder(
    column: $table.nutriScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get novaGroup => $composableBuilder(
    column: $table.novaGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get healthRating => $composableBuilder(
    column: $table.healthRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get healthReason => $composableBuilder(
    column: $table.healthReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get warningText => $composableBuilder(
    column: $table.warningText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FoodNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodNotesTable> {
  $$FoodNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get foodId => $composableBuilder(
    column: $table.foodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nutriScore => $composableBuilder(
    column: $table.nutriScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get novaGroup => $composableBuilder(
    column: $table.novaGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get healthRating => $composableBuilder(
    column: $table.healthRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get healthReason => $composableBuilder(
    column: $table.healthReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get warningText => $composableBuilder(
    column: $table.warningText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodNotesTable> {
  $$FoodNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get nutriScore => $composableBuilder(
    column: $table.nutriScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get novaGroup =>
      $composableBuilder(column: $table.novaGroup, builder: (column) => column);

  GeneratedColumn<int> get healthRating => $composableBuilder(
    column: $table.healthRating,
    builder: (column) => column,
  );

  GeneratedColumn<String> get healthReason => $composableBuilder(
    column: $table.healthReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get warningText => $composableBuilder(
    column: $table.warningText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );
}

class $$FoodNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodNotesTable,
          FoodNoteRow,
          $$FoodNotesTableFilterComposer,
          $$FoodNotesTableOrderingComposer,
          $$FoodNotesTableAnnotationComposer,
          $$FoodNotesTableCreateCompanionBuilder,
          $$FoodNotesTableUpdateCompanionBuilder,
          (
            FoodNoteRow,
            BaseReferences<_$AppDatabase, $FoodNotesTable, FoodNoteRow>,
          ),
          FoodNoteRow,
          PrefetchHooks Function()
        > {
  $$FoodNotesTableTableManager(_$AppDatabase db, $FoodNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> foodId = const Value.absent(),
                Value<String?> nutriScore = const Value.absent(),
                Value<int?> novaGroup = const Value.absent(),
                Value<int?> healthRating = const Value.absent(),
                Value<String?> healthReason = const Value.absent(),
                Value<String?> warningText = const Value.absent(),
                Value<DateTime?> generatedAt = const Value.absent(),
              }) => FoodNotesCompanion(
                foodId: foodId,
                nutriScore: nutriScore,
                novaGroup: novaGroup,
                healthRating: healthRating,
                healthReason: healthReason,
                warningText: warningText,
                generatedAt: generatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> foodId = const Value.absent(),
                Value<String?> nutriScore = const Value.absent(),
                Value<int?> novaGroup = const Value.absent(),
                Value<int?> healthRating = const Value.absent(),
                Value<String?> healthReason = const Value.absent(),
                Value<String?> warningText = const Value.absent(),
                Value<DateTime?> generatedAt = const Value.absent(),
              }) => FoodNotesCompanion.insert(
                foodId: foodId,
                nutriScore: nutriScore,
                novaGroup: novaGroup,
                healthRating: healthRating,
                healthReason: healthReason,
                warningText: warningText,
                generatedAt: generatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FoodNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodNotesTable,
      FoodNoteRow,
      $$FoodNotesTableFilterComposer,
      $$FoodNotesTableOrderingComposer,
      $$FoodNotesTableAnnotationComposer,
      $$FoodNotesTableCreateCompanionBuilder,
      $$FoodNotesTableUpdateCompanionBuilder,
      (
        FoodNoteRow,
        BaseReferences<_$AppDatabase, $FoodNotesTable, FoodNoteRow>,
      ),
      FoodNoteRow,
      PrefetchHooks Function()
    >;
typedef $$MetaTableCreateCompanionBuilder =
    MetaCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$MetaTableUpdateCompanionBuilder =
    MetaCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$MetaTableFilterComposer extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetaTableOrderingComposer extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$MetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetaTable,
          MetaRow,
          $$MetaTableFilterComposer,
          $$MetaTableOrderingComposer,
          $$MetaTableAnnotationComposer,
          $$MetaTableCreateCompanionBuilder,
          $$MetaTableUpdateCompanionBuilder,
          (MetaRow, BaseReferences<_$AppDatabase, $MetaTable, MetaRow>),
          MetaRow,
          PrefetchHooks Function()
        > {
  $$MetaTableTableManager(_$AppDatabase db, $MetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => MetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetaTable,
      MetaRow,
      $$MetaTableFilterComposer,
      $$MetaTableOrderingComposer,
      $$MetaTableAnnotationComposer,
      $$MetaTableCreateCompanionBuilder,
      $$MetaTableUpdateCompanionBuilder,
      (MetaRow, BaseReferences<_$AppDatabase, $MetaTable, MetaRow>),
      MetaRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NutrientsTableTableManager get nutrients =>
      $$NutrientsTableTableManager(_db, _db.nutrients);
  $$FoodsTableTableManager get foods =>
      $$FoodsTableTableManager(_db, _db.foods);
  $$FoodNutrientsTableTableManager get foodNutrients =>
      $$FoodNutrientsTableTableManager(_db, _db.foodNutrients);
  $$LogEntriesTableTableManager get logEntries =>
      $$LogEntriesTableTableManager(_db, _db.logEntries);
  $$RequestsTableTableManager get requests =>
      $$RequestsTableTableManager(_db, _db.requests);
  $$SupplementPlansTableTableManager get supplementPlans =>
      $$SupplementPlansTableTableManager(_db, _db.supplementPlans);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$ReferenceValuesTableTableManager get referenceValues =>
      $$ReferenceValuesTableTableManager(_db, _db.referenceValues);
  $$FoodNotesTableTableManager get foodNotes =>
      $$FoodNotesTableTableManager(_db, _db.foodNotes);
  $$MetaTableTableManager get meta => $$MetaTableTableManager(_db, _db.meta);
}

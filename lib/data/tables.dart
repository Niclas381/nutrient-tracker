import 'package:drift/drift.dart';

/// Definition of every nutrient. Mirrors the bundled DB (`tool/catalog.py`).
@DataClassName('NutrientRow')
class Nutrients extends Table {
  IntColumn get id => integer()();
  TextColumn get code => text().unique()();
  TextColumn get name => text()();
  TextColumn get unit => text()();
  IntColumn get importanceRank => integer()();
  TextColumn get targetType => text()();
  BoolColumn get hasBar => boolean()();

  /// Missing values are estimated by Claude on first use.
  BoolColumn get claudeFills => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// One entry per distinct food or product.
///
/// Ids: bundled BLS/USDA foods keep their bundled ids (< 100,000,000); foods created in the app start at
/// 100,000,000 so new bundled DB versions never collide with them.
@DataClassName('FoodRow')
class Foods extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get nameDe => text().nullable()();

  /// bls | usda | off | claude_estimate | supplement
  TextColumn get source => text()();
  TextColumn get sourceRef => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get foodGroup => text().nullable()();
  RealColumn get defaultServingG => real().nullable()();
  TextColumn get servingLabel => text().nullable()();
  RealColumn get packageQuantity => real().nullable()();
  TextColumn get packageUnit => text().nullable()();

  /// Unit amounts are logged in: g | ml | piece. Nutrient values are per 100 of this unit.
  TextColumn get amountUnit => text().withDefault(const Constant('g'))();
  BoolColumn get isCommon => boolean().withDefault(const Constant(false))();

  /// Nutri-Score inputs: category (null = unknown) and % fruit/vegetables/legumes.
  TextColumn get nutriscoreCategory => text().nullable()();
  RealColumn get fvlPercent => real().nullable()();
  BoolColumn get nonNutritiveSweeteners => boolean().nullable()();

  /// none | pending | done | failed — the one-time enrich_food request on first use.
  TextColumn get enrichment => text().withDefault(const Constant('none'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FoodNutrientRow')
class FoodNutrients extends Table {
  IntColumn get foodId => integer()();
  IntColumn get nutrientId => integer()();
  RealColumn get amountPer100 => real()();

  /// Provenance of this value: null = same as the food's source; otherwise off | bls | usda | claude_estimate.
  /// Priority when values conflict: product label (off) > generic database > Claude estimate.
  TextColumn get source => text().nullable()();

  @override
  Set<Column> get primaryKey => {foodId, nutrientId};
}

@DataClassName('LogEntryRow')
class LogEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get foodId => integer()();

  /// Amount in the food's unit (g, ml or pieces).
  RealColumn get grams => real()();

  /// text | voice | photo | barcode | supplement_auto
  TextColumn get inputSource => text()();
  TextColumn get rawInput => text().nullable()();
  RealColumn get confidence => real().nullable()();
  TextColumn get requestId => text().nullable()();

  /// For supplement_auto entries: the plan that created it.
  IntColumn get supplementPlanId => integer().nullable()();
}

/// Every job sent to Claude; drives the "processing" cards and retries.
@DataClassName('RequestRow')
class Requests extends Table {
  TextColumn get id => text()();

  /// log_text | log_photo | enrich_food | ping
  TextColumn get type => text()();
  DateTimeColumn get createdAt => dateTime()();

  /// queued | uploaded | fired | done | failed
  TextColumn get status => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  TextColumn get rawInput => text().nullable()();
  TextColumn get imagePath => text().nullable()();

  /// Request JSON (as written to `inbox/<id>.json`).
  TextColumn get payload => text()();

  /// text | voice | photo | barcode — how the user entered it (for log entries).
  TextColumn get inputSource => text().nullable()();
  DateTimeColumn get firedAt => dateTime().nullable()();
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();

  /// Food the request is about (enrich_food).
  IntColumn get foodId => integer().nullable()();

  /// Time the resulting log entries get (past-day logging from the calendar); null = createdAt.
  DateTimeColumn get logAt => dateTime().nullable()();

  /// Short note from Claude shown on the card (e.g. nothing edible recognised).
  TextColumn get resultNote => text().nullable()();

  /// The result card was dismissed in the chat.
  BoolColumn get dismissed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SupplementPlanRow')
class SupplementPlans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get foodId => integer()();
  RealColumn get amount => real()();

  /// g | ml | piece
  TextColumn get unit => text()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  /// First day the plan is auto-logged.
  DateTimeColumn get startDate => dateTime()();
  TextColumn get rawInput => text().nullable()();
}

/// Single row.
@DataClassName('ProfileRow')
class Profiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  /// m | f
  TextColumn get sex => text()();
  IntColumn get age => integer()();
  RealColumn get heightCm => real()();
  RealColumn get weightKg => real()();

  /// DGE PAL: 1.4 | 1.6 | 1.8
  TextColumn get activityLevel => text()();
  TextColumn get ironStatus => text().withDefault(const Constant('menstruating'))();
  TextColumn get phytate => text().withDefault(const Constant('medium'))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ReferenceValueRow')
class ReferenceValues extends Table {
  IntColumn get id => integer()();
  IntColumn get nutrientId => integer()();
  TextColumn get sex => text()();
  IntColumn get ageMin => integer()();
  IntColumn get ageMax => integer()();
  TextColumn get valueType => text()();
  RealColumn get amount => real()();
  TextColumn get basis => text()();
  TextColumn get condition => text()();
  TextColumn get ulBasis => text()();
  TextColumn get source => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cached ranking data and Claude's assessment, generated once per food.
@DataClassName('FoodNoteRow')
class FoodNotes extends Table {
  IntColumn get foodId => integer()();
  TextColumn get nutriScore => text().nullable()();

  /// NOVA group 1–4 (4 = ultra-processed).
  IntColumn get novaGroup => integer().nullable()();

  /// Claude's absolute health rating 1 (very unhealthy) – 5 (very healthy).
  IntColumn get healthRating => integer().nullable()();
  TextColumn get healthReason => text().nullable()();

  /// Shown on the ranking page when the health rating is poor.
  TextColumn get warningText => text().nullable()();
  DateTimeColumn get generatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {foodId};
}

@DataClassName('MetaRow')
class Meta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

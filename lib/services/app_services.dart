import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../claude/backend.dart';
import '../claude/routine_backend.dart';
import '../claude/schemas.dart';
import '../data/database.dart';
import 'db_request_store.dart';
import 'food_service.dart';
import 'nutrition_service.dart';
import 'request_service.dart';
import 'result_importer.dart';
import 'secrets.dart';

/// Wires the modules together. Created once at startup.
class AppServices {
  AppServices._(this.db, this.validator, this.secrets, this._dbVersion) {
    requests = RequestService(db: db, backend: () => _backend, dbVersion: () => _dbVersion);
    foods = FoodService(db: db, requests: requests);
    importer = ResultImporter(db: db, foods: foods);
    nutrition = NutritionService(db);
  }

  final AppDatabase db;
  final SchemaValidator validator;
  final SecretStore secrets;
  final String _dbVersion;
  late final RequestService requests;
  late final FoodService foods;
  late final ResultImporter importer;
  late final NutritionService nutrition;

  ClaudeBackend? _backend;
  StreamSubscription<ClaudeResult>? _resultsSub;

  String get dbVersion => _dbVersion;
  bool get hasBackend => _backend != null;

  /// Opens the database, imports the bundled nutrient DB when its version changed, and starts the backend.
  /// [onProgress] reports what is happening (first launch takes a moment).
  static Future<AppServices> start({void Function(String)? onProgress}) async {
    final db = AppDatabase();
    final bundledVersion = (await rootBundle.loadString('assets/db/db_version.txt')).trim();
    if (await db.getMeta('db_version') != bundledVersion) {
      onProgress?.call('Preparing the nutrient database…');
      final tmp = File(p.join((await getTemporaryDirectory()).path, 'nutrients-$bundledVersion.sqlite'));
      final data = await rootBundle.load('assets/db/nutrients.sqlite');
      await tmp.writeAsBytes(data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes), flush: true);
      await db.importBundled(tmp, bundledVersion);
      await tmp.delete();
    }
    final validator = SchemaValidator(
      requestSchema: await rootBundle.loadString('routine_repo/schemas/request.schema.json'),
      resultSchema: await rootBundle.loadString('routine_repo/schemas/result.schema.json'),
    );
    final s = AppServices._(db, validator, SecretStore(), bundledVersion);
    await s.configure(await s.secrets.read());
    await s.foods.autoLogSupplements(DateTime.now());
    await db.dismissOldDone(const Duration(days: 1));
    return s;
  }

  /// (Re)creates the backend for [config]. Without a complete config, requests stay queued.
  Future<void> configure(RoutineConfig config) async {
    await _resultsSub?.cancel();
    await _backend?.dispose();
    _backend = null;
    if (!config.isComplete) return;
    final backend = RoutineBackend(config: config, store: DbRequestStore(db), validator: validator);
    _resultsSub = backend.results.listen((r) async {
      await importer.import(r);
      await backend.acknowledge(r.requestId);
    });
    _backend = backend;
    backend.start();
  }

  Future<void> saveConfig(RoutineConfig config) async {
    await secrets.write(config);
    await configure(config);
  }

  /// Called when the app returns to the foreground.
  Future<void> resume() async {
    await foods.autoLogSupplements(DateTime.now());
    await db.dismissOldDone(const Duration(days: 1));
    _backend?.start();
  }
}

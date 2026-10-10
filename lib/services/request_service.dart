import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../claude/backend.dart';
import '../data/database.dart';

/// Creates requests (one row per job) and hands them to the current backend.
///
/// Requests are always stored first, so raw input is never lost: without a configured backend they simply stay
/// `queued` until the routine connection is set up.
class RequestService {
  RequestService({required this.db, required this.backend, required this.dbVersion});

  final AppDatabase db;
  final ClaudeBackend? Function() backend;
  final String Function() dbVersion;
  static const _uuid = Uuid();

  Future<String> _create({
    required RequestType type,
    required Map<String, dynamic> payload,
    String? rawInput,
    String? inputSource,
    String? imagePath,
    int? foodId,
    DateTime? logAt,
  }) =>
      _createWithId(_uuid.v4(),
          type: type,
          payload: payload,
          rawInput: rawInput,
          inputSource: inputSource,
          imagePath: imagePath,
          foodId: foodId,
          logAt: logAt);

  /// Text typed or dictated in the chat. [logAt] places the entries on a past day.
  Future<String> logText(String text, {required String inputSource, DateTime? logAt}) => _create(
        type: RequestType.logText,
        payload: {'text': text, 'purpose': 'log'},
        rawInput: text,
        inputSource: inputSource,
        logAt: logAt,
      );

  /// A daily supplement described by the user ("vitamin D 1000 IU").
  Future<String> supplementPlan(String text) => _create(
        type: RequestType.logText,
        payload: {'text': text, 'purpose': 'supplement_plan'},
        rawInput: text,
        inputSource: 'text',
      );

  /// A meal photo, or (kind `label`) the label of a product Open Food Facts doesn't know.
  Future<String> logPhoto(String requestId, String imagePath,
          {String? caption, String kind = 'meal', String? barcode, DateTime? logAt}) =>
      _createWithId(
        requestId,
        type: RequestType.logPhoto,
        payload: {
          'image_path': 'inbox/$requestId.jpg',
          if (caption != null && caption.trim().isNotEmpty) 'caption': caption.trim(),
          'kind': kind,
          'barcode': ?barcode,
        },
        rawInput: caption?.trim().isNotEmpty == true ? caption!.trim() : (kind == 'label' ? 'Label photo' : 'Photo'),
        inputSource: kind == 'label' ? 'barcode' : 'photo',
        imagePath: imagePath,
        logAt: logAt,
      );

  /// Photos are stored under the request id, so the id is chosen before capturing.
  String newId() => _uuid.v4();

  Future<String> _createWithId(String id,
      {required RequestType type,
      required Map<String, dynamic> payload,
      String? rawInput,
      String? inputSource,
      String? imagePath,
      int? foodId,
      DateTime? logAt}) async {
    final req = ClaudeRequest(
        id: id, type: type, createdAt: DateTime.now(), dbVersion: dbVersion(), payload: payload, imageFile: imagePath);
    await db.insertRequest(RequestsCompanion.insert(
      id: id,
      type: type.code,
      createdAt: req.createdAt,
      status: RequestStatus.queued.code,
      payload: jsonEncode(req.toJson()),
      rawInput: Value(rawInput),
      inputSource: Value(inputSource),
      imagePath: Value(imagePath),
      foodId: Value(foodId),
      logAt: Value(logAt),
    ));
    await backend()?.submit(req);
    return id;
  }

  Future<String> enrichFood(int foodId, Map<String, dynamic> payload) =>
      _create(type: RequestType.enrichFood, payload: payload, foodId: foodId, rawInput: payload['food']['name'] as String);

  Future<String> ping() => _create(type: RequestType.ping, payload: const {}, rawInput: 'Test connection');

  Future<void> retry(String id) async {
    final b = backend();
    if (b != null) {
      await b.retry(id);
    } else {
      await db.updateRequest(
          id, const RequestsCompanion(status: Value('queued'), attempts: Value(0), lastError: Value(null)));
    }
  }

  Future<void> dismiss(String id) => db.updateRequest(id, const RequestsCompanion(dismissed: Value(true)));
}

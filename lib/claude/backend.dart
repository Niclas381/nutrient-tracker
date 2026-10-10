/// The app's only door to Claude. A future `ServerBackend` replaces `RoutineBackend` without touching other
/// modules; request and result JSON stay identical (schemas in routine_repo/schemas/).
library;

import 'dart:async';

enum RequestType {
  logText('log_text'),
  logPhoto('log_photo'),
  enrichFood('enrich_food'),
  ping('ping');

  const RequestType(this.code);
  final String code;

  static RequestType fromCode(String code) => values.firstWhere((t) => t.code == code);
}

/// Lifecycle of a request (stored in the `requests` table).
enum RequestStatus {
  queued('queued'),
  uploaded('uploaded'),
  fired('fired'),
  done('done'),
  failed('failed');

  const RequestStatus(this.code);
  final String code;

  static RequestStatus fromCode(String code) => values.firstWhere((s) => s.code == code);
}

class ClaudeRequest {
  const ClaudeRequest({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.dbVersion,
    required this.payload,
    this.imageFile,
  });

  /// UUID v4.
  final String id;
  final RequestType type;
  final DateTime createdAt;
  final String dbVersion;
  final Map<String, dynamic> payload;

  /// Local path of the photo for log_photo.
  final String? imageFile;

  Map<String, dynamic> toJson() => {
        'request_id': id,
        'type': type.code,
        'created_at': createdAt.toUtc().toIso8601String(),
        'db_version': dbVersion,
        'payload': payload,
      };
}

class ClaudeResult {
  const ClaudeResult({
    required this.requestId,
    required this.type,
    required this.dbVersion,
    required this.ok,
    this.errorMessage,
    this.result,
  });

  factory ClaudeResult.fromJson(Map<String, dynamic> j) => ClaudeResult(
        requestId: j['request_id'] as String,
        type: RequestType.fromCode(j['type'] as String),
        dbVersion: j['db_version'] as String,
        ok: j['status'] == 'ok',
        errorMessage: j['error_message'] as String?,
        result: j['result'] as Map<String, dynamic>?,
      );

  final String requestId;
  final RequestType type;
  final String dbVersion;
  final bool ok;
  final String? errorMessage;
  final Map<String, dynamic>? result;
}

abstract interface class ClaudeBackend {
  /// Queues a request. The request row must already exist in the store with status `queued`.
  Future<void> submit(ClaudeRequest request);

  /// Validated results, at most once per request id while the app runs.
  Stream<ClaudeResult> get results;

  /// Called after a result was imported; the backend may then clean up (e.g. delete the outbox file).
  Future<void> acknowledge(String requestId);

  /// Sends a failed request again.
  Future<void> retry(String requestId);

  /// Starts background work (resumes open requests after an app restart).
  void start();

  Future<void> dispose();
}

/// Persistence the backend needs; implemented on top of the app database.
abstract interface class RequestStore {
  Future<List<StoredRequest>> openRequests();

  Future<StoredRequest?> byId(String id);

  Future<void> update(
    String id, {
    RequestStatus? status,
    int? attempts,
    String? lastError,
    bool clearError = false,
    DateTime? firedAt,
    DateTime? nextAttemptAt,
    bool clearNextAttempt = false,
  });
}

class StoredRequest {
  const StoredRequest({
    required this.request,
    required this.status,
    required this.attempts,
    this.firedAt,
    this.nextAttemptAt,
  });

  final ClaudeRequest request;
  final RequestStatus status;

  /// Number of fires so far.
  final int attempts;
  final DateTime? firedAt;
  final DateTime? nextAttemptAt;
}

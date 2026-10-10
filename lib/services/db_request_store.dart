import 'dart:convert';

import 'package:drift/drift.dart';

import '../claude/backend.dart';
import '../data/database.dart';

/// [RequestStore] on top of the `requests` table.
class DbRequestStore implements RequestStore {
  DbRequestStore(this.db);

  final AppDatabase db;

  static StoredRequest toStored(RequestRow r) {
    final json = jsonDecode(r.payload) as Map<String, dynamic>;
    return StoredRequest(
      request: ClaudeRequest(
        id: r.id,
        type: RequestType.fromCode(r.type),
        createdAt: r.createdAt,
        dbVersion: json['db_version'] as String,
        payload: (json['payload'] as Map).cast<String, dynamic>(),
        imageFile: r.imagePath,
      ),
      status: RequestStatus.fromCode(r.status),
      attempts: r.attempts,
      firedAt: r.firedAt,
      nextAttemptAt: r.nextAttemptAt,
    );
  }

  @override
  Future<List<StoredRequest>> openRequests() async => (await db.openRequests()).map(toStored).toList();

  @override
  Future<StoredRequest?> byId(String id) async {
    final r = await db.requestById(id);
    return r == null ? null : toStored(r);
  }

  @override
  Future<void> update(String id,
      {RequestStatus? status,
      int? attempts,
      String? lastError,
      bool clearError = false,
      DateTime? firedAt,
      DateTime? nextAttemptAt,
      bool clearNextAttempt = false}) {
    return db.updateRequest(
      id,
      RequestsCompanion(
        status: status == null ? const Value.absent() : Value(status.code),
        attempts: attempts == null ? const Value.absent() : Value(attempts),
        lastError: clearError ? const Value(null) : (lastError == null ? const Value.absent() : Value(lastError)),
        firedAt: firedAt == null ? const Value.absent() : Value(firedAt),
        nextAttemptAt:
            clearNextAttempt ? const Value(null) : (nextAttemptAt == null ? const Value.absent() : Value(nextAttemptAt)),
      ),
    );
  }
}

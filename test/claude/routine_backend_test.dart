import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nutrient_tracker/claude/backend.dart';
import 'package:nutrient_tracker/claude/routine_backend.dart';
import 'package:nutrient_tracker/claude/schemas.dart';

class MemoryStore implements RequestStore {
  final rows = <String, StoredRequest>{};

  @override
  Future<StoredRequest?> byId(String id) async => rows[id];

  @override
  Future<List<StoredRequest>> openRequests() async => rows.values
      .where((r) => [RequestStatus.queued, RequestStatus.uploaded, RequestStatus.fired].contains(r.status))
      .toList();

  final errors = <String, String?>{};

  @override
  Future<void> update(String id,
      {RequestStatus? status,
      int? attempts,
      String? lastError,
      bool clearError = false,
      DateTime? firedAt,
      DateTime? nextAttemptAt,
      bool clearNextAttempt = false}) async {
    final r = rows[id]!;
    if (clearError) errors[id] = null;
    if (lastError != null) errors[id] = lastError;
    rows[id] = StoredRequest(
      request: r.request,
      status: status ?? r.status,
      attempts: attempts ?? r.attempts,
      firedAt: firedAt ?? r.firedAt,
      nextAttemptAt: clearNextAttempt ? null : (nextAttemptAt ?? r.nextAttemptAt),
    );
  }
}

/// Fake GitHub contents API + routine fire endpoint.
class FakeServer {
  final files = <String, String>{};
  final fires = <String>[];
  int fireStatus = 200;

  late final client = MockClient((req) async {
    final url = req.url.toString();
    if (url.startsWith('https://api.anthropic.com/fire')) {
      expect(req.headers['anthropic-beta'], RoutineBackend.betaHeader);
      expect(req.headers['anthropic-version'], '2023-06-01');
      expect(req.headers['Authorization'], 'Bearer fire-token');
      fires.add((jsonDecode(req.body) as Map)['text'] as String);
      return http.Response('{}', fireStatus);
    }
    final m = RegExp(r'^https://api.github.com/repos/me/routine/contents/(.*)$').firstMatch(url);
    if (m == null) return http.Response('not found', 404);
    final path = m.group(1)!;
    switch (req.method) {
      case 'PUT':
        files[path] = utf8.decode(base64Decode((jsonDecode(req.body) as Map)['content'] as String));
        return http.Response('{}', 201);
      case 'DELETE':
        return files.remove(path) == null ? http.Response('{}', 404) : http.Response('{}', 200);
      case 'GET':
        if (path == 'outbox') {
          final list = files.keys
              .where((k) => k.startsWith('outbox/'))
              .map((k) => {'type': 'file', 'name': k.substring(7), 'path': k, 'sha': 'sha-$k'})
              .toList();
          return http.Response(jsonEncode(list), 200);
        }
        final body = files[path];
        return body == null ? http.Response('{}', 404) : http.Response(body, 200);
    }
    return http.Response('bad', 400);
  });
}

void main() {
  late SchemaValidator validator;
  setUpAll(() {
    validator = SchemaValidator(
      requestSchema: File('routine_repo/schemas/request.schema.json').readAsStringSync(),
      resultSchema: File('routine_repo/schemas/result.schema.json').readAsStringSync(),
    );
  });

  const id = '0f8fad5b-d9cb-469f-a165-70867728950e';
  var now = DateTime(2026, 10, 10, 12);

  late MemoryStore store;
  late FakeServer server;
  late RoutineBackend backend;

  setUp(() {
    now = DateTime(2026, 10, 10, 12);
    store = MemoryStore();
    server = FakeServer();
    backend = RoutineBackend(
      config: const RoutineConfig(
          fireUrl: 'https://api.anthropic.com/fire', fireToken: 'fire-token', githubToken: 'gh', repo: 'me/routine'),
      store: store,
      validator: validator,
      httpClient: server.client,
      clock: () => now,
    );
    store.rows[id] = StoredRequest(
      request: ClaudeRequest(
        id: id,
        type: RequestType.logText,
        createdAt: now,
        dbVersion: '2026.10.10-1',
        payload: {'text': 'banana', 'purpose': 'log'},
      ),
      status: RequestStatus.queued,
      attempts: 0,
    );
  });

  tearDown(() => backend.dispose());

  test('uploads, fires, polls and emits a validated result; acknowledge deletes it', () async {
    final results = <ClaudeResult>[];
    backend.results.listen(results.add);

    await backend.tick();
    expect(server.files.containsKey('inbox/$id.json'), isTrue);
    expect(server.fires, ['inbox/$id.json']);
    expect(store.rows[id]!.status, RequestStatus.fired);
    expect(store.rows[id]!.attempts, 1);

    server.files['outbox/$id.json'] = jsonEncode({
      'request_id': id,
      'type': 'log_text',
      'db_version': '2026.10.10-1',
      'status': 'ok',
      'result': {
        'items': [
          {'label': 'banana', 'food_id': 10001166, 'amount': 120, 'unit': 'g', 'confidence': 0.9}
        ]
      },
    });
    now = now.add(const Duration(seconds: 25));
    await backend.tick();
    await Future<void>.delayed(Duration.zero);
    expect(results.single.requestId, id);
    expect(results.single.result!['items'], hasLength(1));

    await backend.acknowledge(id);
    expect(server.files.containsKey('outbox/$id.json'), isFalse);
  });

  test('invalid result marks the request failed', () async {
    await backend.tick();
    server.files['outbox/$id.json'] = jsonEncode({'request_id': id, 'type': 'log_text', 'status': 'ok'});
    now = now.add(const Duration(seconds: 25));
    await backend.tick();
    expect(store.rows[id]!.status, RequestStatus.failed);
    expect(store.errors[id], startsWith('Invalid result'));
  });

  test('refires after 15 minutes without result and fails after 3 attempts', () async {
    await backend.tick();
    for (var i = 2; i <= 3; i++) {
      now = now.add(const Duration(minutes: 15));
      await backend.tick();
      expect(store.rows[id]!.attempts, i);
      expect(store.rows[id]!.status, RequestStatus.fired);
    }
    now = now.add(const Duration(minutes: 15));
    await backend.tick();
    expect(store.rows[id]!.status, RequestStatus.failed);
    expect(server.fires, hasLength(3));
  });

  test('fire failure keeps the request uploaded and backs off', () async {
    server.fireStatus = 429;
    await backend.tick();
    expect(store.rows[id]!.status, RequestStatus.uploaded);
    expect(store.rows[id]!.nextAttemptAt, isNotNull);
    server.fireStatus = 200;
    await backend.tick(); // still waiting
    expect(store.rows[id]!.status, RequestStatus.uploaded);
    now = now.add(const Duration(minutes: 16));
    await backend.tick();
    expect(store.rows[id]!.status, RequestStatus.fired);
  });

  test('duplicate results for done requests are deleted and ignored', () async {
    final results = <ClaudeResult>[];
    backend.results.listen(results.add);
    store.rows[id] = StoredRequest(request: store.rows[id]!.request, status: RequestStatus.done, attempts: 1);
    server.files['outbox/$id.json'] = '{}';
    await backend.tick();
    await Future<void>.delayed(Duration.zero);
    expect(results, isEmpty);
    expect(server.files.containsKey('outbox/$id.json'), isFalse);
  });
}

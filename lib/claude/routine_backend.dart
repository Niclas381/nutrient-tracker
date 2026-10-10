/// Claude via a Claude Code routine: requests and results travel through a private GitHub repo.
///
/// Flow per request: write `inbox/<id>.json` (+ `.jpg`) → status uploaded → POST the routine's /fire endpoint →
/// status fired → poll `outbox/` → validate → emit result → after import, delete the outbox file.
///
/// All routine-specific behaviour (endpoint, headers, rate limits, retries) lives in this file. Routines are a
/// research preview; adjust the constants below when the endpoint changes.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import 'backend.dart';
import 'github_client.dart';
import 'schemas.dart';

class RoutineConfig {
  const RoutineConfig({
    required this.fireUrl,
    required this.fireToken,
    required this.githubToken,
    required this.repo,
  });

  final String fireUrl;
  final String fireToken;
  final String githubToken;

  /// `owner/name`
  final String repo;

  bool get isComplete => [fireUrl, fireToken, githubToken, repo].every((s) => s.trim().isNotEmpty);
}

class RoutineBackend implements ClaudeBackend {
  RoutineBackend({
    required this.config,
    required this.store,
    required this.validator,
    http.Client? httpClient,
    DateTime Function()? clock,
  })  : _http = httpClient ?? http.Client(),
        _now = clock ?? DateTime.now {
    _github = GitHubClient(token: config.githubToken, repo: config.repo, client: _http);
  }

  static const betaHeader = 'experimental-cc-routine-2026-04-01';
  static const anthropicVersion = '2023-06-01';
  static const firstPollInterval = Duration(seconds: 20);
  static const maxPollInterval = Duration(minutes: 2);
  static const pollBackoff = 1.5;
  static const noResultTimeout = Duration(minutes: 15);
  static const maxAttempts = 3;
  static const maxFiresPerHour = 30;

  final RoutineConfig config;
  final RequestStore store;
  final SchemaValidator validator;
  final http.Client _http;
  final DateTime Function() _now;
  late final GitHubClient _github;

  final _results = StreamController<ClaudeResult>.broadcast();
  final _outboxSha = <String, String>{};
  final _emitted = <String>{};
  final _failures = <String, int>{};
  final _fires = <DateTime>[];
  Timer? _timer;
  bool _busy = false;
  bool _again = false;
  bool _disposed = false;
  Duration _pollInterval = firstPollInterval;
  DateTime? _lastPoll;
  bool _pollOnStart = true;

  @override
  Stream<ClaudeResult> get results => _results.stream;

  @override
  void start() => _kick();

  @override
  Future<void> submit(ClaudeRequest request) async => _kick();

  @override
  Future<void> retry(String requestId) async {
    _failures.remove(requestId);
    _emitted.remove(requestId);
    await store.update(requestId,
        status: RequestStatus.queued, attempts: 0, clearError: true, clearNextAttempt: true);
    _kick();
  }

  @override
  Future<void> acknowledge(String requestId) async {
    final sha = _outboxSha.remove(requestId);
    if (sha != null) {
      try {
        await _github.delete('outbox/$requestId.json', sha, 'Remove imported result $requestId');
      } catch (_) {
        // Deleted on a later poll (results for done requests are treated as duplicates).
      }
    }
  }

  @override
  Future<void> dispose() async {
    _disposed = true;
    _timer?.cancel();
    await _results.close();
    _github.close();
  }

  /// Runs one step immediately (used by tests and when the app comes to the foreground).
  Future<void> tick() => _tick();

  void _kick() {
    if (_disposed) return;
    _timer?.cancel();
    _timer = Timer(Duration.zero, _tick);
  }

  Future<void> _tick() async {
    if (_disposed) return;
    if (_busy) {
      _again = true;
      return;
    }
    _busy = true;
    try {
      do {
        _again = false;
        final open = await store.openRequests();
        for (final r in open) {
          await _advance(r);
        }
        await _maybePoll(open);
      } while (_again && !_disposed);
    } finally {
      _busy = false;
    }
    await _schedule();
  }

  Future<void> _schedule() async {
    if (_disposed) return;
    final open = await store.openRequests();
    if (open.isEmpty) return;
    final now = _now();
    var next = now.add(maxPollInterval);
    void consider(DateTime t) {
      if (t.isBefore(next)) next = t;
    }

    for (final r in open) {
      switch (r.status) {
        case RequestStatus.queued || RequestStatus.uploaded:
          consider(r.nextAttemptAt ?? now);
        case RequestStatus.fired:
          consider((r.firedAt ?? now).add(noResultTimeout));
          consider((_lastPoll ?? now).add(_pollInterval));
        default:
      }
    }
    var delay = next.difference(now);
    if (delay < const Duration(seconds: 2)) delay = const Duration(seconds: 2);
    _timer?.cancel();
    _timer = Timer(delay, _tick);
  }

  Duration _backoff(String id) {
    final n = (_failures[id] = (_failures[id] ?? 0) + 1);
    final seconds = math.min(30 * math.pow(2, n - 1), 15 * 60).toInt();
    return Duration(seconds: seconds);
  }

  Future<void> _advance(StoredRequest r) async {
    final now = _now();
    final id = r.request.id;
    if (r.nextAttemptAt != null && r.nextAttemptAt!.isAfter(now)) return;
    switch (r.status) {
      case RequestStatus.queued:
        final problems = validator.validateRequest(r.request.toJson());
        if (problems.isNotEmpty) {
          await store.update(id, status: RequestStatus.failed, lastError: 'Invalid request: ${problems.first}');
          return;
        }
        try {
          if (r.request.imageFile != null) {
            final bytes = await File(r.request.imageFile!).readAsBytes();
            await _github.put('inbox/$id.jpg', bytes, 'Add photo $id');
          }
          await _github.put('inbox/$id.json', utf8.encode(jsonEncode(r.request.toJson())), 'Add request $id');
          _failures.remove(id);
          await store.update(id, status: RequestStatus.uploaded, clearError: true, clearNextAttempt: true);
          await _fire(id, attempts: r.attempts);
        } catch (e) {
          await store.update(id, lastError: 'Upload failed: $e', nextAttemptAt: now.add(_backoff(id)));
        }
      case RequestStatus.uploaded:
        await _fire(id, attempts: r.attempts);
      case RequestStatus.fired:
        if (r.firedAt != null && now.difference(r.firedAt!) >= noResultTimeout) {
          if (r.attempts >= maxAttempts) {
            await store.update(id,
                status: RequestStatus.failed, lastError: 'No result after $maxAttempts attempts');
          } else {
            await _fire(id, attempts: r.attempts);
          }
        }
      case RequestStatus.done || RequestStatus.failed:
        break;
    }
  }

  Future<void> _fire(String id, {required int attempts}) async {
    final now = _now();
    _fires.removeWhere((t) => now.difference(t) > const Duration(hours: 1));
    if (_fires.length >= maxFiresPerHour) {
      await store.update(id,
          lastError: 'Waiting: routine fire limit ($maxFiresPerHour per hour) reached',
          nextAttemptAt: _fires.first.add(const Duration(hours: 1)));
      return;
    }
    http.Response resp;
    try {
      resp = await _http.post(
        Uri.parse(config.fireUrl),
        headers: {
          'Authorization': 'Bearer ${config.fireToken}',
          'anthropic-beta': betaHeader,
          'anthropic-version': anthropicVersion,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'text': 'inbox/$id.json'}),
      );
    } catch (e) {
      await store.update(id, lastError: 'Fire failed: $e', nextAttemptAt: now.add(_backoff(id)));
      return;
    }
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      _fires.add(now);
      _failures.remove(id);
      _pollInterval = firstPollInterval;
      _lastPoll = now;
      await store.update(id,
          status: RequestStatus.fired, attempts: attempts + 1, firedAt: now, clearError: true, clearNextAttempt: true);
      return;
    }
    final retryAfter = int.tryParse(resp.headers['retry-after'] ?? '');
    final wait = resp.statusCode == 429
        ? Duration(seconds: retryAfter ?? 15 * 60)
        : (resp.statusCode == 401 || resp.statusCode == 403)
            ? const Duration(minutes: 10)
            : _backoff(id);
    await store.update(id,
        lastError: 'Fire failed (${resp.statusCode}): ${_short(resp.body)}', nextAttemptAt: now.add(wait));
  }

  String _short(String s) => s.length > 200 ? '${s.substring(0, 200)}…' : s;

  Future<void> _maybePoll(List<StoredRequest> open) async {
    final now = _now();
    final anyFired = open.any((r) => r.status == RequestStatus.fired);
    final regularPollDue =
        anyFired && (_lastPoll == null || now.difference(_lastPoll!) >= _pollInterval);
    // One extra poll at start picks up results that arrived while the app was closed (even for failed requests).
    final startPoll = _pollOnStart;
    if (!regularPollDue && !startPoll) return;
    _pollOnStart = false;
    if (regularPollDue) _lastPoll = now;
    var found = false;
    try {
      for (final f in await _github.list('outbox')) {
        if (!f.name.endsWith('.json')) continue;
        final id = f.name.substring(0, f.name.length - 5);
        if (_emitted.contains(id)) continue;
        final stored = await store.byId(id);
        if (stored == null || stored.status == RequestStatus.done) {
          // Duplicate (overlapping runs) or unknown result: results are idempotent by request id.
          await _github.delete(f.path, f.sha, 'Remove duplicate result $id');
          continue;
        }
        found = true;
        Object? json;
        try {
          json = jsonDecode(await _github.readText(f.path));
        } catch (e) {
          json = null;
        }
        final problems = json == null ? ['not valid JSON'] : validator.validateResult(json);
        if (problems.isNotEmpty) {
          await store.update(id, status: RequestStatus.failed, lastError: 'Invalid result: ${problems.first}');
          await _github.delete(f.path, f.sha, 'Remove invalid result $id');
          continue;
        }
        _outboxSha[id] = f.sha;
        _emitted.add(id);
        _results.add(ClaudeResult.fromJson(json as Map<String, dynamic>));
      }
    } catch (_) {
      // Network problem: try again on the next poll.
    }
    if (!found && regularPollDue) {
      final ms = (_pollInterval.inMilliseconds * pollBackoff).round();
      _pollInterval = Duration(milliseconds: math.min(ms, maxPollInterval.inMilliseconds));
    }
  }
}

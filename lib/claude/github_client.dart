/// Minimal GitHub Contents API client for the routine repo.
library;

import 'dart:convert';

import 'package:http/http.dart' as http;

class GitHubException implements Exception {
  GitHubException(this.statusCode, this.message);
  final int statusCode;
  final String message;

  @override
  String toString() => 'GitHub $statusCode: $message';
}

class RepoFile {
  const RepoFile(this.name, this.path, this.sha);
  final String name;
  final String path;
  final String sha;
}

class GitHubClient {
  GitHubClient({required this.token, required this.repo, http.Client? client}) : _http = client ?? http.Client();

  final String token;

  /// `owner/name`
  final String repo;
  final http.Client _http;

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      };

  Uri _contents(String path) => Uri.parse('https://api.github.com/repos/$repo/contents/$path');

  Never _fail(http.Response r) {
    var msg = r.body;
    try {
      msg = (jsonDecode(r.body) as Map<String, dynamic>)['message'] as String? ?? r.body;
    } catch (_) {}
    throw GitHubException(r.statusCode, msg);
  }

  /// Sha of [path] on the default branch, or null if it doesn't exist.
  Future<String?> sha(String path) async {
    final r = await _http.get(_contents(path), headers: _headers);
    if (r.statusCode == 404) return null;
    if (r.statusCode != 200) _fail(r);
    return (jsonDecode(r.body) as Map<String, dynamic>)['sha'] as String;
  }

  /// Creates or replaces a file on the default branch (one commit).
  Future<void> put(String path, List<int> bytes, String message) async {
    Future<http.Response> send(String? sha) => _http.put(_contents(path),
        headers: _headers,
        body: jsonEncode({'message': message, 'content': base64Encode(bytes), 'sha': ?sha}));
    var r = await send(null);
    if (r.statusCode == 422 || r.statusCode == 409) {
      // File exists already (e.g. a retried upload) or the branch moved: retry with the current sha.
      r = await send(await sha(path));
    }
    if (r.statusCode != 200 && r.statusCode != 201) _fail(r);
  }

  /// Files directly in [dir]; empty if the folder doesn't exist.
  Future<List<RepoFile>> list(String dir) async {
    final r = await _http.get(_contents(dir), headers: _headers);
    if (r.statusCode == 404) return const [];
    if (r.statusCode != 200) _fail(r);
    final items = jsonDecode(r.body) as List<dynamic>;
    return [
      for (final i in items.cast<Map<String, dynamic>>())
        if (i['type'] == 'file') RepoFile(i['name'] as String, i['path'] as String, i['sha'] as String),
    ];
  }

  Future<String> readText(String path) async {
    final r = await _http.get(_contents(path), headers: {..._headers, 'Accept': 'application/vnd.github.raw+json'});
    if (r.statusCode != 200) _fail(r);
    return utf8.decode(r.bodyBytes);
  }

  Future<void> delete(String path, String sha, String message, {int attempt = 0}) async {
    final req = http.Request('DELETE', _contents(path))
      ..headers.addAll(_headers)
      ..body = jsonEncode({'message': message, 'sha': sha});
    final r = await http.Response.fromStream(await _http.send(req));
    if (r.statusCode == 404) return;
    if ((r.statusCode == 409 || r.statusCode == 422) && attempt < 3) {
      final current = await this.sha(path);
      if (current == null) return;
      return delete(path, current, message, attempt: attempt + 1);
    }
    if (r.statusCode != 200) _fail(r);
  }

  void close() => _http.close();
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../claude/routine_backend.dart';

/// Routine fire URL + token and the GitHub token live only in Android's encrypted storage.
class SecretStore {
  SecretStore([FlutterSecureStorage? storage]) : _s = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _s;

  static const _fireUrl = 'routine_fire_url';
  static const _fireToken = 'routine_fire_token';
  static const _githubToken = 'github_token';
  static const _repo = 'routine_repo';

  Future<RoutineConfig> read() async => RoutineConfig(
        fireUrl: await _s.read(key: _fireUrl) ?? '',
        fireToken: await _s.read(key: _fireToken) ?? '',
        githubToken: await _s.read(key: _githubToken) ?? '',
        repo: await _s.read(key: _repo) ?? '',
      );

  Future<void> write(RoutineConfig c) async {
    await _s.write(key: _fireUrl, value: c.fireUrl.trim());
    await _s.write(key: _fireToken, value: c.fireToken.trim());
    await _s.write(key: _githubToken, value: c.githubToken.trim());
    await _s.write(key: _repo, value: c.repo.trim());
  }
}

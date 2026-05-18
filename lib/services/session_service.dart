import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService extends ChangeNotifier {
  SessionService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const accessTokenKey = 'jwt_token';
  static const refreshTokenKey = 'jwt_refresh_token';

  final FlutterSecureStorage _storage;

  bool _loaded = false;
  Future<void>? _loadInFlight;
  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _normalize(_accessToken);
  String? get refreshToken => _normalize(_refreshToken);

  Future<void> load() {
    if (_loaded) return Future.value();
    _loadInFlight ??= _loadTokens().whenComplete(() => _loadInFlight = null);
    return _loadInFlight!;
  }

  Future<String?> readAccessToken() async {
    await load();
    return accessToken;
  }

  Future<String> requireAccessToken() async {
    final token = await readAccessToken();
    if (token == null) throw Exception('Missing auth token');
    return token;
  }

  Future<String?> readRefreshToken() async {
    await load();
    return refreshToken;
  }

  Future<void> saveTokens({
    String? accessToken,
    String? refreshToken,
  }) async {
    await load();

    final writes = <Future<void>>[];
    final normalizedAccess = _normalize(accessToken);
    final normalizedRefresh = _normalize(refreshToken);

    if (normalizedAccess != null) {
      _accessToken = normalizedAccess;
      writes.add(_storage.write(key: accessTokenKey, value: normalizedAccess));
    }
    if (normalizedRefresh != null) {
      _refreshToken = normalizedRefresh;
      writes
          .add(_storage.write(key: refreshTokenKey, value: normalizedRefresh));
    }

    if (writes.isEmpty) return;
    await Future.wait(writes);
    notifyListeners();
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: accessTokenKey),
      _storage.delete(key: refreshTokenKey),
    ]);
    _loaded = true;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  Future<void> _loadTokens() async {
    final values = await Future.wait([
      _storage.read(key: accessTokenKey),
      _storage.read(key: refreshTokenKey),
    ]);
    _accessToken = _normalize(values[0]);
    _refreshToken = _normalize(values[1]);
    _loaded = true;
  }

  static String? _normalize(String? value) {
    if (value == null || value.isEmpty) return null;
    return value;
  }
}

final sessionServiceProvider = Provider<SessionService>((ref) {
  final service = SessionService();
  ref.onDispose(service.dispose);
  return service;
});

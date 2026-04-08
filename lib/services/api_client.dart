import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// Shared HTTP layer for all Ithaki API repositories.
///
/// Centralises base-URL resolution, auth-token reads, header building,
/// timeout, and error-body parsing so individual repositories stay thin.
class ApiClient {
  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'ITHAKI_API_BASE_URL',
              defaultValue: 'https://api.odyssea.com/talent/staging',
            );

  final http.Client _client;
  final String _baseUrl;

  static const _storage = FlutterSecureStorage();
  static const timeout = Duration(seconds: 20);
  static const _okStatuses = {200, 201, 202, 204};

  // Mutex: only one refresh in flight at a time; concurrent callers await the same Future.
  Future<void>? _refreshInFlight;

  /// Exposed for repositories that need to make non-standard requests
  /// (e.g. auth flows with no token, text/plain bodies).
  http.Client get client => _client;

  /// Base URL with trailing `/api` guaranteed and no trailing slash.
  String get base {
    final trimmed =
        _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    return trimmed.endsWith('/api') ? trimmed : '$trimmed/api';
  }

  Uri uri(String path, [Map<String, String>? params]) {
    final u = Uri.parse('$base$path');
    return (params != null && params.isNotEmpty) ? u.replace(queryParameters: params) : u;
  }

  Future<String> requireToken() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) throw Exception('Missing auth token');
    return token;
  }

  Future<String?> readTokenOrNull() async {
    final token = await _storage.read(key: 'jwt_token');
    return (token == null || token.isEmpty) ? null : token;
  }

  /// Exchanges the stored refresh token for a new access token.
  /// Throws if no refresh token is available or the server rejects it.
  /// Concurrent callers share a single in-flight refresh to avoid token rotation races.
  Future<void> refreshAccessToken() {
    _refreshInFlight ??= _doRefresh().whenComplete(() => _refreshInFlight = null);
    return _refreshInFlight!;
  }

  Future<void> _doRefresh() async {
    final refreshToken = await _storage.read(key: 'jwt_refresh_token');
    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('Session expired — please log in again');
    }

    final res = await _client
        .post(
          uri('/auth/refresh'),
          headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}),
        )
        .timeout(timeout);

    if (!_okStatuses.contains(res.statusCode)) {
      throw Exception('Session expired — please log in again');
    }

    final Map<String, dynamic> data;
    try {
      data = (jsonDecode(res.body) as Map).cast<String, dynamic>();
    } catch (_) {
      throw Exception('Unexpected refresh response — please log in again');
    }

    final nested = data['data'];
    final newAccess = data['accessToken'] ?? data['token'] ??
        (nested is Map ? nested['accessToken'] ?? nested['token'] : null);
    if (newAccess is String && newAccess.isNotEmpty) {
      await _storage.write(key: 'jwt_token', value: newAccess);
    }
    final newRefresh = data['refreshToken'] ??
        (nested is Map ? nested['refreshToken'] : null);
    if (newRefresh is String && newRefresh.isNotEmpty) {
      await _storage.write(key: 'jwt_refresh_token', value: newRefresh);
    }
  }

  /// JSON + optional Bearer auth headers.
  Map<String, String> jsonHeaders({String? token}) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  String readErrorBody(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final msg = decoded['message'] ?? decoded['error'];
        if (msg is String && msg.isNotEmpty) return msg;
      }
    } catch (_) {}
    return response.body.isEmpty ? 'Unknown server error' : response.body;
  }

  /// Authenticated GET. Throws if no token is stored.
  /// Automatically refreshes the access token once on 401 and retries.
  Future<http.Response> get(String path, {Map<String, String>? params}) async {
    var token = await requireToken();
    var res = await _client
        .get(uri(path, params), headers: jsonHeaders(token: token))
        .timeout(timeout);
    if (res.statusCode == 401) {
      await refreshAccessToken();
      token = await requireToken();
      res = await _client
          .get(uri(path, params), headers: jsonHeaders(token: token))
          .timeout(timeout);
    }
    return res;
  }

  /// GET with optional auth — uses Bearer token when available, falls back to
  /// Accept-only headers (for public or partially-public endpoints).
  /// Refreshes and retries once on 401 when a token is present.
  Future<http.Response> getOptionalAuth(String path, {Map<String, String>? params}) async {
    var token = await readTokenOrNull();
    final headers = token != null ? jsonHeaders(token: token) : {'Accept': 'application/json'};
    var res = await _client.get(uri(path, params), headers: headers).timeout(timeout);
    if (res.statusCode == 401 && token != null) {
      await refreshAccessToken();
      token = await requireToken();
      res = await _client
          .get(uri(path, params), headers: jsonHeaders(token: token))
          .timeout(timeout);
    }
    return res;
  }

  /// Authenticated JSON POST. Throws [Exception] on non-2xx responses.
  /// Automatically refreshes the access token once on 401 and retries.
  Future<void> postJson(
    String path,
    Object body, {
    Map<String, String>? params,
  }) async {
    Future<http.Response> doPost(String t) => _client
        .post(uri(path, params), headers: jsonHeaders(token: t), body: jsonEncode(body))
        .timeout(timeout);

    var token = await requireToken();
    var res = await doPost(token);
    if (res.statusCode == 401) {
      await refreshAccessToken();
      token = await requireToken();
      res = await doPost(token);
    }
    if (!_okStatuses.contains(res.statusCode)) {
      throw Exception(readErrorBody(res));
    }
  }
}

final apiClientProvider = Provider<ApiClient>((_) => ApiClient());
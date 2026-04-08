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
  Future<http.Response> get(String path, {Map<String, String>? params}) async {
    final token = await requireToken();
    return _client
        .get(uri(path, params), headers: jsonHeaders(token: token))
        .timeout(timeout);
  }

  /// GET with optional auth — uses Bearer token when available, falls back to
  /// Accept-only headers (for public or partially-public endpoints).
  Future<http.Response> getOptionalAuth(String path, {Map<String, String>? params}) async {
    final token = await readTokenOrNull();
    final headers = token != null
        ? jsonHeaders(token: token)
        : {'Accept': 'application/json'};
    return _client.get(uri(path, params), headers: headers).timeout(timeout);
  }

  /// Authenticated JSON POST. Throws [Exception] on non-2xx responses.
  Future<void> postJson(
    String path,
    Object body, {
    Map<String, String>? params,
  }) async {
    final token = await requireToken();
    final res = await _client
        .post(
          uri(path, params),
          headers: jsonHeaders(token: token),
          body: jsonEncode(body),
        )
        .timeout(timeout);
    if (!_okStatuses.contains(res.statusCode)) {
      throw Exception('API error ${res.statusCode} on POST $path');
    }
  }
}

final apiClientProvider = Provider<ApiClient>((_) => ApiClient());
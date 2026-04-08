import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthRepository {
  Future<void> loginWithEmail(String email, String password);
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required String phone,
    required String verifyMethod,
    required String techComfort,
    required String systemLanguage,
  });
  Future<void> verifyOtp(String otp);
  Future<void> sendOtp();
  Future<void> updatePhone(String phone);
  Future<void> resetPassword(String newPassword);
  Future<void> logout();
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<void> loginWithEmail(String email, String password) => Future.value();

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required String phone,
    required String verifyMethod,
    required String techComfort,
    required String systemLanguage,
  }) =>
      Future.value();

  @override
  Future<void> verifyOtp(String otp) => Future.value();

  @override
  Future<void> sendOtp() => Future.value();

  @override
  Future<void> updatePhone(String phone) => Future.value();

  @override
  Future<void> resetPassword(String newPassword) => Future.value();

  @override
  Future<void> logout() => Future.value();
}

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? const String.fromEnvironment(
          'ITHAKI_API_BASE_URL',
          defaultValue: 'https://api.odyssea.com/talent/staging',
        );

  final http.Client _client;
  final String _baseUrl;

  String get _apiBase {
    final trimmed =
        _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    return trimmed.endsWith('/api') ? trimmed : '$trimmed/api';
  }

  Uri _uri(String path) => Uri.parse('$_apiBase$path');

  Map<String, String> _jsonHeaders({String? token}) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

  String? _extractToken(Map<String, dynamic> data) {
    final direct = data['accessToken'] ?? data['token'];
    if (direct is String && direct.isNotEmpty) return direct;

    final nestedData = data['data'];
    if (nestedData is Map<String, dynamic>) {
      final nested = nestedData['accessToken'] ?? nestedData['token'];
      if (nested is String && nested.isNotEmpty) return nested;
    }
    return null;
  }

  static const _storage = FlutterSecureStorage();

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    final accessToken = _extractToken(data);
    if (accessToken != null) await _storage.write(key: 'jwt_token', value: accessToken);

    final refreshToken = data['refreshToken'] ?? data['data']?['refreshToken'];
    if (refreshToken is String && refreshToken.isNotEmpty) {
      await _storage.write(key: 'jwt_refresh_token', value: refreshToken);
    }
  }

  Future<String> _requireToken() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) throw Exception('Missing auth token');
    return token;
  }

  Future<void> _triggerOtpSms(String token) async {
    final response = await _client
        .post(
          _uri('/user/sendSMS/twilio'),
          headers: _jsonHeaders(token: token),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('OTP send failed: ${_readErrorBody(response)}');
    }
  }

  String _readErrorBody(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'] ?? decoded['error'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
    } catch (_) {
      // Fallback to raw body when response isn't JSON.
    }
    return response.body.isEmpty ? 'Unknown server error' : response.body;
  }

  @override
  Future<void> loginWithEmail(String email, String password) async {
    final response = await _client
        .post(
          _uri('/auth/login'),
          headers: _jsonHeaders(),
          body: jsonEncode({
            'email': email.trim(),
            'password': password,
          }),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Login failed: ${_readErrorBody(response)}');
    }

    final Map<String, dynamic> data =
        (jsonDecode(response.body) as Map).cast<String, dynamic>();
    final token = _extractToken(data);
    if (token == null) {
      throw Exception('Login failed: token not found in response');
    }
    await _saveTokens(data);
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required String phone,
    required String verifyMethod,
    required String techComfort,
    required String systemLanguage,
  }) async {
    final signupResponse = await _client
        .post(
          _uri('/auth/signup'),
          headers: _jsonHeaders(),
          body: jsonEncode({
            'email': email.trim(),
            'password': password,
            'confirmPassword': password,
            'systemLanguage': systemLanguage.toUpperCase(),
            'techComfort': techComfort,
          }),
        )
        .timeout(const Duration(seconds: 20));

    if (signupResponse.statusCode != 200 && signupResponse.statusCode != 201) {
      throw Exception('Signup failed: ${_readErrorBody(signupResponse)}');
    }

    final Map<String, dynamic> data =
        (jsonDecode(signupResponse.body) as Map).cast<String, dynamic>();
    final token = _extractToken(data);
    if (token == null) {
      throw Exception('Signup failed: token not found in response');
    }
    await _saveTokens(data);

    // Save personal details after signup so Twilio has a phone number to target.
    final profileResponse = await _client
        .post(
          _uri('/user/me'),
          headers: _jsonHeaders(token: token),
          body: jsonEncode({
            'firstName': name.trim(),
            'lastName': lastName.trim(),
            'phone': phone.replaceAll(RegExp(r'\s+'), ''),
          }),
        )
        .timeout(const Duration(seconds: 20));

    if (profileResponse.statusCode != 200 && profileResponse.statusCode != 201) {
      throw Exception('Profile save failed: ${_readErrorBody(profileResponse)}');
    }

    // OTP send is best-effort — if Twilio fails the user can retry from the OTP screen.
    try {
      await _triggerOtpSms(token);
    } catch (_) {}
  }

  @override
  Future<void> sendOtp() async {
    final token = await _requireToken();
    await _triggerOtpSms(token);
  }

  @override
  Future<void> updatePhone(String phone) async {
    final token = await _requireToken();
    await _client
        .post(
          _uri('/user/me'),
          headers: _jsonHeaders(token: token),
          body: jsonEncode({'phone': phone.replaceAll(RegExp(r'\s+'), '')}),
        )
        .timeout(const Duration(seconds: 20));
  }

  @override
  Future<void> verifyOtp(String otp) async {
    final token = await _requireToken();

    final response = await _client
        .post(
          _uri('/user/sendSMS/verify'),
          headers: {
            'Content-Type': 'text/plain',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: otp.trim(),
        )
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('OTP verification failed: ${_readErrorBody(response)}');
    }

    final raw = response.body.trim().toLowerCase();
    if (raw == 'false') {
      throw Exception('OTP verification failed: invalid code');
    }
  }

  @override
  Future<void> resetPassword(String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }
}

const bool _useMockAuth = bool.fromEnvironment('ITHAKI_USE_MOCK_AUTH');

final authRepositoryProvider = Provider<AuthRepository>(
  (_) => _useMockAuth ? MockAuthRepository() : ApiAuthRepository(),
);

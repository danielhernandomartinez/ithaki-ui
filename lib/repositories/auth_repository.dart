import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'profile/profile_local_store.dart';

import '../config/app_config.dart';
import '../services/api_client.dart';

class AuthException implements Exception {
  const AuthException(this.userMessage, {this.internalDetail});
  final String userMessage;
  final String? internalDetail;

  @override
  String toString() => 'AuthException: $userMessage'
      '${internalDetail != null ? ' [$internalDetail]' : ''}';
}

enum AccountType { jobSeeker, employer }

class LoginSession {
  const LoginSession({required this.accountType});

  final AccountType accountType;

  bool get isEmployer => accountType == AccountType.employer;
}

abstract class AuthRepository {
  Future<LoginSession> loginWithEmail(String email, String password);
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
  Future<LoginSession> loginWithEmail(String email, String password) async {
    await ApiAuthRepository._storage.write(
      key: 'jwt_token',
      value: 'mock-token',
    );
    await ProfileLocalStore.savePhoneVerified(true);
    return const LoginSession(accountType: AccountType.jobSeeker);
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
    await ApiAuthRepository._storage.write(
      key: 'jwt_token',
      value: 'mock-token',
    );
    await ProfileLocalStore.savePhoneVerified(true);
  }

  @override
  Future<void> verifyOtp(String otp) async {
    await ApiAuthRepository._storage.write(
      key: 'jwt_token',
      value: 'mock-token',
    );
    await ProfileLocalStore.savePhoneVerified(true);
  }

  @override
  Future<void> sendOtp() => Future.value();

  @override
  Future<void> updatePhone(String phone) => Future.value();

  @override
  Future<void> resetPassword(String newPassword) => Future.value();

  @override
  Future<void> logout() async {
    await ApiAuthRepository._storage.delete(key: 'jwt_token');
    await ApiAuthRepository._storage.delete(key: 'jwt_refresh_token');
    await ProfileLocalStore.clearAll();
  }
}

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  // Storage is kept here because auth is the only place that *writes* tokens.
  static const _storage = FlutterSecureStorage();

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

  AccountType _extractAccountType(Map<String, dynamic> data) {
    final values = <Object?>[
      data['accountType'],
      data['userType'],
      data['type'],
      data['role'],
      data['authority'],
      data['roles'],
      data['authorities'],
    ];

    final nestedData = data['data'];
    if (nestedData is Map<String, dynamic>) {
      values.addAll([
        nestedData['accountType'],
        nestedData['userType'],
        nestedData['type'],
        nestedData['role'],
        nestedData['authority'],
        nestedData['roles'],
        nestedData['authorities'],
        nestedData['user'],
      ]);
    }

    final user = data['user'];
    if (user is Map<String, dynamic>) {
      values.addAll([
        user['accountType'],
        user['userType'],
        user['type'],
        user['role'],
        user['authority'],
        user['roles'],
        user['authorities'],
      ]);
    }

    final token = _extractToken(data);
    final tokenClaims = token == null ? null : _decodeJwtPayload(token);
    if (tokenClaims != null) {
      values.add(tokenClaims);
    }

    return _containsEmployerMarker(values)
        ? AccountType.employer
        : AccountType.jobSeeker;
  }

  Map<String, dynamic>? _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length < 2) return null;
    try {
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payload = jsonDecode(decoded);
      return payload is Map<String, dynamic> ? payload : null;
    } catch (_) {
      return null;
    }
  }

  bool _containsEmployerMarker(Iterable<Object?> values) {
    for (final value in values) {
      if (value == null) continue;
      if (value is Iterable) {
        if (_containsEmployerMarker(value.cast<Object?>())) return true;
        continue;
      }
      if (value is Map) {
        if (_containsEmployerMarker(value.values.cast<Object?>())) return true;
        continue;
      }
      final normalized =
          value.toString().toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
      if (normalized.contains('employer') ||
          normalized.contains('company') ||
          normalized.contains('organization') ||
          normalized.contains('organisation')) {
        return true;
      }
    }
    return false;
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    // New session: clear previous user's cached profile data.
    await ProfileLocalStore.clearAll();

    final accessToken = _extractToken(data);
    if (accessToken != null) {
      await _storage.write(key: 'jwt_token', value: accessToken);
    }

    final refreshToken = data['refreshToken'] ?? data['data']?['refreshToken'];
    if (refreshToken is String && refreshToken.isNotEmpty) {
      await _storage.write(key: 'jwt_refresh_token', value: refreshToken);
    }
  }

  Future<void> _triggerOtpSms(String token) async {
    final response = await _api.client
        .post(
          _api.uri('/user/send-sms/twilio'),
          headers: _api.jsonHeaders(token: token),
        )
        .timeout(ApiClient.timeout);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw AuthException(
        'Could not send verification code. Please try again.',
        internalDetail: _api.readErrorBody(response),
      );
    }
  }

  @override
  Future<LoginSession> loginWithEmail(String email, String password) async {
    final response = await _api.client
        .post(
          _api.uri('/auth/login'),
          headers: _api.jsonHeaders(),
          body: jsonEncode({
            'email': email.trim(),
            'password': password,
          }),
        )
        .timeout(ApiClient.timeout);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw AuthException(
        response.statusCode == 401
            ? 'Invalid email or password.'
            : 'Login failed. Please try again.',
        internalDetail: _api.readErrorBody(response),
      );
    }

    final Map<String, dynamic> data;
    try {
      data = (jsonDecode(response.body) as Map).cast<String, dynamic>();
    } on FormatException {
      throw AuthException(
        'Login failed. Please try again.',
        internalDetail: 'server returned non-JSON response',
      );
    }
    final token = _extractToken(data);
    if (token == null) {
      throw AuthException(
        'Login failed. Please try again.',
        internalDetail: 'token not found in response',
      );
    }
    await _saveTokens(data);
    // Login users are exempt from phone verification — only registration enforces it.
    await ProfileLocalStore.savePhoneVerified(true);
    return LoginSession(accountType: _extractAccountType(data));
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
    final signupResponse = await _api.client
        .post(
          _api.uri('/auth/signup'),
          headers: _api.jsonHeaders(),
          body: jsonEncode({
            'email': email.trim(),
            'password': password,
            'confirmPassword': password,
            'systemLanguage': systemLanguage.toUpperCase(),
            'techComfort': techComfort,
          }),
        )
        .timeout(ApiClient.timeout);

    if (signupResponse.statusCode != 200 && signupResponse.statusCode != 201) {
      throw AuthException(
        'Registration failed. Please try again.',
        internalDetail: _api.readErrorBody(signupResponse),
      );
    }

    final Map<String, dynamic> data;
    try {
      data = (jsonDecode(signupResponse.body) as Map).cast<String, dynamic>();
    } on FormatException {
      throw AuthException(
        'Registration failed. Please try again.',
        internalDetail: 'server returned non-JSON response',
      );
    }
    final token = _extractToken(data);
    if (token == null) {
      throw AuthException(
        'Registration failed. Please try again.',
        internalDetail: 'token not found in response',
      );
    }
    await _saveTokens(data);
    await ProfileLocalStore.savePhoneVerified(false);

    // Save personal details after signup so Twilio has a phone number to target.
    final profileResponse = await _api.client
        .post(
          _api.uri('/user/me'),
          headers: _api.jsonHeaders(token: token),
          body: jsonEncode({
            'firstName': name.trim(),
            'lastName': lastName.trim(),
            'phone': phone.replaceAll(RegExp(r'\s+'), ''),
          }),
        )
        .timeout(ApiClient.timeout);

    if (profileResponse.statusCode != 200 &&
        profileResponse.statusCode != 201) {
      throw AuthException(
        'Could not save profile. Please try again.',
        internalDetail: _api.readErrorBody(profileResponse),
      );
    }

    // OTP send is best-effort — if Twilio fails the user can retry from the OTP screen.
    try {
      await _triggerOtpSms(token);
    } catch (_) {}
  }

  @override
  Future<void> sendOtp() async {
    final token = await _api.requireToken();
    await _triggerOtpSms(token);
  }

  @override
  Future<void> updatePhone(String phone) async {
    final token = await _api.requireToken();
    final response = await _api.client
        .post(
          _api.uri('/user/me'),
          headers: _api.jsonHeaders(token: token),
          body: jsonEncode({'phone': phone.replaceAll(RegExp(r'\s+'), '')}),
        )
        .timeout(ApiClient.timeout);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw AuthException(
        'Could not update phone number. Please try again.',
        internalDetail: _api.readErrorBody(response),
      );
    }
  }

  @override
  Future<void> verifyOtp(String otp) async {
    final token = await _api.requireToken();

    final response = await _api.client
        .post(
          _api.uri('/user/send-sms/verify'),
          headers: {
            'Content-Type': 'text/plain',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: otp.trim(),
        )
        .timeout(ApiClient.timeout);

    debugPrint(
        '[verifyOtp] status=${response.statusCode} body=${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw AuthException(
        'Verification failed. Please try again.',
        internalDetail: _api.readErrorBody(response),
      );
    }

    final raw = response.body.trim().toLowerCase();
    if (raw != 'true') {
      throw AuthException(
        'Invalid verification code.',
        internalDetail: 'OTP response body was not "true"',
      );
    }

    await ProfileLocalStore.savePhoneVerified(true);
  }

  @override
  Future<void> resetPassword(String newPassword) async {
    // TODO: implement reset password via API once endpoint is available
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'jwt_refresh_token');
    await ProfileLocalStore.clearAll();
  }
}

const bool _useMockAuth =
    AppConfig.useMockData || bool.fromEnvironment('ITHAKI_USE_MOCK_AUTH');

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => _useMockAuth
      ? MockAuthRepository()
      : ApiAuthRepository(apiClient: ref.watch(apiClientProvider)),
);

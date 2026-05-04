import 'dart:async';
import 'dart:convert';


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
  Future<void> loginWithEmail(String email, String password) async {
    await ApiAuthRepository._storage.write(
      key: 'jwt_token',
      value: 'mock-token',
    );
    await ProfileLocalStore.savePhoneVerified(true);
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

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    // New session: clear previous user's cached profile data.
    await ProfileLocalStore.clearAll();

    final accessToken = _extractToken(data);
    if (accessToken != null) await _storage.write(key: 'jwt_token', value: accessToken);

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
    ApiClient.log('POST', _api.uri('/user/send-sms/twilio'), response.statusCode);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw AuthException(
        'Could not send verification code. Please try again.',
        internalDetail: _api.readErrorBody(response),
      );
    }
  }

  @override
  Future<void> loginWithEmail(String email, String password) async {
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
    ApiClient.log('POST', _api.uri('/auth/login'), response.statusCode);

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
    ApiClient.log('POST', _api.uri('/auth/signup'), signupResponse.statusCode);

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
    ApiClient.log('POST', _api.uri('/user/me'), profileResponse.statusCode);

    if (profileResponse.statusCode != 200 && profileResponse.statusCode != 201) {
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
    ApiClient.log('POST', _api.uri('/user/me'), response.statusCode);

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

    ApiClient.log('POST', _api.uri('/user/send-sms/verify'), response.statusCode);

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

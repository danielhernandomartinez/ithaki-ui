import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'profile/profile_local_store.dart';

import '../services/api_client.dart';
import '../services/session_service.dart';

class AuthException implements Exception {
  const AuthException(this.userMessage, {this.internalDetail});
  final String userMessage;
  final String? internalDetail;

  @override
  String toString() => 'AuthException: $userMessage'
      '${internalDetail != null ? ' [$internalDetail]' : ''}';
}

class LoginSession {
  final bool isNewUser;
  final bool phoneVerified;
  final String name;
  final String lastName;
  final String email;

  const LoginSession({
    this.isNewUser = false,
    this.phoneVerified = true,
    this.name = '',
    this.lastName = '',
    this.email = '',
  });
}

abstract class AuthRepository {
  Future<LoginSession> loginWithEmail(String email, String password);
  Future<LoginSession> loginWithGoogle(String idToken);
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
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> logout();
}

class MockAuthRepository implements AuthRepository {
  MockAuthRepository({SessionService? sessionService})
      : _sessionService = sessionService ?? SessionService();

  final SessionService _sessionService;

  @override
  Future<LoginSession> loginWithEmail(String email, String password) async {
    await _sessionService.saveTokens(accessToken: 'mock-token');
    await ProfileLocalStore.savePhoneVerified(true);
    return const LoginSession();
  }

  @override
  Future<LoginSession> loginWithGoogle(String idToken) async {
    await _sessionService.saveTokens(accessToken: 'mock-token');
    await ProfileLocalStore.savePhoneVerified(true);
    return const LoginSession(isNewUser: false);
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
    await _sessionService.saveTokens(accessToken: 'mock-token');
    await ProfileLocalStore.savePhoneVerified(true);
  }

  @override
  Future<void> verifyOtp(String otp) async {
    await _sessionService.saveTokens(accessToken: 'mock-token');
    await ProfileLocalStore.savePhoneVerified(true);
  }

  @override
  Future<void> sendOtp() => Future.value();

  @override
  Future<void> updatePhone(String phone) => Future.value();

  @override
  Future<void> forgotPassword(String email) => Future.value();

  @override
  Future<void> resetPassword(String token, String newPassword) =>
      Future.value();

  @override
  Future<void> logout() async {
    await _sessionService.clearTokens();
    await ProfileLocalStore.clearAll();
  }
}

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({ApiClient? apiClient, SessionService? sessionService})
      : _api = apiClient ?? ApiClient(sessionService: sessionService),
        _sessionService =
            sessionService ?? apiClient?.sessionService ?? SessionService();

  final ApiClient _api;
  final SessionService _sessionService;

  @override
  Future<LoginSession> loginWithGoogle(String idToken) async {
    developer.log('Google token exchange started', name: 'ithaki.auth');
    final response = await _api.client
        .post(
          _api.uri('/auth/google'),
          headers: _api.jsonHeaders(),
          body: jsonEncode({'idToken': idToken}),
        )
        .timeout(ApiClient.authTimeout);
    ApiClient.log('POST', _api.uri('/auth/google'), response.statusCode);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw AuthException(
        'Google sign-in failed. Please try again.',
        internalDetail: _api.readErrorBody(response),
      );
    }

    final Map<String, dynamic> data;
    try {
      data = (jsonDecode(response.body) as Map).cast<String, dynamic>();
    } on FormatException {
      throw AuthException(
        'Google sign-in failed. Please try again.',
        internalDetail: 'server returned non-JSON response',
      );
    }
    final token = _extractToken(data);
    if (token == null) {
      throw AuthException(
        'Google sign-in failed. Please try again.',
        internalDetail: 'token not found in response',
      );
    }
    await _saveTokens(data);
    developer.log('Google auth payload: $data', name: 'ithaki.auth');

    // /auth/google does not return phoneVerified — fetch it from /user/me.
    final userInfo = await _fetchUserInfo();
    final phoneVerified = userInfo['phoneVerified'] == true;
    await ProfileLocalStore.savePhoneVerified(phoneVerified);

    final name = userInfo['firstName'] as String? ?? '';
    final lastName = userInfo['lastName'] as String? ?? '';
    final email = userInfo['email'] as String? ?? data['email'] as String? ?? '';

    developer.log('Google token exchange succeeded phoneVerified=$phoneVerified', name: 'ithaki.auth');
    return LoginSession(phoneVerified: phoneVerified, name: name, lastName: lastName, email: email);
  }

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

  Future<Map<String, dynamic>> _fetchUserInfo() async {
    try {
      final response = await _api.get('/user/me');
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as Map).cast<String, dynamic>();
      }
    } catch (_) {}
    return {};
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    // New session: clear previous user's cached profile data.
    await ProfileLocalStore.clearAll();

    final accessToken = _extractToken(data);
    final refreshToken = data['refreshToken'] ?? data['data']?['refreshToken'];
    await _sessionService.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken is String ? refreshToken : null,
    );
  }

  Future<void> _triggerOtpSms(String token) async {
    final response = await _api.client
        .post(
          _api.uri('/user/send-sms/twilio'),
          headers: _api.jsonHeaders(token: token),
        )
        .timeout(ApiClient.timeout);
    ApiClient.log(
        'POST', _api.uri('/user/send-sms/twilio'), response.statusCode);

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
    return const LoginSession();
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
    } catch (e) {
      _logOtpSendFailure(e);
    }
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

    ApiClient.log(
        'POST', _api.uri('/user/send-sms/verify'), response.statusCode);

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
  Future<void> forgotPassword(String email) async {
    developer.log('Password reset link request started', name: 'ithaki.auth');
    final response = await _api.client
        .post(
          _api.uri('/auth/forgot-password'),
          headers: _api.jsonHeaders(),
          body: jsonEncode({'email': email.trim()}),
        )
        .timeout(ApiClient.authTimeout);
    ApiClient.log(
        'POST', _api.uri('/auth/forgot-password'), response.statusCode);

    // Non-2xx is unexpected; silent on unknown email is handled server-side.
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw AuthException(
        'Could not send reset link. Please try again.',
        internalDetail: _api.readErrorBody(response),
      );
    }
    developer.log('Password reset link request accepted', name: 'ithaki.auth');
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    developer.log('Password reset request started', name: 'ithaki.auth');
    final response = await _api.client
        .post(
          _api.uri('/auth/reset-password'),
          headers: _api.jsonHeaders(),
          body: jsonEncode({'token': token, 'newPassword': newPassword}),
        )
        .timeout(ApiClient.authTimeout);
    ApiClient.log(
        'POST', _api.uri('/auth/reset-password'), response.statusCode);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw AuthException(
        response.statusCode == 400
            ? 'Reset link is invalid or expired.'
            : 'Password reset failed. Please try again.',
        internalDetail: _api.readErrorBody(response),
      );
    }
    developer.log('Password reset request succeeded', name: 'ithaki.auth');
  }

  @override
  Future<void> logout() async {
    await _sessionService.clearTokens();
    await ProfileLocalStore.clearAll();
  }

  static void _logOtpSendFailure(Object error) {
    final summary = error is AuthException
        ? error.userMessage
        : error is TimeoutException
            ? 'Request timed out'
            : error.runtimeType.toString();
    developer.log(
      'Initial OTP send failed after registration: $summary',
      name: 'ithaki.auth',
    );
  }
}

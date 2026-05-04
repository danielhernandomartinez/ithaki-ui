import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:ithaki_ui/repositories/auth_repository.dart';
import 'package:ithaki_ui/services/api_client.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final storage = <String, String>{};
  const storageChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  setUp(() {
    storage.clear();
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      storageChannel,
      (call) async {
        final args = (call.arguments as Map?) ?? const {};
        final key = args['key'] as String?;
        switch (call.method) {
          case 'write':
            storage[key!] = args['value'] as String;
          case 'read':
            return storage[key];
          case 'delete':
            storage.remove(key);
          case 'deleteAll':
            storage.clear();
          case 'readAll':
            return storage;
        }
        return null;
      },
    );
  });

  ApiAuthRepository repoFor(Map<String, dynamic> body) {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/auth/login');
      return http.Response(jsonEncode(body), 200);
    });
    return ApiAuthRepository(
      apiClient: ApiClient(client: client, baseUrl: 'http://localhost'),
    );
  }

  String tokenWithPayload(Map<String, dynamic> payload) {
    String part(Object value) =>
        base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
    return '${part({'alg': 'none'})}.${part(payload)}.';
  }

  test('loginWithEmail detects employer account from login response role',
      () async {
    final repo = repoFor({
      'accessToken': 'token',
      'role': 'EMPLOYER',
    });

    final session = await repo.loginWithEmail('employer@example.com', 'secret');

    expect(session.accountType, AccountType.employer);
  });

  test('loginWithEmail detects employer account from nested roles', () async {
    final repo = repoFor({
      'data': {
        'accessToken': 'token',
        'user': {
          'roles': ['ROLE_EMPLOYER'],
        },
      },
    });

    final session = await repo.loginWithEmail('employer@example.com', 'secret');

    expect(session.isEmployer, isTrue);
  });

  test('loginWithEmail detects employer account from JWT claims', () async {
    final repo = repoFor({
      'accessToken': tokenWithPayload({
        'roles': ['ROLE_EMPLOYER'],
      }),
    });

    final session = await repo.loginWithEmail('employer@example.com', 'secret');

    expect(session.isEmployer, isTrue);
  });
}

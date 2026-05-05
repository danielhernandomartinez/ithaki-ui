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

  ApiAuthRepository repoFor(Map<String, dynamic> body, {int status = 200}) {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/auth/login');
      return http.Response(jsonEncode(body), status);
    });
    return ApiAuthRepository(
      apiClient: ApiClient(client: client, baseUrl: 'http://localhost'),
    );
  }

  test('loginWithEmail returns LoginSession on success', () async {
    final repo = repoFor({'accessToken': 'token123'});

    final session = await repo.loginWithEmail('user@example.com', 'secret');

    expect(session, isA<LoginSession>());
  });

  test('loginWithEmail saves access token to storage', () async {
    final repo = repoFor({'accessToken': 'mytoken'});

    await repo.loginWithEmail('user@example.com', 'secret');

    expect(storage['jwt_token'], 'mytoken');
  });

  test('loginWithEmail accepts token in nested data field', () async {
    final repo = repoFor({
      'data': {'accessToken': 'nested-token'},
    });

    await repo.loginWithEmail('user@example.com', 'secret');

    expect(storage['jwt_token'], 'nested-token');
  });

  test('loginWithEmail throws AuthException on 401', () async {
    final repo = repoFor({'error': 'Unauthorized'}, status: 401);

    expect(
      () => repo.loginWithEmail('user@example.com', 'wrong'),
      throwsA(isA<AuthException>()),
    );
  });

  test('loginWithEmail throws AuthException when token missing', () async {
    final repo = repoFor({'someOtherField': 'value'});

    expect(
      () => repo.loginWithEmail('user@example.com', 'secret'),
      throwsA(isA<AuthException>()),
    );
  });
}

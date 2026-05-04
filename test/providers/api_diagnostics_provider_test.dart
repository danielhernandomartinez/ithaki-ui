import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:ithaki_ui/providers/api_diagnostics_provider.dart';
import 'package:ithaki_ui/services/api_client.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('runEndpoint captures non-2xx responses without throwing', () async {
    final repo = ApiDiagnosticsRepository(
      apiClient: ApiClient(
        baseUrl: 'http://localhost',
        client: MockClient(
          (_) async => http.Response('Unauthorized', 401),
        ),
      ),
    );

    final result = await repo.runEndpoint(
      const ApiDiagnosticEndpoint(
        id: 'user',
        title: 'Current user',
        path: '/user/me',
        requiresAuth: true,
      ),
    );

    expect(result.statusCode, 401);
    expect(result.hasError, isTrue);
    expect(result.error, isNull);
    expect(result.responsePreview, 'Unauthorized');
  });

  test('runEndpoint sends bearer token when one is stored', () async {
    FlutterSecureStorage.setMockInitialValues({'jwt_token': 'abc'});

    late Map<String, String> headers;
    final repo = ApiDiagnosticsRepository(
      apiClient: ApiClient(
        baseUrl: 'http://localhost',
        client: MockClient((request) async {
          headers = request.headers;
          return http.Response('[]', 200);
        }),
      ),
    );

    await repo.runEndpoint(
      const ApiDiagnosticEndpoint(
        id: 'jobs',
        title: 'Jobs',
        path: '/jobs',
      ),
    );

    expect(headers['Authorization'], 'Bearer abc');
  });
}

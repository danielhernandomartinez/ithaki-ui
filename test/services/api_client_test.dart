import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:ithaki_ui/services/api_client.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('optional auth 401 does not expire session when refresh fails',
      () async {
    FlutterSecureStorage.setMockInitialValues({
      'jwt_token': 'expired-access',
      'jwt_refresh_token': 'expired-refresh',
    });

    var sessionExpired = false;
    final api = ApiClient(
      baseUrl: 'http://localhost',
      onSessionExpired: () => sessionExpired = true,
      client: MockClient((request) async {
        if (request.url.path == '/api/auth/refresh') {
          return http.Response('Unauthorized', 401);
        }

        if (request.url.path == '/api/skills/soft' &&
            request.headers['Authorization'] == 'Bearer expired-access') {
          return http.Response('Unauthorized', 401);
        }

        if (request.url.path == '/api/skills/soft' &&
            !request.headers.containsKey('Authorization')) {
          return http.Response('[{"id":1,"name":"Communication"}]', 200);
        }

        return http.Response('Unexpected request', 500);
      }),
    );

    final response = await api.getOptionalAuth('/skills/soft');

    expect(response.statusCode, 200);
    expect(sessionExpired, isFalse);
  });
}

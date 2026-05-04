import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:ithaki_ui/providers/company_provider.dart';
import 'package:ithaki_ui/services/api_client.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  late _MockApiClient api;
  late ApiCompanyRepository repo;

  setUp(() {
    api = _MockApiClient();
    repo = ApiCompanyRepository(apiClient: api);
  });

  test('company profile uses optional auth to avoid session-expired redirects',
      () async {
    when(() => api.getOptionalAuth('/companies/company-1')).thenAnswer(
      (_) async => http.Response('Unauthorized', 401),
    );

    await expectLater(repo.getCompany('company-1'), throwsA(anything));

    verify(() => api.getOptionalAuth('/companies/company-1')).called(1);
    verifyNever(() => api.get('/companies/company-1'));
  });
}

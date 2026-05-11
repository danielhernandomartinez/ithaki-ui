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
    when(() => api.getOptionalAuth('/company/company-1')).thenAnswer(
      (_) async => http.Response('Unauthorized', 401),
    );

    await expectLater(repo.getCompany('company-1'), throwsA(anything));

    verify(() => api.getOptionalAuth('/company/company-1')).called(1);
    verifyNever(() => api.get('/company/company-1'));
  });

  test('company profile loads vacancies from the dedicated endpoint', () async {
    when(() => api.getOptionalAuth('/company/company-1')).thenAnswer(
      (_) async => http.Response('{"id":"company-1","name":"Acme Corp"}', 200),
    );
    when(() => api.getOptionalAuth('/company/company-1/vacancies')).thenAnswer(
      (_) async => http.Response(
        '{"content":[{"id":7,"title":"Backend Developer"}]}',
        200,
      ),
    );

    final company = await repo.getCompany('company-1');

    expect(company.name, 'Acme Corp');
    expect(company.vacancies.single.id, '7');
    expect(company.vacancies.single.jobTitle, 'Backend Developer');
    expect(company.events, isEmpty);
    expect(company.posts, isEmpty);
    verify(() => api.getOptionalAuth('/company/company-1')).called(1);
    verify(() => api.getOptionalAuth('/company/company-1/vacancies')).called(1);
  });
}

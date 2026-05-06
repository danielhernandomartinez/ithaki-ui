import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:ithaki_ui/repositories/reference_data_repository.dart';
import 'package:ithaki_ui/services/api_client.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  setUpAll(() {
    registerFallbackValue(http.Response('', 500));
  });

  late _MockApiClient api;
  late ReferenceDataRepository repo;

  setUp(() {
    api = _MockApiClient();
    repo = ReferenceDataRepository(apiClient: api);
  });

  test('personality values throw when API is unavailable', () async {
    when(() => api.getOptionalAuth('/list/personality-values'))
        .thenThrow(Exception('Missing auth token'));

    expect(repo.getPersonalityValues(), throwsException);
    verifyNever(() => api.get('/list/personality-values'));
  });

  test('hard skills throw when optional auth returns unauthorized', () async {
    when(() => api.getOptionalAuth('/skills/hard')).thenAnswer(
      (_) async => http.Response('Unauthorized', 401),
    );
    when(() => api.readErrorBody(any())).thenReturn('Unauthorized');

    expect(repo.getHardSkills(), throwsException);
    verifyNever(() => api.get('/skills/hard'));
  });

  test('soft skills throw when optional auth returns unauthorized', () async {
    when(() => api.getOptionalAuth('/skills/soft')).thenAnswer(
      (_) async => http.Response('Unauthorized', 401),
    );
    when(() => api.readErrorBody(any())).thenReturn('Unauthorized');

    expect(repo.getSoftSkills(), throwsException);
    verifyNever(() => api.get('/skills/soft'));
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ithaki_ui/repositories/reference_data_repository.dart';
import 'package:ithaki_ui/services/api_client.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  late _MockApiClient api;
  late ReferenceDataRepository repo;

  setUp(() {
    api = _MockApiClient();
    repo = ReferenceDataRepository(apiClient: api);
  });

  test('personality values fall back before login when auth token is missing',
      () async {
    when(() => api.getOptionalAuth('/list/personality-values'))
        .thenThrow(Exception('Missing auth token'));

    final values = await repo.getPersonalityValues();

    expect(values, isNotEmpty);
    expect(values.map((v) => v.title), contains('Learning'));
    verifyNever(() => api.get('/list/personality-values'));
  });
}

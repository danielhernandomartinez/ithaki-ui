import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/providers/application_detail_provider.dart';
import 'package:ithaki_ui/repositories/application_detail_repository.dart';
import 'package:ithaki_ui/services/api_client.dart';

void main() {
  test('applicationDetailRepositoryProvider uses API repository by default',
      () {
    final container = ProviderContainer(
      overrides: [
        apiClientProvider.overrideWithValue(
          ApiClient(baseUrl: 'http://localhost'),
        ),
      ],
    );
    addTearDown(container.dispose);

    expect(
      container.read(applicationDetailRepositoryProvider),
      isA<ApiApplicationDetailRepository>(),
    );
  });
}

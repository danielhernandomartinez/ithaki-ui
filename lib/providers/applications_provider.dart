import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/applications_models.dart';
import '../repositories/applications_repository.dart';
import '../services/api_client.dart';

final applicationsRepositoryProvider = Provider<ApplicationsRepository>(
  (ref) => AppConfig.useMockData
      ? MockApplicationsRepository()
      : ApiApplicationsRepository(apiClient: ref.watch(apiClientProvider)),
);

final applicationsProvider =
    AsyncNotifierProvider<ApplicationsNotifier, List<Application>>(
  ApplicationsNotifier.new,
);

class ApplicationsNotifier extends AsyncNotifier<List<Application>> {
  @override
  Future<List<Application>> build() =>
      ref.read(applicationsRepositoryProvider).getApplications();
}

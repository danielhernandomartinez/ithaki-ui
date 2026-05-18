import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/applications_models.dart';
import '../repositories/applications_repository.dart';
import '../services/api_client.dart';
import 'swr_async_notifier.dart';

final applicationsRepositoryProvider = Provider<ApplicationsRepository>(
  (ref) => AppConfig.useMockData
      ? MockApplicationsRepository()
      : ApiApplicationsRepository(apiClient: ref.watch(apiClientProvider)),
);

final applicationsProvider =
    AsyncNotifierProvider<ApplicationsNotifier, List<Application>>(
  ApplicationsNotifier.new,
);

class ApplicationsNotifier extends SwrAsyncNotifier<List<Application>> {
  @override
  String get cacheKey => 'applications';

  @override
  Future<List<Application>> load() =>
      ref.read(applicationsRepositoryProvider).getApplications();
}

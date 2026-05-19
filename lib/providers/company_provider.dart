import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/company_models.dart';
import '../repositories/company_repository.dart';
import '../services/api_client.dart';
import 'swr_async_notifier.dart';

final companyRepositoryProvider = Provider<CompanyRepository>(
  (ref) => AppConfig.useMockData
      ? MockCompanyRepository()
      : ApiCompanyRepository(apiClient: ref.watch(apiClientProvider)),
);

final companyProvider = FutureProvider.family<CompanyProfile, String>(
  (ref, companyId) async {
    return ref.read(swrCacheProvider).getOrRefresh(
          key: 'company.$companyId',
          ttl: const Duration(minutes: 10),
          load: () async {
            try {
              return await ref
                  .watch(companyRepositoryProvider)
                  .getCompany(companyId);
            } catch (_) {
              if (AppConfig.useMockData) {
                return mockCompanyProfile(companyId);
              }
              rethrow;
            }
          },
        );
  },
);

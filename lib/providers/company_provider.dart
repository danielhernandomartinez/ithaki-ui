import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/company_models.dart';
import '../repositories/company_repository.dart';
import '../services/api_client.dart';

final companyRepositoryProvider = Provider<CompanyRepository>(
  (ref) => AppConfig.shouldUseMockData
      ? MockCompanyRepository()
      : ApiCompanyRepository(apiClient: ref.watch(apiClientProvider)),
);

final companyProvider = FutureProvider.family<CompanyProfile, String>(
  (ref, companyId) async {
    try {
      return await ref.watch(companyRepositoryProvider).getCompany(companyId);
    } catch (_) {
      if (AppConfig.shouldUseMockData) {
        return mockCompanyProfile(companyId);
      }
      rethrow;
    }
  },
);

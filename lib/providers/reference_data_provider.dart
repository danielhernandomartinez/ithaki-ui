import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../repositories/reference_data_repository.dart';
import '../services/api_client.dart';

export '../repositories/reference_data_repository.dart'
    show SkillItem, LanguageItem, JobInterestItem, PersonalityValueItem;

final referenceDataRepositoryProvider = Provider<ReferenceDataRepository>(
  (ref) => AppConfig.useMockData
      ? MockReferenceDataRepository()
      : ReferenceDataRepository(apiClient: ref.watch(apiClientProvider)),
);

final hardSkillsProvider = FutureProvider<List<SkillItem>>(
  (ref) => ref.read(referenceDataRepositoryProvider).getHardSkills(),
);

final softSkillsProvider = FutureProvider<List<SkillItem>>(
  (ref) => ref.read(referenceDataRepositoryProvider).getSoftSkills(),
);

final languagesListProvider = FutureProvider<List<LanguageItem>>(
  (ref) => ref.read(referenceDataRepositoryProvider).getLanguages(),
);

final jobInterestsListProvider = FutureProvider<List<JobInterestItem>>(
  (ref) => ref.read(referenceDataRepositoryProvider).getJobInterests(),
);

final personalityValuesListProvider =
    FutureProvider<List<PersonalityValueItem>>(
  (ref) => ref.read(referenceDataRepositoryProvider).getPersonalityValues(),
);

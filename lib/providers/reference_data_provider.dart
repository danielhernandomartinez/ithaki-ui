import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/reference_data_repository.dart';

export '../repositories/reference_data_repository.dart'
    show SkillItem, LanguageItem, JobInterestItem, PersonalityValueItem;

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

final personalityValuesListProvider = FutureProvider<List<PersonalityValueItem>>(
  (ref) => ref.read(referenceDataRepositoryProvider).getPersonalityValues(),
);

// lib/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../models/profile_models.dart';
import '../repositories/profile/api_profile_repository.dart';
import '../repositories/profile/mock_profile_repository.dart';
import '../repositories/profile_repository.dart';
import '../services/api_client.dart';
import 'swr_async_notifier.dart';

export '../models/profile_models.dart';

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => AppConfig.shouldUseMockData
      ? MockProfileRepository(persistLocal: true)
      : ApiProfileRepository(apiClient: ref.watch(apiClientProvider)),
);

const _profileCachePrefix = 'profile.';
const _profileBasicsCacheKey = '${_profileCachePrefix}basics';
const _profileAboutMeCacheKey = '${_profileCachePrefix}aboutMe';
const _profileSkillsCacheKey = '${_profileCachePrefix}skills';
const _profileWorkExperiencesCacheKey = '${_profileCachePrefix}workExperiences';
const _profileEducationsCacheKey = '${_profileCachePrefix}educations';
const _profileFilesCacheKey = '${_profileCachePrefix}files';
const _profileValuesCacheKey = '${_profileCachePrefix}values';
const _profileJobPreferencesCacheKey = '${_profileCachePrefix}jobPreferences';
const _profileVisibleCacheKey = '${_profileCachePrefix}visible';

enum ProfileCompletionSection {
  aboutMe,
  photo,
  experience,
  education,
  skills,
  documents,
}

class ProfileCompletionItem {
  final ProfileCompletionSection section;
  final bool completed;

  const ProfileCompletionItem({
    required this.section,
    required this.completed,
  });
}

// ─── Profile Basics ──────────────────────────────────────────────────────────

class ProfileBasicsNotifier extends SwrAsyncNotifier<ProfileBasics> {
  @override
  String get cacheKey => _profileBasicsCacheKey;

  @override
  Future<ProfileBasics> load() async {
    final result = await ref.read(profileRepositoryProvider).refreshAll();
    ref.read(profilePartialLoadProvider.notifier).set(result.isPartial);
    _invalidateHydratedProfileSections();
    return result.basics;
  }

  Future<void> save({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String gender,
    required String citizenship,
    String? citizenshipCode,
    required String residence,
    String? residenceCode,
    required String status,
    required String relocationReadiness,
    String? photoUrl,
  }) async {
    final updated = state.requireValue.copyWith(
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      gender: gender,
      citizenship: citizenship,
      citizenshipCode: citizenshipCode,
      residence: residence,
      residenceCode: residenceCode,
      status: status,
      relocationReadiness: relocationReadiness,
      photoUrl: photoUrl,
    );
    await ref.read(profileRepositoryProvider).saveBasics(updated);
    final result = await ref.read(profileRepositoryProvider).refreshAll();
    ref.read(profilePartialLoadProvider.notifier).set(result.isPartial);
    _invalidateHydratedProfileSections();
    cacheValue(result.basics);
    state = AsyncData(result.basics);
  }

  void _invalidateHydratedProfileSections() {
    final cache = ref.read(swrCacheProvider);
    cache.invalidate(_profileAboutMeCacheKey);
    cache.invalidate(_profileSkillsCacheKey);
    cache.invalidate(_profileWorkExperiencesCacheKey);
    cache.invalidate(_profileEducationsCacheKey);
    cache.invalidate(_profileFilesCacheKey);
    cache.invalidate(_profileValuesCacheKey);
    cache.invalidate(_profileJobPreferencesCacheKey);
    cache.invalidate(_profileVisibleCacheKey);
    ref.invalidate(profileAboutMeProvider);
    ref.invalidate(profileSkillsProvider);
    ref.invalidate(profileWorkExperiencesProvider);
    ref.invalidate(profileEducationsProvider);
    ref.invalidate(profileFilesProvider);
    ref.invalidate(profileValuesProvider);
    ref.invalidate(profileJobPreferencesProvider);
    ref.invalidate(profileVisibleProvider);
  }
}

/// True when /job-seeker/me failed during the last refreshAll() call,
/// meaning the profile was loaded partially from /user/me + local cache.
class _PartialLoadNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void set(bool value) => state = value;
}

final profilePartialLoadProvider =
    NotifierProvider<_PartialLoadNotifier, bool>(_PartialLoadNotifier.new);

final profileBasicsProvider =
    AsyncNotifierProvider<ProfileBasicsNotifier, ProfileBasics>(
  ProfileBasicsNotifier.new,
);

// ─── About Me ─────────────────────────────────────────────────────────────────

class ProfileAboutMeNotifier extends SwrAsyncNotifier<ProfileAboutMe> {
  @override
  String get cacheKey => _profileAboutMeCacheKey;

  @override
  Future<ProfileAboutMe> load() =>
      ref.read(profileRepositoryProvider).getAboutMe();

  Future<void> save(String bio, {String? videoUrl}) async {
    final updated = state.requireValue.copyWith(bio: bio, videoUrl: videoUrl);
    final repository = ref.read(profileRepositoryProvider);
    await repository.saveAboutMe(updated);
    final saved = await repository.getAboutMe();
    cacheValue(saved);
    state = AsyncData(saved);
  }
}

final profileAboutMeProvider =
    AsyncNotifierProvider<ProfileAboutMeNotifier, ProfileAboutMe>(
  ProfileAboutMeNotifier.new,
);

// ─── Skills ───────────────────────────────────────────────────────────────────

class ProfileSkillsNotifier extends SwrAsyncNotifier<ProfileSkills> {
  @override
  String get cacheKey => _profileSkillsCacheKey;

  @override
  Future<ProfileSkills> load() =>
      ref.read(profileRepositoryProvider).getSkills();

  Future<void> updateSkills(List<String> hard, List<String> soft) async {
    final updated =
        state.requireValue.copyWith(hardSkills: hard, softSkills: soft);
    await ref.read(profileRepositoryProvider).saveSkills(updated);
    cacheValue(updated);
    state = AsyncData(updated);
  }

  Future<void> updateLanguages(List<Language> langs) async {
    final updated = state.requireValue.copyWith(languages: langs);
    await ref.read(profileRepositoryProvider).saveLanguages(langs);
    cacheValue(updated);
    state = AsyncData(updated);
  }

  Future<void> updateCompetencies(Map<String, String> comp) async {
    final updated = state.requireValue.copyWith(competencies: comp);
    await ref.read(profileRepositoryProvider).saveSkills(updated);
    cacheValue(updated);
    state = AsyncData(updated);
  }
}

final profileSkillsProvider =
    AsyncNotifierProvider<ProfileSkillsNotifier, ProfileSkills>(
  ProfileSkillsNotifier.new,
);

// ─── Work Experiences ─────────────────────────────────────────────────────────

class ProfileWorkExperiencesNotifier
    extends SwrAsyncNotifier<List<WorkExperience>> {
  @override
  String get cacheKey => _profileWorkExperiencesCacheKey;

  @override
  Future<List<WorkExperience>> load() =>
      ref.read(profileRepositoryProvider).getWorkExperiences();

  Future<void> add(WorkExperience exp) async {
    final updated = [...state.requireValue, exp];
    await ref.read(profileRepositoryProvider).saveWorkExperiences(updated);
    cacheValue(updated);
    state = AsyncData(updated);
  }

  Future<void> save(int index, WorkExperience exp) async {
    final list = [...state.requireValue];
    list[index] = exp;
    await ref.read(profileRepositoryProvider).saveWorkExperiences(list);
    cacheValue(list);
    state = AsyncData(list);
  }
}

final profileWorkExperiencesProvider =
    AsyncNotifierProvider<ProfileWorkExperiencesNotifier, List<WorkExperience>>(
  ProfileWorkExperiencesNotifier.new,
);

// ─── Educations ───────────────────────────────────────────────────────────────

class ProfileEducationsNotifier extends SwrAsyncNotifier<List<Education>> {
  @override
  String get cacheKey => _profileEducationsCacheKey;

  @override
  Future<List<Education>> load() =>
      ref.read(profileRepositoryProvider).getEducations();

  Future<void> add(Education edu) async {
    final updated = [...state.requireValue, edu];
    await ref.read(profileRepositoryProvider).saveEducations(updated);
    cacheValue(updated);
    state = AsyncData(updated);
  }

  Future<void> save(int index, Education edu) async {
    final list = [...state.requireValue];
    list[index] = edu;
    await ref.read(profileRepositoryProvider).saveEducations(list);
    cacheValue(list);
    state = AsyncData(list);
  }
}

final profileEducationsProvider =
    AsyncNotifierProvider<ProfileEducationsNotifier, List<Education>>(
  ProfileEducationsNotifier.new,
);

// ─── Files ────────────────────────────────────────────────────────────────────

class ProfileFilesNotifier extends SwrAsyncNotifier<List<UploadedFile>> {
  @override
  String get cacheKey => _profileFilesCacheKey;

  @override
  Future<List<UploadedFile>> load() =>
      ref.read(profileRepositoryProvider).getFiles();

  Future<void> add(UploadedFile file) async {
    final updated = [...state.requireValue, file];
    final repository = ref.read(profileRepositoryProvider);
    await repository.saveFiles(updated);
    final saved = await repository.getFiles();
    cacheValue(saved);
    state = AsyncData(saved);
  }

  Future<void> addAll(List<UploadedFile> files) async {
    if (files.isEmpty) return;
    final updated = [...state.requireValue, ...files];
    final repository = ref.read(profileRepositoryProvider);
    await repository.saveFiles(updated);
    final saved = await repository.getFiles();
    cacheValue(saved);
    state = AsyncData(saved);
  }

  Future<void> delete(int index) async {
    final list = [...state.requireValue];
    list.removeAt(index);
    final repository = ref.read(profileRepositoryProvider);
    await repository.saveFiles(list);
    final saved = await repository.getFiles();
    cacheValue(saved);
    state = AsyncData(saved);
  }
}

final profileFilesProvider =
    AsyncNotifierProvider<ProfileFilesNotifier, List<UploadedFile>>(
  ProfileFilesNotifier.new,
);

// ─── Values ───────────────────────────────────────────────────────────────────

class ProfileValuesNotifier extends SwrAsyncNotifier<List<String>> {
  @override
  String get cacheKey => _profileValuesCacheKey;

  @override
  Future<List<String>> load() =>
      ref.read(profileRepositoryProvider).getValues();

  Future<void> save(List<String> values) async {
    await ref.read(profileRepositoryProvider).saveValues(values);
    cacheValue(values);
    state = AsyncData(values);
  }
}

final profileValuesProvider =
    AsyncNotifierProvider<ProfileValuesNotifier, List<String>>(
  ProfileValuesNotifier.new,
);

// ─── Job Preferences ──────────────────────────────────────────────────────────

class ProfileJobPreferencesNotifier
    extends SwrAsyncNotifier<ProfileJobPreferences> {
  @override
  String get cacheKey => _profileJobPreferencesCacheKey;

  @override
  Future<ProfileJobPreferences> load() =>
      ref.read(profileRepositoryProvider).getJobPreferences();

  Future<void> save({
    required List<JobInterest> interests,
    required String positionLevel,
    required String jobType,
    required String workplace,
    double? expectedSalary,
    required bool preferNotToSpecifySalary,
  }) async {
    final updated = ProfileJobPreferences(
      jobInterests: interests,
      positionLevel: positionLevel,
      jobType: jobType,
      workplace: workplace,
      expectedSalary: expectedSalary,
      preferNotToSpecifySalary: preferNotToSpecifySalary,
    );
    await ref.read(profileRepositoryProvider).saveJobPreferences(updated);
    cacheValue(updated);
    state = AsyncData(updated);
  }
}

final profileJobPreferencesProvider =
    AsyncNotifierProvider<ProfileJobPreferencesNotifier, ProfileJobPreferences>(
  ProfileJobPreferencesNotifier.new,
);

// ─── Profile Visible ──────────────────────────────────────────────────────────

class ProfileVisibleNotifier extends SwrAsyncNotifier<bool> {
  @override
  String get cacheKey => _profileVisibleCacheKey;

  @override
  Future<bool> load() =>
      ref.read(profileRepositoryProvider).getProfileVisible();

  Future<void> toggle() async {
    final updated = !state.requireValue;
    await ref.read(profileRepositoryProvider).saveProfileVisible(updated);
    cacheValue(updated);
    state = AsyncData(updated);
  }
}

final profileVisibleProvider =
    AsyncNotifierProvider<ProfileVisibleNotifier, bool>(
  ProfileVisibleNotifier.new,
);

// ─── Profile Completion (derived) ─────────────────────────────────────────────

final profileCompletionItemsProvider =
    Provider<List<ProfileCompletionItem>>((ref) {
  final photoUrl = ref.watch(profileBasicsProvider).value?.photoUrl;
  final bio = ref.watch(profileAboutMeProvider).value?.bio ?? '';
  final experiences = ref.watch(profileWorkExperiencesProvider).value ?? [];
  final educations = ref.watch(profileEducationsProvider).value ?? [];
  final skills = ref.watch(profileSkillsProvider).value;
  final files = ref.watch(profileFilesProvider).value ?? [];

  final hasAboutMe = bio.trim().isNotEmpty;
  final hasPhoto = photoUrl != null && photoUrl.trim().isNotEmpty;
  final hasExperience = experiences.isNotEmpty;
  final hasEducation = educations.isNotEmpty;
  final hasSkills = skills != null &&
      (skills.hardSkills.isNotEmpty || skills.softSkills.isNotEmpty);
  final hasDocuments = files.isNotEmpty;

  return [
    ProfileCompletionItem(
        section: ProfileCompletionSection.aboutMe, completed: hasAboutMe),
    ProfileCompletionItem(
        section: ProfileCompletionSection.photo, completed: hasPhoto),
    ProfileCompletionItem(
        section: ProfileCompletionSection.experience, completed: hasExperience),
    ProfileCompletionItem(
        section: ProfileCompletionSection.education, completed: hasEducation),
    ProfileCompletionItem(
        section: ProfileCompletionSection.skills, completed: hasSkills),
    ProfileCompletionItem(
        section: ProfileCompletionSection.documents, completed: hasDocuments),
  ];
});

final profileCompletionProvider = Provider<double>((ref) {
  final items = ref.watch(profileCompletionItemsProvider);
  final completed = items.where((item) => item.completed).length;
  return items.isEmpty ? 0 : completed / items.length;
});

void resetProfileProviders(WidgetRef ref) {
  ref.read(swrCacheProvider).invalidatePrefix(_profileCachePrefix);
  ref.invalidate(profileBasicsProvider);
  ref.invalidate(profileAboutMeProvider);
  ref.invalidate(profileSkillsProvider);
  ref.invalidate(profileWorkExperiencesProvider);
  ref.invalidate(profileEducationsProvider);
  ref.invalidate(profileFilesProvider);
  ref.invalidate(profileValuesProvider);
  ref.invalidate(profileJobPreferencesProvider);
  ref.invalidate(profileVisibleProvider);
  ref.invalidate(profileCompletionItemsProvider);
  ref.invalidate(profileCompletionProvider);
}

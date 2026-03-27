// lib/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_models.dart';
import '../repositories/profile_repository.dart';

export '../models/profile_models.dart';

// ─── Profile Basics ──────────────────────────────────────────────────────────

class ProfileBasicsNotifier extends AsyncNotifier<ProfileBasics> {
  @override
  Future<ProfileBasics> build() =>
      ref.read(profileRepositoryProvider).getBasics();

  Future<void> save({
    required String firstName, required String lastName,
    required String dateOfBirth, required String gender,
    required String citizenship, String? citizenshipCode,
    required String residence, String? residenceCode,
    required String status, required String relocationReadiness,
    String? photoUrl,
  }) async {
    final updated = state.requireValue.copyWith(
      firstName: firstName, lastName: lastName,
      dateOfBirth: dateOfBirth, gender: gender,
      citizenship: citizenship, citizenshipCode: citizenshipCode,
      residence: residence, residenceCode: residenceCode,
      status: status, relocationReadiness: relocationReadiness,
      photoUrl: photoUrl,
    );
    await ref.read(profileRepositoryProvider).saveBasics(updated);
    state = AsyncData(updated);
  }
}

final profileBasicsProvider =
    AsyncNotifierProvider<ProfileBasicsNotifier, ProfileBasics>(
  ProfileBasicsNotifier.new,
);

// ─── About Me ─────────────────────────────────────────────────────────────────

class ProfileAboutMeNotifier extends AsyncNotifier<ProfileAboutMe> {
  @override
  Future<ProfileAboutMe> build() =>
      ref.read(profileRepositoryProvider).getAboutMe();

  Future<void> save(String bio, {String? videoUrl}) async {
    final updated = state.requireValue.copyWith(bio: bio, videoUrl: videoUrl);
    await ref.read(profileRepositoryProvider).saveAboutMe(updated);
    state = AsyncData(updated);
  }
}

final profileAboutMeProvider =
    AsyncNotifierProvider<ProfileAboutMeNotifier, ProfileAboutMe>(
  ProfileAboutMeNotifier.new,
);

// ─── Skills ───────────────────────────────────────────────────────────────────

class ProfileSkillsNotifier extends AsyncNotifier<ProfileSkills> {
  @override
  Future<ProfileSkills> build() =>
      ref.read(profileRepositoryProvider).getSkills();

  Future<void> updateSkills(List<String> hard, List<String> soft) async {
    final updated = state.requireValue.copyWith(hardSkills: hard, softSkills: soft);
    await ref.read(profileRepositoryProvider).saveSkills(updated);
    state = AsyncData(updated);
  }

  Future<void> updateLanguages(List<Language> langs) async {
    final updated = state.requireValue.copyWith(languages: langs);
    await ref.read(profileRepositoryProvider).saveSkills(updated);
    state = AsyncData(updated);
  }

  Future<void> updateCompetencies(Map<String, String> comp) async {
    final updated = state.requireValue.copyWith(competencies: comp);
    await ref.read(profileRepositoryProvider).saveSkills(updated);
    state = AsyncData(updated);
  }
}

final profileSkillsProvider =
    AsyncNotifierProvider<ProfileSkillsNotifier, ProfileSkills>(
  ProfileSkillsNotifier.new,
);

// ─── Work Experiences ─────────────────────────────────────────────────────────

class ProfileWorkExperiencesNotifier
    extends AsyncNotifier<List<WorkExperience>> {
  @override
  Future<List<WorkExperience>> build() =>
      ref.read(profileRepositoryProvider).getWorkExperiences();

  Future<void> add(WorkExperience exp) async {
    final updated = [...state.requireValue, exp];
    await ref.read(profileRepositoryProvider).saveWorkExperiences(updated);
    state = AsyncData(updated);
  }

  Future<void> save(int index, WorkExperience exp) async {
    final list = [...state.requireValue];
    list[index] = exp;
    await ref.read(profileRepositoryProvider).saveWorkExperiences(list);
    state = AsyncData(list);
  }
}

final profileWorkExperiencesProvider =
    AsyncNotifierProvider<ProfileWorkExperiencesNotifier, List<WorkExperience>>(
  ProfileWorkExperiencesNotifier.new,
);

// ─── Educations ───────────────────────────────────────────────────────────────

class ProfileEducationsNotifier extends AsyncNotifier<List<Education>> {
  @override
  Future<List<Education>> build() =>
      ref.read(profileRepositoryProvider).getEducations();

  Future<void> add(Education edu) async {
    final updated = [...state.requireValue, edu];
    await ref.read(profileRepositoryProvider).saveEducations(updated);
    state = AsyncData(updated);
  }

  Future<void> save(int index, Education edu) async {
    final list = [...state.requireValue];
    list[index] = edu;
    await ref.read(profileRepositoryProvider).saveEducations(list);
    state = AsyncData(list);
  }
}

final profileEducationsProvider =
    AsyncNotifierProvider<ProfileEducationsNotifier, List<Education>>(
  ProfileEducationsNotifier.new,
);

// ─── Files ────────────────────────────────────────────────────────────────────

class ProfileFilesNotifier extends AsyncNotifier<List<UploadedFile>> {
  @override
  Future<List<UploadedFile>> build() =>
      ref.read(profileRepositoryProvider).getFiles();

  Future<void> add(UploadedFile file) async {
    final updated = [...state.requireValue, file];
    await ref.read(profileRepositoryProvider).saveFiles(updated);
    state = AsyncData(updated);
  }

  Future<void> delete(int index) async {
    final list = [...state.requireValue];
    list.removeAt(index);
    await ref.read(profileRepositoryProvider).saveFiles(list);
    state = AsyncData(list);
  }
}

final profileFilesProvider =
    AsyncNotifierProvider<ProfileFilesNotifier, List<UploadedFile>>(
  ProfileFilesNotifier.new,
);

// ─── Values ───────────────────────────────────────────────────────────────────

class ProfileValuesNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() =>
      ref.read(profileRepositoryProvider).getValues();

  Future<void> save(List<String> values) async {
    await ref.read(profileRepositoryProvider).saveValues(values);
    state = AsyncData(values);
  }
}

final profileValuesProvider =
    AsyncNotifierProvider<ProfileValuesNotifier, List<String>>(
  ProfileValuesNotifier.new,
);

// ─── Job Preferences ──────────────────────────────────────────────────────────

class ProfileJobPreferencesNotifier
    extends AsyncNotifier<ProfileJobPreferences> {
  @override
  Future<ProfileJobPreferences> build() =>
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
    state = AsyncData(updated);
  }
}

final profileJobPreferencesProvider =
    AsyncNotifierProvider<ProfileJobPreferencesNotifier, ProfileJobPreferences>(
  ProfileJobPreferencesNotifier.new,
);

// ─── Profile Visible ──────────────────────────────────────────────────────────

class ProfileVisibleNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() =>
      ref.read(profileRepositoryProvider).getProfileVisible();

  Future<void> toggle() async {
    final updated = !state.requireValue;
    await ref.read(profileRepositoryProvider).saveProfileVisible(updated);
    state = AsyncData(updated);
  }
}

final profileVisibleProvider =
    AsyncNotifierProvider<ProfileVisibleNotifier, bool>(
  ProfileVisibleNotifier.new,
);

// ─── Profile Completion (derived) ─────────────────────────────────────────────

final profileCompletionProvider = Provider<double>((ref) {
  final photoUrl = ref.watch(profileBasicsProvider).value?.photoUrl;
  final bio = ref.watch(profileAboutMeProvider).value?.bio ?? '';
  final experiences = ref.watch(profileWorkExperiencesProvider).value ?? [];
  final educations = ref.watch(profileEducationsProvider).value ?? [];
  final skills = ref.watch(profileSkillsProvider).value;
  final files = ref.watch(profileFilesProvider).value ?? [];

  int filled = 0;
  if (bio.isNotEmpty) { filled++; }
  if (photoUrl != null) { filled++; }
  if (experiences.isNotEmpty) { filled++; }
  if (educations.isNotEmpty) { filled++; }
  if (skills != null &&
      (skills.hardSkills.isNotEmpty || skills.softSkills.isNotEmpty)) { filled++; }
  if (files.isNotEmpty) { filled++; }
  return filled / 6;
});

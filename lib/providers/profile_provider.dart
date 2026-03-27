// lib/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_models.dart';
import '../repositories/profile_repository.dart';

export '../models/profile_models.dart';

// ─── Profile Basics ──────────────────────────────────────────────────────────

class ProfileBasicsNotifier extends Notifier<ProfileBasics> {
  @override
  ProfileBasics build() => ref.read(profileRepositoryProvider).getBasics();

  void update({
    required String firstName, required String lastName,
    required String dateOfBirth, required String gender,
    required String citizenship, String? citizenshipCode,
    required String residence, String? residenceCode,
    required String status, required String relocationReadiness,
    String? photoUrl,
  }) {
    state = state.copyWith(
      firstName: firstName, lastName: lastName,
      dateOfBirth: dateOfBirth, gender: gender,
      citizenship: citizenship, citizenshipCode: citizenshipCode,
      residence: residence, residenceCode: residenceCode,
      status: status, relocationReadiness: relocationReadiness,
      photoUrl: photoUrl,
    );
  }
}

final profileBasicsProvider =
    NotifierProvider<ProfileBasicsNotifier, ProfileBasics>(
  ProfileBasicsNotifier.new,
);

// ─── About Me ─────────────────────────────────────────────────────────────────

class ProfileAboutMeNotifier extends Notifier<ProfileAboutMe> {
  @override
  ProfileAboutMe build() => ref.read(profileRepositoryProvider).getAboutMe();

  void update(String bio, {String? videoUrl}) {
    state = state.copyWith(bio: bio, videoUrl: videoUrl);
  }
}

final profileAboutMeProvider =
    NotifierProvider<ProfileAboutMeNotifier, ProfileAboutMe>(
  ProfileAboutMeNotifier.new,
);

// ─── Skills ───────────────────────────────────────────────────────────────────

class ProfileSkillsNotifier extends Notifier<ProfileSkills> {
  @override
  ProfileSkills build() => ref.read(profileRepositoryProvider).getSkills();

  void updateSkills(List<String> hard, List<String> soft) {
    state = state.copyWith(hardSkills: hard, softSkills: soft);
  }

  void updateLanguages(List<Language> langs) {
    state = state.copyWith(languages: langs);
  }

  void updateCompetencies(Map<String, String> comp) {
    state = state.copyWith(competencies: comp);
  }
}

final profileSkillsProvider =
    NotifierProvider<ProfileSkillsNotifier, ProfileSkills>(
  ProfileSkillsNotifier.new,
);

// ─── Work Experiences ─────────────────────────────────────────────────────────

class ProfileWorkExperiencesNotifier extends Notifier<List<WorkExperience>> {
  @override
  List<WorkExperience> build() =>
      ref.read(profileRepositoryProvider).getWorkExperiences();

  void add(WorkExperience exp) => state = [...state, exp];

  void update(int index, WorkExperience exp) {
    final list = [...state];
    list[index] = exp;
    state = list;
  }
}

final profileWorkExperiencesProvider =
    NotifierProvider<ProfileWorkExperiencesNotifier, List<WorkExperience>>(
  ProfileWorkExperiencesNotifier.new,
);

// ─── Educations ───────────────────────────────────────────────────────────────

class ProfileEducationsNotifier extends Notifier<List<Education>> {
  @override
  List<Education> build() =>
      ref.read(profileRepositoryProvider).getEducations();

  void add(Education edu) => state = [...state, edu];

  void update(int index, Education edu) {
    final list = [...state];
    list[index] = edu;
    state = list;
  }
}

final profileEducationsProvider =
    NotifierProvider<ProfileEducationsNotifier, List<Education>>(
  ProfileEducationsNotifier.new,
);

// ─── Files ────────────────────────────────────────────────────────────────────

class ProfileFilesNotifier extends Notifier<List<UploadedFile>> {
  @override
  List<UploadedFile> build() =>
      ref.read(profileRepositoryProvider).getFiles();

  void add(UploadedFile file) => state = [...state, file];

  void delete(int index) {
    final list = [...state];
    list.removeAt(index);
    state = list;
  }
}

final profileFilesProvider =
    NotifierProvider<ProfileFilesNotifier, List<UploadedFile>>(
  ProfileFilesNotifier.new,
);

// ─── Values ───────────────────────────────────────────────────────────────────

class ProfileValuesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() => ref.read(profileRepositoryProvider).getValues();

  void update(List<String> values) => state = values;
}

final profileValuesProvider =
    NotifierProvider<ProfileValuesNotifier, List<String>>(
  ProfileValuesNotifier.new,
);

// ─── Job Preferences ──────────────────────────────────────────────────────────

class ProfileJobPreferencesNotifier extends Notifier<ProfileJobPreferences> {
  @override
  ProfileJobPreferences build() =>
      ref.read(profileRepositoryProvider).getJobPreferences();

  void update({
    required List<JobInterest> interests,
    required String positionLevel,
    required String jobType,
    required String workplace,
    double? expectedSalary,
    required bool preferNotToSpecifySalary,
  }) {
    state = ProfileJobPreferences(
      jobInterests: interests,
      positionLevel: positionLevel,
      jobType: jobType,
      workplace: workplace,
      expectedSalary: expectedSalary,
      preferNotToSpecifySalary: preferNotToSpecifySalary,
    );
  }
}

final profileJobPreferencesProvider =
    NotifierProvider<ProfileJobPreferencesNotifier, ProfileJobPreferences>(
  ProfileJobPreferencesNotifier.new,
);

// ─── Profile Visible ──────────────────────────────────────────────────────────

class ProfileVisibleNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(profileRepositoryProvider).getProfileVisible();

  void toggle() => state = !state;
}

final profileVisibleProvider =
    NotifierProvider<ProfileVisibleNotifier, bool>(
  ProfileVisibleNotifier.new,
);

// ─── Profile Completion (derived) ─────────────────────────────────────────────

final profileCompletionProvider = Provider<double>((ref) {
  final photoUrl = ref.watch(profileBasicsProvider.select((b) => b.photoUrl));
  final bio = ref.watch(profileAboutMeProvider.select((a) => a.bio));
  final experiences = ref.watch(profileWorkExperiencesProvider);
  final educations = ref.watch(profileEducationsProvider);
  final skills = ref.watch(profileSkillsProvider);
  final files = ref.watch(profileFilesProvider);

  int filled = 0;
  if (bio.isNotEmpty) filled++;
  if (photoUrl != null) filled++;
  if (experiences.isNotEmpty) filled++;
  if (educations.isNotEmpty) filled++;
  if (skills.hardSkills.isNotEmpty || skills.softSkills.isNotEmpty) filled++;
  if (files.isNotEmpty) filled++;
  return filled / 6;
});

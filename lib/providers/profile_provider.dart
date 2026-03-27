// lib/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_models.dart';

// ─── Profile Basics ──────────────────────────────────────────────────────────

class ProfileBasics {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? photoUrl;
  final String dateOfBirth;
  final String gender;
  final String citizenship;
  final String citizenshipCode;
  final String residence;
  final String residenceCode;
  final String status;
  final String relocationReadiness;

  const ProfileBasics({
    this.firstName = 'Christos',
    this.lastName = 'Ioannides',
    this.email = 'c.ioannidis@gmail.com',
    this.phone = '+30 123 456 78 90',
    this.photoUrl,
    this.dateOfBirth = '01-01-1997',
    this.gender = 'Male',
    this.citizenship = 'Greece',
    this.citizenshipCode = 'gr',
    this.residence = 'Greece',
    this.residenceCode = 'gr',
    this.status = 'Citizen',
    this.relocationReadiness = 'Yes',
  });

  ProfileBasics copyWith({
    String? firstName, String? lastName, String? email, String? phone,
    String? photoUrl, String? dateOfBirth, String? gender,
    String? citizenship, String? citizenshipCode,
    String? residence, String? residenceCode,
    String? status, String? relocationReadiness,
  }) => ProfileBasics(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    photoUrl: photoUrl ?? this.photoUrl,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
    citizenship: citizenship ?? this.citizenship,
    citizenshipCode: citizenshipCode ?? this.citizenshipCode,
    residence: residence ?? this.residence,
    residenceCode: residenceCode ?? this.residenceCode,
    status: status ?? this.status,
    relocationReadiness: relocationReadiness ?? this.relocationReadiness,
  );
}

class ProfileBasicsNotifier extends Notifier<ProfileBasics> {
  @override
  ProfileBasics build() => const ProfileBasics();

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

class ProfileAboutMe {
  final String bio;
  final String? videoUrl;

  const ProfileAboutMe({this.bio = '', this.videoUrl});

  ProfileAboutMe copyWith({String? bio, String? videoUrl}) => ProfileAboutMe(
    bio: bio ?? this.bio,
    videoUrl: videoUrl ?? this.videoUrl,
  );
}

class ProfileAboutMeNotifier extends Notifier<ProfileAboutMe> {
  @override
  ProfileAboutMe build() => const ProfileAboutMe();

  void update(String bio, {String? videoUrl}) {
    state = state.copyWith(bio: bio, videoUrl: videoUrl);
  }
}

final profileAboutMeProvider =
    NotifierProvider<ProfileAboutMeNotifier, ProfileAboutMe>(
  ProfileAboutMeNotifier.new,
);

// ─── Skills ───────────────────────────────────────────────────────────────────

class ProfileSkills {
  final List<String> hardSkills;
  final List<String> softSkills;
  final List<Language> languages;
  final Map<String, String> competencies;

  const ProfileSkills({
    this.hardSkills = const [],
    this.softSkills = const [],
    this.languages = const [],
    this.competencies = const {},
  });

  ProfileSkills copyWith({
    List<String>? hardSkills, List<String>? softSkills,
    List<Language>? languages, Map<String, String>? competencies,
  }) => ProfileSkills(
    hardSkills: hardSkills ?? this.hardSkills,
    softSkills: softSkills ?? this.softSkills,
    languages: languages ?? this.languages,
    competencies: competencies ?? this.competencies,
  );
}

class ProfileSkillsNotifier extends Notifier<ProfileSkills> {
  @override
  ProfileSkills build() => const ProfileSkills();

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
  List<WorkExperience> build() => const [];

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
  List<Education> build() => const [];

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
  List<UploadedFile> build() => const [];

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
  List<String> build() => const [];

  void update(List<String> values) => state = values;
}

final profileValuesProvider =
    NotifierProvider<ProfileValuesNotifier, List<String>>(
  ProfileValuesNotifier.new,
);

// ─── Job Preferences ──────────────────────────────────────────────────────────

class ProfileJobPreferences {
  final List<JobInterest> jobInterests;
  final String positionLevel;
  final String jobType;
  final String workplace;
  final double? expectedSalary;
  final bool preferNotToSpecifySalary;

  const ProfileJobPreferences({
    this.jobInterests = const [
      JobInterest(title: 'Web Developer', category: 'IT & Development'),
    ],
    this.positionLevel = 'Senior',
    this.jobType = 'Full time',
    this.workplace = 'On-site',
    this.expectedSalary = 1800,
    this.preferNotToSpecifySalary = false,
  });

  ProfileJobPreferences copyWith({
    List<JobInterest>? jobInterests, String? positionLevel,
    String? jobType, String? workplace,
    double? expectedSalary, bool? preferNotToSpecifySalary,
  }) => ProfileJobPreferences(
    jobInterests: jobInterests ?? this.jobInterests,
    positionLevel: positionLevel ?? this.positionLevel,
    jobType: jobType ?? this.jobType,
    workplace: workplace ?? this.workplace,
    expectedSalary: expectedSalary ?? this.expectedSalary,
    preferNotToSpecifySalary:
        preferNotToSpecifySalary ?? this.preferNotToSpecifySalary,
  );
}

class ProfileJobPreferencesNotifier extends Notifier<ProfileJobPreferences> {
  @override
  ProfileJobPreferences build() => const ProfileJobPreferences();

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
  bool build() => true;

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

// lib/providers/profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_models.dart';

class ProfileState {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? photoUrl;
  final String dateOfBirth; // Format: 'dd-MM-yyyy'
  final String gender;
  final String citizenship;
  final String residence;
  final String status;
  final String relocationReadiness;
  final List<WorkExperience> workExperiences;
  final List<Education> educations;
  final List<String> hardSkills;
  final List<String> softSkills;
  final List<Language> languages;
  final Map<String, String> competencies;
  final String bio;
  final String? videoUrl;
  final List<JobInterest> jobInterests;
  final String positionLevel;
  final String jobType;
  final String workplace;
  final double? expectedSalary;
  final bool preferNotToSpecifySalary;
  final List<String> values;
  final List<UploadedFile> files;
  final bool profileVisible;

  const ProfileState({
    this.firstName = 'Christos',
    this.lastName = 'Ioannou',
    this.email = 'c.ioannou@example.com',
    this.phone = '+30 694 000 0000',
    this.photoUrl,
    this.dateOfBirth = '01-01-1995',
    this.gender = 'Male',
    this.citizenship = 'GR',
    this.residence = 'GR',
    this.status = 'Citizen',
    this.relocationReadiness = 'Yes',
    this.workExperiences = const [],
    this.educations = const [],
    this.hardSkills = const [],
    this.softSkills = const [],
    this.languages = const [],
    this.competencies = const {},
    this.bio = '',
    this.videoUrl,
    this.jobInterests = const [],
    this.positionLevel = '',
    this.jobType = '',
    this.workplace = '',
    this.expectedSalary,
    this.preferNotToSpecifySalary = false,
    this.values = const [],
    this.files = const [],
    this.profileVisible = true,
  });

  // Note: nullable fields (photoUrl, videoUrl, expectedSalary) cannot be cleared via copyWith
  // once set (null argument is ignored). Acceptable for this in-memory mock.
  ProfileState copyWith({
    String? firstName, String? lastName, String? email, String? phone,
    String? photoUrl, String? dateOfBirth, String? gender,
    String? citizenship, String? residence, String? status,
    String? relocationReadiness, List<WorkExperience>? workExperiences,
    List<Education>? educations, List<String>? hardSkills,
    List<String>? softSkills, List<Language>? languages,
    Map<String, String>? competencies, String? bio, String? videoUrl,
    List<JobInterest>? jobInterests, String? positionLevel,
    String? jobType, String? workplace, double? expectedSalary,
    bool? preferNotToSpecifySalary, List<String>? values,
    List<UploadedFile>? files, bool? profileVisible,
  }) => ProfileState(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    photoUrl: photoUrl ?? this.photoUrl,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
    citizenship: citizenship ?? this.citizenship,
    residence: residence ?? this.residence,
    status: status ?? this.status,
    relocationReadiness: relocationReadiness ?? this.relocationReadiness,
    workExperiences: workExperiences ?? this.workExperiences,
    educations: educations ?? this.educations,
    hardSkills: hardSkills ?? this.hardSkills,
    softSkills: softSkills ?? this.softSkills,
    languages: languages ?? this.languages,
    competencies: competencies ?? this.competencies,
    bio: bio ?? this.bio,
    videoUrl: videoUrl ?? this.videoUrl,
    jobInterests: jobInterests ?? this.jobInterests,
    positionLevel: positionLevel ?? this.positionLevel,
    jobType: jobType ?? this.jobType,
    workplace: workplace ?? this.workplace,
    expectedSalary: expectedSalary ?? this.expectedSalary,
    preferNotToSpecifySalary: preferNotToSpecifySalary ?? this.preferNotToSpecifySalary,
    values: values ?? this.values,
    files: files ?? this.files,
    profileVisible: profileVisible ?? this.profileVisible,
  );
}

class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileState();

  void updateBasics({
    required String firstName, required String lastName,
    required String dateOfBirth, required String gender,
    required String citizenship, required String residence,
    required String status, required String relocationReadiness,
    String? photoUrl,
  }) {
    state = state.copyWith(
      firstName: firstName, lastName: lastName,
      dateOfBirth: dateOfBirth, gender: gender,
      citizenship: citizenship, residence: residence,
      status: status, relocationReadiness: relocationReadiness,
      photoUrl: photoUrl,
    );
  }

  void addWorkExperience(WorkExperience exp) {
    state = state.copyWith(workExperiences: [...state.workExperiences, exp]);
  }

  void updateWorkExperience(int index, WorkExperience exp) {
    final list = [...state.workExperiences];
    list[index] = exp;
    state = state.copyWith(workExperiences: list);
  }

  void addEducation(Education edu) {
    state = state.copyWith(educations: [...state.educations, edu]);
  }

  void updateEducation(int index, Education edu) {
    final list = [...state.educations];
    list[index] = edu;
    state = state.copyWith(educations: list);
  }

  void updateSkills(List<String> hard, List<String> soft) {
    state = state.copyWith(hardSkills: hard, softSkills: soft);
  }

  void updateCompetencies(Map<String, String> comp) {
    state = state.copyWith(competencies: comp);
  }

  void updateLanguages(List<Language> langs) {
    state = state.copyWith(languages: langs);
  }

  void updateBio(String bio, {String? videoUrl}) {
    state = state.copyWith(bio: bio, videoUrl: videoUrl);
  }

  void updateJobPreferences({
    required List<JobInterest> interests, required String positionLevel,
    required String jobType, required String workplace,
    double? expectedSalary, required bool preferNotToSpecifySalary,
  }) {
    state = state.copyWith(
      jobInterests: interests, positionLevel: positionLevel,
      jobType: jobType, workplace: workplace,
      expectedSalary: expectedSalary,
      preferNotToSpecifySalary: preferNotToSpecifySalary,
    );
  }

  void updateValues(List<String> values) {
    state = state.copyWith(values: values);
  }

  void addFile(UploadedFile file) {
    state = state.copyWith(files: [...state.files, file]);
  }

  void deleteFile(int index) {
    final list = [...state.files];
    list.removeAt(index);
    state = state.copyWith(files: list);
  }

  void toggleProfileVisibility() {
    state = state.copyWith(profileVisible: !state.profileVisible);
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(
  ProfileNotifier.new,
);

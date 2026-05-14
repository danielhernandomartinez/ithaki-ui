import 'dart:typed_data';

import '../models/profile_models.dart';

class ProfileLoadResult {
  final ProfileBasics basics;
  final bool isPartial;
  final Object? partialError;

  const ProfileLoadResult({
    required this.basics,
    this.isPartial = false,
    this.partialError,
  });
}

abstract class ProfileRepository {
  /// Fetches the full profile from the API and hydrates all in-memory fields.
  /// Returns [ProfileLoadResult] with the user's basics and an [isPartial] flag
  /// if /job-seeker/me failed (other sections fall back to local cache).
  Future<ProfileLoadResult> refreshAll();

  Future<ProfileAboutMe> getAboutMe();
  Future<ProfileSkills> getSkills();
  Future<List<WorkExperience>> getWorkExperiences();
  Future<List<Education>> getEducations();
  Future<List<UploadedFile>> getFiles();
  Future<List<String>> getValues();
  Future<ProfileJobPreferences> getJobPreferences();
  Future<bool> getProfileVisible();

  Future<void> saveBasics(ProfileBasics basics);
  Future<void> saveAboutMe(ProfileAboutMe aboutMe);
  Future<void> saveSkills(ProfileSkills skills);
  Future<void> saveLanguages(List<Language> languages);
  Future<void> saveWorkExperiences(List<WorkExperience> experiences);
  Future<void> saveEducations(List<Education> educations);
  Future<void> saveFiles(List<UploadedFile> files);
  Future<Uint8List> downloadFile(UploadedFile file);
  Future<void> saveValues(List<String> values);
  Future<void> saveJobPreferences(ProfileJobPreferences prefs);
  Future<void> saveProfileVisible(bool visible);
}

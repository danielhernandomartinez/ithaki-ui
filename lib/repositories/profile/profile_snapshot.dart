import '../../models/profile_models.dart';

class ProfileSnapshot {
  const ProfileSnapshot({
    required this.basics,
    required this.aboutMe,
    required this.skills,
    required this.workExperiences,
    required this.educations,
    required this.files,
    required this.values,
    required this.jobPreferences,
    required this.profileVisible,
  });

  factory ProfileSnapshot.empty() => const ProfileSnapshot(
        basics: ProfileBasics(),
        aboutMe: ProfileAboutMe(),
        skills: ProfileSkills(),
        workExperiences: [],
        educations: [],
        files: [],
        values: [],
        jobPreferences: ProfileJobPreferences(),
        profileVisible: true,
      );

  final ProfileBasics basics;
  final ProfileAboutMe aboutMe;
  final ProfileSkills skills;
  final List<WorkExperience> workExperiences;
  final List<Education> educations;
  final List<UploadedFile> files;
  final List<String> values;
  final ProfileJobPreferences jobPreferences;
  final bool profileVisible;

  ProfileSnapshot copyWith({
    ProfileBasics? basics,
    ProfileAboutMe? aboutMe,
    ProfileSkills? skills,
    List<WorkExperience>? workExperiences,
    List<Education>? educations,
    List<UploadedFile>? files,
    List<String>? values,
    ProfileJobPreferences? jobPreferences,
    bool? profileVisible,
  }) {
    return ProfileSnapshot(
      basics: basics ?? this.basics,
      aboutMe: aboutMe ?? this.aboutMe,
      skills: skills ?? this.skills,
      workExperiences: workExperiences ?? this.workExperiences,
      educations: educations ?? this.educations,
      files: files ?? this.files,
      values: values ?? this.values,
      jobPreferences: jobPreferences ?? this.jobPreferences,
      profileVisible: profileVisible ?? this.profileVisible,
    );
  }
}

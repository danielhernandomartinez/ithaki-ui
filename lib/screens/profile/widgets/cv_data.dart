import '../../../models/assessment_models.dart';
import '../../../models/profile_models.dart';

class MyCvData {
  const MyCvData({
    required this.avatarInitials,
    required this.fullName,
    required this.jobTitle,
    required this.email,
    required this.phone,
    required this.photoPath,
    required this.gender,
    required this.age,
    required this.citizenship,
    required this.location,
    required this.workplace,
    required this.jobType,
    required this.experienceLevel,
    required this.salary,
    required this.aboutMe,
    required this.skills,
    required this.competencies,
    required this.workExperiences,
    required this.educations,
    required this.languages,
    required this.files,
    required this.assessmentCards,
  });

  final String avatarInitials;
  final String fullName;
  final String jobTitle;
  final String email;
  final String phone;
  final String? photoPath;
  final String gender;
  final String age;
  final String citizenship;
  final String location;
  final String workplace;
  final String jobType;
  final String experienceLevel;
  final String salary;
  final String aboutMe;
  final List<String> skills;
  final Map<String, String> competencies;
  final List<WorkExperience> workExperiences;
  final List<Education> educations;
  final List<Language> languages;
  final List<UploadedFile> files;
  final List<Assessment> assessmentCards;

  factory MyCvData.fromSources({
    required ProfileBasics basics,
    required ProfileAboutMe aboutMe,
    required ProfileSkills skills,
    required List<WorkExperience> workExperiences,
    required List<Education> educations,
    required List<UploadedFile> files,
    required ProfileJobPreferences jobPreferences,
    required List<Assessment> assessments,
  }) {
    final fullName = '${basics.firstName} ${basics.lastName}'.trim();
    final avatarInitials = basics.initials.isEmpty ? '' : basics.initials;
    final combinedSkills = [...skills.hardSkills, ...skills.softSkills];
    final salaryValue = jobPreferences.preferNotToSpecifySalary
        ? ''
        : jobPreferences.expectedSalary == null
            ? ''
            : '${jobPreferences.expectedSalary!.toStringAsFixed(0)} € / month';
    final completedAssessments = assessments
        .where((a) => a.status == AssessmentStatus.completed)
        .take(3)
        .toList();

    return MyCvData(
      avatarInitials: avatarInitials,
      fullName: fullName,
      jobTitle: jobPreferences.jobInterests.firstOrNull?.title ?? '',
      email: basics.email,
      phone: basics.phone,
      photoPath: basics.photoUrl,
      gender: basics.gender,
      age: _ageFromDate(basics.dateOfBirth),
      citizenship: basics.citizenship,
      location: basics.residence,
      workplace: jobPreferences.workplace,
      jobType: jobPreferences.jobType,
      experienceLevel: jobPreferences.positionLevel,
      salary: salaryValue,
      aboutMe: aboutMe.bio,
      skills: combinedSkills,
      competencies: skills.competencies,
      workExperiences: workExperiences,
      educations: educations,
      languages: skills.languages,
      files: files,
      assessmentCards: completedAssessments,
    );
  }

  static String _ageFromDate(String dateOfBirth) {
    final parts = dateOfBirth.split('-');
    if (parts.length < 3) {
      return '';
    }

    final year = int.tryParse(parts[2]);
    if (year == null) {
      return '';
    }

    return '${DateTime.now().year - year}';
  }
}

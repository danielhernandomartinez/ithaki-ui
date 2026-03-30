// lib/models/profile_models.dart

/// Calculates a human-readable duration string between two MM-YYYY date strings.
/// [endDate] defaults to today when null (i.e. current position).
String _calcDuration(String startDate, String? endDate) {
  try {
    final parts = startDate.split('-');
    if (parts.length != 2) return '';
    final start = DateTime(int.parse(parts[1]), int.parse(parts[0]));
    final end = endDate != null
        ? () {
            final ep = endDate.split('-');
            return DateTime(int.parse(ep[1]), int.parse(ep[0]));
          }()
        : DateTime.now();
    final months = (end.year - start.year) * 12 + (end.month - start.month);
    if (months < 0) return '';
    final years = months ~/ 12;
    final rem = months % 12;
    if (years == 0) return '$rem month${rem != 1 ? 's' : ''}';
    if (rem == 0) return '$years year${years != 1 ? 's' : ''}';
    return '$years year${years != 1 ? 's' : ''} $rem month${rem != 1 ? 's' : ''}';
  } catch (_) {
    return '';
  }
}

class WorkExperience {
  final String jobTitle;
  final String companyName;
  final String location;
  final String experienceLevel;
  final String workplace; // On-site / Remote / Hybrid
  final String jobType;   // Full time / Part time / Contract
  final String startDate; // MM-YYYY
  final String? endDate;  // null if currentlyWorkHere
  final bool currentlyWorkHere;
  final String? summary;

  const WorkExperience({
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.experienceLevel,
    required this.workplace,
    required this.jobType,
    required this.startDate,
    this.endDate,
    this.currentlyWorkHere = false,
    this.summary,
  });

  String get duration =>
      _calcDuration(startDate, currentlyWorkHere ? null : endDate);

  WorkExperience copyWith({
    String? jobTitle, String? companyName, String? location,
    String? experienceLevel, String? workplace, String? jobType,
    String? startDate, String? endDate, bool? currentlyWorkHere,
    String? summary,
  }) => WorkExperience(
    jobTitle: jobTitle ?? this.jobTitle,
    companyName: companyName ?? this.companyName,
    location: location ?? this.location,
    experienceLevel: experienceLevel ?? this.experienceLevel,
    workplace: workplace ?? this.workplace,
    jobType: jobType ?? this.jobType,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    currentlyWorkHere: currentlyWorkHere ?? this.currentlyWorkHere,
    summary: summary ?? this.summary,
  );
}

class Education {
  final String institutionName;
  final String fieldOfStudy;
  final String location;
  final String degreeType;
  final String startDate; // MM-YYYY
  final String? endDate;
  final bool currentlyStudyHere;

  const Education({
    required this.institutionName,
    required this.fieldOfStudy,
    required this.location,
    required this.degreeType,
    required this.startDate,
    this.endDate,
    this.currentlyStudyHere = false,
  });

  String get duration =>
      _calcDuration(startDate, currentlyStudyHere ? null : endDate);

  Education copyWith({
    String? institutionName, String? fieldOfStudy, String? location,
    String? degreeType, String? startDate, String? endDate,
    bool? currentlyStudyHere,
  }) => Education(
    institutionName: institutionName ?? this.institutionName,
    fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
    location: location ?? this.location,
    degreeType: degreeType ?? this.degreeType,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    currentlyStudyHere: currentlyStudyHere ?? this.currentlyStudyHere,
  );
}

class Language {
  final String language;
  final String proficiency; // Native / Fluent / Advanced / Conversational / Basic

  const Language({required this.language, required this.proficiency});

  Language copyWith({String? language, String? proficiency}) => Language(
    language: language ?? this.language,
    proficiency: proficiency ?? this.proficiency,
  );
}

class JobInterest {
  final String id;
  final String title;
  final String category;
  final String? iconName; // IthakiIcon name, optional

  const JobInterest({this.id = '', required this.title, required this.category, this.iconName});
}

class UploadedFile {
  final String name;
  final String size;
  final String? url;
  final double uploadProgress; // 0.0–1.0

  const UploadedFile({
    required this.name,
    required this.size,
    this.url,
    this.uploadProgress = 1.0,
  });

  bool get isComplete => uploadProgress >= 1.0;

  UploadedFile copyWith({
    String? name, String? size, String? url, double? uploadProgress,
  }) => UploadedFile(
    name: name ?? this.name,
    size: size ?? this.size,
    url: url ?? this.url,
    uploadProgress: uploadProgress ?? this.uploadProgress,
  );
}

// ─── Profile State Classes ───────────────────────────────────────────────────

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
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.photoUrl,
    this.dateOfBirth = '',
    this.gender = '',
    this.citizenship = '',
    this.citizenshipCode = '',
    this.residence = '',
    this.residenceCode = '',
    this.status = '',
    this.relocationReadiness = '',
  });

  String get initials =>
      '${firstName.isNotEmpty ? firstName[0] : '?'}${lastName.isNotEmpty ? lastName[0] : '?'}';

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

class ProfileAboutMe {
  final String bio;
  final String? videoUrl;

  const ProfileAboutMe({this.bio = '', this.videoUrl});

  ProfileAboutMe copyWith({String? bio, String? videoUrl}) => ProfileAboutMe(
    bio: bio ?? this.bio,
    videoUrl: videoUrl ?? this.videoUrl,
  );
}

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

class ProfileJobPreferences {
  final List<JobInterest> jobInterests;
  final String positionLevel;
  final String jobType;
  final String workplace;
  final double? expectedSalary;
  final bool preferNotToSpecifySalary;

  const ProfileJobPreferences({
    this.jobInterests = const [],
    this.positionLevel = '',
    this.jobType = '',
    this.workplace = '',
    this.expectedSalary,
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

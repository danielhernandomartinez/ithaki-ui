// lib/models/profile_models.dart

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
  final String title;
  final String category;
  final String? iconName; // IthakiIcon name, optional

  const JobInterest({required this.title, required this.category, this.iconName});
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

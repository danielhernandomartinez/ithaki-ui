import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/profile_models.dart';

class ProfileLocalStore {
  static const _storage = FlutterSecureStorage();

  static const _kBasics = 'profile_basics_v1';
  static const _kAboutMe = 'profile_about_me_v1';
  static const _kSkills = 'profile_skills_v1';
  static const _kWork = 'profile_work_v1';
  static const _kEducation = 'profile_education_v1';
  static const _kFiles = 'profile_files_v1';
  static const _kValues = 'profile_values_v1';
  static const _kPrefs = 'profile_job_prefs_v1';
  static const _kVisible = 'profile_visible_v1';

  static Future<void> saveBasics(ProfileBasics value) async {
    await _storage.write(
      key: _kBasics,
      value: jsonEncode({
        'firstName': value.firstName,
        'lastName': value.lastName,
        'email': value.email,
        'phone': value.phone,
        'photoUrl': value.photoUrl,
        'dateOfBirth': value.dateOfBirth,
        'gender': value.gender,
        'citizenship': value.citizenship,
        'citizenshipCode': value.citizenshipCode,
        'residence': value.residence,
        'residenceCode': value.residenceCode,
        'status': value.status,
        'relocationReadiness': value.relocationReadiness,
      }),
    );
  }

  static Future<ProfileBasics?> loadBasics() async {
    final raw = await _storage.read(key: _kBasics);
    if (raw == null || raw.isEmpty) return null;
    final map = (jsonDecode(raw) as Map).cast<String, dynamic>();
    return ProfileBasics(
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      photoUrl: map['photoUrl'] as String?,
      dateOfBirth: map['dateOfBirth'] as String? ?? '',
      gender: map['gender'] as String? ?? '',
      citizenship: map['citizenship'] as String? ?? '',
      citizenshipCode: map['citizenshipCode'] as String? ?? '',
      residence: map['residence'] as String? ?? '',
      residenceCode: map['residenceCode'] as String? ?? '',
      status: map['status'] as String? ?? '',
      relocationReadiness: map['relocationReadiness'] as String? ?? '',
    );
  }

  static Future<void> saveAboutMe(ProfileAboutMe value) async {
    await _storage.write(
      key: _kAboutMe,
      value: jsonEncode({'bio': value.bio, 'videoUrl': value.videoUrl}),
    );
  }

  static Future<ProfileAboutMe?> loadAboutMe() async {
    final raw = await _storage.read(key: _kAboutMe);
    if (raw == null || raw.isEmpty) return null;
    final map = (jsonDecode(raw) as Map).cast<String, dynamic>();
    return ProfileAboutMe(
      bio: map['bio'] as String? ?? '',
      videoUrl: map['videoUrl'] as String?,
    );
  }

  static Future<void> saveSkills(ProfileSkills value) async {
    await _storage.write(
      key: _kSkills,
      value: jsonEncode({
        'hardSkills': value.hardSkills,
        'softSkills': value.softSkills,
        'languages': value.languages
            .map((l) => {'language': l.language, 'proficiency': l.proficiency})
            .toList(),
        'competencies': value.competencies,
      }),
    );
  }

  static Future<ProfileSkills?> loadSkills() async {
    final raw = await _storage.read(key: _kSkills);
    if (raw == null || raw.isEmpty) return null;
    final map = (jsonDecode(raw) as Map).cast<String, dynamic>();
    final langs = (map['languages'] as List? ?? [])
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map(
          (j) => Language(
            language: j['language'] as String? ?? '',
            proficiency: j['proficiency'] as String? ?? '',
          ),
        )
        .toList();
    return ProfileSkills(
      hardSkills: (map['hardSkills'] as List? ?? []).whereType<String>().toList(),
      softSkills: (map['softSkills'] as List? ?? []).whereType<String>().toList(),
      languages: langs,
      competencies: (map['competencies'] as Map? ?? {})
          .map((k, v) => MapEntry(k.toString(), v.toString())),
    );
  }

  static Future<void> saveWork(List<WorkExperience> values) async {
    await _storage.write(
      key: _kWork,
      value: jsonEncode(
        values
            .map(
              (e) => {
                'jobTitle': e.jobTitle,
                'companyName': e.companyName,
                'location': e.location,
                'experienceLevel': e.experienceLevel,
                'workplace': e.workplace,
                'jobType': e.jobType,
                'startDate': e.startDate,
                'endDate': e.endDate,
                'currentlyWorkHere': e.currentlyWorkHere,
                'summary': e.summary,
              },
            )
            .toList(),
      ),
    );
  }

  static Future<List<WorkExperience>?> loadWork() async {
    final raw = await _storage.read(key: _kWork);
    if (raw == null || raw.isEmpty) return null;
    return (jsonDecode(raw) as List)
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map(
          (j) => WorkExperience(
            jobTitle: j['jobTitle'] as String? ?? '',
            companyName: j['companyName'] as String? ?? '',
            location: j['location'] as String? ?? '',
            experienceLevel: j['experienceLevel'] as String? ?? '',
            workplace: j['workplace'] as String? ?? '',
            jobType: j['jobType'] as String? ?? '',
            startDate: j['startDate'] as String? ?? '',
            endDate: j['endDate'] as String?,
            currentlyWorkHere: j['currentlyWorkHere'] as bool? ?? false,
            summary: j['summary'] as String?,
          ),
        )
        .toList();
  }

  static Future<void> saveEducation(List<Education> values) async {
    await _storage.write(
      key: _kEducation,
      value: jsonEncode(
        values
            .map(
              (e) => {
                'institutionName': e.institutionName,
                'fieldOfStudy': e.fieldOfStudy,
                'location': e.location,
                'degreeType': e.degreeType,
                'startDate': e.startDate,
                'endDate': e.endDate,
                'currentlyStudyHere': e.currentlyStudyHere,
              },
            )
            .toList(),
      ),
    );
  }

  static Future<List<Education>?> loadEducation() async {
    final raw = await _storage.read(key: _kEducation);
    if (raw == null || raw.isEmpty) return null;
    return (jsonDecode(raw) as List)
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map(
          (j) => Education(
            institutionName: j['institutionName'] as String? ?? '',
            fieldOfStudy: j['fieldOfStudy'] as String? ?? '',
            location: j['location'] as String? ?? '',
            degreeType: j['degreeType'] as String? ?? '',
            startDate: j['startDate'] as String? ?? '',
            endDate: j['endDate'] as String?,
            currentlyStudyHere: j['currentlyStudyHere'] as bool? ?? false,
          ),
        )
        .toList();
  }

  static Future<void> saveFiles(List<UploadedFile> values) async {
    await _storage.write(
      key: _kFiles,
      value: jsonEncode(
        values
            .map(
              (e) => {
                'name': e.name,
                'size': e.size,
                'url': e.url,
                'uploadProgress': e.uploadProgress,
              },
            )
            .toList(),
      ),
    );
  }

  static Future<List<UploadedFile>?> loadFiles() async {
    final raw = await _storage.read(key: _kFiles);
    if (raw == null || raw.isEmpty) return null;
    return (jsonDecode(raw) as List)
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map(
          (j) => UploadedFile(
            name: j['name'] as String? ?? '',
            size: j['size'] as String? ?? '',
            url: j['url'] as String?,
            uploadProgress: (j['uploadProgress'] as num?)?.toDouble() ?? 1.0,
          ),
        )
        .toList();
  }

  static Future<void> saveValues(List<String> values) async {
    await _storage.write(key: _kValues, value: jsonEncode(values));
  }

  static Future<List<String>?> loadValues() async {
    final raw = await _storage.read(key: _kValues);
    if (raw == null || raw.isEmpty) return null;
    return (jsonDecode(raw) as List).whereType<String>().toList();
  }

  static Future<void> savePrefs(ProfileJobPreferences value) async {
    await _storage.write(
      key: _kPrefs,
      value: jsonEncode({
        'jobInterests': value.jobInterests
            .map(
              (e) => {
                'id': e.id,
                'title': e.title,
                'category': e.category,
                'iconName': e.iconName,
              },
            )
            .toList(),
        'positionLevel': value.positionLevel,
        'jobType': value.jobType,
        'workplace': value.workplace,
        'expectedSalary': value.expectedSalary,
        'preferNotToSpecifySalary': value.preferNotToSpecifySalary,
      }),
    );
  }

  static Future<ProfileJobPreferences?> loadPrefs() async {
    final raw = await _storage.read(key: _kPrefs);
    if (raw == null || raw.isEmpty) return null;
    final map = (jsonDecode(raw) as Map).cast<String, dynamic>();
    final interests = (map['jobInterests'] as List? ?? [])
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map(
          (j) => JobInterest(
            id: j['id'] as String? ?? '',
            title: j['title'] as String? ?? '',
            category: j['category'] as String? ?? '',
            iconName: j['iconName'] as String?,
          ),
        )
        .toList();
    return ProfileJobPreferences(
      jobInterests: interests,
      positionLevel: map['positionLevel'] as String? ?? '',
      jobType: map['jobType'] as String? ?? '',
      workplace: map['workplace'] as String? ?? '',
      expectedSalary: (map['expectedSalary'] as num?)?.toDouble(),
      preferNotToSpecifySalary:
          map['preferNotToSpecifySalary'] as bool? ?? false,
    );
  }

  static Future<void> saveVisible(bool visible) async {
    await _storage.write(key: _kVisible, value: visible.toString());
  }

  static Future<bool?> loadVisible() async {
    final raw = await _storage.read(key: _kVisible);
    if (raw == null) return null;
    return raw == 'true';
  }

  static Future<void> clearAll() async {
    await Future.wait([
      _storage.delete(key: _kBasics),
      _storage.delete(key: _kAboutMe),
      _storage.delete(key: _kSkills),
      _storage.delete(key: _kWork),
      _storage.delete(key: _kEducation),
      _storage.delete(key: _kFiles),
      _storage.delete(key: _kValues),
      _storage.delete(key: _kPrefs),
      _storage.delete(key: _kVisible),
    ]);
  }
}

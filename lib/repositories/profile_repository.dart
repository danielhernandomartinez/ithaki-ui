import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/profile_models.dart';

class _ProfileLocalStore {
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kBasics,
      jsonEncode({
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
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kBasics);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kAboutMe,
      jsonEncode({'bio': value.bio, 'videoUrl': value.videoUrl}),
    );
  }

  static Future<ProfileAboutMe?> loadAboutMe() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kAboutMe);
    if (raw == null || raw.isEmpty) return null;
    final map = (jsonDecode(raw) as Map).cast<String, dynamic>();
    return ProfileAboutMe(
      bio: map['bio'] as String? ?? '',
      videoUrl: map['videoUrl'] as String?,
    );
  }

  static Future<void> saveSkills(ProfileSkills value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kSkills,
      jsonEncode({
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
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kSkills);
    if (raw == null || raw.isEmpty) return null;
    final map = (jsonDecode(raw) as Map).cast<String, dynamic>();
    final langs = (map['languages'] as List? ?? [])
        .whereType<Map>()
        .map((e) => (e).cast<String, dynamic>())
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kWork,
      jsonEncode(
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
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kWork);
    if (raw == null || raw.isEmpty) return null;
    return (jsonDecode(raw) as List)
        .whereType<Map>()
        .map((e) => (e).cast<String, dynamic>())
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kEducation,
      jsonEncode(
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
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kEducation);
    if (raw == null || raw.isEmpty) return null;
    return (jsonDecode(raw) as List)
        .whereType<Map>()
        .map((e) => (e).cast<String, dynamic>())
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kFiles,
      jsonEncode(
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
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kFiles);
    if (raw == null || raw.isEmpty) return null;
    return (jsonDecode(raw) as List)
        .whereType<Map>()
        .map((e) => (e).cast<String, dynamic>())
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kValues, values);
  }

  static Future<List<String>?> loadValues() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_kValues);
    return values == null ? null : List<String>.from(values);
  }

  static Future<void> savePrefs(ProfileJobPreferences value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kPrefs,
      jsonEncode({
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
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPrefs);
    if (raw == null || raw.isEmpty) return null;
    final map = (jsonDecode(raw) as Map).cast<String, dynamic>();
    final interests = (map['jobInterests'] as List? ?? [])
        .whereType<Map>()
        .map((e) => (e).cast<String, dynamic>())
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kVisible, visible);
  }

  static Future<bool?> loadVisible() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kVisible);
  }
}

abstract class ProfileRepository {
  Future<ProfileBasics> getBasics();
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
  Future<void> saveWorkExperiences(List<WorkExperience> experiences);
  Future<void> saveEducations(List<Education> educations);
  Future<void> saveFiles(List<UploadedFile> files);
  Future<void> saveValues(List<String> values);
  Future<void> saveJobPreferences(ProfileJobPreferences prefs);
  Future<void> saveProfileVisible(bool visible);
}

class MockProfileRepository implements ProfileRepository {
  ProfileBasics _basics = const ProfileBasics(
    firstName: 'Christos',
    lastName: 'Ioannides',
    email: 'c.ioannidis@gmail.com',
    phone: '+30 123 456 78 90',
    dateOfBirth: '01-01-1997',
    gender: 'Male',
    citizenship: 'Greece',
    citizenshipCode: 'gr',
    residence: 'Greece',
    residenceCode: 'gr',
    status: 'Citizen',
    relocationReadiness: 'Yes',
  );
  ProfileAboutMe _aboutMe = const ProfileAboutMe();
  ProfileSkills _skills = const ProfileSkills();
  List<WorkExperience> _workExperiences = const [];
  List<Education> _educations = const [];
  List<UploadedFile> _files = const [];
  List<String> _values = const [];
  ProfileJobPreferences _jobPreferences = const ProfileJobPreferences(
    jobInterests: [JobInterest(title: 'Web Developer', category: 'IT & Development')],
    positionLevel: 'Senior',
    jobType: 'Full time',
    workplace: 'On-site',
    expectedSalary: 1800,
  );
  bool _profileVisible = true;

  Future<void>? _initFuture;

  Future<void> _ensureLoaded() => _initFuture ??= _loadFromLocal();

  Future<void> _loadFromLocal() async {
    _basics = await _ProfileLocalStore.loadBasics() ?? _basics;
    _aboutMe = await _ProfileLocalStore.loadAboutMe() ?? _aboutMe;
    _skills = await _ProfileLocalStore.loadSkills() ?? _skills;
    _workExperiences = await _ProfileLocalStore.loadWork() ?? _workExperiences;
    _educations = await _ProfileLocalStore.loadEducation() ?? _educations;
    _files = await _ProfileLocalStore.loadFiles() ?? _files;
    _values = await _ProfileLocalStore.loadValues() ?? _values;
    _jobPreferences = await _ProfileLocalStore.loadPrefs() ?? _jobPreferences;
    _profileVisible = await _ProfileLocalStore.loadVisible() ?? _profileVisible;
  }

  @override
  Future<ProfileBasics> getBasics() async {
    await _ensureLoaded();
    return _basics;
  }

  @override
  Future<ProfileAboutMe> getAboutMe() async {
    await _ensureLoaded();
    return _aboutMe;
  }

  @override
  Future<ProfileSkills> getSkills() async {
    await _ensureLoaded();
    return _skills;
  }

  @override
  Future<List<WorkExperience>> getWorkExperiences() async {
    await _ensureLoaded();
    return _workExperiences;
  }

  @override
  Future<List<Education>> getEducations() async {
    await _ensureLoaded();
    return _educations;
  }

  @override
  Future<List<UploadedFile>> getFiles() async {
    await _ensureLoaded();
    return _files;
  }

  @override
  Future<List<String>> getValues() async {
    await _ensureLoaded();
    return _values;
  }

  @override
  Future<ProfileJobPreferences> getJobPreferences() async {
    await _ensureLoaded();
    return _jobPreferences;
  }

  @override
  Future<bool> getProfileVisible() async {
    await _ensureLoaded();
    return _profileVisible;
  }

  @override
  Future<void> saveBasics(ProfileBasics basics) async {
    await _ensureLoaded();
    _basics = basics;
    await _ProfileLocalStore.saveBasics(_basics);
  }

  @override
  Future<void> saveAboutMe(ProfileAboutMe aboutMe) async {
    await _ensureLoaded();
    _aboutMe = aboutMe;
    await _ProfileLocalStore.saveAboutMe(_aboutMe);
  }

  @override
  Future<void> saveSkills(ProfileSkills skills) async {
    await _ensureLoaded();
    _skills = skills;
    await _ProfileLocalStore.saveSkills(_skills);
  }

  @override
  Future<void> saveWorkExperiences(List<WorkExperience> experiences) async {
    await _ensureLoaded();
    _workExperiences = experiences;
    await _ProfileLocalStore.saveWork(_workExperiences);
  }

  @override
  Future<void> saveEducations(List<Education> educations) async {
    await _ensureLoaded();
    _educations = educations;
    await _ProfileLocalStore.saveEducation(_educations);
  }

  @override
  Future<void> saveFiles(List<UploadedFile> files) async {
    await _ensureLoaded();
    _files = files;
    await _ProfileLocalStore.saveFiles(_files);
  }

  @override
  Future<void> saveValues(List<String> values) async {
    await _ensureLoaded();
    _values = values;
    await _ProfileLocalStore.saveValues(_values);
  }

  @override
  Future<void> saveJobPreferences(ProfileJobPreferences prefs) async {
    await _ensureLoaded();
    _jobPreferences = prefs;
    await _ProfileLocalStore.savePrefs(_jobPreferences);
  }

  @override
  Future<void> saveProfileVisible(bool visible) async {
    await _ensureLoaded();
    _profileVisible = visible;
    await _ProfileLocalStore.saveVisible(_profileVisible);
  }
}

class ApiProfileRepository implements ProfileRepository {
  ApiProfileRepository({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'ITHAKI_API_BASE_URL',
              defaultValue: 'https://api.odyssea.com/talent/staging',
            );

  final http.Client _client;
  final String _baseUrl;
  Future<void>? _initFuture;

  ProfileBasics _basics = const ProfileBasics();
  ProfileAboutMe _aboutMe = const ProfileAboutMe();
  ProfileSkills _skills = const ProfileSkills();
  List<WorkExperience> _workExperiences = const [];
  List<Education> _educations = const [];
  List<UploadedFile> _files = const [];
  List<String> _values = const [];
  ProfileJobPreferences _jobPreferences = const ProfileJobPreferences();
  bool _profileVisible = true;

  String get _apiBase {
    final trimmed =
        _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    return trimmed.endsWith('/api') ? trimmed : '$trimmed/api';
  }

  Uri _uri(String path) => Uri.parse('$_apiBase$path');

  static const _storage = FlutterSecureStorage();

  Future<String> _requireToken() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token == null || token.isEmpty) throw Exception('Missing auth token');
    return token;
  }

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<void> _ensureLoaded() => _initFuture ??= _loadFromLocal();

  Future<void> _loadFromLocal() async {
    _basics = await _ProfileLocalStore.loadBasics() ?? _basics;
    _aboutMe = await _ProfileLocalStore.loadAboutMe() ?? _aboutMe;
    _skills = await _ProfileLocalStore.loadSkills() ?? _skills;
    _workExperiences = await _ProfileLocalStore.loadWork() ?? _workExperiences;
    _educations = await _ProfileLocalStore.loadEducation() ?? _educations;
    _files = await _ProfileLocalStore.loadFiles() ?? _files;
    _values = await _ProfileLocalStore.loadValues() ?? _values;
    _jobPreferences = await _ProfileLocalStore.loadPrefs() ?? _jobPreferences;
    _profileVisible = await _ProfileLocalStore.loadVisible() ?? _profileVisible;
  }

  static String _enumTitle(dynamic field) =>
      field is Map ? (field['title'] as String? ?? '') : (field as String? ?? '');

  static String _countryName(dynamic field) =>
      field is Map ? (field['name'] as String? ?? '') : (field as String? ?? '');

  static String _countryCode(dynamic field) =>
      field is Map ? ((field['code'] as String? ?? '')).toLowerCase() : '';

  @override
  Future<ProfileBasics> getBasics() async {
    await _ensureLoaded();
    try {
      final token = await _requireToken();

      final userRes = await _client
          .get(_uri('/user/me'), headers: _headers(token))
          .timeout(const Duration(seconds: 20));

      if (userRes.statusCode != 200) {
        throw Exception('Failed to load user: ${userRes.statusCode}');
      }

      final userData = (jsonDecode(userRes.body) as Map).cast<String, dynamic>();
      ProfileBasics basics = ProfileBasics(
        firstName: userData['firstName'] as String? ?? '',
        lastName: userData['lastName'] as String? ?? '',
        email: userData['email'] as String? ?? '',
        phone: userData['phone'] as String? ?? '',
      );

      try {
        final profileRes = await _client
            .get(_uri('/job-seeker/me'), headers: _headers(token))
            .timeout(const Duration(seconds: 20));

        if (profileRes.statusCode == 200) {
          final profileData =
              (jsonDecode(profileRes.body) as Map).cast<String, dynamic>();
          final b = profileData['basics'];
          if (b is Map<String, dynamic>) {
            basics = basics.copyWith(
              phone: b['phone'] as String? ?? basics.phone,
              dateOfBirth: b['dateOfBirth'] as String? ?? '',
              gender: _enumTitle(b['gender']),
              citizenship: _countryName(b['citizenship']),
              citizenshipCode: _countryCode(b['citizenship']),
              residence: _countryName(b['residence']),
              residenceCode: _countryCode(b['residence']),
              photoUrl: b['photo'] as String?,
            );
          }
          final loc = profileData['location'];
          if (loc is Map<String, dynamic>) {
            basics = basics.copyWith(
              status: _enumTitle(loc['status']),
              relocationReadiness: _enumTitle(loc['relocationReadiness']),
            );
          }
        }
      } catch (_) {
        // Keep basics from /user/me
      }

      _basics = basics;
      await _ProfileLocalStore.saveBasics(_basics);
      return _basics;
    } catch (_) {
      return _basics;
    }
  }

  @override
  Future<void> saveBasics(ProfileBasics basics) async {
    await _ensureLoaded();
    _basics = basics;
    await _ProfileLocalStore.saveBasics(_basics);
    final token = await _requireToken();
    await _client
        .post(
          _uri('/user/me'),
          headers: _headers(token),
          body: jsonEncode({
            'firstName': basics.firstName,
            'lastName': basics.lastName,
            'phone': basics.phone,
          }),
        )
        .timeout(const Duration(seconds: 20));
  }

  @override
  Future<ProfileAboutMe> getAboutMe() async {
    await _ensureLoaded();
    return _aboutMe;
  }

  @override
  Future<ProfileSkills> getSkills() async {
    await _ensureLoaded();
    return _skills;
  }

  @override
  Future<List<WorkExperience>> getWorkExperiences() async {
    await _ensureLoaded();
    return _workExperiences;
  }

  @override
  Future<List<Education>> getEducations() async {
    await _ensureLoaded();
    return _educations;
  }

  @override
  Future<List<UploadedFile>> getFiles() async {
    await _ensureLoaded();
    return _files;
  }

  @override
  Future<List<String>> getValues() async {
    await _ensureLoaded();
    return _values;
  }

  @override
  Future<ProfileJobPreferences> getJobPreferences() async {
    await _ensureLoaded();
    return _jobPreferences;
  }

  @override
  Future<bool> getProfileVisible() async {
    await _ensureLoaded();
    return _profileVisible;
  }

  @override
  Future<void> saveAboutMe(ProfileAboutMe aboutMe) async {
    await _ensureLoaded();
    _aboutMe = aboutMe;
    await _ProfileLocalStore.saveAboutMe(_aboutMe);
  }

  @override
  Future<void> saveSkills(ProfileSkills skills) async {
    await _ensureLoaded();
    _skills = skills;
    await _ProfileLocalStore.saveSkills(_skills);
  }

  @override
  Future<void> saveWorkExperiences(List<WorkExperience> experiences) async {
    await _ensureLoaded();
    _workExperiences = experiences;
    await _ProfileLocalStore.saveWork(_workExperiences);
  }

  @override
  Future<void> saveEducations(List<Education> educations) async {
    await _ensureLoaded();
    _educations = educations;
    await _ProfileLocalStore.saveEducation(_educations);
  }

  @override
  Future<void> saveFiles(List<UploadedFile> files) async {
    await _ensureLoaded();
    _files = files;
    await _ProfileLocalStore.saveFiles(_files);
  }

  @override
  Future<void> saveValues(List<String> values) async {
    await _ensureLoaded();
    _values = values;
    await _ProfileLocalStore.saveValues(_values);
  }

  @override
  Future<void> saveJobPreferences(ProfileJobPreferences prefs) async {
    await _ensureLoaded();
    _jobPreferences = prefs;
    await _ProfileLocalStore.savePrefs(_jobPreferences);
  }

  @override
  Future<void> saveProfileVisible(bool visible) async {
    await _ensureLoaded();
    _profileVisible = visible;
    await _ProfileLocalStore.saveVisible(_profileVisible);
  }
}

const bool _useMockProfile = bool.fromEnvironment('ITHAKI_USE_MOCK_PROFILE');

final profileRepositoryProvider = Provider<ProfileRepository>(
  (_) => _useMockProfile ? MockProfileRepository() : ApiProfileRepository(),
);

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/profile_models.dart';
import 'profile/profile_api_mapper.dart';
import 'profile/profile_local_store.dart';

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
    _basics = await ProfileLocalStore.loadBasics() ?? _basics;
    _aboutMe = await ProfileLocalStore.loadAboutMe() ?? _aboutMe;
    _skills = await ProfileLocalStore.loadSkills() ?? _skills;
    _workExperiences = await ProfileLocalStore.loadWork() ?? _workExperiences;
    _educations = await ProfileLocalStore.loadEducation() ?? _educations;
    _files = await ProfileLocalStore.loadFiles() ?? _files;
    _values = await ProfileLocalStore.loadValues() ?? _values;
    _jobPreferences = await ProfileLocalStore.loadPrefs() ?? _jobPreferences;
    _profileVisible = await ProfileLocalStore.loadVisible() ?? _profileVisible;
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
    await ProfileLocalStore.saveBasics(_basics);
  }

  @override
  Future<void> saveAboutMe(ProfileAboutMe aboutMe) async {
    await _ensureLoaded();
    _aboutMe = aboutMe;
    await ProfileLocalStore.saveAboutMe(_aboutMe);
  }

  @override
  Future<void> saveSkills(ProfileSkills skills) async {
    await _ensureLoaded();
    _skills = skills;
    await ProfileLocalStore.saveSkills(_skills);
  }

  @override
  Future<void> saveWorkExperiences(List<WorkExperience> experiences) async {
    await _ensureLoaded();
    _workExperiences = experiences;
    await ProfileLocalStore.saveWork(_workExperiences);
  }

  @override
  Future<void> saveEducations(List<Education> educations) async {
    await _ensureLoaded();
    _educations = educations;
    await ProfileLocalStore.saveEducation(_educations);
  }

  @override
  Future<void> saveFiles(List<UploadedFile> files) async {
    await _ensureLoaded();
    _files = files;
    await ProfileLocalStore.saveFiles(_files);
  }

  @override
  Future<void> saveValues(List<String> values) async {
    await _ensureLoaded();
    _values = values;
    await ProfileLocalStore.saveValues(_values);
  }

  @override
  Future<void> saveJobPreferences(ProfileJobPreferences prefs) async {
    await _ensureLoaded();
    _jobPreferences = prefs;
    await ProfileLocalStore.savePrefs(_jobPreferences);
  }

  @override
  Future<void> saveProfileVisible(bool visible) async {
    await _ensureLoaded();
    _profileVisible = visible;
    await ProfileLocalStore.saveVisible(_profileVisible);
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

  static const _okStatuses = {200, 201, 202, 204};

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

  Future<bool> _postJson(
    String path,
    Object body, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      final token = await _requireToken();
      final res = await _client
          .post(
            _uri(path).replace(queryParameters: queryParameters),
            headers: _headers(token),
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));
      return _okStatuses.contains(res.statusCode);
    } catch (_) {
      return false;
    }
  }

  Future<void> _ensureLoaded() => _initFuture ??= _loadFromLocal();

  Future<void> _loadFromLocal() async {
    _basics = await ProfileLocalStore.loadBasics() ?? _basics;
    _aboutMe = await ProfileLocalStore.loadAboutMe() ?? _aboutMe;
    _skills = await ProfileLocalStore.loadSkills() ?? _skills;
    _workExperiences = await ProfileLocalStore.loadWork() ?? _workExperiences;
    _educations = await ProfileLocalStore.loadEducation() ?? _educations;
    _files = await ProfileLocalStore.loadFiles() ?? _files;
    _values = await ProfileLocalStore.loadValues() ?? _values;
    _jobPreferences = await ProfileLocalStore.loadPrefs() ?? _jobPreferences;
    _profileVisible = await ProfileLocalStore.loadVisible() ?? _profileVisible;
  }


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
              gender: ProfileApiMapper.enumTitle(b['gender']),
              citizenship: ProfileApiMapper.countryName(b['citizenship']),
              citizenshipCode: ProfileApiMapper.countryCode(b['citizenship']),
              residence: ProfileApiMapper.countryName(b['residence']),
              residenceCode: ProfileApiMapper.countryCode(b['residence']),
              photoUrl: b['photo'] as String?,
            );
          }
          final loc = profileData['location'];
          if (loc is Map<String, dynamic>) {
            basics = basics.copyWith(
              status: ProfileApiMapper.enumTitle(loc['status']),
              relocationReadiness: ProfileApiMapper.enumTitle(loc['relocationReadiness']),
            );
          }

          final about = profileData['aboutMe'];
          if (about is Map<String, dynamic>) {
            _aboutMe = ProfileAboutMe(
              bio: (about['bio'] as String? ?? about['text'] as String? ?? '').trim(),
              videoUrl: (about['video'] as String? ?? about['videoUrl'] as String?)?.trim(),
            );
            await ProfileLocalStore.saveAboutMe(_aboutMe);
          }

          final skillsMap = profileData['skills'];
          final competencies = profileData['competencies'];
          final languageList = profileData['languages'];
          _skills = ProfileSkills(
            hardSkills: skillsMap is Map<String, dynamic>
                ? ProfileApiMapper.stringList(skillsMap['hardSkills'])
                : _skills.hardSkills,
            softSkills: skillsMap is Map<String, dynamic>
                ? ProfileApiMapper.stringList(skillsMap['softSkills'])
                : _skills.softSkills,
            languages: (languageList as List? ?? [])
                .whereType<Map>()
                .map((e) => e.cast<String, dynamic>())
                .map(
                  (l) => Language(
                    language: ProfileApiMapper.titleOrText(l['language']).isNotEmpty
                        ? ProfileApiMapper.titleOrText(l['language'])
                        : ProfileApiMapper.titleOrText(l['languageName']),
                    proficiency: ProfileApiMapper.titleOrText(l['level']).isNotEmpty
                        ? ProfileApiMapper.titleOrText(l['level'])
                        : ProfileApiMapper.titleOrText(l['proficiency']),
                  ),
                )
                .where((l) => l.language.isNotEmpty)
                .toList(),
            competencies: competencies is Map<String, dynamic>
                ? competencies.map(
                    (key, value) => MapEntry(key, ProfileApiMapper.titleOrText(value)),
                  )
                : _skills.competencies,
          );
          await ProfileLocalStore.saveSkills(_skills);

          _workExperiences = ((profileData['workExperience'] ?? profileData['workExperiences'])
                      as List? ??
                  [])
              .whereType<Map>()
              .map((e) => e.cast<String, dynamic>())
              .map(
                (item) => WorkExperience(
                  jobTitle: (item['title'] as String? ?? '').trim(),
                  companyName: (item['companyName'] as String? ?? '').trim(),
                  location: ProfileApiMapper.titleOrText(item['city']),
                  experienceLevel: ProfileApiMapper.titleOrText(item['level']),
                  workplace: ProfileApiMapper.titleOrText(item['employmentType']),
                  jobType: ProfileApiMapper.titleOrText(item['workType']),
                  startDate: ProfileApiMapper.isoDateToMmYyyy(item['startDate']) ?? '',
                  endDate: ProfileApiMapper.isoDateToMmYyyy(item['endDate']),
                  currentlyWorkHere: item['current'] as bool? ?? false,
                  summary: (item['description'] as String?)?.trim(),
                ),
              )
              .where((e) => e.jobTitle.isNotEmpty || e.companyName.isNotEmpty)
              .toList();
          await ProfileLocalStore.saveWork(_workExperiences);

          _educations = ((profileData['education'] ?? profileData['educations']) as List? ?? [])
              .whereType<Map>()
              .map((e) => e.cast<String, dynamic>())
              .map(
                (item) => Education(
                  institutionName:
                      (item['institution'] as String? ?? item['institutionName'] as String? ?? '')
                          .trim(),
                  fieldOfStudy: (item['fieldOfStudy'] as String? ?? '').trim(),
                  location: ProfileApiMapper.titleOrText(item['city']),
                  degreeType: (item['degree'] as String? ?? item['degreeType'] as String? ?? '')
                      .trim(),
                  startDate: ProfileApiMapper.isoDateToMmYyyy(item['startDate']) ?? '',
                  endDate: ProfileApiMapper.isoDateToMmYyyy(item['endDate']),
                  currentlyStudyHere: item['currentlyStudying'] as bool? ?? false,
                ),
              )
              .where((e) => e.institutionName.isNotEmpty || e.fieldOfStudy.isNotEmpty)
              .toList();
          await ProfileLocalStore.saveEducation(_educations);

          final prefs = profileData['jobPreferences'];
          if (prefs is Map<String, dynamic>) {
            _jobPreferences = ProfileJobPreferences(
              jobInterests: (profileData['jobInterests'] as List? ?? [])
                  .whereType<Map>()
                  .map((e) => e.cast<String, dynamic>())
                  .map(
                    (j) => JobInterest(
                      id: (j['value'] ?? j['id'] ?? '').toString(),
                      title: ProfileApiMapper.titleOrText(j['title']),
                      category: ProfileApiMapper.titleOrText(j['category']),
                    ),
                  )
                  .where((j) => j.title.isNotEmpty)
                  .toList(),
              positionLevel: ProfileApiMapper.titleOrText(prefs['experienceLevel']),
              jobType: ProfileApiMapper.titleOrText((prefs['employmentType'] as List?)?.first),
              workplace: ProfileApiMapper.titleOrText((prefs['workLocation'] as List?)?.first),
              expectedSalary: double.tryParse(
                (prefs['salaryExpected'] ?? prefs['expectedPayment'] ?? '').toString(),
              ),
              preferNotToSpecifySalary: prefs['preferNotToSpecify'] as bool? ?? false,
            );
            await ProfileLocalStore.savePrefs(_jobPreferences);
          }

          _values = ((profileData['values'] as List?) ?? [])
              .map((e) => ProfileApiMapper.titleOrText(e))
              .where((e) => e.isNotEmpty)
              .toList();
          if (_values.isNotEmpty) {
            await ProfileLocalStore.saveValues(_values);
          }
        }
      } catch (_) {
        // Keep basics from /user/me
      }

      _basics = basics;
      await ProfileLocalStore.saveBasics(_basics);
      return _basics;
    } catch (_) {
      return _basics;
    }
  }

  @override
  Future<void> saveBasics(ProfileBasics basics) async {
    await _ensureLoaded();
    _basics = basics;
    await ProfileLocalStore.saveBasics(_basics);
    await _postJson('/user/me', {
      'firstName': basics.firstName,
      'lastName': basics.lastName,
      'phone': basics.phone,
    });
    await _postJson('/job-seeker/me/onboarding', ProfileApiMapper.onboardingLocationBody(basics),
        queryParameters: const {'step': 'location'});
    await _postJson('/job-seeker/me', {
      'basics': {
        'name': '${basics.firstName} ${basics.lastName}'.trim(),
        'email': basics.email,
        'phone': basics.phone,
        'gender': ProfileApiMapper.enumDto(basics.gender),
        'citizenship': {
          'name': basics.citizenship,
          'code': basics.citizenshipCode.toUpperCase(),
        },
        'residence': {
          'name': basics.residence,
          'code': basics.residenceCode.toUpperCase(),
        },
        'photo': basics.photoUrl,
        'dateOfBirth': basics.dateOfBirth,
      },
      'location': {
        'status': ProfileApiMapper.enumDto(basics.status),
        'relocationReadiness': ProfileApiMapper.enumDto(basics.relocationReadiness),
      },
    });
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
    await ProfileLocalStore.saveAboutMe(_aboutMe);
    await _postJson('/job-seeker/me', {
      'aboutMe': {
        'bio': aboutMe.bio,
        'text': aboutMe.bio,
        'video': aboutMe.videoUrl,
      },
    });
  }

  @override
  Future<void> saveSkills(ProfileSkills skills) async {
    await _ensureLoaded();
    _skills = skills;
    await ProfileLocalStore.saveSkills(_skills);
    await _postJson('/job-seeker/me', {
      'skills': {
        'hardSkills': skills.hardSkills,
        'softSkills': skills.softSkills,
      },
      'competencies': skills.competencies,
      'languages': skills.languages
          .map(
            (lang) => {
              'language': lang.language,
              'proficiency': lang.proficiency,
              'level': ProfileApiMapper.enumDto(lang.proficiency),
            },
          )
          .toList(),
    });
  }

  @override
  Future<void> saveWorkExperiences(List<WorkExperience> experiences) async {
    await _ensureLoaded();
    _workExperiences = experiences;
    await ProfileLocalStore.saveWork(_workExperiences);
    await _postJson('/job-seeker/me/work-experiences/replace', ProfileApiMapper.workReplaceBody(experiences));
  }

  @override
  Future<void> saveEducations(List<Education> educations) async {
    await _ensureLoaded();
    _educations = educations;
    await ProfileLocalStore.saveEducation(_educations);
    await _postJson('/job-seeker/me/education/replace', ProfileApiMapper.educationReplaceBody(educations));
  }

  @override
  Future<void> saveFiles(List<UploadedFile> files) async {
    await _ensureLoaded();
    _files = files;
    await ProfileLocalStore.saveFiles(_files);
    // Metadata only. Real file upload must use multipart /files endpoints.
    await _postJson('/job-seeker/me', {
      'documents': files
          .map((f) => {'name': f.name, 'size': f.size, 'url': f.url})
          .toList(),
    });
  }

  @override
  Future<void> saveValues(List<String> values) async {
    await _ensureLoaded();
    _values = values;
    await ProfileLocalStore.saveValues(_values);
    await _postJson(
      '/job-seeker/me/onboarding',
      {'values': ProfileApiMapper.listItemDtos(values)},
      queryParameters: const {'step': 'values'},
    );
  }

  @override
  Future<void> saveJobPreferences(ProfileJobPreferences prefs) async {
    await _ensureLoaded();
    _jobPreferences = prefs;
    await ProfileLocalStore.savePrefs(_jobPreferences);
    await _postJson(
      '/job-seeker/me/onboarding',
      ProfileApiMapper.onboardingPreferencesBody(prefs),
      queryParameters: const {'step': 'preferences'},
    );
  }

  @override
  Future<void> saveProfileVisible(bool visible) async {
    await _ensureLoaded();
    _profileVisible = visible;
    await ProfileLocalStore.saveVisible(_profileVisible);
    await _postJson('/job-seeker/me', {'profileVisible': visible});
  }
}

const bool _useMockProfile = bool.fromEnvironment('ITHAKI_USE_MOCK_PROFILE');

final profileRepositoryProvider = Provider<ProfileRepository>(
  (_) => _useMockProfile ? MockProfileRepository() : ApiProfileRepository(),
);

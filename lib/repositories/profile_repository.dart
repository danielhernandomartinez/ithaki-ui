import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/profile_models.dart';
import '../services/api_client.dart';
import 'profile/profile_api_mapper.dart';
import 'profile/profile_local_store.dart';

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
  Future<void> saveValues(List<String> values);
  Future<void> saveJobPreferences(ProfileJobPreferences prefs);
  Future<void> saveProfileVisible(bool visible);
}

class MockProfileRepository implements ProfileRepository {
  ProfileBasics _basics = const ProfileBasics(
    firstName: '',
    lastName: '',
    email: '',
    phone: '',
    dateOfBirth: '',
    gender: '',
    citizenship: '',
    citizenshipCode: '',
    residence: '',
    residenceCode: '',
    status: '',
    relocationReadiness: '',
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
  Future<ProfileLoadResult> refreshAll() async {
    await _ensureLoaded();
    return ProfileLoadResult(basics: _basics);
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
  Future<void> saveLanguages(List<Language> languages) async {
    await _ensureLoaded();
    _skills = _skills.copyWith(languages: languages);
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
  ApiProfileRepository({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;
  Future<void>? _initFuture;
  Future<void>? _syncFuture;
  String? _sessionToken;

  ProfileBasics _basics = const ProfileBasics();
  ProfileAboutMe _aboutMe = const ProfileAboutMe();
  ProfileSkills _skills = const ProfileSkills();
  List<WorkExperience> _workExperiences = const [];
  List<Education> _educations = const [];
  List<UploadedFile> _files = const [];
  List<String> _values = const [];
  ProfileJobPreferences _jobPreferences = const ProfileJobPreferences();
  bool _profileVisible = true;

  Map<String, int>? _languageIdByName;

  void _resetInMemory() {
    _basics = const ProfileBasics();
    _aboutMe = const ProfileAboutMe();
    _skills = const ProfileSkills();
    _workExperiences = const [];
    _educations = const [];
    _files = const [];
    _values = const [];
    _jobPreferences = const ProfileJobPreferences();
    _profileVisible = true;
  }

  Future<void> _syncSession() {
    return _syncFuture ??= _doSync().whenComplete(() => _syncFuture = null);
  }

  Future<void> _doSync() async {
    final token = await _api.readTokenOrNull();
    if (_sessionToken == token) return;
    _sessionToken = token;
    _initFuture = null;
    _languageIdByName = null;
    _resetInMemory();
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

  String _normalize(String value) => value.trim().toLowerCase();

  String _normalizeLoose(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'\(.*?\)'), '')
      .replaceAll(RegExp(r'[^a-z0-9,\s-]'), ' ')
      .replaceAll('-', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  Future<Map<String, int>> _getLanguageIdByName() async {
    if (_languageIdByName != null) return _languageIdByName!;
    final res = await _api.get('/list/languages');
    if (res.statusCode != 200) {
      _languageIdByName = <String, int>{};
      return _languageIdByName!;
    }
    final body = jsonDecode(res.body);
    final List raw = body is List
        ? body
        : (body as Map<String, dynamic>)['content'] ?? body['data'] ?? const [];

    final map = <String, int>{};
    for (final item in raw.whereType<Map>()) {
      final j = item.cast<String, dynamic>();
      final name = (j['title'] as String? ?? j['name'] as String? ?? '').trim();
      final idRaw = j['value'] ?? j['id'];
      final id = idRaw is num ? idRaw.toInt() : int.tryParse(idRaw.toString());
      if (name.isEmpty || id == null) continue;
      map[_normalize(name)] = id;
      map[_normalizeLoose(name)] = id;
    }
    _languageIdByName = map;
    return map;
  }

  Map<String, String> _proficiencyEnum(String proficiency) {
    final normalized = _normalize(proficiency);
    switch (normalized) {
      case 'native':
        return const {'value': 'C2', 'title': 'Native/Proficiency'};
      case 'fluent':
        return const {'value': 'C1', 'title': 'Fluent'};
      case 'advanced':
        return const {'value': 'B2', 'title': 'Upper Intermediate'};
      case 'conversational':
        return const {'value': 'B1', 'title': 'Intermediate'};
      case 'basic':
        return const {'value': 'A1', 'title': 'Basic'};
      default:
        return {'value': ProfileApiMapper.slug(proficiency), 'title': proficiency};
    }
  }

  Future<void> _saveLanguagesReplace(List<Language> languages) async {
    final languageMap = await _getLanguageIdByName();
    final payloadEnumDto = <Map<String, dynamic>>[];

    for (final lang in languages) {
      final id = languageMap[_normalize(lang.language)] ??
          languageMap[_normalizeLoose(lang.language)];
      if (id == null) continue;
      payloadEnumDto.add({
        'languageId': id,
        'level': _proficiencyEnum(lang.proficiency),
      });
    }

    if (languages.isNotEmpty && payloadEnumDto.isEmpty) {
      throw Exception('Could not map languages to backend IDs');
    }

    await _api.postJson('/job-seeker/me/languages/replace', payloadEnumDto);
  }


  @override
  Future<ProfileLoadResult> refreshAll() async {
    await _syncSession();
    await _ensureLoaded();
    try {
      final userRes = await _api.get('/user/me');

      if (userRes.statusCode != 200) {
        throw Exception('Failed to load user: ${userRes.statusCode}');
      }

      final Map<String, dynamic> userData;
      try {
        userData = (jsonDecode(userRes.body) as Map).cast<String, dynamic>();
      } on FormatException {
        throw Exception('Failed to load user: server returned non-JSON response');
      }
      final phoneVerified = userData['phoneVerified'] as bool? ?? false;
      // Only persist `true` from the API — the `false` value is written
      // exclusively during signup to gate the OTP verification screen.
      // Overwriting with `false` here would block users who logged in
      // (login clears the store to null, which the router treats as "allowed").
      if (phoneVerified) {
        await ProfileLocalStore.savePhoneVerified(true);
      }

      ProfileBasics basics = ProfileBasics(
        firstName: userData['firstName'] as String? ?? '',
        lastName: userData['lastName'] as String? ?? '',
        email: userData['email'] as String? ?? '',
        phone: userData['phone'] as String? ?? '',
        phoneVerified: phoneVerified,
      );

      try {
        final profileRes = await _api.get('/job-seeker/me');

        if (profileRes.statusCode == 200) {
          final Map<String, dynamic> profileData;
          try {
            profileData = (jsonDecode(profileRes.body) as Map).cast<String, dynamic>();
          } on FormatException {
            throw Exception('Failed to load profile: server returned non-JSON response');
          }

          // ── 1. Parse basics fields ────────────────────────────────────────
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

          // ── 2. Parse all other sections into local vars (no mutation yet) ─
          ProfileAboutMe? parsedAboutMe;
          final about = profileData['aboutMe'];
          if (about is Map<String, dynamic>) {
            parsedAboutMe = ProfileAboutMe(
              bio: (about['bio'] as String? ?? about['text'] as String? ?? '').trim(),
              videoUrl: (about['video'] as String? ?? about['videoUrl'] as String?)?.trim(),
            );
          }

          final skillsMap = profileData['skills'];
          final competencies = profileData['competencies'];
          final languageList = profileData['languages'];
          final parsedSkills = ProfileSkills(
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

          final parsedWork = ((profileData['workExperience'] ?? profileData['workExperiences'])
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

          final parsedEducations =
              ((profileData['education'] ?? profileData['educations']) as List? ?? [])
                  .whereType<Map>()
                  .map((e) => e.cast<String, dynamic>())
                  .map(
                    (item) => Education(
                      institutionName: (item['institution'] as String? ??
                              item['institutionName'] as String? ??
                              '')
                          .trim(),
                      fieldOfStudy: (item['fieldOfStudy'] as String? ?? '').trim(),
                      location: ProfileApiMapper.titleOrText(item['city']),
                      degreeType:
                          (item['degree'] as String? ?? item['degreeType'] as String? ?? '')
                              .trim(),
                      startDate: ProfileApiMapper.isoDateToMmYyyy(item['startDate']) ?? '',
                      endDate: ProfileApiMapper.isoDateToMmYyyy(item['endDate']),
                      currentlyStudyHere: item['currentlyStudying'] as bool? ?? false,
                    ),
                  )
                  .where((e) => e.institutionName.isNotEmpty || e.fieldOfStudy.isNotEmpty)
                  .toList();

          ProfileJobPreferences? parsedPrefs;
          final prefs = profileData['jobPreferences'];
          if (prefs is Map<String, dynamic>) {
            parsedPrefs = ProfileJobPreferences(
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
              jobType: ProfileApiMapper.titleOrText((prefs['employmentType'] as List?)?.firstOrNull),
              workplace: ProfileApiMapper.titleOrText((prefs['workLocation'] as List?)?.firstOrNull),
              expectedSalary: double.tryParse(
                (prefs['salaryExpected'] ?? prefs['expectedPayment'] ?? '').toString(),
              ),
              preferNotToSpecifySalary: prefs['preferNotToSpecify'] as bool? ?? false,
            );
          }

          final parsedValues = ((profileData['values'] as List?) ?? [])
              .map((e) => ProfileApiMapper.titleOrText(e))
              .where((e) => e.isNotEmpty)
              .toList();

          // ── 3. All parsing succeeded — apply mutations in one block ───────
          if (parsedAboutMe != null) {
            _aboutMe = parsedAboutMe;
            await ProfileLocalStore.saveAboutMe(_aboutMe);
          }
          _skills = parsedSkills;
          await ProfileLocalStore.saveSkills(_skills);
          _workExperiences = parsedWork;
          await ProfileLocalStore.saveWork(_workExperiences);
          _educations = parsedEducations;
          await ProfileLocalStore.saveEducation(_educations);
          if (parsedPrefs != null) {
            _jobPreferences = parsedPrefs;
            await ProfileLocalStore.savePrefs(_jobPreferences);
          }
          if (parsedValues.isNotEmpty) {
            _values = parsedValues;
            await ProfileLocalStore.saveValues(_values);
          }
        }
      } catch (e) {
        // /job-seeker/me failed; update only /user/me fields, preserve the rest from cache
        _basics = _basics.copyWith(
          firstName: basics.firstName,
          lastName: basics.lastName,
          email: basics.email,
          phone: basics.phone,
        );
        await ProfileLocalStore.saveBasics(_basics);
        return ProfileLoadResult(basics: _basics, isPartial: true, partialError: e);
      }

      _basics = basics;
      await ProfileLocalStore.saveBasics(_basics);
      return ProfileLoadResult(basics: _basics);
    } catch (e, st) {
      Error.throwWithStackTrace(e, st);
    }
  }

  @override
  Future<void> saveBasics(ProfileBasics basics) async {
    await _syncSession();
    await _ensureLoaded();
    await _api.postJson('/user/me', {
      'firstName': basics.firstName,
      'lastName': basics.lastName,
      'phone': basics.phone,
    });
    await _api.postJson('/job-seeker/me', {
      'basics': {
        'name': '${basics.firstName} ${basics.lastName}'.trim(),
        'email': basics.email,
        'phone': basics.phone,
        'gender': ProfileApiMapper.enumDto(basics.gender),
        if (basics.citizenship.isNotEmpty)
          'citizenship': {
            'name': basics.citizenship,
            'code': basics.citizenshipCode.toUpperCase(),
          },
        if (basics.residence.isNotEmpty)
          'residence': {
            'name': basics.residence,
            'code': basics.residenceCode.toUpperCase(),
          },
        'photo': basics.photoUrl,
        if (basics.dateOfBirth.isNotEmpty)
          'dateOfBirth': ProfileApiMapper.dobToIsoDate(basics.dateOfBirth),
      },
      'location': {
        'status': ProfileApiMapper.enumDto(basics.status),
        'relocationReadiness': ProfileApiMapper.enumDto(basics.relocationReadiness),
      },
    });
    _basics = basics;
    await ProfileLocalStore.saveBasics(_basics);
  }

  @override
  Future<ProfileAboutMe> getAboutMe() async {
    await _syncSession();
    await _ensureLoaded();
    return _aboutMe;
  }

  @override
  Future<ProfileSkills> getSkills() async {
    await _syncSession();
    await _ensureLoaded();
    return _skills;
  }

  @override
  Future<List<WorkExperience>> getWorkExperiences() async {
    await _syncSession();
    await _ensureLoaded();
    return _workExperiences;
  }

  @override
  Future<List<Education>> getEducations() async {
    await _syncSession();
    await _ensureLoaded();
    return _educations;
  }

  @override
  Future<List<UploadedFile>> getFiles() async {
    await _syncSession();
    await _ensureLoaded();
    return _files;
  }

  @override
  Future<List<String>> getValues() async {
    await _syncSession();
    await _ensureLoaded();
    return _values;
  }

  @override
  Future<ProfileJobPreferences> getJobPreferences() async {
    await _syncSession();
    await _ensureLoaded();
    return _jobPreferences;
  }

  @override
  Future<bool> getProfileVisible() async {
    await _syncSession();
    await _ensureLoaded();
    return _profileVisible;
  }

  @override
  Future<void> saveAboutMe(ProfileAboutMe aboutMe) async {
    await _syncSession();
    await _ensureLoaded();
    await _api.postJson('/job-seeker/me', {
      'aboutMe': {
        'bio': aboutMe.bio,
        'text': aboutMe.bio,
        'video': aboutMe.videoUrl,
      },
    });
    _aboutMe = aboutMe;
    await ProfileLocalStore.saveAboutMe(_aboutMe);
  }

  @override
  Future<void> saveSkills(ProfileSkills skills) async {
    await _syncSession();
    await _ensureLoaded();
    await _api.postJson('/job-seeker/me', {
      'skills': {
        'hardSkills': skills.hardSkills,
        'softSkills': skills.softSkills,
      },
      'competencies': skills.competencies,
    });
    await _saveLanguagesReplace(skills.languages);
    _skills = skills;
    await ProfileLocalStore.saveSkills(_skills);
  }

  @override
  Future<void> saveLanguages(List<Language> languages) async {
    await _syncSession();
    await _ensureLoaded();
    await _saveLanguagesReplace(languages);
    _skills = _skills.copyWith(languages: languages);
    await ProfileLocalStore.saveSkills(_skills);
  }

  @override
  Future<void> saveWorkExperiences(List<WorkExperience> experiences) async {
    await _syncSession();
    await _ensureLoaded();
    await _api.postJson('/job-seeker/me/work-experiences/replace', ProfileApiMapper.workReplaceBody(experiences));
    _workExperiences = experiences;
    await ProfileLocalStore.saveWork(_workExperiences);
  }

  @override
  Future<void> saveEducations(List<Education> educations) async {
    await _syncSession();
    await _ensureLoaded();
    await _api.postJson('/job-seeker/me/education/replace', ProfileApiMapper.educationReplaceBody(educations));
    _educations = educations;
    await ProfileLocalStore.saveEducation(_educations);
  }

  @override
  Future<void> saveFiles(List<UploadedFile> files) async {
    await _syncSession();
    await _ensureLoaded();
    // Metadata only. Real file upload must use multipart /files endpoints.
    await _api.postJson('/job-seeker/me', {
      'documents': files
          .map((f) => {'name': f.name, 'size': f.size, 'url': f.url})
          .toList(),
    });
    _files = files;
    await ProfileLocalStore.saveFiles(_files);
  }

  @override
  Future<void> saveValues(List<String> values) async {
    await _syncSession();
    await _ensureLoaded();
    await _api.postJson(
      '/job-seeker/me/onboarding',
      {'values': ProfileApiMapper.listItemDtos(values)},
      params: const {'step': 'values'},
    );
    _values = values;
    await ProfileLocalStore.saveValues(_values);
  }

  @override
  Future<void> saveJobPreferences(ProfileJobPreferences prefs) async {
    await _syncSession();
    await _ensureLoaded();
    await _api.postJson(
      '/job-seeker/me/onboarding',
      ProfileApiMapper.onboardingPreferencesBody(prefs),
      params: const {'step': 'preferences'},
    );
    _jobPreferences = prefs;
    await ProfileLocalStore.savePrefs(_jobPreferences);
  }

  @override
  Future<void> saveProfileVisible(bool visible) async {
    await _syncSession();
    await _ensureLoaded();
    await _api.postJson('/job-seeker/me', {'profileVisible': visible});
    _profileVisible = visible;
    await ProfileLocalStore.saveVisible(_profileVisible);
  }
}

const bool _useMockProfile =
    AppConfig.useMockData || bool.fromEnvironment('ITHAKI_USE_MOCK_PROFILE');

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => _useMockProfile
      ? MockProfileRepository()
      : ApiProfileRepository(apiClient: ref.watch(apiClientProvider)),
);

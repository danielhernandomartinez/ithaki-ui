import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../data/countries.dart';
import '../../models/profile_models.dart';
import '../../services/api_client.dart';
import '../profile_repository.dart';
import 'profile_api_mapper.dart';
import 'profile_local_store.dart';

class ApiProfileRepository implements ProfileRepository {
  ApiProfileRepository({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient();

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

  String _prettyJson(Object value) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(value);
  }

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

  String _countryCodeFor(dynamic field) {
    final apiCode = ProfileApiMapper.countryCode(field);
    if (apiCode.isNotEmpty) return apiCode;

    final idRaw = field is Map ? field['id'] ?? field['value'] : field;
    final id = idRaw is num ? idRaw.toInt() : int.tryParse(idRaw.toString());
    if (id == null) return '';

    for (final entry in countryIdByCode.entries) {
      if (entry.value == id) return entry.key.toLowerCase();
    }
    return '';
  }

  String _countryNameFor(dynamic field) {
    final apiName = field is Map || field is String
        ? ProfileApiMapper.countryName(field)
        : '';
    if (apiName.isNotEmpty) return apiName;

    final code = _countryCodeFor(field);
    if (code.isEmpty) return '';
    for (final country in allCountries) {
      if (country.id.toLowerCase() == code) return country.label;
    }
    return '';
  }

  Map<String, dynamic>? _stringMap(dynamic value) =>
      value is Map ? value.cast<String, dynamic>() : null;

  List<Map<String, dynamic>> _mapList(dynamic value) => value is List
      ? value
          .whereType<Map>()
          .map((item) => item.cast<String, dynamic>())
          .toList()
      : const [];

  List<String> _titleList(dynamic value) => value is List
      ? value
          .map((item) => ProfileApiMapper.titleOrText(item))
          .where((item) => item.isNotEmpty)
          .toList()
      : const [];

  String _firstTitle(dynamic value) {
    if (value is List) {
      for (final item in value) {
        final title = ProfileApiMapper.titleOrText(item);
        if (title.isNotEmpty) return title;
      }
      return '';
    }
    return ProfileApiMapper.titleOrText(value);
  }

  double? _doubleValue(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse((value ?? '').toString());
  }

  bool _boolValue(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = ProfileApiMapper.titleOrText(value).toLowerCase();
    return text == 'true' || text == 'yes' || text == '1';
  }

  String _textValue(dynamic value) => ProfileApiMapper.titleOrText(value);

  bool _isLocalFilePath(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return false;
    final uri = Uri.tryParse(text);
    if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
      return false;
    }
    return File(text).existsSync() ||
        (uri != null &&
            uri.isScheme('file') &&
            File(uri.toFilePath()).existsSync());
  }

  String? _localFilePath(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    if (uri != null && uri.isScheme('file')) return uri.toFilePath();
    return text;
  }

  UploadedFile _documentFromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final id = idRaw is num ? idRaw.toInt() : int.tryParse('$idRaw');
    final name = _textValue(json['name']);
    final type = _textValue(json['type']);
    final uploadedAt = _textValue(json['uploadedAt']);
    final date =
        uploadedAt.contains('T') ? uploadedAt.split('T').first : uploadedAt;
    return UploadedFile(
      id: id,
      name: name.isEmpty ? 'Document' : name,
      size: date.isNotEmpty ? date : (type.isNotEmpty ? type : 'Uploaded'),
      type: type.isEmpty ? null : type,
      uploadedAt: uploadedAt.isEmpty ? null : uploadedAt,
    );
  }

  Future<List<UploadedFile>> _fetchRemoteDocuments() async {
    final response = await _api.get('/files/me/documents');
    debugPrint('[documents] list status -> ${response.statusCode}');
    debugPrint('[documents] list body -> ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to load documents: ${response.statusCode}');
    }
    final decoded = jsonDecode(response.body);
    final raw = decoded is List
        ? decoded
        : decoded is Map
            ? decoded['content'] ?? decoded['data'] ?? const []
            : const [];
    return (raw as List)
        .whereType<Map>()
        .map((item) => _documentFromJson(item.cast<String, dynamic>()))
        .toList();
  }

  Future<void> _refreshRemoteDocuments() async {
    _files = await _fetchRemoteDocuments();
    await ProfileLocalStore.saveFiles(_files);
  }

  ProfileJobPreferences? _parseJobPreferences(
    dynamic preferences,
    dynamic interests,
  ) {
    final prefs = _stringMap(preferences);
    if (prefs == null) return null;

    final parsed = ProfileJobPreferences(
      jobInterests: _mapList(interests)
          .map(
            (item) => JobInterest(
              id: (item['value'] ?? item['id'] ?? '').toString(),
              title: _firstTitle(
                ProfileApiMapper.titleOrText(item['title']).isNotEmpty
                    ? item['title']
                    : item,
              ),
              category: ProfileApiMapper.titleOrText(item['category']),
            ),
          )
          .where((item) => item.title.isNotEmpty)
          .toList(),
      positionLevel:
          _firstTitle(prefs['experienceLevel'] ?? prefs['positionLevel']),
      jobType: _firstTitle(
        prefs['employmentType'] ?? prefs['jobType'] ?? prefs['jobTypes'],
      ),
      workplace: _firstTitle(
        prefs['workLocation'] ??
            prefs['workplace'] ??
            prefs['workplaceFormats'],
      ),
      expectedSalary:
          _doubleValue(prefs['salaryExpected'] ?? prefs['expectedPayment']),
      preferNotToSpecifySalary: prefs['preferNotToSpecify'] as bool? ?? false,
    );

    final hasData = parsed.jobInterests.isNotEmpty ||
        parsed.positionLevel.isNotEmpty ||
        parsed.jobType.isNotEmpty ||
        parsed.workplace.isNotEmpty ||
        parsed.expectedSalary != null ||
        parsed.preferNotToSpecifySalary;
    return hasData ? parsed : null;
  }

  String? _normalizePhotoUrl(dynamic raw) {
    final value = raw is Map
        ? _textValue(raw['url'] ?? raw['signedUrl'] ?? raw['photo'])
        : _textValue(raw);
    if (value.isEmpty) return null;

    for (final marker in const [
      'https%3A//',
      'https%3A%2F%2F',
      'http%3A//',
      'http%3A%2F%2F',
    ]) {
      final start = value.indexOf(marker);
      if (start <= 0) continue;
      final outerQueryStart = value.indexOf('?Expires=', start);
      final encoded = outerQueryStart == -1
          ? value.substring(start)
          : value.substring(start, outerQueryStart);
      final decoded = Uri.decodeFull(encoded);
      final uri = Uri.tryParse(decoded);
      if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
        return decoded;
      }
    }

    return value;
  }

  bool _isRemotePhoto(String? value) {
    final uri = Uri.tryParse(value?.trim() ?? '');
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

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
        return {
          'value': ProfileApiMapper.slug(proficiency),
          'title': proficiency
        };
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
        throw Exception(
            'Failed to load user: server returned non-JSON response');
      }
      debugPrint('[refreshAll] userInfo →\n${_prettyJson(userData)}');
      final phoneVerified = userData['phoneVerified'] as bool? ?? false;
      // Only persist `true` from the API — the `false` value is written
      // exclusively during signup to gate the OTP verification screen.
      // Overwriting with `false` here would block users who logged in
      // (login clears the store to null, which the router treats as "allowed").
      if (phoneVerified) {
        await ProfileLocalStore.savePhoneVerified(true);
      }

      ProfileBasics basics = ProfileBasics(
        firstName: _textValue(userData['firstName']),
        lastName: _textValue(userData['lastName']),
        email: _textValue(userData['email']),
        phone: _textValue(userData['phone']),
        photoUrl: _normalizePhotoUrl(userData['photo']),
        phoneVerified: phoneVerified,
      );

      final onboarding = _stringMap(userData['onboarding']);
      final onboardingLocation = _stringMap(onboarding?['location']);
      if (onboardingLocation != null) {
        final citizenship = onboardingLocation['citizenship'];
        final residence = onboardingLocation['residence'];
        basics = basics.copyWith(
          citizenship: _countryNameFor(citizenship),
          citizenshipCode: _countryCodeFor(citizenship),
          residence: _countryNameFor(residence),
          residenceCode: _countryCodeFor(residence),
          status: ProfileApiMapper.enumTitle(onboardingLocation['status']),
          relocationReadiness: ProfileApiMapper.enumTitle(
            onboardingLocation['relocationReadiness'],
          ),
        );
      }

      final onboardingPrefs = _parseJobPreferences(
        onboarding?['preferences'],
        onboarding?['jobInterests'],
      );
      if (onboardingPrefs != null) {
        _jobPreferences = onboardingPrefs;
        await ProfileLocalStore.savePrefs(_jobPreferences);
      }

      final onboardingValues = _titleList(onboarding?['values']);
      if (onboardingValues.isNotEmpty) {
        _values = onboardingValues;
        await ProfileLocalStore.saveValues(_values);
      }

      try {
        final profileRes = await _api.get('/job-seeker/me');

        if (profileRes.statusCode == 200) {
          final Map<String, dynamic> profileData;
          try {
            profileData =
                (jsonDecode(profileRes.body) as Map).cast<String, dynamic>();
          } on FormatException {
            throw Exception(
                'Failed to load profile: server returned non-JSON response');
          }

          // ── 1. Parse basics fields ────────────────────────────────────────
          final b = _stringMap(profileData['basics']);
          if (b != null) {
            final dateOfBirth =
                ProfileApiMapper.isoDateToDdMmYyyy(b['dateOfBirth']);
            final gender = ProfileApiMapper.enumTitle(b['gender']);
            final citizenship = _countryNameFor(b['citizenship']);
            final citizenshipCode = _countryCodeFor(b['citizenship']);
            final residence = _countryNameFor(b['residence']);
            final residenceCode = _countryCodeFor(b['residence']);
            debugPrint('[refreshAll] basics.photo → ${b['photo']}');
            basics = basics.copyWith(
              phone: _textValue(b['phone']).isNotEmpty
                  ? _textValue(b['phone'])
                  : basics.phone,
              dateOfBirth:
                  dateOfBirth.isNotEmpty ? dateOfBirth : basics.dateOfBirth,
              gender: gender.isNotEmpty ? gender : basics.gender,
              citizenship:
                  citizenship.isNotEmpty ? citizenship : basics.citizenship,
              citizenshipCode: citizenshipCode.isNotEmpty
                  ? citizenshipCode
                  : basics.citizenshipCode,
              residence: residence.isNotEmpty ? residence : basics.residence,
              residenceCode: residenceCode.isNotEmpty
                  ? residenceCode
                  : basics.residenceCode,
              photoUrl: _normalizePhotoUrl(b['photo']),
            );
          }
          final loc = _stringMap(profileData['location']);
          if (loc != null) {
            final status = ProfileApiMapper.enumTitle(loc['status']);
            final relocationReadiness =
                ProfileApiMapper.enumTitle(loc['relocationReadiness']);
            basics = basics.copyWith(
              status: status.isNotEmpty ? status : basics.status,
              relocationReadiness: relocationReadiness.isNotEmpty
                  ? relocationReadiness
                  : basics.relocationReadiness,
            );
          }

          // ── 2. Parse all other sections into local vars (no mutation yet) ─
          ProfileAboutMe? parsedAboutMe;
          final about = _stringMap(profileData['aboutMe']);
          if (about != null) {
            final bio = _textValue(about['bio']);
            final text = _textValue(about['text']);
            final video = _textValue(about['video']);
            final videoUrl =
                video.isNotEmpty ? video : _textValue(about['videoUrl']);
            parsedAboutMe = ProfileAboutMe(
              bio: bio.isNotEmpty ? bio : text,
              videoUrl: videoUrl.isEmpty ? null : videoUrl,
            );
          }

          final skillsMap = _stringMap(profileData['skills']);
          final competencies = profileData['competencies'];
          final languageList = profileData['languages'];
          final parsedSkills = ProfileSkills(
            hardSkills: skillsMap != null
                ? ProfileApiMapper.stringList(skillsMap['hardSkills'])
                : _skills.hardSkills,
            softSkills: skillsMap != null
                ? ProfileApiMapper.stringList(skillsMap['softSkills'])
                : _skills.softSkills,
            languages: _mapList(languageList)
                .map(
                  (l) => Language(
                    language:
                        ProfileApiMapper.titleOrText(l['language']).isNotEmpty
                            ? ProfileApiMapper.titleOrText(l['language'])
                            : ProfileApiMapper.titleOrText(l['languageName']),
                    proficiency:
                        ProfileApiMapper.titleOrText(l['level']).isNotEmpty
                            ? ProfileApiMapper.titleOrText(l['level'])
                            : ProfileApiMapper.titleOrText(l['proficiency']),
                  ),
                )
                .where((l) => l.language.isNotEmpty)
                .toList(),
            competencies: competencies is Map
                ? competencies.cast<String, dynamic>().map(
                      (key, value) =>
                          MapEntry(key, ProfileApiMapper.titleOrText(value)),
                    )
                : _skills.competencies,
          );

          final parsedWork = _mapList(profileData['workExperience'] ??
                  profileData['workExperiences'])
              .map(
                (item) => WorkExperience(
                  jobTitle: _textValue(item['title']),
                  companyName: _textValue(item['companyName']),
                  location: ProfileApiMapper.titleOrText(item['city']),
                  experienceLevel: ProfileApiMapper.titleOrText(item['level']),
                  workplace:
                      ProfileApiMapper.titleOrText(item['employmentType']),
                  jobType: ProfileApiMapper.titleOrText(item['workType']),
                  startDate:
                      ProfileApiMapper.isoDateToMmYyyy(item['startDate']) ?? '',
                  endDate: ProfileApiMapper.isoDateToMmYyyy(item['endDate']),
                  currentlyWorkHere: _boolValue(item['current']),
                  summary: _textValue(item['description']).isEmpty
                      ? null
                      : _textValue(item['description']),
                ),
              )
              .where((e) => e.jobTitle.isNotEmpty || e.companyName.isNotEmpty)
              .toList();

          final parsedEducations = _mapList(
                  profileData['education'] ?? profileData['educations'])
              .map(
                (item) => Education(
                  institutionName: _textValue(item['institution']).isNotEmpty
                      ? _textValue(item['institution'])
                      : _textValue(item['institutionName']),
                  fieldOfStudy: _textValue(item['fieldOfStudy']),
                  location: ProfileApiMapper.titleOrText(item['city']),
                  degreeType: _textValue(item['degree']).isNotEmpty
                      ? _textValue(item['degree'])
                      : _textValue(item['degreeType']),
                  startDate:
                      ProfileApiMapper.isoDateToMmYyyy(item['startDate']) ?? '',
                  endDate: ProfileApiMapper.isoDateToMmYyyy(item['endDate']),
                  currentlyStudyHere: _boolValue(item['currentlyStudying']),
                ),
              )
              .where((e) =>
                  e.institutionName.isNotEmpty || e.fieldOfStudy.isNotEmpty)
              .toList();

          final parsedPrefs = _parseJobPreferences(
                profileData['jobPreferences'] ?? profileData['preferences'],
                profileData['jobInterests'],
              ) ??
              onboardingPrefs;

          final profileValues = _titleList(profileData['values']);
          final parsedValues =
              profileValues.isNotEmpty ? profileValues : onboardingValues;

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
        debugPrint('[refreshAll] jobSeeker profile partial load -> $e');
        _basics = basics;
        await ProfileLocalStore.saveBasics(_basics);
        return ProfileLoadResult(
            basics: _basics, isPartial: true, partialError: e);
      }

      try {
        await _refreshRemoteDocuments();
      } catch (e) {
        debugPrint('[refreshAll] documents load skipped -> $e');
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

    String prettyJson(Object value) {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(value);
    }

    String readUploadedPhoto(String body) {
      final trimmed = body.trim();
      if (trimmed.isEmpty) {
        throw Exception('Photo upload response was empty');
      }
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is String && decoded.trim().isNotEmpty) {
          return decoded.trim();
        }
        if (decoded is Map<String, dynamic>) {
          final rawUrl =
              decoded['url'] ?? decoded['signedUrl'] ?? decoded['photo'];
          if (rawUrl is String && rawUrl.trim().isNotEmpty) {
            return rawUrl.trim();
          }
        }
      } catch (_) {}
      return trimmed;
    }

    Future<String?> uploadPhotoIfNeeded(String? photoUrl) async {
      final localPath = _normalizePhotoUrl(photoUrl);
      if (localPath == null || localPath.isEmpty || _isRemotePhoto(localPath)) {
        return localPath;
      }

      final file = File(localPath);
      if (!await file.exists()) {
        debugPrint(
            '[saveBasics] photo upload skipped; file does not exist → $localPath');
        return photoUrl;
      }

      debugPrint('[saveBasics] photo upload file → $localPath');
      final body = await _api.uploadMultipart(
          '/files/me/upload/photo', 'file', localPath);
      final uploadedPhoto = readUploadedPhoto(body);
      debugPrint('[saveBasics] uploaded photo → $uploadedPhoto');
      return uploadedPhoto;
    }

    Map<String, dynamic>? countryPayload(String code, String name) {
      if (code.isEmpty || name.trim().isEmpty) return null;
      final countryId = countryIdByCode[code.toUpperCase()];
      if (countryId == null) return null;
      final trimmedName = name.trim();
      final capitalizedName =
          trimmedName[0].toUpperCase() + trimmedName.substring(1);
      return {
        'id': countryId,
        'name': capitalizedName,
        'code': code.toUpperCase(),
      };
    }

    final citizenship =
        countryPayload(basics.citizenshipCode, basics.citizenship);
    final residence = countryPayload(basics.residenceCode, basics.residence);
    final uploadedPhotoUrl = await uploadPhotoIfNeeded(basics.photoUrl);
    final photoForPayload =
        _isRemotePhoto(uploadedPhotoUrl) ? null : uploadedPhotoUrl;
    final locationStatus = ProfileApiMapper.locationStatusDto(basics.status);

    final jobSeekerPayload = {
      'basics': {
        'name': '${basics.firstName} ${basics.lastName}'.trim(),
        'email': basics.email,
        'phone': basics.phone,
        'gender': ProfileApiMapper.enumDto(basics.gender),
        if (citizenship != null) 'citizenship': citizenship,
        if (residence != null) 'residence': residence,
        if (photoForPayload != null) 'photo': photoForPayload,
        if (basics.dateOfBirth.isNotEmpty)
          'dateOfBirth': ProfileApiMapper.dobToIsoDate(basics.dateOfBirth),
      },
      'location': {
        if (locationStatus != null) 'status': locationStatus,
        if (basics.relocationReadiness.isNotEmpty)
          'relocationReadiness': ProfileApiMapper.relocationReadinessDto(
              basics.relocationReadiness),
      },
    };
    debugPrint('[saveBasics] payload →\n${prettyJson(jobSeekerPayload)}');
    await _api.postJson('/user/me', {
      'firstName': basics.firstName,
      'lastName': basics.lastName,
      'phone': basics.phone,
    });
    await _api.postJson('/job-seeker/me', jobSeekerPayload);
    try {
      await _api.postJson(
        '/job-seeker/me/onboarding',
        {
          'location': {
            if (citizenship != null) 'citizenship': citizenship['id'],
            if (residence != null) 'residence': residence['id'],
            if (locationStatus != null) 'status': locationStatus,
            if (basics.relocationReadiness.isNotEmpty)
              'relocationReadiness': ProfileApiMapper.relocationReadinessDto(
                  basics.relocationReadiness),
          },
        },
        params: const {'step': 'location'},
      );
    } catch (e) {
      debugPrint('[saveBasics] onboarding location save skipped → $e');
    }

    _basics = basics.copyWith(photoUrl: uploadedPhotoUrl);
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
    await _api.postJson('/job-seeker/me/work-experiences/replace',
        ProfileApiMapper.workReplaceBody(experiences));
    _workExperiences = experiences;
    await ProfileLocalStore.saveWork(_workExperiences);
  }

  @override
  Future<void> saveEducations(List<Education> educations) async {
    await _syncSession();
    await _ensureLoaded();
    await _api.postJson('/job-seeker/me/education/replace',
        ProfileApiMapper.educationReplaceBody(educations));
    _educations = educations;
    await ProfileLocalStore.saveEducation(_educations);
  }

  @override
  Future<void> saveFiles(List<UploadedFile> files) async {
    await _syncSession();
    await _ensureLoaded();

    final incomingIds =
        files.where((file) => file.id != null).map((file) => file.id).toSet();
    final removedIds = _files
        .where((file) => file.id != null && !incomingIds.contains(file.id))
        .map((file) => file.id!)
        .toList();
    for (final id in removedIds) {
      debugPrint('[saveFiles] deleting remote document id=$id');
      final response = await _api.delete('/files/me/documents/$id');
      debugPrint(
          '[saveFiles] delete response status -> ${response.statusCode}');
      debugPrint('[saveFiles] delete response body -> ${response.body}');
    }

    final localFiles = files
        .where((file) => file.id == null && _isLocalFilePath(file.url))
        .toList();
    final localPaths = localFiles
        .map((file) => _localFilePath(file.url))
        .whereType<String>()
        .toList();
    if (localPaths.isNotEmpty) {
      debugPrint('[saveFiles] uploading ${localPaths.length} document(s)');
      for (final file in localFiles) {
        debugPrint(
            '[saveFiles] upload candidate -> ${file.name} | ${file.url}');
      }
      final response = await _api.uploadMultipartFiles(
        '/files/me/upload/documents',
        'uploadedFiles',
        localPaths,
      );
      debugPrint(
          '[saveFiles] upload response status -> ${response.statusCode}');
      debugPrint('[saveFiles] upload response body -> ${response.body}');
    }

    final unsupported = files.where(
      (file) => file.id == null && !_isLocalFilePath(file.url),
    );
    for (final file in unsupported) {
      debugPrint(
        '[saveFiles] skipped unsupported document source -> ${file.name} | ${file.url}',
      );
    }

    try {
      await _refreshRemoteDocuments();
    } catch (e) {
      debugPrint('[saveFiles] remote refresh failed -> $e');
      _files = files;
    }
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

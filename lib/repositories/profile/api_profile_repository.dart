import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../data/countries.dart';
import '../../models/profile_models.dart';
import '../../services/api_client.dart';
import '../reference_data_repository.dart';
import '../profile_repository.dart';
import 'profile_api_mapper.dart';
import 'profile_language_resolver.dart';
import 'profile_local_store.dart';
import 'profile_response_parser.dart';

class ApiProfileRepository implements ProfileRepository {
  ApiProfileRepository({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient() {
    _languageResolver = ProfileLanguageResolver(_api);
  }

  final ApiClient _api;
  late final ProfileLanguageResolver _languageResolver;

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

  static String _prettyJson(Object value) {
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
    _languageResolver.invalidate();
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

  Future<void> _refreshRemoteDocuments() async {
    _files = await ProfileResponseParser.fetchRemoteDocuments(_api);
    await ProfileLocalStore.saveFiles(_files);
  }

  bool _needsSkillResolution(List<String> skills) {
    return skills.any((skill) =>
        int.tryParse(skill.trim()) != null ||
        skill.trim().toLowerCase() == 'true' ||
        skill.trim().toLowerCase() == 'false');
  }

  Future<Map<int, String>> _skillNameById(String path) async {
    try {
      final response = await _api.getOptionalAuth(path);
      if (response.statusCode != 200 || response.body.trim().isEmpty) {
        return const {};
      }
      final decoded = jsonDecode(response.body);
      final raw = decoded is List
          ? decoded
          : decoded is Map
              ? decoded['content'] ?? decoded['data'] ?? const []
              : const [];
      final result = <int, String>{};
      for (final item in raw) {
        if (item is! Map) continue;
        final skill = SkillItem.fromJson(item.cast<String, dynamic>());
        if (skill.name.trim().isNotEmpty) {
          result[skill.id] = skill.name.trim();
        }
      }
      return result;
    } catch (_) {
      return const {};
    }
  }

  List<String> _resolveSkillList(List<String> skills, Map<int, String> names) {
    final resolved = <String>[];
    for (final skill in skills) {
      final text = skill.trim();
      if (text.isEmpty) continue;
      final id = int.tryParse(text);
      if (id != null) {
        final name = names[id];
        if (name != null && name.isNotEmpty) resolved.add(name);
        continue;
      }
      final lower = text.toLowerCase();
      if (lower == 'true' || lower == 'false') continue;
      resolved.add(text);
    }
    return resolved;
  }

  Future<ProfileSkills> _resolveSkillNames(ProfileSkills skills) async {
    final needsHard = _needsSkillResolution(skills.hardSkills);
    final needsSoft = _needsSkillResolution(skills.softSkills);
    if (!needsHard && !needsSoft) return skills;

    final hardNames = needsHard
        ? await _skillNameById('/skills/hard')
        : const <int, String>{};
    final softNames = needsSoft
        ? await _skillNameById('/skills/soft')
        : const <int, String>{};

    return skills.copyWith(
      hardSkills: _resolveSkillList(skills.hardSkills, hardNames),
      softSkills: _resolveSkillList(skills.softSkills, softNames),
    );
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

      ProfileBasics basics =
          ProfileResponseParser.parseBasicsFromUser(userData);

      final onboarding =
          ProfileResponseParser.stringMap(userData['onboarding']);
      final onboardingPrefs = ProfileResponseParser.parseJobPreferences(
        onboarding?['preferences'],
        onboarding?['jobInterests'],
      );
      if (onboardingPrefs != null) {
        _jobPreferences = onboardingPrefs;
        await ProfileLocalStore.savePrefs(_jobPreferences);
      }

      final onboardingValues =
          ProfileResponseParser.titleList(onboarding?['values']);
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

          basics =
              ProfileResponseParser.applyProfileBasics(basics, profileData);

          // Parse all sections before mutating state.
          final parsedAboutMe = ProfileResponseParser.parseAboutMe(profileData);
          final parsedSkills = await _resolveSkillNames(
            ProfileResponseParser.parseSkills(profileData, _skills),
          );
          final parsedWork =
              ProfileResponseParser.parseWorkExperiences(profileData);
          final parsedEducations =
              ProfileResponseParser.parseEducations(profileData);
          final parsedPrefs = ProfileResponseParser.parseJobPreferences(
                profileData['jobPreferences'] ?? profileData['preferences'],
                profileData['jobInterests'],
              ) ??
              onboardingPrefs;
          final profileValues =
              ProfileResponseParser.titleList(profileData['values']);
          final parsedValues =
              profileValues.isNotEmpty ? profileValues : onboardingValues;

          // All parsing succeeded — apply mutations in one block.
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
      final localPath = ProfileResponseParser.normalizePhotoUrl(photoUrl);
      if (localPath == null ||
          localPath.isEmpty ||
          ProfileResponseParser.isRemotePhoto(localPath)) {
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
        ProfileResponseParser.isRemotePhoto(uploadedPhotoUrl)
            ? null
            : uploadedPhotoUrl;
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
    debugPrint('[saveBasics] payload →\n${_prettyJson(jobSeekerPayload)}');
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
    await _languageResolver.saveLanguagesReplace(skills.languages);
    _skills = skills;
    await ProfileLocalStore.saveSkills(_skills);
  }

  @override
  Future<void> saveLanguages(List<Language> languages) async {
    await _syncSession();
    await _ensureLoaded();
    await _languageResolver.saveLanguagesReplace(languages);
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
        .where((file) =>
            file.id == null && ProfileResponseParser.isLocalFilePath(file.url))
        .toList();
    final localPaths = localFiles
        .map((file) => ProfileResponseParser.localFilePath(file.url))
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
      (file) =>
          file.id == null && !ProfileResponseParser.isLocalFilePath(file.url),
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
  Future<Uint8List> downloadFile(UploadedFile file) async {
    // The documents list normally returns id + name; use the backend download
    // route as the primary source. URL fields are kept as a legacy/future
    // fallback for signed/CDN links.
    final id = file.id;
    final url = file.url;
    debugPrint(
      '[downloadFile] requested -> id=${file.id}, name=${file.name}, url=${url ?? '<none>'}',
    );

    if (id != null) {
      debugPrint('[downloadFile] using document id endpoint -> $id');
      final res = await _api.get(
        '/files/me/documents/$id/download',
        timeout: ApiClient.uploadTimeout,
      );
      debugPrint('[downloadFile] id endpoint status -> ${res.statusCode}');
      if (res.statusCode == 200) return res.bodyBytes;
      if (url == null) {
        throw Exception('Download failed: HTTP ${res.statusCode}');
      }
      debugPrint('[downloadFile] id endpoint failed, trying url fallback');
    }

    if (url != null) {
      final uri = Uri.tryParse(url);
      if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
        debugPrint('[downloadFile] trying remote url -> $url');
        final apiHost = Uri.parse(_api.base).host;
        final isSameOrigin = uri.host == apiHost;
        final headers = isSameOrigin
            ? {'Authorization': 'Bearer ${await _api.requireToken()}'}
            : <String, String>{};
        final res = await _api.client
            .get(uri, headers: headers)
            .timeout(ApiClient.uploadTimeout);
        debugPrint('[downloadFile] remote url status -> ${res.statusCode}');
        if (res.statusCode == 200) return res.bodyBytes;
      } else {
        debugPrint(
            '[downloadFile] url is not http(s), skipping direct download');
      }
    }

    throw Exception('No download source for: ${file.name}');
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

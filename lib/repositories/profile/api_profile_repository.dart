import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../models/profile_models.dart';
import '../../services/api_client.dart';
import '../profile_repository.dart';
import 'profile_api_mapper.dart';
import 'profile_basics_service.dart';
import 'profile_documents_service.dart';
import 'profile_language_resolver.dart';
import 'profile_local_store.dart';
import 'profile_response_parser.dart';
import 'profile_session_cache.dart';
import 'profile_skill_resolver.dart';

class ApiProfileRepository implements ProfileRepository {
  ApiProfileRepository({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient() {
    _languageResolver = ProfileLanguageResolver(_api);
    _basicsService = ProfileBasicsService(_api);
    _documentsService = ProfileDocumentsService(_api);
    _skillResolver = ProfileSkillResolver(_api);
  }

  final ApiClient _api;
  final ProfileSessionCache _cache = ProfileSessionCache();
  late final ProfileLanguageResolver _languageResolver;
  late final ProfileBasicsService _basicsService;
  late final ProfileDocumentsService _documentsService;
  late final ProfileSkillResolver _skillResolver;

  Future<void> _prepare() async {
    await _cache.sync(_api, onSessionChanged: _languageResolver.invalidate);
    await _cache.ensureLoaded();
  }

  static String _prettyJson(Object value) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(value);
  }

  @override
  Future<ProfileLoadResult> refreshAll() async {
    await _prepare();

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
    debugPrint('[refreshAll] userInfo ->\n${_prettyJson(userData)}');

    final phoneVerified = userData['phoneVerified'] as bool? ?? false;
    if (phoneVerified) {
      await ProfileLocalStore.savePhoneVerified(true);
    }

    var basics = ProfileResponseParser.parseBasicsFromUser(userData);
    final onboarding = ProfileResponseParser.stringMap(userData['onboarding']);
    final onboardingPrefs = ProfileResponseParser.parseJobPreferences(
      onboarding?['preferences'],
      onboarding?['jobInterests'],
    );
    if (onboardingPrefs != null) {
      await _cache.saveJobPreferences(onboardingPrefs);
    }

    final onboardingValues =
        ProfileResponseParser.titleList(onboarding?['values']);
    if (onboardingValues.isNotEmpty) {
      await _cache.saveValues(onboardingValues);
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
            'Failed to load profile: server returned non-JSON response',
          );
        }

        basics = ProfileResponseParser.applyProfileBasics(basics, profileData);

        final parsedAboutMe = ProfileResponseParser.parseAboutMe(profileData);
        final parsedSkills = await _skillResolver.resolveSkillNames(
          ProfileResponseParser.parseSkills(
            profileData,
            _cache.snapshot.skills,
          ),
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

        if (parsedAboutMe != null) {
          await _cache.saveAboutMe(parsedAboutMe);
        }
        await _cache.saveSkills(parsedSkills);
        await _cache.saveWorkExperiences(parsedWork);
        await _cache.saveEducations(parsedEducations);
        if (parsedPrefs != null) {
          await _cache.saveJobPreferences(parsedPrefs);
        }
        if (parsedValues.isNotEmpty) {
          await _cache.saveValues(parsedValues);
        }
      }
    } catch (e) {
      debugPrint('[refreshAll] jobSeeker profile partial load -> $e');
      await _cache.saveBasics(basics);
      return ProfileLoadResult(
        basics: _cache.snapshot.basics,
        isPartial: true,
        partialError: e,
      );
    }

    try {
      await _cache.saveFiles(await _documentsService.fetchRemoteDocuments());
    } catch (e) {
      debugPrint('[refreshAll] documents load skipped -> $e');
    }

    await _cache.saveBasics(basics);
    return ProfileLoadResult(basics: _cache.snapshot.basics);
  }

  @override
  Future<void> saveBasics(ProfileBasics basics) async {
    await _prepare();
    await _cache.saveBasics(await _basicsService.save(basics));
  }

  @override
  Future<ProfileAboutMe> getAboutMe() async {
    await _prepare();
    return _cache.snapshot.aboutMe;
  }

  @override
  Future<ProfileSkills> getSkills() async {
    await _prepare();
    return _cache.snapshot.skills;
  }

  @override
  Future<List<WorkExperience>> getWorkExperiences() async {
    await _prepare();
    return _cache.snapshot.workExperiences;
  }

  @override
  Future<List<Education>> getEducations() async {
    await _prepare();
    return _cache.snapshot.educations;
  }

  @override
  Future<List<UploadedFile>> getFiles() async {
    await _prepare();
    return _cache.snapshot.files;
  }

  @override
  Future<List<String>> getValues() async {
    await _prepare();
    return _cache.snapshot.values;
  }

  @override
  Future<ProfileJobPreferences> getJobPreferences() async {
    await _prepare();
    return _cache.snapshot.jobPreferences;
  }

  @override
  Future<bool> getProfileVisible() async {
    await _prepare();
    return _cache.snapshot.profileVisible;
  }

  @override
  Future<void> saveAboutMe(ProfileAboutMe aboutMe) async {
    await _prepare();

    final updated = ProfileAboutMe(
      bio: aboutMe.bio,
      videoUrl: _remoteVideoUrlOrNull(aboutMe.videoUrl),
    );
    await _api.postJson('/job-seeker/me', {
      'aboutMe': {
        'bio': updated.bio,
        'text': updated.bio,
        'video': updated.videoUrl,
      },
    });
    await _cache.saveAboutMe(updated);
  }

  @override
  Future<void> saveSkills(ProfileSkills skills) async {
    await _prepare();
    await _api.postJson('/job-seeker/me', {
      'skills': {
        'hardSkills': skills.hardSkills,
        'softSkills': skills.softSkills,
      },
      'competencies': skills.competencies,
    });
    await _languageResolver.saveLanguagesReplace(skills.languages);
    await _cache.saveSkills(skills);
  }

  @override
  Future<void> saveLanguages(List<Language> languages) async {
    await _prepare();
    await _languageResolver.saveLanguagesReplace(languages);
    await _cache.saveSkills(_cache.snapshot.skills.copyWith(
      languages: languages,
    ));
  }

  @override
  Future<void> saveWorkExperiences(List<WorkExperience> experiences) async {
    await _prepare();
    await _api.postJson(
      '/job-seeker/me/work-experiences/replace',
      ProfileApiMapper.workReplaceBody(experiences),
    );
    await _cache.saveWorkExperiences(experiences);
  }

  @override
  Future<void> saveEducations(List<Education> educations) async {
    await _prepare();
    await _api.postJson(
      '/job-seeker/me/education/replace',
      ProfileApiMapper.educationReplaceBody(educations),
    );
    await _cache.saveEducations(educations);
  }

  @override
  Future<void> saveFiles(List<UploadedFile> files) async {
    await _prepare();
    final savedFiles = await _documentsService.saveFiles(
      incoming: files,
      current: _cache.snapshot.files,
    );
    await _cache.saveFiles(savedFiles);
  }

  @override
  Future<Uint8List> downloadFile(UploadedFile file) {
    return _documentsService.downloadFile(file);
  }

  @override
  Future<void> saveValues(List<String> values) async {
    await _prepare();
    await _api.postJson(
      '/job-seeker/me/onboarding',
      {'values': ProfileApiMapper.listItemDtos(values)},
      params: const {'step': 'values'},
    );
    await _cache.saveValues(values);
  }

  @override
  Future<void> saveJobPreferences(ProfileJobPreferences prefs) async {
    await _prepare();
    await _api.postJson(
      '/job-seeker/me/onboarding',
      ProfileApiMapper.onboardingPreferencesBody(prefs),
      params: const {'step': 'preferences'},
    );
    await _cache.saveJobPreferences(prefs);
  }

  @override
  Future<void> saveProfileVisible(bool visible) async {
    await _prepare();
    await _api.postJson('/job-seeker/me', {'profileVisible': visible});
    await _cache.saveProfileVisible(visible);
  }

  static bool _isRemoteResource(String value) {
    final uri = Uri.tryParse(value);
    return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
  }

  static String? _remoteVideoUrlOrNull(String? videoUrl) {
    final value = videoUrl?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    if (_isRemoteResource(value)) return value;
    debugPrint(
        '[saveAboutMe] local video ignored; no upload endpoint -> $value');
    return null;
  }
}

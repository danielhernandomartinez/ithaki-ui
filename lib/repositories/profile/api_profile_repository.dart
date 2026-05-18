import 'package:flutter/foundation.dart';

import '../../models/profile_models.dart';
import '../../services/api_client.dart';
import '../../utils/parse_utils.dart';
import '../profile_repository.dart';
import 'profile_api_mapper.dart';
import 'profile_basics_service.dart';
import 'profile_documents_service.dart';
import 'profile_language_resolver.dart';
import 'profile_loader.dart';
import 'profile_session_cache.dart';
import 'profile_skill_resolver.dart';

class ApiProfileRepository implements ProfileRepository {
  ApiProfileRepository({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient() {
    _languageResolver = ProfileLanguageResolver(_api);
    _basicsService = ProfileBasicsService(_api);
    _documentsService = ProfileDocumentsService(_api);
    _loader = ProfileLoader(
      api: _api,
      cache: _cache,
      documentsService: _documentsService,
      skillResolver: ProfileSkillResolver(_api),
    );
  }

  final ApiClient _api;
  final ProfileSessionCache _cache = ProfileSessionCache();
  late final ProfileLanguageResolver _languageResolver;
  late final ProfileBasicsService _basicsService;
  late final ProfileDocumentsService _documentsService;
  late final ProfileLoader _loader;

  Future<void> _prepare() async {
    await _cache.sync(_api, onSessionChanged: _languageResolver.invalidate);
    await _cache.ensureLoaded();
  }

  @override
  Future<ProfileLoadResult> refreshAll() async {
    await _prepare();
    return _loader.refreshAll();
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

  static String? _remoteVideoUrlOrNull(String? videoUrl) {
    final value = videoUrl?.trim();
    if (value == null || value.isEmpty) {
      return null;
    }
    if (isHttpUrl(value)) return value;
    debugPrint(
        '[saveAboutMe] local video ignored; no upload endpoint -> $value');
    return null;
  }
}

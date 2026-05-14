import 'dart:convert';

import '../../models/profile_models.dart';
import '../../services/api_client.dart';
import 'profile_local_store.dart';
import 'profile_snapshot.dart';

class ProfileSessionCache {
  Future<void>? _initFuture;
  Future<void>? _syncFuture;
  String? _sessionKey;
  ProfileSnapshot _snapshot = ProfileSnapshot.empty();

  ProfileSnapshot get snapshot => _snapshot;

  Future<void> sync(ApiClient api, {void Function()? onSessionChanged}) {
    return _syncFuture ??=
        _doSync(api, onSessionChanged).whenComplete(() => _syncFuture = null);
  }

  Future<void> _doSync(
    ApiClient api,
    void Function()? onSessionChanged,
  ) async {
    final nextSessionKey = _sessionKeyFromToken(await api.readTokenOrNull());
    if (_sessionKey == nextSessionKey) return;

    final storedSessionKey = await ProfileLocalStore.loadSessionKey();
    if (nextSessionKey != null &&
        storedSessionKey != null &&
        storedSessionKey != nextSessionKey) {
      await ProfileLocalStore.clearAll();
    }
    if (nextSessionKey != null && storedSessionKey != nextSessionKey) {
      await ProfileLocalStore.saveSessionKey(nextSessionKey);
    }

    _sessionKey = nextSessionKey;
    _initFuture = null;
    _snapshot = ProfileSnapshot.empty();
    onSessionChanged?.call();
  }

  Future<void> ensureLoaded() {
    return _initFuture ??= _loadFromLocal();
  }

  Future<void> _loadFromLocal() async {
    _snapshot = _snapshot.copyWith(
      basics: await ProfileLocalStore.loadBasics() ?? _snapshot.basics,
      aboutMe: await ProfileLocalStore.loadAboutMe() ?? _snapshot.aboutMe,
      skills: await ProfileLocalStore.loadSkills() ?? _snapshot.skills,
      workExperiences:
          await ProfileLocalStore.loadWork() ?? _snapshot.workExperiences,
      educations:
          await ProfileLocalStore.loadEducation() ?? _snapshot.educations,
      files: await ProfileLocalStore.loadFiles() ?? _snapshot.files,
      values: await ProfileLocalStore.loadValues() ?? _snapshot.values,
      jobPreferences:
          await ProfileLocalStore.loadPrefs() ?? _snapshot.jobPreferences,
      profileVisible:
          await ProfileLocalStore.loadVisible() ?? _snapshot.profileVisible,
    );
  }

  Future<void> saveBasics(ProfileBasics value) async {
    _snapshot = _snapshot.copyWith(basics: value);
    await ProfileLocalStore.saveBasics(value);
  }

  Future<void> saveAboutMe(ProfileAboutMe value) async {
    _snapshot = _snapshot.copyWith(aboutMe: value);
    await ProfileLocalStore.saveAboutMe(value);
  }

  Future<void> saveSkills(ProfileSkills value) async {
    _snapshot = _snapshot.copyWith(skills: value);
    await ProfileLocalStore.saveSkills(value);
  }

  Future<void> saveWorkExperiences(List<WorkExperience> values) async {
    _snapshot = _snapshot.copyWith(workExperiences: values);
    await ProfileLocalStore.saveWork(values);
  }

  Future<void> saveEducations(List<Education> values) async {
    _snapshot = _snapshot.copyWith(educations: values);
    await ProfileLocalStore.saveEducation(values);
  }

  Future<void> saveFiles(List<UploadedFile> values) async {
    _snapshot = _snapshot.copyWith(files: values);
    await ProfileLocalStore.saveFiles(values);
  }

  Future<void> saveValues(List<String> values) async {
    _snapshot = _snapshot.copyWith(values: values);
    await ProfileLocalStore.saveValues(values);
  }

  Future<void> saveJobPreferences(ProfileJobPreferences value) async {
    _snapshot = _snapshot.copyWith(jobPreferences: value);
    await ProfileLocalStore.savePrefs(value);
  }

  Future<void> saveProfileVisible(bool value) async {
    _snapshot = _snapshot.copyWith(profileVisible: value);
    await ProfileLocalStore.saveVisible(value);
  }

  static String? _sessionKeyFromToken(String? token) {
    if (token == null || token.isEmpty) return null;
    final parts = token.split('.');
    if (parts.length != 3) return token;
    try {
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(
        parts[1],
      )));
      final claims = (jsonDecode(payload) as Map).cast<String, dynamic>();
      for (final key in const ['sub', 'userId', 'id', 'email']) {
        final value = claims[key]?.toString().trim();
        if (value != null && value.isNotEmpty) return '$key:$value';
      }
    } catch (_) {
      return token;
    }
    return token;
  }
}

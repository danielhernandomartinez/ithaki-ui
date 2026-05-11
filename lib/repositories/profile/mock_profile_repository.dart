import '../../data/mock_profile_data.dart';
import '../../models/profile_models.dart';
import '../profile_repository.dart';
import 'profile_local_store.dart';

class MockProfileRepository implements ProfileRepository {
  MockProfileRepository({bool persistLocal = false})
      : _persistLocal = persistLocal;

  final bool _persistLocal;

  ProfileBasics _basics = mockProfileBasics;
  ProfileAboutMe _aboutMe = mockProfileAboutMe;
  ProfileSkills _skills = mockProfileSkills;
  List<WorkExperience> _workExperiences = mockProfileWorkExperiences;
  List<Education> _educations = mockProfileEducations;
  List<UploadedFile> _files = mockProfileFiles;
  List<String> _values = const [];
  ProfileJobPreferences _jobPreferences = mockProfileJobPreferences;
  bool _profileVisible = true;

  Future<void>? _initFuture;

  Future<void> _ensureLoaded() => _initFuture ??= _loadFromLocal();

  Future<void> _loadFromLocal() async {
    if (!_persistLocal) {
      return;
    }

    try {
      final cachedBasics = await ProfileLocalStore.loadBasics();
      final cachedAboutMe = await ProfileLocalStore.loadAboutMe();
      final cachedSkills = await ProfileLocalStore.loadSkills();
      final cachedWorkExperiences = await ProfileLocalStore.loadWork();
      final cachedEducations = await ProfileLocalStore.loadEducation();
      final cachedFiles = await ProfileLocalStore.loadFiles();

      if (cachedBasics != null &&
          '${cachedBasics.firstName}${cachedBasics.lastName}'.isNotEmpty) {
        _basics = cachedBasics;
      }
      if (cachedAboutMe != null && cachedAboutMe.bio.trim().isNotEmpty) {
        _aboutMe = cachedAboutMe;
      }
      if (cachedSkills != null &&
          (cachedSkills.hardSkills.isNotEmpty ||
              cachedSkills.softSkills.isNotEmpty ||
              cachedSkills.languages.isNotEmpty ||
              cachedSkills.competencies.isNotEmpty)) {
        _skills = cachedSkills;
      }
      if (cachedWorkExperiences != null && cachedWorkExperiences.isNotEmpty) {
        _workExperiences = cachedWorkExperiences;
      }
      if (cachedEducations != null && cachedEducations.isNotEmpty) {
        _educations = cachedEducations;
      }
      if (cachedFiles != null && cachedFiles.isNotEmpty) {
        _files = cachedFiles;
      }
      _values = await ProfileLocalStore.loadValues() ?? _values;
      final cachedJobPreferences = await ProfileLocalStore.loadPrefs();
      if (cachedJobPreferences != null &&
          (cachedJobPreferences.jobInterests.isNotEmpty ||
              cachedJobPreferences.positionLevel.isNotEmpty ||
              cachedJobPreferences.jobType.isNotEmpty ||
              cachedJobPreferences.workplace.isNotEmpty ||
              cachedJobPreferences.expectedSalary != null)) {
        _jobPreferences = cachedJobPreferences;
      }
      _profileVisible =
          await ProfileLocalStore.loadVisible() ?? _profileVisible;
    } catch (_) {
      // Tests and non-Flutter contexts may not have platform channels for
      // flutter_secure_storage. Keep the mock repository usable in memory.
    }
  }

  Future<void> _persist(Future<void> Function() action) async {
    if (!_persistLocal) {
      return;
    }
    try {
      await action();
    } catch (_) {
      // Best-effort cache only; in-memory state is the source of truth here.
    }
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
    await _persist(() => ProfileLocalStore.saveBasics(_basics));
  }

  @override
  Future<void> saveAboutMe(ProfileAboutMe aboutMe) async {
    await _ensureLoaded();
    _aboutMe = aboutMe;
    await _persist(() => ProfileLocalStore.saveAboutMe(_aboutMe));
  }

  @override
  Future<void> saveSkills(ProfileSkills skills) async {
    await _ensureLoaded();
    _skills = skills;
    await _persist(() => ProfileLocalStore.saveSkills(_skills));
  }

  @override
  Future<void> saveLanguages(List<Language> languages) async {
    await _ensureLoaded();
    _skills = _skills.copyWith(languages: languages);
    await _persist(() => ProfileLocalStore.saveSkills(_skills));
  }

  @override
  Future<void> saveWorkExperiences(List<WorkExperience> experiences) async {
    await _ensureLoaded();
    _workExperiences = experiences;
    await _persist(() => ProfileLocalStore.saveWork(_workExperiences));
  }

  @override
  Future<void> saveEducations(List<Education> educations) async {
    await _ensureLoaded();
    _educations = educations;
    await _persist(() => ProfileLocalStore.saveEducation(_educations));
  }

  @override
  Future<void> saveFiles(List<UploadedFile> files) async {
    await _ensureLoaded();
    _files = files;
    await _persist(() => ProfileLocalStore.saveFiles(_files));
  }

  @override
  Future<void> saveValues(List<String> values) async {
    await _ensureLoaded();
    _values = values;
    await _persist(() => ProfileLocalStore.saveValues(_values));
  }

  @override
  Future<void> saveJobPreferences(ProfileJobPreferences prefs) async {
    await _ensureLoaded();
    _jobPreferences = prefs;
    await _persist(() => ProfileLocalStore.savePrefs(_jobPreferences));
  }

  @override
  Future<void> saveProfileVisible(bool visible) async {
    await _ensureLoaded();
    _profileVisible = visible;
    await _persist(() => ProfileLocalStore.saveVisible(_profileVisible));
  }
}

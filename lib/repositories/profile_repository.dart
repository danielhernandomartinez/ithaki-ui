import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/profile_models.dart';

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
    jobInterests: [
      JobInterest(title: 'Web Developer', category: 'IT & Development'),
    ],
    positionLevel: 'Senior',
    jobType: 'Full time',
    workplace: 'On-site',
    expectedSalary: 1800,
  );
  bool _profileVisible = true;

  @override
  Future<ProfileBasics> getBasics() async => _basics;
  @override
  Future<ProfileAboutMe> getAboutMe() async => _aboutMe;
  @override
  Future<ProfileSkills> getSkills() async => _skills;
  @override
  Future<List<WorkExperience>> getWorkExperiences() async => _workExperiences;
  @override
  Future<List<Education>> getEducations() async => _educations;
  @override
  Future<List<UploadedFile>> getFiles() async => _files;
  @override
  Future<List<String>> getValues() async => _values;
  @override
  Future<ProfileJobPreferences> getJobPreferences() async => _jobPreferences;
  @override
  Future<bool> getProfileVisible() async => _profileVisible;

  @override
  Future<void> saveBasics(ProfileBasics basics) async => _basics = basics;
  @override
  Future<void> saveAboutMe(ProfileAboutMe aboutMe) async => _aboutMe = aboutMe;
  @override
  Future<void> saveSkills(ProfileSkills skills) async => _skills = skills;
  @override
  Future<void> saveWorkExperiences(List<WorkExperience> experiences) async =>
      _workExperiences = experiences;
  @override
  Future<void> saveEducations(List<Education> educations) async =>
      _educations = educations;
  @override
  Future<void> saveFiles(List<UploadedFile> files) async => _files = files;
  @override
  Future<void> saveValues(List<String> values) async => _values = values;
  @override
  Future<void> saveJobPreferences(ProfileJobPreferences prefs) async =>
      _jobPreferences = prefs;
  @override
  Future<void> saveProfileVisible(bool visible) async =>
      _profileVisible = visible;
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (_) => MockProfileRepository(),
);

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  String get _apiBase {
    final trimmed =
        _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    return trimmed.endsWith('/api') ? trimmed : '$trimmed/api';
  }

  Uri _uri(String path) => Uri.parse('$_apiBase$path');

  Future<String> _requireToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null || token.isEmpty) throw Exception('Missing auth token');
    return token;
  }

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  static String _enumTitle(dynamic field) =>
      field is Map ? (field['title'] as String? ?? '') : (field as String? ?? '');

  static String _countryName(dynamic field) =>
      field is Map ? (field['name'] as String? ?? '') : (field as String? ?? '');

  static String _countryCode(dynamic field) =>
      field is Map ? ((field['code'] as String? ?? '')).toLowerCase() : '';

  // ─── Basics ────────────────────────────────────────────────────────────────

  @override
  Future<ProfileBasics> getBasics() async {
    final token = await _requireToken();

    // Basic user info: name, email
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

    // Extended profile: dob, gender, citizenship, etc.
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
        // status + relocationReadiness live under the location onboarding step
        final loc = profileData['location'];
        if (loc is Map<String, dynamic>) {
          basics = basics.copyWith(
            status: _enumTitle(loc['status']),
            relocationReadiness: _enumTitle(loc['relocationReadiness']),
          );
        }
      }
    } catch (_) {
      // Extended profile unavailable — basics from /user/me is enough
    }

    return basics;
  }

  @override
  Future<void> saveBasics(ProfileBasics basics) async {
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

  // ─── Sections not yet connected to API — in-memory fallback ───────────────

  ProfileAboutMe _aboutMe = const ProfileAboutMe();
  ProfileSkills _skills = const ProfileSkills();
  List<WorkExperience> _workExperiences = const [];
  List<Education> _educations = const [];
  List<UploadedFile> _files = const [];
  List<String> _values = const [];
  ProfileJobPreferences _jobPreferences = const ProfileJobPreferences();
  bool _profileVisible = true;

  @override Future<ProfileAboutMe> getAboutMe() async => _aboutMe;
  @override Future<ProfileSkills> getSkills() async => _skills;
  @override Future<List<WorkExperience>> getWorkExperiences() async => _workExperiences;
  @override Future<List<Education>> getEducations() async => _educations;
  @override Future<List<UploadedFile>> getFiles() async => _files;
  @override Future<List<String>> getValues() async => _values;
  @override Future<ProfileJobPreferences> getJobPreferences() async => _jobPreferences;
  @override Future<bool> getProfileVisible() async => _profileVisible;

  @override Future<void> saveAboutMe(ProfileAboutMe v) async => _aboutMe = v;
  @override Future<void> saveSkills(ProfileSkills v) async => _skills = v;
  @override Future<void> saveWorkExperiences(List<WorkExperience> v) async => _workExperiences = v;
  @override Future<void> saveEducations(List<Education> v) async => _educations = v;
  @override Future<void> saveFiles(List<UploadedFile> v) async => _files = v;
  @override Future<void> saveValues(List<String> v) async => _values = v;
  @override Future<void> saveJobPreferences(ProfileJobPreferences v) async => _jobPreferences = v;
  @override Future<void> saveProfileVisible(bool v) async => _profileVisible = v;
}

const bool _useMockProfile = bool.fromEnvironment('ITHAKI_USE_MOCK_PROFILE');

final profileRepositoryProvider = Provider<ProfileRepository>(
  (_) => _useMockProfile ? MockProfileRepository() : ApiProfileRepository(),
);

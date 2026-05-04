import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ithaki_ui/models/profile_models.dart';
import 'package:ithaki_ui/repositories/profile_repository.dart';
import 'package:ithaki_ui/services/api_client.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  final storage = <String, String>{};
  const storageChannel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  setUp(() {
    storage
      ..clear()
      ..['jwt_token'] = 'token';
    binding.defaultBinaryMessenger.setMockMethodCallHandler(
      storageChannel,
      (call) async {
        final args = (call.arguments as Map?) ?? const {};
        final key = args['key'] as String?;
        switch (call.method) {
          case 'write':
            storage[key!] = args['value'] as String;
          case 'read':
            return storage[key];
          case 'delete':
            storage.remove(key);
          case 'deleteAll':
            storage.clear();
          case 'readAll':
            return storage;
        }
        return null;
      },
    );
  });

  group('MockProfileRepository', () {
    test('starts profile sections with the same demo data shown in My CV',
        () async {
      final repository = MockProfileRepository();

      final aboutMe = await repository.getAboutMe();
      final skills = await repository.getSkills();
      final workExperiences = await repository.getWorkExperiences();
      final educations = await repository.getEducations();
      final files = await repository.getFiles();
      final jobPreferences = await repository.getJobPreferences();

      expect(aboutMe.bio, contains('Passionate Frontend Developer'));
      expect(skills.hardSkills, contains('Web Development'));
      expect(skills.softSkills, contains('Teamwork'));
      expect(skills.languages.map((language) => language.language),
          containsAll(['English', 'Greek']));
      expect(skills.competencies['Computer Skills'], 'Professional');
      expect(workExperiences.first.jobTitle, 'Web Developer');
      expect(workExperiences.first.companyName, 'Amazing Dev');
      expect(educations.first.institutionName,
          'National Technical University of Athens');
      expect(files.first.name, 'CV_Christos.pdf');
      expect(jobPreferences.jobInterests.first.title, 'Frontend Developer');
    });
  });

  group('ApiProfileRepository', () {
    test('refreshAll accepts numeric and boolean fields without partial load',
        () async {
      final client = MockClient((request) async {
        switch (request.url.path) {
          case '/api/user/me':
            return http.Response(
              jsonEncode({
                'firstName': 'Pablo',
                'lastName': 'Armas',
                'email': 'pablo@example.com',
                'phone': '123',
                'phoneVerified': true,
              }),
              200,
            );
          case '/api/job-seeker/me':
            return http.Response(
              jsonEncode({
                'basics': {
                  'phone': '123',
                  'gender': {'value': 'MALE', 'title': 'Male'},
                  'citizenship': {'id': 2, 'name': 'Albania'},
                  'residence': {'id': 1, 'name': 'Afghanistan'},
                  'photo':
                      'https://cdn.test/https%3A//cdn.test/photo.jpg%3FExpires%3D1%26Signature%3Dabc%26Key-Pair-Id%3Dkey?Expires=2&Signature=outer',
                  'dateOfBirth': '1995-01-01',
                },
                'location': {
                  'status': {'value': 'CITIZEN', 'title': 'Citizen'},
                  'relocationReadiness': {
                    'value': 'NEGATIVE',
                    'title': 'Not willing to relocate',
                  },
                },
                'skills': {
                  'hardSkills': [
                    1,
                    {'title': 'Dart'}
                  ],
                  'softSkills': [true],
                },
                'competencies': {
                  'hasDrivingLicense': true,
                  'computerSkills': {'title': 'Advanced'},
                },
                'languages': [],
                'workExperience': [],
                'education': [],
                'jobPreferences': {},
                'values': [],
              }),
              200,
            );
        }
        return http.Response('not found', 404);
      });
      final repository = ApiProfileRepository(
        apiClient: ApiClient(client: client, baseUrl: 'http://localhost'),
      );

      final result = await repository.refreshAll();
      final skills = await repository.getSkills();

      expect(result.isPartial, isFalse);
      expect(result.basics.dateOfBirth, '01-01-1995');
      expect(
        result.basics.photoUrl,
        'https://cdn.test/photo.jpg?Expires=1&Signature=abc&Key-Pair-Id=key',
      );
      expect(result.basics.citizenshipCode, 'al');
      expect(result.basics.residenceCode, 'af');
      expect(skills.hardSkills, containsAll(['1', 'Dart']));
      expect(skills.softSkills, ['true']);
      expect(skills.competencies['hasDrivingLicense'], 'true');
    });

    test('saveBasics persists user fields and onboarding location', () async {
      final requests = <String, Object?>{};
      final client = MockClient((request) async {
        requests[request.url.path] =
            request.body.isEmpty ? null : jsonDecode(request.body);
        if (request.url.path == '/api/job-seeker/me/onboarding') {
          return http.Response('boom', 500);
        }
        return http.Response('{}', 200);
      });
      final repository = ApiProfileRepository(
        apiClient: ApiClient(client: client, baseUrl: 'http://localhost'),
      );

      await repository.saveBasics(
        const ProfileBasics(
          firstName: 'Pablo',
          lastName: 'Armas',
          email: 'pablo@example.com',
          phone: '123',
          dateOfBirth: '1995-01-01',
          gender: 'Male',
          citizenship: 'Albania',
          citizenshipCode: 'al',
          residence: 'Afghanistan',
          residenceCode: 'af',
          photoUrl: 'https://cdn.test/photo.jpg?Expires=1&Signature=abc',
          status: 'Citizen',
          relocationReadiness: 'Not willing to relocate',
        ),
      );

      expect(requests['/api/user/me'], {
        'firstName': 'Pablo',
        'lastName': 'Armas',
        'phone': '123',
      });
      final profileBody =
          requests['/api/job-seeker/me'] as Map<String, dynamic>;
      expect(profileBody['basics']['dateOfBirth'], '1995-01-01');
      expect(
        (profileBody['basics'] as Map<String, dynamic>).containsKey('photo'),
        isFalse,
      );
      expect(profileBody['basics']['citizenship'], {
        'id': 2,
        'name': 'Albania',
        'code': 'AL',
      });
      expect(profileBody['basics']['residence'], {
        'id': 1,
        'name': 'Afghanistan',
        'code': 'AF',
      });
      final onboardingBody =
          requests['/api/job-seeker/me/onboarding'] as Map<String, dynamic>;
      expect(onboardingBody['location']['citizenship'], 2);
      expect(onboardingBody['location']['residence'], 1);
    });
  });
}

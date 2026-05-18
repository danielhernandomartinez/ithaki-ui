import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ithaki_ui/repositories/application_detail_repository.dart';
import 'package:ithaki_ui/services/api_client.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({'jwt_token': 'token'});
  });

  test('ApiApplicationDetailRepository loads detail from backend', () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/job-seeker/me/applications/42');
      expect(request.headers['Authorization'], 'Bearer token');

      return http.Response(
        jsonEncode({
          'id': 42,
          'createdAt': '2026-05-18T09:30:00Z',
          'status': 'VIEWED',
          'coverLetter': 'I would love to join.',
          'screeningQuestions': [
            {'question': 'Why this role?', 'answer': 'Strong fit.'}
          ],
          'matchPercentage': 91,
          'job': {
            'id': 7,
            'title': 'Frontend Developer',
            'postedAt': '2026-05-17T09:30:00Z',
            'company': {
              'id': 3,
              'name': 'TechWave',
              'teamSize': '100-150 members',
              'location': 'Athens',
              'description': 'Modern software company.',
            },
            'salaryMin': 1000,
            'salaryMax': 1400,
            'paymentTerm': {'title': 'Monthly'},
            'location': 'Athens',
            'workArrangement': {'title': 'Hybrid'},
            'employmentType': {'title': 'Full-Time'},
            'experienceLevel': {'title': 'Entry'},
            'industry': {'title': 'IT and Web Development'},
            'languages': [
              {'title': 'English'},
              {'title': 'Greek'},
            ],
          },
        }),
        200,
      );
    });
    final repository = ApiApplicationDetailRepository(
      apiClient: ApiClient(client: client, baseUrl: 'http://localhost'),
    );

    final detail = await repository.getApplicationDetail('42');

    expect(detail, isNotNull);
    expect(detail!.id, '42');
    expect(detail.statusLabel, 'Viewed');
    expect(detail.jobTitle, 'Frontend Developer');
    expect(detail.companyName, 'TechWave');
    expect(detail.salaryRange, contains('1000'));
    expect(detail.salaryRange, contains('1400'));
    expect(detail.languages, 'English, Greek');
    expect(detail.coverLetter, 'I would love to join.');
    expect(detail.screeningQuestions.single.answer, 'Strong fit.');
    expect(detail.company.id, '3');
  });
}

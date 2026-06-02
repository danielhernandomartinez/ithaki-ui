import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:ithaki_ui/repositories/applications_repository.dart';
import 'package:ithaki_ui/services/api_client.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({'jwt_token': 'token'});
  });

  test('ApiApplicationsRepository maps nested flat job card fields', () async {
    final client = MockClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/job-seeker/me/applications');
      expect(request.headers['Authorization'], 'Bearer token');

      return http.Response(
        jsonEncode([
          {
            'id': 7,
            'status': 'SUBMITTED',
            'createdAt': '2026-05-20T09:30:00Z',
            'matchPercent': 100,
            'job': {
              'id': 85,
              'title': 'Software Engineer',
              'company': 'Acme Corp',
              'logoInitials': 'AC',
              'salary': '2500 - 4000 EUR',
              'category': 'Technology',
              'location': '',
              'workType': 'Hybrid',
              'schedule': 'Full-Time',
              'level': 'Mid',
              'postedAgo': '3 weeks ago',
            },
          },
        ]),
        200,
      );
    });
    final repository = ApiApplicationsRepository(
      apiClient: ApiClient(client: client, baseUrl: 'http://localhost'),
    );

    final applications = await repository.getApplications();

    expect(applications, hasLength(1));
    expect(applications.single.id, '7');
    expect(applications.single.jobId, '85');
    expect(applications.single.jobTitle, 'Software Engineer');
    expect(applications.single.companyName, 'Acme Corp');
    expect(applications.single.companyInitials, 'AC');
    expect(applications.single.salary, '2500 - 4000 EUR');
    expect(applications.single.category, 'Technology');
    expect(applications.single.location, '');
    expect(applications.single.workplaceType, 'Hybrid');
    expect(applications.single.employmentType, 'Full-Time');
    expect(applications.single.experienceLevel, 'Mid');
    expect(applications.single.matchPercentage, 100);
    expect(applications.single.matchLabel, 'STRONG MATCH');
    expect(applications.single.postedAgo, '3 weeks ago');
  });
}

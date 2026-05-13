import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:ithaki_ui/repositories/home_repository.dart';
import 'package:ithaki_ui/services/api_client.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({'jwt_token': 'token'});
  });

  test('ApiHomeRepository loads jobs and application count', () async {
    final requestedPaths = <String>[];
    final client = MockClient((request) async {
      requestedPaths.add(request.url.path);
      expect(request.headers['Authorization'], 'Bearer token');

      switch (request.url.path) {
        case '/api/jobs':
          expect(request.url.queryParameters['page'], '0');
          expect(request.url.queryParameters['size'], '3');
          return http.Response(
            jsonEncode({
              'content': [
                {
                  'id': 1,
                  'title': 'HR Specialist',
                  'company': 'Meridian Analytics Inc',
                  'logoInitials': 'MA',
                  'salary': '1100 - 1863 EUR / Yearly',
                  'category': 'HR',
                  'location': 'Vienna',
                  'workType': 'On site',
                  'schedule': 'Full-Time',
                  'level': 'Entry',
                  'matchPercent': 100,
                  'postedAgo': '3 weeks ago',
                },
              ],
            }),
            200,
          );
        case '/api/job-seeker/me/applications':
          return http.Response(
            jsonEncode([
              {'id': 1, 'jobId': 42, 'status': 'PENDING'},
              {'id': 2, 'jobId': 43, 'status': 'REVIEWED'},
            ]),
            200,
          );
      }

      return http.Response('Unexpected request', 500);
    });
    final repository = ApiHomeRepository(
      apiClient: ApiClient(client: client, baseUrl: 'http://localhost'),
    );

    final data = await repository.getData();

    expect(requestedPaths,
        containsAll(['/api/jobs', '/api/job-seeker/me/applications']));
    expect(data.cvStats.applicationsSent, 2);
    expect(data.cvStats.views, 0);
    expect(data.cvStats.invitations, 0);
    expect(data.cvStats.interviews, 0);
    expect(data.jobs, hasLength(1));
    expect(data.jobs.single.id, '1');
    expect(data.jobs.single.companyName, 'Meridian Analytics Inc');
    expect(data.jobs.single.companyInitials, 'MA');
    expect(data.jobs.single.jobTitle, 'HR Specialist');
    expect(data.jobs.single.salary, '1100 - 1863 EUR / Yearly');
    expect(data.jobs.single.location, 'Vienna');
    expect(data.jobs.single.workMode, 'On site');
    expect(data.jobs.single.employmentType, 'Full-Time');
    expect(data.jobs.single.level, 'Entry');
    expect(data.jobs.single.matchPercentage, 100);
    expect(data.jobs.single.matchLabel, 'STRONG MATCH');
    expect(data.courses, isEmpty);
    expect(data.news, isEmpty);
  });
}

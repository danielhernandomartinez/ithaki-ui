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
                  'title': 'Senior Backend Developer',
                  'companyName': 'Acme Corp',
                  'location': 'Athens, Greece',
                  'employmentType': {
                    'value': 'FULL_TIME',
                    'title': 'Full Time',
                  },
                  'workArrangement': {
                    'value': 'HYBRID',
                    'title': 'Hybrid',
                  },
                  'experienceLevel': {
                    'value': 'SENIOR',
                    'title': 'Senior',
                  },
                  'salaryMin': 2000,
                  'salaryMax': 3500,
                  'paymentTerm': {
                    'value': 'MONTHLY',
                    'title': 'Monthly',
                  },
                  'matchPercentage': 88,
                  'matchLabel': 'GREAT MATCH',
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
    expect(data.jobs.single.companyName, 'Acme Corp');
    expect(data.jobs.single.jobTitle, 'Senior Backend Developer');
    expect(data.jobs.single.workMode, 'Hybrid');
    expect(data.jobs.single.employmentType, 'Full Time');
    expect(data.jobs.single.level, 'Senior');
    expect(data.jobs.single.matchPercentage, 88);
    expect(data.courses, isEmpty);
    expect(data.news, isEmpty);
  });
}

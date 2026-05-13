import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:ithaki_ui/repositories/job_search_repository.dart';
import 'package:ithaki_ui/services/api_client.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({'jwt_token': 'token'});
  });

  test('ApiJobSearchRepository maps flat list jobs without reformatting',
      () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/jobs');
      expect(request.url.queryParameters['page'], '0');
      expect(request.url.queryParameters['size'], '10');
      expect(request.headers['Authorization'], 'Bearer token');

      return http.Response(
        jsonEncode({
          'content': [
            {
              'id': 85,
              'title': 'HR Specialist',
              'company': 'Meridian Analytics Inc',
              'logoInitials': 'MA',
              'companyId': 16,
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
          'totalElements': 1,
          'totalPages': 1,
        }),
        200,
      );
    });
    final repository = ApiJobSearchRepository(
      apiClient: ApiClient(client: client, baseUrl: 'http://localhost'),
    );

    final result = await repository.search();

    expect(result.totalJobs, 1);
    expect(result.totalPages, 1);
    expect(result.jobs, hasLength(1));
    expect(result.jobs.single.id, '85');
    expect(result.jobs.single.jobTitle, 'HR Specialist');
    expect(result.jobs.single.companyName, 'Meridian Analytics Inc');
    expect(result.jobs.single.companyInitials, 'MA');
    expect(result.jobs.single.salary, '1100 - 1863 EUR / Yearly');
    expect(result.jobs.single.category, 'HR');
    expect(result.jobs.single.location, 'Vienna');
    expect(result.jobs.single.workMode, 'On site');
    expect(result.jobs.single.employmentType, 'Full-Time');
    expect(result.jobs.single.level, 'Entry');
    expect(result.jobs.single.matchPercentage, 100);
    expect(result.jobs.single.matchLabel, 'STRONG MATCH');
    expect(result.jobs.single.postedAgo, '3 weeks ago');
  });

  test('ApiJobSearchRepository sends search query as q with relevant sort',
      () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/jobs');
      expect(request.url.queryParameters['q'], 'software');
      expect(request.url.queryParameters['sort'], 'relevant');
      expect(request.url.queryParameters.containsKey('title'), isFalse);
      expect(request.url.queryParameters['page'], '0');
      expect(request.url.queryParameters['size'], '10');

      return http.Response(jsonEncode({'content': []}), 200);
    });
    final repository = ApiJobSearchRepository(
      apiClient: ApiClient(client: client, baseUrl: 'http://localhost'),
    );

    await repository.search(query: '  software  ');
  });

  test('MockJobSearchRepository filters jobs by query', () async {
    final repository = MockJobSearchRepository();

    final result = await repository.search(query: 'photographer');

    expect(result.jobs, hasLength(1));
    expect(result.jobs.single.jobTitle, 'Junior Photographer');
  });
}

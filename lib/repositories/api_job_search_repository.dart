import 'dart:convert';

import '../models/job_search_filters.dart';
import '../services/api_client.dart';
import '../utils/api_mappers.dart' as mapper;
import 'job_search_parser.dart';
import 'job_search_repository.dart';

class ApiJobSearchRepository implements JobSearchRepository {
  ApiJobSearchRepository({
    ApiClient? apiClient,
  }) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  @override
  Future<JobSearchResult> search({
    String query = '',
    Map<JobSearchFilter, Set<String>> filters = const {},
    JobSearchSort sort = JobSearchSort.dateRecent,
    int page = 1,
  }) async {
    final params = <String, String>{
      'page': (page - 1).toString(),
      'size': '10',
    };

    final q = query.trim();
    if (q.isNotEmpty) {
      params['q'] = q;
      params['sort'] = 'relevant';
    }

    final location = filters[JobSearchFilter.location];
    if (location != null && location.isNotEmpty) {
      params['location'] = location.first;
    }
    final industry = filters[JobSearchFilter.industry];
    if (industry != null && industry.isNotEmpty) {
      params['industry'] = industry.first;
    }
    final jobType = filters[JobSearchFilter.jobType];
    if (jobType != null && jobType.isNotEmpty) {
      params['jobType'] = jobType.first;
    }
    final workplace = filters[JobSearchFilter.workplace];
    if (workplace != null && workplace.isNotEmpty) {
      params['workArrangement'] = workplace.first;
    }
    final experience = filters[JobSearchFilter.experienceLevel];
    if (experience != null && experience.isNotEmpty) {
      params['experienceLevel'] = experience.first;
    }

    final response = await _api.get('/jobs', params: params);

    if (response.statusCode != 200) {
      throw Exception('Job search failed: ${response.statusCode}');
    }

    final body = jsonDecode(response.body);
    final items = mapper.extractList(body);
    final totalElements = body is Map
        ? (body['totalElements'] as num?)?.toInt() ?? items.length
        : items.length;
    final totalPages =
        body is Map ? (body['totalPages'] as num?)?.toInt() ?? 1 : 1;
    final jobs = items
        .whereType<Map<String, dynamic>>()
        .map(JobSearchParser.parseJob)
        .toList();

    return JobSearchResult(
      jobs: jobs,
      totalJobs: totalElements,
      totalPages: totalPages,
    );
  }

  @override
  Future<JobSearchResult> listSavedJobs({int page = 1, int size = 10}) async {
    final params = <String, String>{
      'page': (page - 1).toString(),
      'size': size.toString(),
    };

    final response = await _api.get('/jobs/saved', params: params);

    if (response.statusCode != 200) {
      throw Exception('Saved jobs fetch failed: ${response.statusCode}');
    }

    final body = jsonDecode(response.body);
    final items = mapper.extractList(body);
    final totalElements = body is Map
        ? (body['totalElements'] as num?)?.toInt() ?? items.length
        : items.length;
    final totalPages =
        body is Map ? (body['totalPages'] as num?)?.toInt() ?? 1 : 1;
    final jobs = items
        .whereType<Map<String, dynamic>>()
        .map(JobSearchParser.parseJob)
        .toList();

    return JobSearchResult(
      jobs: jobs,
      totalJobs: totalElements,
      totalPages: totalPages,
    );
  }

  @override
  Future<Set<String>> getSavedJobIds() async {
    const pageSize = 100;
    const maxPages = 50;

    final saved = <String>{};
    var page = 1;
    var totalPages = 1;

    while (page <= totalPages && page <= maxPages) {
      final response = await listSavedJobs(page: page, size: pageSize);
      saved.addAll(response.jobs.map((j) => j.id));
      totalPages = response.totalPages;
      page++;
    }

    return saved;
  }

  @override
  Future<void> saveJob(String jobId) async {
    await _api.post('/jobs/$jobId/save');
  }

  @override
  Future<void> unsaveJob(String jobId) async {
    await _api.delete('/jobs/$jobId/save');
  }
}

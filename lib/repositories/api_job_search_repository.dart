import 'dart:convert';

import '../models/job_search_filters.dart';
import '../services/api_client.dart';
import '../utils/api_mappers.dart' as mapper;
import 'job_search_parser.dart';
import 'job_search_repository.dart';
import 'saved_jobs_store.dart';

class ApiJobSearchRepository implements JobSearchRepository {
  ApiJobSearchRepository({
    ApiClient? apiClient,
    SavedJobsStore savedJobsStore = const SavedJobsStore(),
  })  : _api = apiClient ?? ApiClient(),
        _savedJobsStore = savedJobsStore;

  final ApiClient _api;
  final SavedJobsStore _savedJobsStore;

  // TODO(backend): replace local persistence with real API calls once the
  // backend exposes GET/POST/DELETE saved-jobs endpoints.

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
  Future<Set<String>> getSavedJobIds() => _savedJobsStore.load();

  @override
  Future<void> saveJob(String jobId) async {
    final savedIds = await _savedJobsStore.load();
    savedIds.add(jobId);
    await _savedJobsStore.save(savedIds);
  }

  @override
  Future<void> unsaveJob(String jobId) async {
    final savedIds = await _savedJobsStore.load();
    savedIds.remove(jobId);
    await _savedJobsStore.save(savedIds);
  }
}

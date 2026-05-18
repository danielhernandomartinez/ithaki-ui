import '../models/job_search_filters.dart';
import '../models/job_search_models.dart';

export 'api_job_search_repository.dart';
export 'mock_job_search_repository.dart';

class JobSearchResult {
  final List<JobListing> jobs;
  final int totalJobs;
  final int totalPages;

  const JobSearchResult({
    required this.jobs,
    required this.totalJobs,
    required this.totalPages,
  });
}

abstract class JobSearchRepository {
  Future<JobSearchResult> search({
    String query,
    Map<JobSearchFilter, Set<String>> filters,
    JobSearchSort sort,
    int page,
  });

  Future<Set<String>> getSavedJobIds();
  Future<void> saveJob(String jobId);
  Future<void> unsaveJob(String jobId);
}

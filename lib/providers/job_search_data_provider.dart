import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job_search_filters.dart';
import '../repositories/job_search_repository.dart';
import 'job_search_provider.dart';

export '../repositories/job_search_repository.dart' show JobSearchResult;

class JobSearchDataNotifier extends AsyncNotifier<JobSearchResult> {
  @override
  Future<JobSearchResult> build() {
    final searchState = ref.watch(jobSearchProvider).value;
    return ref.read(jobSearchRepositoryProvider).search(
          query: searchState?.query ?? '',
          filters: searchState?.filters ?? const {},
          sort: searchState?.sortOption ?? JobSearchSort.dateRecent,
          page: searchState?.currentPage ?? 1,
        );
  }
}

final jobSearchDataProvider =
    AsyncNotifierProvider<JobSearchDataNotifier, JobSearchResult>(
  JobSearchDataNotifier.new,
);

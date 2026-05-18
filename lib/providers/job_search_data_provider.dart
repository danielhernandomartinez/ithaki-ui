import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job_search_filters.dart';
import '../repositories/job_search_repository.dart';
import 'job_search_provider.dart';
import 'swr_async_notifier.dart';

export '../repositories/job_search_repository.dart' show JobSearchResult;

class JobSearchDataNotifier extends SwrAsyncNotifier<JobSearchResult> {
  JobSearchState? get _searchState => ref.watch(jobSearchProvider).value;

  @override
  String get cacheKey {
    final searchState = _searchState;
    final query = searchState?.query ?? '';
    final filters = searchState?.filters ?? const {};
    final sort = searchState?.sortOption ?? JobSearchSort.dateRecent;
    final page = searchState?.currentPage ?? 1;
    return 'job-search.$query.${_filtersKey(filters)}.${sort.name}.$page';
  }

  @override
  Future<JobSearchResult> load() {
    final searchState = _searchState;
    return ref.read(jobSearchRepositoryProvider).search(
          query: searchState?.query ?? '',
          filters: searchState?.filters ?? const {},
          sort: searchState?.sortOption ?? JobSearchSort.dateRecent,
          page: searchState?.currentPage ?? 1,
        );
  }
}

String _filtersKey(Map<JobSearchFilter, Set<String>> filters) {
  if (filters.isEmpty) return 'none';
  final parts = filters.entries.map((entry) {
    final values = entry.value.toList()..sort();
    return '${entry.key.name}:${values.join(",")}';
  }).toList()
    ..sort();
  return parts.join('|');
}

final jobSearchDataProvider =
    AsyncNotifierProvider<JobSearchDataNotifier, JobSearchResult>(
  JobSearchDataNotifier.new,
);

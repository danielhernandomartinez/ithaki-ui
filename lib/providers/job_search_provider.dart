import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/job_search_repository.dart';

class JobSearchState {
  final int selectedTab;
  final int currentPage;
  final String sortOption;
  final Set<String> savedJobIds;
  final Map<String, Set<String>> filters;

  const JobSearchState({
    this.selectedTab = 0,
    this.currentPage = 1,
    this.sortOption = 'Date: Recent',
    this.savedJobIds = const {},
    this.filters = const {
      'Location': {},
      'Industry': {},
      'Skills': {},
      'Job Type': {},
      'Workplace': {},
      'Experience Level': {},
      'Salary': {},
      'Travel': {},
    },
  });

  int get activeFilterCount =>
      filters.values.fold(0, (sum, s) => sum + s.length);

  int get savedCount => savedJobIds.length;

  bool isSaved(String jobId) => savedJobIds.contains(jobId);

  JobSearchState copyWith({
    int? selectedTab,
    int? currentPage,
    String? sortOption,
    Set<String>? savedJobIds,
    Map<String, Set<String>>? filters,
  }) =>
      JobSearchState(
        selectedTab: selectedTab ?? this.selectedTab,
        currentPage: currentPage ?? this.currentPage,
        sortOption: sortOption ?? this.sortOption,
        savedJobIds: savedJobIds ?? this.savedJobIds,
        filters: filters ?? this.filters,
      );
}

class JobSearchNotifier extends AsyncNotifier<JobSearchState> {
  @override
  Future<JobSearchState> build() async {
    final savedIds =
        await ref.read(jobSearchRepositoryProvider).getSavedJobIds();
    return JobSearchState(savedJobIds: savedIds);
  }

  void selectTab(int tab) =>
      state = AsyncData(state.requireValue.copyWith(selectedTab: tab));

  void changePage(int page) =>
      state = AsyncData(state.requireValue.copyWith(currentPage: page));

  void nextPage(int totalPages) {
    final current = state.requireValue;
    if (current.currentPage < totalPages) {
      state = AsyncData(current.copyWith(currentPage: current.currentPage + 1));
    }
  }

  void setSort(String option) =>
      state = AsyncData(state.requireValue.copyWith(sortOption: option));

  Future<void> toggleSaved(String jobId) async {
    final current = state.requireValue;
    final updated = Set<String>.from(current.savedJobIds);
    if (updated.contains(jobId)) {
      updated.remove(jobId);
      await ref.read(jobSearchRepositoryProvider).unsaveJob(jobId);
    } else {
      updated.add(jobId);
      await ref.read(jobSearchRepositoryProvider).saveJob(jobId);
    }
    state = AsyncData(current.copyWith(savedJobIds: updated));
  }

  void applyFilters(Map<String, Set<String>> updated) {
    final current = state.requireValue;
    final merged = Map<String, Set<String>>.from(current.filters);
    for (final e in updated.entries) {
      merged[e.key] = e.value;
    }
    state = AsyncData(current.copyWith(filters: merged));
  }

  void resetFilters() {
    final current = state.requireValue;
    state = AsyncData(
      current.copyWith(filters: {for (final k in current.filters.keys) k: {}}),
    );
  }
}

final jobSearchProvider =
    AsyncNotifierProvider<JobSearchNotifier, JobSearchState>(
  JobSearchNotifier.new,
);

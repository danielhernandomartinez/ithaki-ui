import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobSearchState {
  final int selectedTab;
  final int currentPage;
  final String sortOption;
  final Set<int> savedJobIndices;
  final Map<String, Set<String>> filters;

  const JobSearchState({
    this.selectedTab = 0,
    this.currentPage = 1,
    this.sortOption = 'Date: Recent',
    this.savedJobIndices = const {},
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

  bool isSaved(int index) => savedJobIndices.contains(index);

  JobSearchState copyWith({
    int? selectedTab,
    int? currentPage,
    String? sortOption,
    Set<int>? savedJobIndices,
    Map<String, Set<String>>? filters,
  }) =>
      JobSearchState(
        selectedTab: selectedTab ?? this.selectedTab,
        currentPage: currentPage ?? this.currentPage,
        sortOption: sortOption ?? this.sortOption,
        savedJobIndices: savedJobIndices ?? this.savedJobIndices,
        filters: filters ?? this.filters,
      );
}

class JobSearchNotifier extends Notifier<JobSearchState> {
  @override
  JobSearchState build() => const JobSearchState();

  void selectTab(int tab) => state = state.copyWith(selectedTab: tab);

  void changePage(int page) => state = state.copyWith(currentPage: page);

  void nextPage(int totalPages) {
    if (state.currentPage < totalPages) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  void setSort(String option) => state = state.copyWith(sortOption: option);

  void toggleSaved(int index) {
    final updated = Set<int>.from(state.savedJobIndices);
    if (updated.contains(index)) {
      updated.remove(index);
    } else {
      updated.add(index);
    }
    state = state.copyWith(savedJobIndices: updated);
  }

  void applyFilters(Map<String, Set<String>> updated) {
    final merged = Map<String, Set<String>>.from(state.filters);
    for (final e in updated.entries) {
      merged[e.key] = e.value;
    }
    state = state.copyWith(filters: merged);
  }

  void resetFilters() {
    state = state.copyWith(
      filters: {for (final k in state.filters.keys) k: {}},
    );
  }
}

final jobSearchProvider =
    NotifierProvider<JobSearchNotifier, JobSearchState>(JobSearchNotifier.new);

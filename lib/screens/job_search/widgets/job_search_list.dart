import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/job_search_filters.dart';
import '../../../providers/job_search_data_provider.dart';
import '../../../providers/job_search_provider.dart';
import '../../../providers/tour_provider.dart';
import '../../../routes.dart';
import '../../../utils/ithaki_bottom_sheet.dart';
import '../../../utils/localized_dates.dart';
import '../../../utils/match_colors.dart';
import '../../../utils/number_utils.dart';
import '../sort_sheet.dart';

class JobSearchList extends ConsumerWidget {
  const JobSearchList({super.key});

  void _openSort(BuildContext context, WidgetRef ref) {
    final current = ref.read(jobSearchProvider).value?.sortOption ??
        JobSearchSort.dateRecent;
    showIthakiBottomSheet<void>(
      context: context,
      isScrollControlled: false,
      builder: (_) => SortSheet(
        current: current,
        onSelect: (v) => ref.read(jobSearchProvider.notifier).setSort(v),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final notifier = ref.read(jobSearchProvider.notifier);
    final searchState = ref.watch(jobSearchProvider).value;
    final searchResultAsync = ref.watch(jobSearchDataProvider);
    final searchResult = searchResultAsync.value;
    final isLoading = searchResultAsync.isLoading;
    final tourKeys = ref.watch(tourKeysProvider);
    if (searchState == null || searchResult == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final jobs = ref.watch(displayedJobsProvider);
    final isSavedTab = searchState.selectedTab == 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Loading indicator ─────────────────────────────
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(
                minHeight: 2,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),

          // ── Header ────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isSavedTab
                    ? l.savedJobsCountLabel(formatNumber(jobs.length))
                    : l.jobsFoundLabel(formatNumber(searchResult.totalJobs)),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => _openSort(context, ref),
                child: const IthakiIcon(
                  'sorting',
                  size: 22,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Job cards ─────────────────────────────────────
          if (jobs.isEmpty && isSavedTab)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Text(
                  l.noSavedJobsYet,
                  style: const TextStyle(
                    fontSize: 14,
                    color: IthakiTheme.textSecondary,
                  ),
                ),
              ),
            )
          else
            for (int i = 0; i < jobs.length; i++) ...[
              KeyedSubtree(
                key: i == 0 ? tourKeys[3] : null,
                child: IthakiJobSearchCard(
                  jobTitle: jobs[i].jobTitle,
                  companyName: jobs[i].companyName,
                  companyLogo: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: jobs[i].companyColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      jobs[i].companyInitials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  salary: jobs[i].salary,
                  matchPercentage: jobs[i].matchPercentage,
                  matchLabel: jobs[i].matchLabel,
                  matchGradientColors:
                      getMatchGradientColors(jobs[i].matchLabel),
                  matchBackgroundColor: getMatchBgColor(jobs[i].matchLabel),
                  category:
                      jobs[i].category.isNotEmpty ? jobs[i].category : null,
                  location: jobs[i].location,
                  workMode: jobs[i].workMode,
                  employmentType: jobs[i].employmentType,
                  level: jobs[i].level,
                  postedAgo: formatPostedAgo(context, jobs[i].postedAgo),
                  isSaved: searchState.isSaved(jobs[i].id),
                  onSave: () => notifier.toggleSaved(jobs[i].id),
                  onView: () =>
                      context.push(Routes.jobSearchDetailFor(jobs[i].id)),
                ),
              ),
              if (i < jobs.length - 1) const SizedBox(height: 12),
            ],

          const SizedBox(height: 16),
          if (!isSavedTab) const JobSearchPagination(),
        ],
      ),
    );
  }
}

class JobSearchPagination extends ConsumerWidget {
  const JobSearchPagination({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalPages = ref.watch(jobSearchDataProvider).value?.totalPages ?? 0;
    final currentPage = ref.watch(jobSearchProvider).value?.currentPage ?? 1;
    final notifier = ref.read(jobSearchProvider.notifier);
    final l = AppLocalizations.of(context)!;

    if (totalPages <= 1) return const SizedBox.shrink();

    final pages = _visiblePages(currentPage, totalPages);

    return Column(
      children: [
        Text(
          l.jobSearchPageStatus(currentPage, totalPages),
          style: IthakiTheme.bodySmall.copyWith(
            color: IthakiTheme.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < pages.length; i++) ...[
                if (i > 0)
                  if (pages[i] - pages[i - 1] > 1) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        '...',
                        style: TextStyle(
                          fontSize: 15,
                          color: IthakiTheme.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ] else
                    const SizedBox(width: 6),
                _PageButton(page: pages[i], currentPage: currentPage),
              ],
              const SizedBox(width: 6),
              GestureDetector(
                onTap: currentPage < totalPages
                    ? () => notifier.nextPage(totalPages)
                    : null,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: IthakiTheme.borderLight),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: -1.5708,
                    child: const IthakiIcon(
                      'arrow-down',
                      size: 20,
                      color: IthakiTheme.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<int> _visiblePages(int currentPage, int totalPages) {
    if (totalPages <= 5) {
      return [for (int page = 1; page <= totalPages; page++) page];
    }

    final pages = <int>{1, totalPages};
    if (currentPage <= 3) {
      pages.addAll([2, 3]);
    } else if (currentPage >= totalPages - 2) {
      pages.addAll([totalPages - 2, totalPages - 1]);
    } else {
      pages.addAll([currentPage - 1, currentPage, currentPage + 1]);
    }

    return pages.toList()..sort();
  }
}

class _PageButton extends ConsumerWidget {
  final int page;
  final int currentPage;

  const _PageButton({required this.page, required this.currentPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = currentPage == page;
    return GestureDetector(
      onTap: () => ref.read(jobSearchProvider.notifier).changePage(page),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? IthakiTheme.primaryPurple : Colors.transparent,
          border:
              isSelected ? null : Border.all(color: IthakiTheme.borderLight),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          '$page',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? IthakiTheme.backgroundWhite
                : IthakiTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}

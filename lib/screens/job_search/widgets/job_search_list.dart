import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/job_search_data_provider.dart';
import '../../../providers/job_search_provider.dart';
import '../../../utils/match_colors.dart';
import '../sort_sheet.dart';

class JobSearchList extends ConsumerWidget {
  const JobSearchList({super.key});

  void _openSort(BuildContext context, WidgetRef ref) {
    final current = ref.read(jobSearchProvider).value?.sortOption ?? 'Date: Recent';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SortSheet(
        current: current,
        onSelect: (v) => ref.read(jobSearchProvider.notifier).setSort(v),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(jobSearchProvider.notifier);
    final searchState = ref.watch(jobSearchProvider).value;
    final searchResult = ref.watch(jobSearchDataProvider).value;
    if (searchState == null || searchResult == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final jobs = searchResult.jobs;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_fmt(searchResult.totalJobs)} jobs found',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => _openSort(context, ref),
                child: const Icon(Icons.sort,
                    size: 22, color: IthakiTheme.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Job cards ─────────────────────────────────────
          for (int i = 0; i < jobs.length; i++) ...[
            IthakiJobSearchCard(
              jobTitle: jobs[i].jobTitle,
              companyName: jobs[i].companyName,
              salary: jobs[i].salary,
              matchPercentage: jobs[i].matchPercentage,
              matchLabel: jobs[i].matchLabel,
              matchGradientColors: getMatchGradientColors(jobs[i].matchLabel),
              matchBackgroundColor: getMatchBgColor(jobs[i].matchLabel),
              category: jobs[i].category,
              location: jobs[i].location,
              workMode: jobs[i].workMode,
              employmentType: jobs[i].employmentType,
              level: jobs[i].level,
              postedAgo: jobs[i].postedAgo,
              isSaved: searchState.isSaved(jobs[i].id),
              onSave: () => notifier.toggleSaved(jobs[i].id),
              onView: () {},
            ),
            if (i < jobs.length - 1) const SizedBox(height: 12),
          ],

          const SizedBox(height: 16),
          const JobSearchPagination(),
        ],
      ),
    );
  }

  String _fmt(int number) {
    if (number < 1000) return '$number';
    final str = number.toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return buf.toString();
  }
}

class JobSearchPagination extends ConsumerWidget {
  const JobSearchPagination({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalPages = ref.watch(jobSearchDataProvider).value?.totalPages ?? 0;
    final currentPage = ref.watch(jobSearchProvider).value?.currentPage ?? 1;
    final notifier = ref.read(jobSearchProvider.notifier);

    final pages = <int>[];
    if (totalPages <= 5) {
      for (int i = 1; i <= totalPages; i++) {
        pages.add(i);
      }
    } else {
      pages.addAll([1, 2, 3]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final page in pages) ...[
          _PageButton(page: page, currentPage: currentPage),
          const SizedBox(width: 6),
        ],
        if (totalPages > 5) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('...',
                style: TextStyle(
                    fontSize: 15, color: IthakiTheme.textSecondary)),
          ),
          const SizedBox(width: 6),
          _PageButton(page: totalPages, currentPage: currentPage),
          const SizedBox(width: 6),
        ],
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
            child: const Icon(Icons.chevron_right,
                size: 20, color: IthakiTheme.textPrimary),
          ),
        ),
      ],
    );
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
            color: isSelected ? Colors.white : IthakiTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}

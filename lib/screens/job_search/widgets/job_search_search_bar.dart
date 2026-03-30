import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/job_search_provider.dart';
import '../filters_sheet.dart';

class JobSearchSearchBar extends ConsumerWidget {
  const JobSearchSearchBar({super.key});

  void _openFilters(BuildContext context, WidgetRef ref) {
    final filters = ref.read(jobSearchProvider).value?.filters ?? const {};
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FiltersSheet(
        filters: filters,
        onApply: (updated) =>
            ref.read(jobSearchProvider.notifier).applyFilters(updated),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count =
        ref.watch(jobSearchProvider).value?.activeFilterCount ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Search field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: IthakiTheme.lightGraphite),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search by job title',
                  hintStyle: TextStyle(color: IthakiTheme.softGraphite),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: IthakiIcon('search',
                        size: 20, color: IthakiTheme.lightGraphite),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Filters row
            GestureDetector(
              onTap: () => _openFilters(context, ref),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: count > 0
                      ? IthakiTheme.backgroundViolet
                      : IthakiTheme.backgroundWhite,
                  border: Border.all(
                    color: count > 0
                        ? const Color(0xFFDDD5F8)
                        : IthakiTheme.borderLight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    IthakiIcon(
                      'filter',
                      size: 18,
                      color: count > 0
                          ? IthakiTheme.primaryPurple
                          : IthakiTheme.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: count > 0
                              ? IthakiTheme.primaryPurple
                              : IthakiTheme.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: count > 0
                          ? IthakiTheme.primaryPurple
                          : IthakiTheme.softGraphite,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

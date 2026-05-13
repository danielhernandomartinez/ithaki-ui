import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/job_search_provider.dart';
import '../../../utils/ithaki_bottom_sheet.dart';
import '../filters_sheet.dart';

class JobSearchSearchBar extends ConsumerStatefulWidget {
  const JobSearchSearchBar({super.key});

  @override
  ConsumerState<JobSearchSearchBar> createState() => _JobSearchSearchBarState();
}

class _JobSearchSearchBarState extends ConsumerState<JobSearchSearchBar> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(jobSearchProvider.notifier).setQuery(value);
    });
  }

  void _openFilters(BuildContext context) {
    final filters = ref.read(jobSearchProvider).value?.filters ?? const {};
    showIthakiBottomSheet<void>(
      context: context,
      builder: (_) => FiltersSheet(
        filters: filters,
        onApply: (updated) =>
            ref.read(jobSearchProvider.notifier).applyFilters(updated),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final count = ref.watch(jobSearchProvider).value?.activeFilterCount ?? 0;

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
              child: TextField(
                controller: _controller,
                onChanged: _onQueryChanged,
                decoration: InputDecoration(
                  hintText: l.searchByJobTitle,
                  hintStyle: const TextStyle(color: IthakiTheme.softGraphite),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12),
                    child: IthakiIcon('search',
                        size: 20, color: IthakiTheme.lightGraphite),
                  ),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _controller,
                    builder: (_, value, __) => value.text.isEmpty
                        ? const SizedBox.shrink()
                        : IconButton(
                            icon: const Icon(Icons.close,
                                size: 18, color: IthakiTheme.softGraphite),
                            onPressed: () {
                              _controller.clear();
                              ref
                                  .read(jobSearchProvider.notifier)
                                  .setQuery('');
                            },
                          ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Filters row
            GestureDetector(
              onTap: () => _openFilters(context),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        count > 0
                            ? '${l.filtersTitle} ($count)'
                            : l.filtersTitle,
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

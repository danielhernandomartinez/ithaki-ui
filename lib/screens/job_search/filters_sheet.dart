import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../l10n/app_localizations.dart';
import '../../models/job_search_filters.dart';
import '../../utils/ithaki_bottom_sheet.dart';
import 'filter_sub_sheet.dart';
import 'location_filter_sheet.dart';
import 'salary_filter_sheet.dart';

const kFilterOptions = {
  JobSearchFilter.location: [
    'Athens',
    'Thessaloniki',
    'Remote',
    'Chalkida',
    'Patras'
  ],
  JobSearchFilter.industry: [
    'IT & Web Development',
    'Design & Creative',
    'Sales',
    'Marketing',
    'Customer Service',
    'Logistics',
    'Finance',
    'Healthcare'
  ],
  JobSearchFilter.skills: [
    'Flutter',
    'React',
    'Python',
    'Figma',
    'SQL',
    'Node.js',
    'Swift',
    'Kotlin'
  ],
  JobSearchFilter.jobType: [
    'Full-Time',
    'Part-Time',
    'Contract',
    'Freelance',
    'Internship'
  ],
  JobSearchFilter.workplace: ['On-site', 'Remote', 'Hybrid'],
  JobSearchFilter.experienceLevel: [
    'Entry',
    'Junior',
    'Mid-level',
    'Senior',
    'Lead'
  ],
  JobSearchFilter.salary: [
    '< 1 000 €',
    '1 000 – 2 000 €',
    '2 000 – 3 500 €',
    '3 500 – 5 000 €',
    '> 5 000 €'
  ],
  JobSearchFilter.travel: [
    'No travel',
    'Occasional',
    'Frequent',
    'International'
  ],
};

class FiltersSheet extends StatefulWidget {
  final Map<JobSearchFilter, Set<String>> filters;
  final void Function(Map<JobSearchFilter, Set<String>>) onApply;

  const FiltersSheet({super.key, required this.filters, required this.onApply});

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  late Map<JobSearchFilter, Set<String>> _local;

  @override
  void initState() {
    super.initState();
    _local = {for (final e in widget.filters.entries) e.key: Set.from(e.value)};
  }

  void _openSubSheet(JobSearchFilter filter) {
    final l = AppLocalizations.of(context)!;
    if (filter == JobSearchFilter.location) {
      showIthakiBottomSheet<void>(
        context: context,
        builder: (_) => LocationFilterSheet(
          selected: Set.from(_local[JobSearchFilter.location] ?? {}),
          onConfirm: (selected) =>
              setState(() => _local[JobSearchFilter.location] = selected),
        ),
      );
      return;
    }
    if (filter == JobSearchFilter.salary) {
      showIthakiBottomSheet<void>(
        context: context,
        builder: (_) => SalaryFilterSheet(
          selected: Set.from(_local[JobSearchFilter.salary] ?? {}),
          onConfirm: (selected) =>
              setState(() => _local[JobSearchFilter.salary] = selected),
        ),
      );
      return;
    }
    final options = kFilterOptions[filter] ?? [];
    showIthakiBottomSheet<void>(
      context: context,
      builder: (_) => FilterSubSheet(
        title: _filterLabel(l, filter),
        options: options,
        selected: Set.from(_local[filter] ?? {}),
        onConfirm: (selected) => setState(() => _local[filter] = selected),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l.filtersTitle,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary)),
                IconButton(
                  icon: const Icon(Icons.close,
                      size: 22, color: IthakiTheme.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // ── Filter rows ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: kFilterOptions.keys.map((filter) {
                final selected = _local[filter] ?? {};
                final hasSelection = selected.isNotEmpty;
                String valueText = selected.join('; ');
                if (filter == JobSearchFilter.salary && selected.isNotEmpty) {
                  final parts = selected.first.split('-');
                  if (parts.length == 2) {
                    String fmtNum(String n) {
                      final s = (int.tryParse(n) ?? 0).toString();
                      final buf = StringBuffer();
                      for (int i = 0; i < s.length; i++) {
                        if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
                        buf.write(s[i]);
                      }
                      return buf.toString();
                    }

                    valueText = '${fmtNum(parts[0])} – ${fmtNum(parts[1])} €';
                  }
                }
                return GestureDetector(
                  onTap: () => _openSubSheet(filter),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: hasSelection
                          ? IthakiTheme.backgroundViolet
                          : IthakiTheme.backgroundWhite,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: hasSelection
                              ? const Color(0xFFDDD5F8)
                              : IthakiTheme.placeholderBg),
                    ),
                    child: Row(children: [
                      Text(_filterLabel(l, filter),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: hasSelection
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: IthakiTheme.textPrimary)),
                      if (hasSelection) ...[
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            valueText,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14, color: IthakiTheme.textSecondary),
                          ),
                        ),
                      ] else
                        const Spacer(),
                      const Icon(Icons.chevron_right,
                          color: IthakiTheme.softGraphite, size: 20),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // ── Buttons ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      setState(() => _local.updateAll((_, __) => {})),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: Text(l.resetFilters),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: IthakiTheme.borderLight),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    foregroundColor: IthakiTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_local);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IthakiTheme.primaryPurple,
                    foregroundColor: IthakiTheme.backgroundWhite,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text(l.applyFilters,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  String _filterLabel(AppLocalizations l, JobSearchFilter filter) =>
      switch (filter) {
        JobSearchFilter.location => l.locationHeading,
        JobSearchFilter.industry => l.industryLabel,
        JobSearchFilter.skills => l.profileSkillsTitle,
        JobSearchFilter.jobType => l.jobTypeTitle,
        JobSearchFilter.workplace => l.workplaceLabel,
        JobSearchFilter.experienceLevel => l.experienceLevelLabel,
        JobSearchFilter.salary => l.salaryTitle,
        JobSearchFilter.travel => l.travelLabel,
      };
}

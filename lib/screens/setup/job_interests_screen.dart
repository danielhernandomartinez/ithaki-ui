import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/setup_provider.dart';

final _jobItems = [
  const SearchItem(id: 'accountant', label: 'Accountant', subtitle: 'Finance & Accounting'),
  const SearchItem(id: 'actor', label: 'Actor', subtitle: 'Entertainment'),
  const SearchItem(id: 'architect', label: 'Architect', subtitle: 'Construction'),
  const SearchItem(id: 'archivist', label: 'Archivist', subtitle: 'Information'),
  const SearchItem(id: 'attorney', label: 'Attorney', subtitle: 'Law & Legal Services'),
  const SearchItem(id: 'auditor', label: 'Auditor', subtitle: 'Finance & Accounting'),
  const SearchItem(id: 'web_developer', label: 'Web Developer', subtitle: 'IT & Development'),
  const SearchItem(id: 'welder', label: 'Welder', subtitle: 'Construction'),
  const SearchItem(id: 'wedding_planner', label: 'Wedding Planner', subtitle: 'Entertainment'),
  const SearchItem(id: 'web_designer', label: 'Web Designer', subtitle: 'IT & Development'),
  const SearchItem(id: 'weaver', label: 'Weaver', subtitle: 'Manufacturing'),
  const SearchItem(id: 'software_engineer', label: 'Software Engineer', subtitle: 'IT & Development'),
  const SearchItem(id: 'data_analyst', label: 'Data Analyst', subtitle: 'IT & Development'),
  const SearchItem(id: 'product_manager', label: 'Product Manager', subtitle: 'Management'),
  const SearchItem(id: 'ux_designer', label: 'UX Designer', subtitle: 'Design'),
];

class JobInterestsScreen extends ConsumerStatefulWidget {
  const JobInterestsScreen({super.key});

  @override
  ConsumerState<JobInterestsScreen> createState() => _JobInterestsScreenState();
}

class _JobInterestsScreenState extends ConsumerState<JobInterestsScreen> {
  final List<SearchItem> _selected = [];

  void _openJobSearch(AppLocalizations l) {
    if (_selected.length >= 5) return;
    final available = _jobItems.where((j) => !_selected.any((s) => s.id == j.id)).toList();
    SearchBottomSheet.show(
      context,
      l.selectJobInterest,
      available,
      (item) => setState(() => _selected.add(item)),
      searchHint: l.searchHint,
      selectLabel: l.selectAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return IthakiScreenLayout(
      appBar: const IthakiAppBar(showMenuAndAvatar: true),
      horizontalPadding: 0,
      verticalPadding: 8,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IthakiStepTabs(
                steps: [l.stepLocation, l.stepJobInterests, l.stepPreferences, l.stepValues, l.stepCommunication],
                currentIndex: 1,
                completedUpTo: 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.jobInterestsHeading, style: IthakiTheme.headingLarge),
                    const SizedBox(height: 8),
                    Text(
                      l.jobInterestsDescription,
                      style: IthakiTheme.bodyRegular,
                    ),
                    const SizedBox(height: 24),
                    ..._selected.map((job) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: IthakiJobCard(
                        title: job.label,
                        subtitle: job.subtitle,
                        onDelete: () => setState(() => _selected.removeWhere((j) => j.id == job.id)),
                      ),
                    )),
                    if (_selected.isEmpty)
                      GestureDetector(
                        onTap: () => _openJobSearch(l),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: IthakiTheme.borderLight),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(l.searchJobInterest, style: const TextStyle(fontSize: 14, color: IthakiTheme.softGraphite)),
                              ),
                              const IthakiIcon('arrow-down', size: 20, color: IthakiTheme.textSecondary),
                            ],
                          ),
                        ),
                      )
                    else if (_selected.length < 5)
                      GestureDetector(
                        onTap: () => _openJobSearch(l),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: IthakiTheme.textPrimary),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const IthakiIcon('plus', size: 14, color: IthakiTheme.textPrimary),
                              const SizedBox(width: 6),
                              Text(l.addAnotherJobInterest, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: IthakiTheme.textPrimary)),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 40),
                    IthakiButton(
                      l.continueButton,
                      onPressed: _selected.isNotEmpty
                          ? () {
                              ref.read(setupProvider.notifier).setJobInterests(
                                _selected.map((j) => JobInterest(id: j.id, label: j.label, subtitle: j.subtitle)).toList(),
                              );
                              context.push(Routes.setupPreferences);
                            }
                          : null,
                    ),
                    const SizedBox(height: 12),
                    IthakiButton(
                      l.backButton,
                      variant: IthakiButtonVariant.outline,
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}

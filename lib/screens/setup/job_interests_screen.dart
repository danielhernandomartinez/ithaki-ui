import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../models/profile_models.dart';
import '../../providers/reference_data_provider.dart';
import '../../providers/setup_provider.dart';
import 'widgets/setup_app_bar.dart';

class JobInterestsScreen extends ConsumerStatefulWidget {
  const JobInterestsScreen({super.key});

  @override
  ConsumerState<JobInterestsScreen> createState() => _JobInterestsScreenState();
}

class _JobInterestsScreenState extends ConsumerState<JobInterestsScreen> {
  final List<SearchItem> _selected = [];

  void _openJobSearch(AppLocalizations l, List<SearchItem> allItems) {
    if (_selected.length >= 5) return;
    if (allItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Job interests are still loading. Try again in a moment.')),
      );
      return;
    }
    final available =
        allItems.where((j) => !_selected.any((s) => s.id == j.id)).toList();
    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No more job interests available to add.')),
      );
      return;
    }
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
    final jobInterestsAsync = ref.watch(jobInterestsListProvider);
    final hasLoadError = jobInterestsAsync.hasError;
    final loadErrorText = jobInterestsAsync.error?.toString();
    final allItems = jobInterestsAsync.value
            ?.map((j) => SearchItem(
                  id: j.id.toString(),
                  label: j.title,
                  subtitle: j.category,
                ))
            .toList() ??
        const [];

    return IthakiScreenLayout(
      appBar: const SetupAppBar(),
      horizontalPadding: 0,
      verticalPadding: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IthakiStepTabs(
            steps: [
              l.stepLocation,
              l.stepJobInterests,
              l.stepPreferences,
              l.stepValues,
              l.stepCommunication
            ],
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
                if (hasLoadError) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: IthakiTheme.softGray,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: IthakiTheme.borderLight),
                    ),
                    child: Text(
                      loadErrorText ?? 'Failed to load job interests.',
                      style: IthakiTheme.captionRegular,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ..._selected.map((job) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: IthakiJobCard(
                        title: job.label,
                        subtitle: job.subtitle,
                        onDelete: () => setState(
                            () => _selected.removeWhere((j) => j.id == job.id)),
                      ),
                    )),
                if (_selected.isEmpty)
                  GestureDetector(
                    onTap: () => _openJobSearch(l, allItems),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: IthakiTheme.borderLight),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(l.searchJobInterest,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: IthakiTheme.softGraphite)),
                          ),
                          const IthakiIcon('arrow-down',
                              size: 20, color: IthakiTheme.textSecondary),
                        ],
                      ),
                    ),
                  )
                else if (_selected.length < 5)
                  GestureDetector(
                    onTap: () => _openJobSearch(l, allItems),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: IthakiTheme.textPrimary),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const IthakiIcon('plus',
                              size: 14, color: IthakiTheme.textPrimary),
                          const SizedBox(width: 6),
                          Text(l.addAnotherJobInterest,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: IthakiTheme.textPrimary)),
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
                                _selected
                                    .map((j) => JobInterest(
                                        id: j.id,
                                        title: j.label,
                                        category: j.subtitle))
                                    .toList(),
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

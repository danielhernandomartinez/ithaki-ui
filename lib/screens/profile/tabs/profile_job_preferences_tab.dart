import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';

class ProfileJobPreferencesTab extends ConsumerWidget {
  const ProfileJobPreferencesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final prefs = ref.watch(profileJobPreferencesProvider).value;
    if (prefs == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          l.editJobPreferencesTitle,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: IthakiTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          l.jobPreferencesTabDescription,
          style:
              const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 16),
        if (prefs.jobInterests.isNotEmpty) ...[
          Text(
            l.jobInterestsHeading,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          ...prefs.jobInterests.map(_jobInterestCard),
          const SizedBox(height: 8),
        ],
        Text(
          l.preferencesSectionTitle,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        _prefGrid(prefs, l),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.push(Routes.profileJobPreferences),
          icon: const IthakiIcon('edit-pencil', size: 16),
          label: Text(l.editJobsPreferences),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            foregroundColor: IthakiTheme.textPrimary,
          ),
        ),
      ]),
    );
  }

  Widget _jobInterestCard(JobInterest jobInterest) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        height: 78,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: IthakiTheme.softGray,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const IthakiIcon('rocket',
                size: 20, color: IthakiTheme.primaryPurple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(jobInterest.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary)),
                  Text(jobInterest.category,
                      style: const TextStyle(
                          fontSize: 13, color: IthakiTheme.textSecondary)),
                ]),
          ),
        ]),
      );

  Widget _prefGrid(ProfileJobPreferences prefs, AppLocalizations l) {
    final salary = prefs.preferNotToSpecifySalary
        ? l.notSpecified
        : prefs.expectedSalary != null
            ? '${prefs.expectedSalary!.toStringAsFixed(0)} € / month'
            : '—';
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Row(children: [
          Expanded(
              child: _prefCell('briefcase-work', l.workspaceLabel,
                  prefs.workplace.isNotEmpty ? prefs.workplace : '—')),
          const SizedBox(width: 10),
          Expanded(
              child: _prefCell('clock', l.jobTypeTitle,
                  prefs.jobType.isNotEmpty ? prefs.jobType : '—')),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(
              child: _prefCell('level', l.levelLabel,
                  prefs.positionLevel.isNotEmpty ? prefs.positionLevel : '—')),
          const SizedBox(width: 10),
          Expanded(child: _prefCell('bank-note', l.desiredSalaryLabel, salary)),
        ]),
      ]),
    );
  }

  Widget _prefCell(String iconName, String label, String value) =>
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        IthakiIcon(iconName, size: 20, color: IthakiTheme.softGraphite),
        const SizedBox(width: 8),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: IthakiTheme.textSecondary,
              ),
            ),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ]),
        ),
      ]);
}

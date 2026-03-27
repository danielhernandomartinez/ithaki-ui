import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';

class ProfileJobPreferencesTab extends ConsumerWidget {
  const ProfileJobPreferencesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(profileJobPreferencesProvider).value;
    if (prefs == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Job Preferences',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: IthakiTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'This shows the job you are currently looking for. You can change this anytime.',
          style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 16),
        if (prefs.jobInterests.isNotEmpty) ...[
          const Text(
            'Job Interests',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          ...prefs.jobInterests.map(_jobInterestCard),
          const SizedBox(height: 8),
        ],
        const Text(
          'Preferences',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        _prefGrid(prefs),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.push(Routes.profileJobPreferences),
          icon: const IthakiIcon('edit-pencil', size: 16),
          label: const Text('Edit Jobs Preferences'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
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
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const IthakiIcon('rocket', size: 20,
                color: IthakiTheme.primaryPurple),
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

  Widget _prefGrid(ProfileJobPreferences prefs) {
    final salary = prefs.preferNotToSpecifySalary
        ? 'Not specified'
        : prefs.expectedSalary != null
            ? '${prefs.expectedSalary!.toStringAsFixed(0)} € / month'
            : '—';
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Row(children: [
          Expanded(child: _prefCell('briefcase-work', 'Workspace',
              prefs.workplace.isNotEmpty ? prefs.workplace : '—')),
          const SizedBox(width: 10),
          Expanded(child: _prefCell('clock', 'Job Type',
              prefs.jobType.isNotEmpty ? prefs.jobType : '—')),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _prefCell('level', 'Level',
              prefs.positionLevel.isNotEmpty ? prefs.positionLevel : '—')),
          const SizedBox(width: 10),
          Expanded(child: _prefCell('bank-note', 'Desired Salary', salary)),
        ]),
      ]),
    );
  }

  Widget _prefCell(String iconName, String label, String value) =>
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        IthakiIcon(iconName, size: 20, color: IthakiTheme.softGraphite),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: IthakiTheme.textSecondary)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
        ]),
      ]);
}

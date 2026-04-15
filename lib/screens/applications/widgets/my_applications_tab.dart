import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/applications_models.dart';
import '../../../providers/applications_provider.dart';
import 'application_card.dart';
import 'tab_empty_state.dart';

/// Active applications: submitted, viewed, interview, offer, rejected.
/// Excludes drafts and archived entries.
class MyApplicationsTab extends ConsumerWidget {
  const MyApplicationsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final applicationsAsync = ref.watch(applicationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.myApplicationsTabDescription,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: IthakiTheme.textPrimary,
            letterSpacing: -0.32,
          ),
        ),
        applicationsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text(
              l.myApplicationsLoadError,
              style: TextStyle(color: IthakiTheme.textSecondary),
            ),
          ),
          data: (apps) {
            final active = apps
                .where((a) => !a.status.isDraft && !a.status.isArchived)
                .toList();
            if (active.isEmpty) {
              return TabEmptyState(
                iconName: 'applications',
                title: l.myApplicationsEmptyTitle,
                subtitle: l.myApplicationsEmptySubtitle,
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: active.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => ApplicationCard(application: active[i]),
            );
          },
        ),
      ],
    );
  }
}

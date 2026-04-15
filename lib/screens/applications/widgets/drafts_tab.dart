import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../models/applications_models.dart';
import '../../../providers/applications_provider.dart';
import 'application_card.dart';
import 'tab_empty_state.dart';

class DraftsTab extends ConsumerWidget {
  const DraftsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(applicationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Here you can find applications you started but haven't submitted yet. "
          'Continue where you left off or discard them.',
          style: TextStyle(
            fontFamily: 'Noto Sans',
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
          error: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Failed to load drafts.',
              style: TextStyle(color: IthakiTheme.textSecondary),
            ),
          ),
          data: (apps) {
            final drafts =
                apps.where((a) => a.status == ApplicationStatus.draft).toList();
            if (drafts.isEmpty) {
              return const TabEmptyState(
                iconName: 'edit-pencil',
                title: 'No drafts yet',
                subtitle:
                    'Applications you start but don\'t submit\nwill appear here.',
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: drafts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => ApplicationCard(application: drafts[i]),
            );
          },
        ),
      ],
    );
  }
}

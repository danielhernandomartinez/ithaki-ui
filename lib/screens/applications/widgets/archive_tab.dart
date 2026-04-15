import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../models/applications_models.dart';
import '../../../providers/applications_provider.dart';
import 'application_card.dart';
import 'invitation_card.dart';
import 'tab_empty_state.dart';

class ArchiveTab extends ConsumerWidget {
  const ArchiveTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(applicationsProvider);
    final invitationsAsync = ref.watch(invitationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Here you can find all declined invitations and closed applications. "
          "They're stored for your reference and can be viewed anytime.",
          style: TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: IthakiTheme.textPrimary,
            letterSpacing: -0.32,
          ),
        ),

        // ── Declined invitations ────────────────────────────────────────────
        invitationsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (invitations) {
            final declined =
                invitations.where((i) => i.isDismissed).toList();
            if (declined.isEmpty) return const SizedBox.shrink();
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: declined.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => InvitationCard(
                invitation: declined[i],
                isArchived: true,
                isDismissing: false,
                onDismissRequested: () {},
              ),
            );
          },
        ),

        // ── Closed applications ────────────────────────────────────────────
        applicationsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (apps) {
            final archived =
                apps.where((a) => a.status.isArchived).toList();
            if (archived.isEmpty) {
              final hasDeclined =
                  invitationsAsync.value?.any((i) => i.isDismissed) == true;
              if (hasDeclined) return const SizedBox.shrink();
              return const TabEmptyState(
                iconName: 'applications',
                title: 'Nothing in your archive',
                subtitle:
                    'Declined invitations and closed applications\nwill be stored here.',
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: archived.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => ApplicationCard(application: archived[i]),
            );
          },
        ),
      ],
    );
  }
}

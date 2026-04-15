import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../providers/applications_provider.dart';
import 'invitation_card.dart';
import 'tab_empty_state.dart';

class InvitationsTab extends ConsumerWidget {
  final String? pendingDismissId;
  final void Function(String) onDismissRequested;

  const InvitationsTab({
    super.key,
    required this.pendingDismissId,
    required this.onDismissRequested,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitationsAsync = ref.watch(invitationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Here you can find job opportunities you've been invited to explore. "
          'Review job invitations from employers or organizations who found your profile interesting.',
          style: TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: IthakiTheme.textPrimary,
            letterSpacing: -0.32,
          ),
        ),
        invitationsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'Failed to load invitations.',
              style: TextStyle(color: IthakiTheme.textSecondary),
            ),
          ),
          data: (invitations) {
            final active = invitations.where((i) => !i.isDismissed).toList();
            if (active.isEmpty) {
              return const TabEmptyState(
                iconName: 'envelope',
                title: 'No invitations yet',
                subtitle:
                    'When employers find your profile interesting\nthey will invite you here.',
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: active.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final inv = active[i];
                return InvitationCard(
                  invitation: inv,
                  isDismissing: pendingDismissId == inv.id,
                  onDismissRequested: () => onDismissRequested(inv.id),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

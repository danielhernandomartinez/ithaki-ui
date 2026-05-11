import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/applications_models.dart';
import '../../../providers/invitations_provider.dart'
    show invitationsProvider;

class DeclineInviteSheet extends ConsumerStatefulWidget {
  final String invitationId;
  const DeclineInviteSheet({super.key, required this.invitationId});

  @override
  ConsumerState<DeclineInviteSheet> createState() => _DeclineInviteSheetState();
}

class _DeclineInviteSheetState extends ConsumerState<DeclineInviteSheet> {
  String? _selectedReason;
  bool _declining = false;

  Future<void> _onDecline() async {
    if (_selectedReason == null || _declining) return;
    setState(() => _declining = true);
    await ref.read(invitationsProvider.notifier).dismiss(widget.invitationId);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final reasons = [
      l.declineReasonNotInterested,
      l.declineReasonFoundJob,
      l.declineReasonSalary,
      l.declineReasonLocation,
      l.declineReasonOther,
    ];

    final invitation = ref
        .watch(invitationsProvider)
        .value
        ?.where((i) => i.id == widget.invitationId)
        .firstOrNull;

    return Container(
      decoration: const BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(
        24, 20, 24, MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.declineSheetTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: IthakiTheme.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: const IthakiIcon('x-close', size: 20,
                    color: IthakiTheme.softGraphite),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l.declineSheetSubtitle,
            style: const TextStyle(
              fontSize: 14,
              color: IthakiTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          if (invitation != null) _InvitationPreview(invitation: invitation),
          const SizedBox(height: 16),
          Text(
            l.declineReasonLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: IthakiTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          _ReasonDropdown(
            value: _selectedReason,
            reasons: reasons,
            hint: l.declineReasonHint,
            enabled: !_declining,
            onChanged: (v) => setState(() => _selectedReason = v),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              _declining ? l.declinedButton : l.declineButton,
              onPressed:
                  (_selectedReason == null || _declining) ? null : _onDecline,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvitationPreview extends StatelessWidget {
  final Invitation invitation;
  const _InvitationPreview({required this.invitation});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _SenderAvatar(
              initials: invitation.senderInitials,
              color: invitation.senderAvatarColor,
              size: 44,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invitation.senderName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  invitation.companyName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: IthakiTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          invitation.message,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            color: IthakiTheme.textPrimary,
            height: 1.5,
            letterSpacing: -0.26,
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, thickness: 1, color: IthakiTheme.borderLight),
        const SizedBox(height: 10),
        Text(
          invitation.postedAgo,
          style: const TextStyle(fontSize: 12, color: IthakiTheme.softGraphite),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: invitation.companyLogoColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: IthakiTheme.borderLight),
              ),
              alignment: Alignment.center,
              child: Text(
                invitation.companyInitials,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: invitation.companyLogoColor,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invitation.jobTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    invitation.companyName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: IthakiTheme.softGraphite,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          invitation.salary,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: IthakiTheme.textPrimary,
            letterSpacing: -0.36,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: IthakiTheme.badgeLime,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            invitation.category,
            style: const TextStyle(fontSize: 13, color: IthakiTheme.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _SenderAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;
  const _SenderAvatar(
      {required this.initials, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.33,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _ReasonDropdown extends StatelessWidget {
  final String? value;
  final List<String> reasons;
  final String hint;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  const _ReasonDropdown({
    required this.value,
    required this.reasons,
    required this.hint,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          items: reasons
              .map((r) => DropdownMenuItem(
                    value: r,
                    child: Text(
                      r,
                      style: const TextStyle(
                        fontSize: 14,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
  }
}

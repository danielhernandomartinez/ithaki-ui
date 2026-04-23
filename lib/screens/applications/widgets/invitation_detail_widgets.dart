import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/applications_models.dart';
import '../../../providers/applications_provider.dart';

// ─── Invitation top card ──────────────────────────────────────────────────────

class InvitationTopCard extends StatelessWidget {
  final String senderInitials;
  final String senderName;
  final Color senderAvatarColor;
  final String companyName;
  final String message;
  final String deadline;

  const InvitationTopCard({
    super.key,
    required this.senderInitials,
    required this.senderName,
    required this.senderAvatarColor,
    required this.companyName,
    required this.message,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SenderAvatar(
                initials: senderInitials,
                color: senderAvatarColor,
                size: 40,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    senderName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary,
                      letterSpacing: -0.28,
                    ),
                  ),
                  Text(
                    companyName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: IthakiTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (message.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.28,
              ),
            ),
          ],
          if (deadline.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: IthakiTheme.accentPurpleLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const IthakiIcon('calendar', size: 16,
                      color: IthakiTheme.primaryPurple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      deadline,
                      style: const TextStyle(
                        fontSize: 13,
                        color: IthakiTheme.textPrimary,
                        letterSpacing: -0.26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Invitation sticky bar ────────────────────────────────────────────────────

class InvitationStickyBar extends StatelessWidget {
  final VoidCallback onAccept;
  final void Function(String) onMore;

  const InvitationStickyBar({
    super.key,
    required this.onAccept,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: IthakiTheme.borderLight.withValues(alpha: 0.9),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: IthakiButton(
                    l.acceptInviteAndApply,
                    onPressed: onAccept,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: IthakiTheme.backgroundWhite.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: IthakiTheme.borderLight),
                  ),
                  child: PopupMenuButton<String>(
                    onSelected: onMore,
                    icon: const IthakiIcon(
                      'help',
                      size: 20,
                      color: IthakiTheme.softGraphite,
                    ),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'decline',
                        child: Text(l.declineButton),
                      ),
                      PopupMenuItem(value: 'save', child: Text(l.viewJob)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Apply bottom sheet ───────────────────────────────────────────────────────

class ApplyBottomSheet extends StatelessWidget {
  const ApplyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(
        24, 16, 24, MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: IthakiTheme.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l.applySheetTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary,
                    letterSpacing: -0.36,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const IthakiIcon('close', size: 20,
                    color: IthakiTheme.softGraphite),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.applySheetSubtitle,
            style: const TextStyle(
              fontSize: 14,
              color: IthakiTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          _ApplyOption(
            title: l.applyOptionIthakiCvTitle,
            subtitle: l.applyOptionIthakiCvSubtitle,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ApplyOption(
            title: l.applyOptionUploadTitle,
            subtitle: l.applyOptionUploadSubtitle,
            onTap: () {},
          ),
          const SizedBox(height: 20),
          IthakiButton(l.applyNow, onPressed: () {}),
        ],
      ),
    );
  }
}

class _ApplyOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ApplyOption({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: IthakiTheme.softGray,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: IthakiTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Decline invite sheet ─────────────────────────────────────────────────────

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
    ref.read(invitationDeclinedProvider.notifier).set(true);
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
                child: const IthakiIcon('close', size: 20,
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

// ─── Shared sub-widgets ───────────────────────────────────────────────────────

class _SenderAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double size;
  const _SenderAvatar({
    required this.initials,
    required this.color,
    required this.size,
  });

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

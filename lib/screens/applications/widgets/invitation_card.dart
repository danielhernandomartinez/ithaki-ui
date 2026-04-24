import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../models/applications_models.dart';
import '../../../routes.dart';
import '../../../utils/match_colors.dart';

class InvitationCard extends ConsumerWidget {
  final Invitation invitation;
  final bool isDismissing;
  final bool isArchived;
  final VoidCallback onDismissRequested;

  const InvitationCard({
    super.key,
    required this.invitation,
    this.isDismissing = false,
    this.isArchived = false,
    required this.onDismissRequested,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isArchived)
            _ArchivedHeader(dismissedAt: invitation.dismissedAt)
          else
            _SenderHeader(invitation: invitation),
          if (!isArchived) ...[
            const SizedBox(height: 10),
            Text(
              invitation.message,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.28,
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(
              height: 1, thickness: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 12),
          _JobSection(invitation: invitation),
          if (!isArchived) ...[
            const SizedBox(height: 12),
            _ActionButtons(
              isDismissing: isDismissing,
              onDismiss: onDismissRequested,
              onViewJob: () =>
                  context.push(
                    Routes.invitationJobDetailFor(invitation.id),
                    extra: invitation,
                  ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: IthakiButton(
                AppLocalizations.of(context)!.viewJobDetails,
                variant: IthakiButtonVariant.outline,
                onPressed: () => context.push(
                  Routes.invitationJobDetailFor(invitation.id),
                  extra: invitation,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Archived header ────────────────────────────────────────────────────

class _ArchivedHeader extends StatelessWidget {
  final String dismissedAt;
  const _ArchivedHeader({required this.dismissedAt});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.invitationDeclinedLabel,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
            height: 1.5,
            letterSpacing: -0.32,
          ),
        ),
        if (dismissedAt.isNotEmpty)
          Text(
            dismissedAt,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              color: IthakiTheme.textSecondary,
            ),
          ),
      ],
    );
  }
}

// ─── Sender header ──────────────────────────────────────────────────────

class _SenderHeader extends StatelessWidget {
  final Invitation invitation;
  const _SenderHeader({required this.invitation});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: invitation.senderAvatarColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            invitation.senderInitials,
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: invitation.senderAvatarColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              invitation.senderName,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
                height: 1.4,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              invitation.companyName,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: IthakiTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Job section ──────────────────────────────────────────────────────────────

class _JobSection extends StatelessWidget {
  final Invitation invitation;
  const _JobSection({required this.invitation});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          invitation.postedAgo,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: IthakiTheme.softGraphite,
            height: 1.5,
            letterSpacing: -0.24,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CompanyLogo(invitation: invitation),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invitation.jobTitle,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: IthakiTheme.textPrimary,
                      height: 1.45,
                      letterSpacing: -0.36,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    invitation.companyName,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: IthakiTheme.softGraphite,
                      height: 1.4,
                      letterSpacing: -0.28,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1, color: IthakiTheme.borderLight),
        const SizedBox(height: 8),
        Text(
          invitation.salary,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
            height: 1.5,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 8),
        _MatchBadge(invitation: invitation),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1, color: IthakiTheme.borderLight),
        const SizedBox(height: 12),
        _CategoryTag(category: invitation.category),
        const SizedBox(height: 12),
        _DetailsGrid(invitation: invitation),
      ],
    );
  }
}

class _CompanyLogo extends StatelessWidget {
  final Invitation invitation;
  const _CompanyLogo({required this.invitation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: invitation.companyLogoColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      alignment: Alignment.center,
      child: Text(
        invitation.companyInitials,
        style: TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: invitation.companyLogoColor,
          letterSpacing: -0.4,
        ),
      ),
    );
  }
}

class _MatchBadge extends StatelessWidget {
  final Invitation invitation;
  const _MatchBadge({required this.invitation});

  @override
  Widget build(BuildContext context) {
    final bgColor = getMatchBgColor(invitation.matchLabel);
    final gradientColors = getMatchGradientColors(invitation.matchLabel);
    final pct = invitation.matchPercentage;

    return Container(
      width: double.infinity,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: bgColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const SizedBox.expand(),
          FractionallySizedBox(
            widthFactor: pct / 100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: gradientColors),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: IthakiTheme.backgroundWhite,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$pct%',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      invitation.matchLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final String category;
  const _CategoryTag({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: IthakiTheme.badgeLime,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: IthakiTheme.textPrimary,
          height: 1.45,
        ),
      ),
    );
  }
}

class _DetailsGrid extends StatelessWidget {
  final Invitation invitation;
  const _DetailsGrid({required this.invitation});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 12,
      children: [
        if (invitation.location.isNotEmpty)
          _DetailItem(icon: 'location', label: invitation.location),
        if (invitation.workplaceType.isNotEmpty)
          _DetailItem(icon: 'company-profile', label: invitation.workplaceType),
        if (invitation.employmentType.isNotEmpty)
          _DetailItem(icon: 'clock', label: invitation.employmentType),
        if (invitation.experienceLevel.isNotEmpty)
          _DetailItem(icon: 'level', label: invitation.experienceLevel),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String icon;
  final String label;
  const _DetailItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IthakiIcon(icon, size: 20, color: IthakiTheme.textPrimary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.32,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action buttons ───────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final bool isDismissing;
  final VoidCallback onDismiss;
  final VoidCallback onViewJob;

  const _ActionButtons({
    required this.isDismissing,
    required this.onDismiss,
    required this.onViewJob,
  });

  static const _spacing = 8.0;
  static const _minBtnWidth = 130.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final fitsInOneRow =
            constraints.maxWidth >= _minBtnWidth * 2 + _spacing;

        final leftButton = isDismissing
            ? IthakiButton(
                l.declinedConfirmed,
                variant: IthakiButtonVariant.outline,
                onPressed: null,
              )
            : IthakiButton(
                l.dismissInvite,
                variant: IthakiButtonVariant.outline,
                onPressed: onDismiss,
              );

        final primary = IthakiButton(
          l.viewJob,
          onPressed: onViewJob,
        );

        if (fitsInOneRow) {
          return Row(
            children: [
              Expanded(child: leftButton),
              const SizedBox(width: _spacing),
              Expanded(child: primary),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            leftButton,
            const SizedBox(height: _spacing),
            primary,
          ],
        );
      },
    );
  }
}

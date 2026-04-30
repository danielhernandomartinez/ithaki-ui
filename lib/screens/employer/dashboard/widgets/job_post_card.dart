import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../models/employer_dashboard_models.dart';

class JobPostCard extends StatelessWidget {
  final JobPost jobPost;
  final VoidCallback? onDetails;
  final VoidCallback? onAiMatcher;

  const JobPostCard({
    super.key,
    required this.jobPost,
    this.onDetails,
    this.onAiMatcher,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final day = jobPost.createdAt.day.toString().padLeft(2, '0');
    final month = jobPost.createdAt.month.toString().padLeft(2, '0');
    final year = jobPost.createdAt.year;
    final dateStr = '$day-$month-$year';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Metadata row ──────────────────────────────────────
        Row(
          children: [
            Text('Created at $dateStr', style: IthakiTheme.captionRegular),
            const Spacer(),
            if (jobPost.views > 0) ...[
              const IthakiIcon('eye',
                  size: 14, color: IthakiTheme.softGraphite),
              const SizedBox(width: 3),
              Text('${jobPost.views}',
                  style: IthakiTheme.captionRegular),
              const SizedBox(width: 8),
            ],
            if (jobPost.candidates > 0) ...[
              const IthakiIcon('resume',
                  size: 14, color: IthakiTheme.softGraphite),
              const SizedBox(width: 3),
              Text('${jobPost.candidates}',
                  style: IthakiTheme.captionRegular),
            ],
            if (jobPost.newCandidates > 0) ...[
              const SizedBox(width: 6),
              _Badge('+${jobPost.newCandidates}'),
            ],
          ],
        ),
        const SizedBox(height: 6),

        // ── Title ─────────────────────────────────────────────
        Text(jobPost.title, style: IthakiTheme.headingMedium),
        const SizedBox(height: 4),

        // ── Category + Salary ─────────────────────────────────
        Row(
          children: [
            Expanded(
              child: Text(
                jobPost.category,
                style: IthakiTheme.captionRegular,
              ),
            ),
            Text(jobPost.salary, style: IthakiTheme.bodySmallBold),
          ],
        ),
        const SizedBox(height: 10),

        // ── Status chip + optional boost expiry ───────────────
        Row(
          children: [
            _StatusChip(status: jobPost.status, l10n: l10n),
            if (jobPost.boostedUntil != null) ...[
              const Spacer(),
              Text(jobPost.boostedUntil!, style: IthakiTheme.captionRegular),
            ],
          ],
        ),
        const SizedBox(height: 12),

        const Divider(color: IthakiTheme.borderLight, height: 1),
        const SizedBox(height: 12),

        // ── Action buttons ────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: onDetails,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(color: IthakiTheme.lightGraphite),
                    foregroundColor: IthakiTheme.textPrimary,
                  ),
                  child: Text(l10n.jobActionDetails,
                      style: IthakiTheme.buttonLabel),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: onAiMatcher,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IthakiTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const IthakiIcon('ai', size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(l10n.jobActionAiMatcher,
                          style: IthakiTheme.buttonLabel),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: IthakiTheme.badgeLime,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: IthakiTheme.textPrimary,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final JobPostStatus status;
  final AppLocalizations l10n;

  const _StatusChip({required this.status, required this.l10n});

  ({Color bg, Color text}) get _style => switch (status) {
        JobPostStatus.published =>
          (bg: IthakiTheme.matchBarBg, text: IthakiTheme.matchGradientHighStart),
        JobPostStatus.boosted =>
          (bg: IthakiTheme.chipActive, text: IthakiTheme.primaryPurple),
        JobPostStatus.pendingApproval =>
          (bg: IthakiTheme.matchBgWeak, text: IthakiTheme.matchGradientWeakStart),
        _ => (bg: IthakiTheme.softGray, text: IthakiTheme.softGraphite),
      };

  String get _label => switch (status) {
        JobPostStatus.published => l10n.jobStatusPublished,
        JobPostStatus.boosted => l10n.jobStatusBoosted,
        JobPostStatus.paused => l10n.jobStatusPaused,
        JobPostStatus.draft => l10n.jobStatusDraft,
        JobPostStatus.closed => l10n.jobStatusClosed,
        JobPostStatus.expired => l10n.jobStatusExpired,
        JobPostStatus.pendingApproval => l10n.jobStatusPendingApproval,
      };

  PopupMenuItem<String> _currentItem(String label) => PopupMenuItem(
        value: '__current__',
        enabled: false,
        child: Row(
          children: [
            const IthakiIcon('check', size: 16, color: IthakiTheme.textPrimary),
            const SizedBox(width: 8),
            Text(label,
                style: IthakiTheme.bodySmallBold),
          ],
        ),
      );

  List<PopupMenuEntry<String>> _menuItems() => switch (status) {
        JobPostStatus.published => [
            _currentItem(l10n.jobStatusPublished),
            PopupMenuItem(value: 'boost', child: Text(l10n.jobActionBoost)),
            PopupMenuItem(value: 'pause', child: Text(l10n.jobActionPause)),
            PopupMenuItem(value: 'close', child: Text(l10n.jobActionClose)),
            PopupMenuItem(value: 'delete', child: Text(l10n.jobActionDelete)),
          ],
        JobPostStatus.boosted => [
            _currentItem(l10n.jobStatusBoosted),
            PopupMenuItem(value: 'pause', child: Text(l10n.jobActionPause)),
            PopupMenuItem(value: 'close', child: Text(l10n.jobActionClose)),
            PopupMenuItem(value: 'delete', child: Text(l10n.jobActionDelete)),
          ],
        JobPostStatus.paused ||
        JobPostStatus.expired ||
        JobPostStatus.closed =>
          [
            PopupMenuItem(
                value: 'publish', child: Text(l10n.jobActionPublishAgain)),
            PopupMenuItem(value: 'delete', child: Text(l10n.jobActionDelete)),
          ],
        JobPostStatus.draft => [
            PopupMenuItem(value: 'publish', child: Text(l10n.jobActionPublish)),
            PopupMenuItem(value: 'delete', child: Text(l10n.jobActionDelete)),
          ],
        _ => [
            PopupMenuItem(value: 'delete', child: Text(l10n.jobActionDelete)),
          ],
      };

  @override
  Widget build(BuildContext context) {
    final style = _style;

    return PopupMenuButton<String>(
      onSelected: (_) {},
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) => _menuItems(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: style.bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: style.text,
              ),
            ),
            const SizedBox(width: 4),
            IthakiIcon('arrow-down', size: 13, color: style.text),
          ],
        ),
      ),
    );
  }
}

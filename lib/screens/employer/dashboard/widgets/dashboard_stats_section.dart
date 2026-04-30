import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../models/employer_dashboard_models.dart';

class DashboardStatsSection extends StatelessWidget {
  final EmployerDashboardData data;
  final VoidCallback onToggleStats;

  const DashboardStatsSection({
    super.key,
    required this.data,
    required this.onToggleStats,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!data.showStats) {
      return GestureDetector(
        onTap: onToggleStats,
        child: Center(
          child: Text(
            l10n.dashboardStatPlaceholder,
            style: IthakiTheme.bodySmall.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: IthakiTheme.textPrimary,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatTile(
                label: l10n.dashboardActiveJobPosts,
                count: data.activeJobPostsCount,
                badge: data.activeJobPostsCount > 0
                    ? '+${data.activeJobPostsCount}'
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatTile(
                label: l10n.dashboardArchivedJobPosts,
                count: data.archivedJobPostsCount,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                label: l10n.dashboardApplications,
                count: data.applicationsCount,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _StatTile(
                label: l10n.dashboardInvitations,
                count: data.invitationsCount,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Center(
          child: TextButton(
            onPressed: onToggleStats,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              l10n.dashboardHideStats,
              style: IthakiTheme.bodySmall.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final int count;
  final String? badge;

  const _StatTile({
    required this.label,
    required this.count,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('$count', style: IthakiTheme.headingMedium),
              if (badge != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: IthakiTheme.badgeLime,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: IthakiTheme.captionRegular,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/job_detail_models.dart';
import '../../../routes.dart';
import '../../../utils/match_colors.dart';

class RecommendedJobsSection extends StatelessWidget {
  final List<RecommendedJob> jobs;
  const RecommendedJobsSection({super.key, required this.jobs});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.recommendedForYouLabel,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary,
            )),
        ...jobs.map((job) => Padding(
              padding: const EdgeInsets.only(top: 14),
              child: RecommendedJobTile(job: job),
            )),
      ]),
    );
  }
}

class RecommendedJobTile extends StatelessWidget {
  final RecommendedJob job;
  const RecommendedJobTile({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: job.companyColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: IthakiTheme.borderLight),
          ),
          alignment: Alignment.center,
          child: Text(job.companyInitials,
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: job.companyColor,
              )),
        ),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(job.jobTitle,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                )),
            Text(job.companyName,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 13,
                  color: IthakiTheme.softGraphite,
                )),
          ]),
        ),
      ]),
      const SizedBox(height: 10),
      Text(job.salary,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
          )),
      const SizedBox(height: 6),
      Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: getMatchBgColor(job.matchLabel),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(job.matchLabel,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              )),
        ),
        const SizedBox(width: 8),
        IthakiIcon('location', size: 15, color: IthakiTheme.softGraphite),
        const SizedBox(width: 4),
        Text(job.location,
            style:
                const TextStyle(fontSize: 13, color: IthakiTheme.softGraphite)),
        const SizedBox(width: 8),
        IthakiIcon('clock', size: 15, color: IthakiTheme.softGraphite),
        const SizedBox(width: 4),
        Text(job.employmentType,
            style:
                const TextStyle(fontSize: 13, color: IthakiTheme.softGraphite)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(
          child: IthakiButton(l.saveJob,
              variant: IthakiButtonVariant.outline,
              onPressed: () => context.go(Routes.jobSearch)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: IthakiButton(
            l.viewJob,
            onPressed: () => context.go(Routes.jobSearch),
          ),
        ),
      ]),
    ]);
  }
}

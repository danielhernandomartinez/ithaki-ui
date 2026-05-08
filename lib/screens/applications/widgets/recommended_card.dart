import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/job_detail_models.dart';
import '../../../routes.dart';
import '../../../utils/match_colors.dart';

class RecommendedCard extends StatelessWidget {
  final RecommendedJob job;
  const RecommendedCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.recommendedForYouLabel,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.36,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: job.companyColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: Text(job.companyInitials,
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: job.companyColor,
                    )),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(job.jobTitle,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary,
                          letterSpacing: -0.32,
                        )),
                    Text(job.companyName,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 13,
                          color: IthakiTheme.softGraphite,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(job.salary,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.36,
              )),
          const SizedBox(height: 8),
          IthakiMatchBar(
            percentage: job.matchPercentage,
            label: job.matchLabel,
            gradientColors: getMatchGradientColors(job.matchLabel),
            backgroundColor: getMatchBgColor(job.matchLabel),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IthakiIcon('location', size: 16, color: IthakiTheme.softGraphite),
              const SizedBox(width: 4),
              Text(job.location,
                  style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 14,
                      color: IthakiTheme.softGraphite)),
              const SizedBox(width: 12),
              IthakiIcon('clock', size: 16, color: IthakiTheme.softGraphite),
              const SizedBox(width: 4),
              Text(job.employmentType,
                  style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 14,
                      color: IthakiTheme.softGraphite)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: IthakiButton(AppLocalizations.of(context)!.saveJob,
                    variant: IthakiButtonVariant.outline,
                    onPressed: () => context.go(Routes.jobSearch)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: IthakiButton(
                  AppLocalizations.of(context)!.viewJob,
                  onPressed: () => context.go(Routes.jobSearch),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

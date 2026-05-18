import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/application_detail_models.dart';
import '../../../utils/localized_dates.dart';
import '../../../utils/match_colors.dart';

class JobPostBasicsCard extends StatelessWidget {
  final ApplicationDetail detail;
  const JobPostBasicsCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formatPostedDate(context, detail.postedDate),
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.textSecondary,
                letterSpacing: -0.28,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              _CompanyLogo(
                  color: detail.companyLogoColor,
                  initials: detail.companyLogoInitials,
                  size: 60),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(detail.jobTitle,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: IthakiTheme.textPrimary,
                          letterSpacing: -0.48,
                        )),
                    Text(detail.companyName,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          color: IthakiTheme.textPrimary,
                          letterSpacing: -0.32,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          IthakiMatchBar(
            percentage: detail.matchPercentage,
            label: detail.matchLabel,
            gradientColors: getMatchGradientColors(detail.matchLabel),
            backgroundColor: getMatchBgColor(detail.matchLabel),
          ),
          const SizedBox(height: 12),
          const Divider(
              height: 1, thickness: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 12),
          Wrap(
            spacing: 0,
            runSpacing: 12,
            children: [
              _DetailCell(
                  label: l.locationInfoLabel,
                  icon: 'location',
                  value: detail.location),
              _DetailCell(
                  label: l.jobTypeTitle, icon: 'clock', value: detail.jobType),
              _DetailCell(label: l.industryLabel, value: detail.industry),
              _DetailCell(
                  label: l.salaryRangeLabel,
                  value: detail.salaryRange,
                  valueSemibold: true),
              _DetailCell(
                  label: l.workplaceLabel,
                  icon: 'company-profile',
                  value: detail.workplace),
              _DetailCell(
                  label: l.experienceLevelLabel,
                  icon: 'level',
                  value: detail.experienceLevel),
              _DetailCell(
                  label: l.languageFieldLabel,
                  icon: 'globe',
                  value: detail.languages,
                  wide: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String label;
  final String? icon;
  final String value;
  final bool valueSemibold;
  final bool wide;

  const _DetailCell({
    required this.label,
    this.icon,
    required this.value,
    this.valueSemibold = false,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wide ? double.infinity : 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.textSecondary,
                letterSpacing: -0.28,
              )),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                IthakiIcon(icon!, size: 20, color: IthakiTheme.textPrimary),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(value,
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: valueSemibold ? 20 : 16,
                      fontWeight:
                          valueSemibold ? FontWeight.w600 : FontWeight.w400,
                      color: IthakiTheme.textPrimary,
                      letterSpacing: valueSemibold ? -0.4 : -0.32,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompanyLogo extends StatelessWidget {
  final Color color;
  final String initials;
  final double size;
  const _CompanyLogo(
      {required this.color, required this.initials, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      alignment: Alignment.center,
      child: Text(initials,
          style: TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: size * 0.3,
            fontWeight: FontWeight.w600,
            color: color,
          )),
    );
  }
}

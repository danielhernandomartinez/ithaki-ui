import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/company_models.dart';
import '../../../utils/match_colors.dart';
import 'company_cultural_match_card.dart';
import 'company_profile_atoms.dart';
import 'company_profile_styles.dart';
import 'company_surface_card.dart';

class CompanyVacanciesTab extends StatelessWidget {
  const CompanyVacanciesTab({
    super.key,
    required this.vacancies,
    required this.culturalMatch,
    required this.savedIds,
    required this.onToggleSave,
    required this.onView,
  });

  final List<CompanyVacancy> vacancies;
  final CulturalMatch? culturalMatch;
  final Set<String> savedIds;
  final void Function(String id) onToggleSave;
  final void Function(String id) onView;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (vacancies.isNotEmpty)
            Text(
              l10n.companyJobsFound(vacancies.length),
              style: companyProfileSectionHeaderStyle,
            ),
          const SizedBox(height: 12),
          if (vacancies.isEmpty)
            CompanyEmptyState(l10n.companyNoVacancies)
          else
            ...vacancies.map(
              (vacancy) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _VacancyCard(
                  vacancy: vacancy,
                  saved: savedIds.contains(vacancy.id),
                  onSave: () => onToggleSave(vacancy.id),
                  onView: () => onView(vacancy.id),
                ),
              ),
            ),
          if (culturalMatch != null) ...[
            const SizedBox(height: 8),
            CulturalMatchCard(match: culturalMatch!),
          ],
        ],
      ),
    );
  }
}

class _VacancyCard extends StatelessWidget {
  const _VacancyCard({
    required this.vacancy,
    required this.saved,
    required this.onSave,
    required this.onView,
  });

  final CompanyVacancy vacancy;
  final bool saved;
  final VoidCallback onSave;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return CompanySurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: IthakiTheme.borderLight),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vacancy.postedAgo, style: companyProfilePostMetaStyle),
            const SizedBox(height: 8),
            Row(
              children: [
                _StaticLogo(size: 72),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vacancy.jobTitle, style: companyProfileTitleStyle),
                      const SizedBox(height: 2),
                      const Text('TechWave', style: companyProfileBodyStyle),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: IthakiTheme.borderLight),
            const SizedBox(height: 12),
            Text(
              vacancy.salary.replaceAll('euro', '€'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            IthakiMatchBar(
              percentage: vacancy.matchPercentage,
              label: vacancy.matchLabel,
              gradientColors: getMatchGradientColors(vacancy.matchLabel),
              backgroundColor: getMatchBgColor(vacancy.matchLabel),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: IthakiTheme.matchBarBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                vacancy.category,
                style: companyProfileMetaValueStyle,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 18,
              runSpacing: 12,
              children: [
                CompanyInfoStat(icon: 'location', label: vacancy.location),
                CompanyInfoStat(
                    icon: 'company-profile', label: vacancy.workMode),
                CompanyInfoStat(icon: 'clock', label: vacancy.employmentType),
                CompanyInfoStat(
                    icon: 'level',
                    label: AppLocalizations.of(context)!.entryLevel),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onSave,
                    icon: IthakiIcon(
                      'bookmark',
                      size: 18,
                      color: saved
                          ? IthakiTheme.primaryPurple
                          : IthakiTheme.textPrimary,
                    ),
                    label: Text(AppLocalizations.of(context)!.saveJob),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: IthakiTheme.textPrimary,
                      side: const BorderSide(color: IthakiTheme.softGraphite),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: IthakiButton(
                    AppLocalizations.of(context)!.viewJob,
                    onPressed: onView,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StaticLogo extends StatelessWidget {
  const _StaticLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [IthakiTheme.primaryPurpleLight, IthakiTheme.primaryPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      alignment: Alignment.center,
      child: Text(
        'TW',
        style: TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: size * 0.32,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/company_models.dart';
import '../../../utils/match_colors.dart';
import 'company_profile_components.dart';

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

class CompanyAboutTab extends StatelessWidget {
  const CompanyAboutTab({super.key, required this.company});

  final CompanyProfile company;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (company.aboutText.isNotEmpty) ...[
            CompanySurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CompanySectionTitle(l10n.companyTabAboutCompany),
                  const SizedBox(height: 14),
                  Text(company.aboutText, style: companyProfileBodyStyle),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (company.perks.isNotEmpty) ...[
            CompanySurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CompanySectionTitle(l10n.companyPerksTitle),
                  const SizedBox(height: 14),
                  ...company.perks.map(CompanyBullet.new),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (company.galleryImageAssets.isNotEmpty) ...[
            CompanySurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CompanySectionTitle(l10n.companyGalleryTitle),
                  const SizedBox(height: 14),
                  CompanyGalleryGrid(imageAssets: company.galleryImageAssets),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (company.culturalMatch != null)
            CulturalMatchCard(match: company.culturalMatch!),
        ],
      ),
    );
  }
}

class CompanyEventsTab extends StatelessWidget {
  const CompanyEventsTab({
    super.key,
    required this.events,
    required this.company,
    required this.culturalMatch,
    required this.onOpenEvent,
  });

  final List<CompanyEvent> events;
  final CompanyProfile company;
  final CulturalMatch? culturalMatch;
  final void Function(String eventId) onOpenEvent;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (events.isEmpty)
            CompanyEmptyState(l10n.companyNoEvents)
          else ...[
            CompanySurfaceCard(
              child: CompanySectionTitle(l10n.companyEventsTitle),
            ),
            const SizedBox(height: 12),
            ...events.map(
              (event) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => onOpenEvent(event.id),
                  child: _EventCard(event: event, company: company),
                ),
              ),
            ),
          ],
          if (culturalMatch != null) ...[
            const SizedBox(height: 8),
            CulturalMatchCard(match: culturalMatch!),
          ],
        ],
      ),
    );
  }
}

class CompanyPostsTab extends StatelessWidget {
  const CompanyPostsTab({
    super.key,
    required this.posts,
    required this.company,
    required this.culturalMatch,
  });

  final List<CompanyPost> posts;
  final CompanyProfile company;
  final CulturalMatch? culturalMatch;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanySurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CompanySectionTitle(l10n.companyPostsTitle),
                const SizedBox(height: 18),
                Text(
                  l10n.companyPostsFound(posts.length),
                  style: companyProfileSectionHeaderStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (posts.isEmpty)
            CompanyEmptyState(l10n.companyNoPostsYet)
          else
            ...posts.map(
              (post) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _PostCard(post: post, company: company),
              ),
            ),
          if (culturalMatch != null) CulturalMatchCard(match: culturalMatch!),
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
                    icon: 'level', label: AppLocalizations.of(context)!.entryLevel),
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

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.company});

  final CompanyEvent event;
  final CompanyProfile company;

  @override
  Widget build(BuildContext context) {
    return CompanySurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompanyProfileLogo(company: company, size: 72),
              const SizedBox(width: 16),
              Expanded(
                child: Text(event.title, style: companyProfileTitleStyle),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 18,
            runSpacing: 12,
            children: [
              CompanyInfoStat(icon: 'calendar', label: event.date),
              if (event.time.isNotEmpty)
                CompanyInfoStat(icon: 'clock', label: event.time),
              if (event.location.isNotEmpty)
                CompanyInfoStat(icon: 'location', label: event.location),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 14),
          Text(event.description, style: companyProfileBodyStyle),
          const SizedBox(height: 12),
          if (event.imageAssets.isNotEmpty)
            Row(
              children: event.imageAssets
                  .map(
                    (asset) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          asset,
                          width: 91,
                          height: 82,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            )
          else
            const Row(
              children: [
                Expanded(
                  child: CompanyVisualPlaceholder(
                    title: 'Talks',
                    subtitle: 'Event media placeholder',
                    height: 82,
                    iconName: 'calendar',
                    borderRadius: 18,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: CompanyVisualPlaceholder(
                    title: 'Workshop',
                    subtitle: 'Event media placeholder',
                    height: 82,
                    iconName: 'assessment',
                    borderRadius: 18,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.company});

  final CompanyPost post;
  final CompanyProfile company;

  @override
  Widget build(BuildContext context) {
    return CompanySurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompanyProfileLogo(company: company, size: 60),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name, style: companyProfileCardTitleStyle),
                    const SizedBox(height: 2),
                    Text(post.postedAgo, style: companyProfilePostMetaStyle),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(post.content, style: companyProfileBodyStyle),
          const SizedBox(height: 16),
          if (post.imageAsset.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                post.imageAsset,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            const CompanyVisualPlaceholder(
              title: 'Post media',
              subtitle: 'Placeholder only',
              height: 180,
              iconName: 'blog',
              borderRadius: 24,
            ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const IthakiIcon(
                'share',
                size: 18,
                color: IthakiTheme.softGraphite,
              ),
              label: Text(AppLocalizations.of(context)!.shareButton),
              style: OutlinedButton.styleFrom(
                foregroundColor: IthakiTheme.textPrimary,
                side: const BorderSide(color: IthakiTheme.borderLight),
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
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

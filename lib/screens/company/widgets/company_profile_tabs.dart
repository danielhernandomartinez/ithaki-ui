import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (vacancies.isNotEmpty)
          Text(
            '${vacancies.length} job${vacancies.length == 1 ? '' : 's'} found',
            style: companyProfileSectionHeaderStyle,
          ),
        const SizedBox(height: 12),
        if (vacancies.isEmpty)
          const CompanyEmptyState('No open vacancies at this time.')
        else
          ...vacancies.map(
            (v) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: IthakiJobSearchCard(
                jobTitle: v.jobTitle,
                companyName: '',
                salary: v.salary,
                matchPercentage: v.matchPercentage,
                matchLabel: v.matchLabel,
                matchGradientColors: getMatchGradientColors(v.matchLabel),
                matchBackgroundColor: getMatchBgColor(v.matchLabel),
                category: v.category,
                location: v.location,
                workMode: v.workMode,
                employmentType: v.employmentType,
                postedAgo: v.postedAgo,
                isSaved: savedIds.contains(v.id),
                onSave: () => onToggleSave(v.id),
                onView: () => onView(v.id),
              ),
            ),
          ),
        if (culturalMatch != null) ...[
          const SizedBox(height: 8),
          CulturalMatchCard(match: culturalMatch!),
        ],
        const SizedBox(height: 16),
      ]),
    );
  }
}

class CompanyAboutTab extends StatelessWidget {
  const CompanyAboutTab({super.key, required this.company});

  final CompanyProfile company;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (company.aboutText.isNotEmpty) ...[
          CompanySurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CompanySectionTitle('About Company'),
                const SizedBox(height: 10),
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
                const CompanySectionTitle('Perks & Benefits'),
                const SizedBox(height: 10),
                ...company.perks.map((p) => CompanyBullet(p)),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (company.culturalMatch != null) ...[
          CulturalMatchCard(match: company.culturalMatch!),
          const SizedBox(height: 12),
        ],
      ]),
    );
  }
}

class CompanyEventsTab extends StatelessWidget {
  const CompanyEventsTab({
    super.key,
    required this.events,
    required this.company,
    required this.culturalMatch,
  });

  final List<CompanyEvent> events;
  final CompanyProfile company;
  final CulturalMatch? culturalMatch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (events.isEmpty)
          const CompanyEmptyState('No upcoming events.')
        else
          ...events.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => _openEvent(context, event, company),
                child: _EventCard(event: event, company: company),
              ),
            ),
          ),
        if (culturalMatch != null) ...[
          const SizedBox(height: 4),
          CulturalMatchCard(match: culturalMatch!),
        ],
        const SizedBox(height: 16),
      ]),
    );
  }

  void _openEvent(
    BuildContext context,
    CompanyEvent event,
    CompanyProfile company,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EventDetailSheet(event: event, company: company),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Company Posts', style: companyProfileTitleStyle),
        const SizedBox(height: 18),
        if (posts.isNotEmpty)
          Text(
            '${posts.length} posts found',
            style: companyProfileSectionHeaderStyle,
          ),
        const SizedBox(height: 12),
        if (posts.isEmpty)
          const CompanyEmptyState('No company posts yet.')
        else
          ...posts.map(
            (post) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _PostCard(post: post, company: company),
            ),
          ),
        if (culturalMatch != null) ...[
          const SizedBox(height: 4),
          CulturalMatchCard(match: culturalMatch!),
        ],
      ]),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyProfileLogo(company: company, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: companyProfileCardTitleStyle),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    CompanyInfoChip(icon: 'calendar', label: event.date),
                    if (event.time.isNotEmpty)
                      CompanyInfoChip(icon: 'clock', label: event.time),
                    if (event.location.isNotEmpty)
                      CompanyInfoChip(
                        icon: 'location',
                        label: event.location,
                      ),
                  ],
                ),
                if (event.description.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(event.description, style: companyProfileBodyStyle),
                ],
              ],
            ),
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
            children: [
              CompanyProfileLogo(company: company, size: 56),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(company.name, style: companyProfileCardTitleStyle),
                  Text(post.postedAgo, style: companyProfilePostMetaStyle),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(post.content, style: companyProfileBodyStyle),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post shared.')),
                );
              },
              icon: const IthakiIcon('rocket', size: 16),
              label: const Text('Share'),
              style: OutlinedButton.styleFrom(
                foregroundColor: IthakiTheme.textPrimary,
                side: const BorderSide(color: IthakiTheme.borderLight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventDetailSheet extends StatelessWidget {
  const _EventDetailSheet({required this.event, required this.company});

  final CompanyEvent event;
  final CompanyProfile company;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CompanyProfileLogo(company: company, size: 48),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(event.title, style: companyProfileTitleStyle),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CompanyInfoChip(icon: 'calendar', label: event.date),
                if (event.time.isNotEmpty)
                  CompanyInfoChip(icon: 'clock', label: event.time),
                if (event.location.isNotEmpty)
                  CompanyInfoChip(icon: 'location', label: event.location),
              ],
            ),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 16),
              const CompanySectionTitle('Event Details'),
              const SizedBox(height: 8),
              Text(event.description, style: companyProfileBodyStyle),
            ],
            if (event.address.isNotEmpty) ...[
              const SizedBox(height: 16),
              const CompanySectionTitle('Address'),
              const SizedBox(height: 6),
              Text(event.address, style: companyProfileBodyStyle),
            ],
            const SizedBox(height: 20),
            IthakiButton(
              'Register',
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registered for ${event.title}.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

const companyProfilePostMetaStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 13,
  color: IthakiTheme.textSecondary,
);

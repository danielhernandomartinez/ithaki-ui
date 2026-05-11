import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/company_models.dart';
import 'company_cultural_match_card.dart';
import 'company_profile_atoms.dart';
import 'company_profile_styles.dart';
import 'company_surface_card.dart';
import 'company_visual_placeholder.dart';

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

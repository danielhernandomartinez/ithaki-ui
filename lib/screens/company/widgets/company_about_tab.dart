import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/company_models.dart';
import 'company_cultural_match_card.dart';
import 'company_gallery_grid.dart';
import 'company_profile_atoms.dart';
import 'company_profile_styles.dart';
import 'company_surface_card.dart';

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

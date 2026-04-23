import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../models/company_models.dart';
import 'company_profile_components.dart';

class CompanyProfileHeader extends StatelessWidget {
  const CompanyProfileHeader({
    super.key,
    required this.company,
    required this.topOffset,
  });

  final CompanyProfile company;
  final double topOffset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topOffset, 16, 0),
      child: Column(
        children: [
          CompanyPlatformChip(label: company.platformDomain),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: AspectRatio(
              aspectRatio: 361 / 168,
              child: company.heroImageAsset.isNotEmpty
                  ? Image.asset(company.heroImageAsset, fit: BoxFit.cover)
                  : CompanyVisualPlaceholder(
                      title: company.name,
                      subtitle: 'Approved hero placeholder',
                      height: double.infinity,
                      iconName: 'company-profile',
                      borderRadius: 32,
                    ),
            ),
          ),
          const SizedBox(height: 12),
          CompanySurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompanyProfileLogo(company: company, size: 82),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(company.name, style: companyProfileTitleStyle),
                            const SizedBox(height: 4),
                            Text(
                              company.industry,
                              style: companyProfileHeroSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: IthakiTheme.borderLight),
                const SizedBox(height: 14),
                if (company.teamSize.isNotEmpty)
                  CompanyMetaBlock(
                    label: 'Team',
                    value: '${company.teamSize} employees',
                    iconName: 'team',
                  ),
                if (company.location.isNotEmpty)
                  CompanyMetaBlock(
                    label: 'Main Office Location',
                    value: company.location,
                    iconName: 'location',
                  ),
                CompanyMetaBlock(
                  label: 'Other Locations',
                  value: company.otherLocations.isEmpty
                      ? 'n/a'
                      : company.otherLocations,
                ),
                if (company.phone.isNotEmpty)
                  CompanyMetaBlock(
                    label: 'Contact Phone',
                    value: company.phone,
                  ),
                if (company.email.isNotEmpty)
                  CompanyMetaBlock(
                    label: 'Email',
                    value: company.email,
                  ),
                if (company.website.isNotEmpty)
                  CompanyMetaBlock(
                    label: 'Website',
                    value: company.website,
                    isLink: true,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

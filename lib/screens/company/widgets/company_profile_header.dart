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
    return Column(
      children: [
        Container(
          height: topOffset + 140,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                company.logoColor.withValues(alpha: 0.8),
                const Color(0xFF1A1030),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  CompanyProfileLogo(company: company, size: 64),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(company.name, style: companyProfileHeroTitleStyle),
                        Text(
                          company.industry,
                          style: companyProfileHeroSubtitleStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          color: IthakiTheme.backgroundWhite,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            children: [
              if (company.teamSize.isNotEmpty)
                CompanyProfileMetaRow(
                  icon: 'team',
                  label: 'Team',
                  value: '${company.teamSize} employees',
                ),
              if (company.location.isNotEmpty)
                CompanyProfileMetaRow(
                  icon: 'location',
                  label: 'Main Office',
                  value: company.location,
                ),
              if (company.phone.isNotEmpty)
                CompanyProfileMetaRow(
                  icon: 'phone',
                  label: 'Contact Phone',
                  value: company.phone,
                ),
              if (company.email.isNotEmpty)
                CompanyProfileMetaRow(
                  icon: 'envelope',
                  label: 'Email',
                  value: company.email,
                ),
              if (company.website.isNotEmpty)
                CompanyProfileMetaRow(
                  icon: 'eye',
                  label: 'Website',
                  value: company.website,
                  isLink: true,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

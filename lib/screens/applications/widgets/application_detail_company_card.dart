import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/application_detail_models.dart';
import '../../../routes.dart';

class ApplicationDetailCompanyCard extends StatelessWidget {
  final CompanyInfo company;
  const ApplicationDetailCompanyCard({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.aboutCompanyTitle,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.36,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              _CompanyLogo(
                  color: company.logoColor,
                  initials: company.logoInitials,
                  size: 64),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(company.name,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary,
                          letterSpacing: -0.32,
                        )),
                    Text(company.industry,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 14,
                          color: IthakiTheme.softGraphite,
                          letterSpacing: -0.28,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 12),
          _CompanyInfoRow(label: l.teamTitle, icon: 'team', value: company.teamSize),
          const SizedBox(height: 8),
          _CompanyInfoRow(label: l.locationInfoLabel, icon: 'location', value: company.location),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 12),
          Text(company.description,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.32,
              )),
          const SizedBox(height: 12),
          IthakiButton(l.companyProfile,
              variant: IthakiButtonVariant.outline,
              onPressed: company.id.isNotEmpty
                  ? () => context.push(Routes.companyProfileFor(company.id))
                  : null),
        ],
      ),
    );
  }
}

class _CompanyInfoRow extends StatelessWidget {
  final String label;
  final String icon;
  final String value;
  const _CompanyInfoRow(
      {required this.label, required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.textSecondary)),
        const SizedBox(height: 2),
        Row(children: [
          IthakiIcon(icon, size: 20, color: IthakiTheme.textPrimary),
          const SizedBox(width: 4),
          Text(value,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.32,
              )),
        ]),
      ],
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/job_detail_models.dart';
import '../../../routes.dart';

class JobDetailCompanyCard extends StatelessWidget {
  final JobDetailCompany company;
  const JobDetailCompanyCard({super.key, required this.company});

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
          Text(AppLocalizations.of(context)!.aboutCompanyTitle,
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
                  color: company.logoColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: Text(company.logoInitials,
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: company.logoColor,
                    )),
              ),
              const SizedBox(width: 10),
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
                          fontSize: 13,
                          color: IthakiTheme.softGraphite,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          Text(company.description,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 15,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.3,
              )),
          const SizedBox(height: 12),
          IthakiButton(AppLocalizations.of(context)!.companyProfile,
              variant: IthakiButtonVariant.outline,
              onPressed: company.id.isNotEmpty
                  ? () => context.push(Routes.companyProfileFor(company.id))
                  : null),
        ],
      ),
    );
  }
}

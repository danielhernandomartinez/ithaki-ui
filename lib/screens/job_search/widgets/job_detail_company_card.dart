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
    final l = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l.aboutCompanyTitle,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary,
            )),
        const SizedBox(height: 12),
        Row(children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: company.logoColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: IthakiTheme.borderLight),
            ),
            alignment: Alignment.center,
            child: Text(company.logoInitials,
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: company.logoColor,
                )),
          ),
          const SizedBox(width: 10),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(company.name,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary,
                  )),
              Text(company.industry,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 13,
                    color: IthakiTheme.softGraphite,
                  )),
            ]),
          ),
        ]),
        if (company.description.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          Text(company.description,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.textPrimary,
                height: 1.5,
              )),
        ],
        const SizedBox(height: 12),
        IthakiButton(l.companyProfile,
            variant: IthakiButtonVariant.outline,
            onPressed: company.id.isNotEmpty
                ? () => context.push(Routes.companyProfileFor(company.id))
                : null),
      ]),
    );
  }
}

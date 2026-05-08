import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../models/company_models.dart';
import 'company_profile_styles.dart';
import 'company_surface_card.dart';

class CompanyPlatformChip extends StatelessWidget {
  const CompanyPlatformChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        label,
        style: IthakiTheme.bodySmall.copyWith(
          color: IthakiTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class CompanyProfileLogo extends StatelessWidget {
  const CompanyProfileLogo({
    super.key,
    required this.company,
    required this.size,
  });

  final CompanyProfile company;
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
        company.logoInitials,
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

class CompanyMetaBlock extends StatelessWidget {
  const CompanyMetaBlock({
    super.key,
    required this.label,
    required this.value,
    this.iconName,
    this.isLink = false,
  });

  final String label;
  final String value;
  final String? iconName;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: companyProfileMetaLabelStyle),
          const SizedBox(height: 4),
          if (iconName == null)
            Text(
              value,
              style: companyProfileMetaValueStyle.copyWith(
                color: isLink
                    ? IthakiTheme.textSecondary
                    : IthakiTheme.textPrimary,
                decoration: isLink ? TextDecoration.underline : null,
                decorationColor: IthakiTheme.textSecondary,
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IthakiIcon(iconName!,
                    size: 18, color: IthakiTheme.softGraphite),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    value,
                    style: companyProfileMetaValueStyle.copyWith(
                      color: isLink
                          ? IthakiTheme.textSecondary
                          : IthakiTheme.textPrimary,
                      decoration: isLink ? TextDecoration.underline : null,
                      decorationColor: IthakiTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class CompanyTabChip extends StatelessWidget {
  const CompanyTabChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? IthakiTheme.backgroundWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: companyProfileTabStyle.copyWith(
            color:
                selected ? IthakiTheme.textPrimary : IthakiTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

class CompanyInfoStat extends StatelessWidget {
  const CompanyInfoStat({
    super.key,
    required this.icon,
    required this.label,
  });

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IthakiIcon(icon, size: 20, color: IthakiTheme.softGraphite),
        const SizedBox(width: 8),
        Text(label, style: companyProfileBodyStyle),
      ],
    );
  }
}

class CompanySectionTitle extends StatelessWidget {
  const CompanySectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: companyProfileSectionTitle);
}

class CompanyBullet extends StatelessWidget {
  const CompanyBullet(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child:
                Icon(Icons.circle, size: 6, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: companyProfileBodyStyle)),
        ],
      ),
    );
  }
}

class CompanyEmptyState extends StatelessWidget {
  const CompanyEmptyState(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return CompanySurfaceCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text(message, style: companyProfileBodyStyle)),
      ),
    );
  }
}

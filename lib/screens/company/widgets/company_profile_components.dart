import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../models/company_models.dart';

class CulturalMatchCard extends StatelessWidget {
  const CulturalMatchCard({super.key, required this.match});

  final CulturalMatch match;

  Color get _badgeColor {
    switch (match.label.toLowerCase()) {
      case 'high':
        return const Color(0xFF4ADE80);
      case 'medium':
        return const Color(0xFFFFB800);
      default:
        return IthakiTheme.softGraphite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompanySurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 112,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [_badgeColor, _badgeColor.withValues(alpha: 0.45)],
                ),
              ),
              child: Text(match.label, style: companyProfileMatchStyle),
            ),
          ),
          const SizedBox(height: 14),
          const CompanySectionTitle('Cultural Match Score'),
          const SizedBox(height: 12),
          const Text(
            'You and this company both chose your top 5 values and preferences. This score shows how closely they align.',
            style: companyProfileBodyStyle,
          ),
          if (match.sharedValues.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('You both care about:', style: companyProfileBodyStyle),
            const SizedBox(height: 6),
            ...match.sharedValues.map((value) => CompanyBullet(value)),
          ],
          if (match.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(match.description, style: companyProfileBodyStyle),
          ],
        ],
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
          colors: [Color(0xFFB8B6F2), Color(0xFF0B7BE8)],
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

class CompanyProfileMetaRow extends StatelessWidget {
  const CompanyProfileMetaRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isLink = false,
  });

  final String icon;
  final String label;
  final String value;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          IthakiIcon(icon, size: 16, color: IthakiTheme.softGraphite),
          const SizedBox(width: 8),
          Text('$label: ', style: companyProfileMetaLabelStyle),
          Expanded(
            child: Text(
              value,
              style: companyProfileMetaStyle.copyWith(
                color:
                    isLink ? IthakiTheme.primaryPurple : IthakiTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyInfoChip extends StatelessWidget {
  const CompanyInfoChip({super.key, required this.icon, required this.label});

  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IthakiIcon(icon, size: 14, color: IthakiTheme.softGraphite),
          const SizedBox(width: 6),
          Text(label, style: companyProfileMetaStyle),
        ],
      ),
    );
  }
}

class CompanySurfaceCard extends StatelessWidget {
  const CompanySurfaceCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

class CompanySectionTitle extends StatelessWidget {
  const CompanySectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: companyProfileTitleStyle);
}

class CompanyBullet extends StatelessWidget {
  const CompanyBullet(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '- ',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textPrimary),
          ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(message, style: companyProfileEmptyStyle),
      ),
    );
  }
}

class CompanyProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  const CompanyProfileTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(
      color: IthakiTheme.backgroundViolet,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: tabBar,
      ),
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height + 12;

  @override
  double get minExtent => tabBar.preferredSize.height + 12;

  @override
  bool shouldRebuild(CompanyProfileTabBarDelegate oldDelegate) =>
      oldDelegate.tabBar != tabBar;
}

const companyProfileHeroTitleStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 20,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);

const companyProfileHeroSubtitleStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 14,
  color: Colors.white70,
);

const companyProfileTabStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const companyProfileTitleStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: IthakiTheme.textPrimary,
);

const companyProfileCardTitleStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: IthakiTheme.textPrimary,
);

const companyProfileSectionHeaderStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 15,
  fontWeight: FontWeight.w600,
  color: IthakiTheme.textPrimary,
);

const companyProfileBodyStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 14,
  color: IthakiTheme.textPrimary,
  height: 1.5,
);

const companyProfileMetaStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 13,
  color: IthakiTheme.textPrimary,
);

const companyProfileMetaLabelStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 13,
  color: IthakiTheme.softGraphite,
);

const companyProfileEmptyStyle = TextStyle(color: IthakiTheme.textSecondary);

const companyProfileMatchStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 22,
  fontWeight: FontWeight.w700,
  color: IthakiTheme.textPrimary,
);

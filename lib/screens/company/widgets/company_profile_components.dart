import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../models/company_models.dart';

class CompanySurfaceCard extends StatelessWidget {
  const CompanySurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: child,
    );
  }
}

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

class CompanyVisualPlaceholder extends StatelessWidget {
  const CompanyVisualPlaceholder({
    super.key,
    required this.title,
    required this.subtitle,
    this.height = 160,
    this.iconName = 'company-profile',
    this.borderRadius = 24,
  });

  final String title;
  final String subtitle;
  final double height;
  final String iconName;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            IthakiTheme.primaryPurpleLight,
            IthakiTheme.backgroundWhite,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -24,
            right: -16,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: IthakiTheme.backgroundWhite.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -18,
            left: -8,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: IthakiTheme.primaryPurple.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: IthakiTheme.backgroundWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: IthakiTheme.borderLight),
                  ),
                  child: Center(
                    child: IthakiIcon(
                      iconName,
                      size: 24,
                      color: IthakiTheme.primaryPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(title, style: companyProfileCardTitleStyle),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: companyProfileBodyStyle.copyWith(
                      color: IthakiTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CompanyGalleryGrid extends StatelessWidget {
  const CompanyGalleryGrid({super.key, required this.imageAssets});

  final List<String> imageAssets;

  @override
  Widget build(BuildContext context) {
    if (imageAssets.length < 5) {
      return const _CompanyGalleryPlaceholderGrid();
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _CompanyImageTile(
                imageAsset: imageAssets[0],
                height: 154,
                borderRadius: 18,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _CompanyImageTile(
                imageAsset: imageAssets[1],
                height: 154,
                borderRadius: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: _CompanyImageTile(
                imageAsset: imageAssets[2],
                height: 90,
                borderRadius: 14,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _CompanyImageTile(
                imageAsset: imageAssets[3],
                height: 90,
                borderRadius: 14,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Stack(
                children: [
                  _CompanyImageTile(
                    imageAsset: imageAssets[4],
                    height: 90,
                    borderRadius: 14,
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Text(
                          '+10',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CulturalMatchCard extends StatelessWidget {
  const CulturalMatchCard({super.key, required this.match});

  final CulturalMatch match;

  @override
  Widget build(BuildContext context) {
    return CompanySurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: _CulturalMatchGauge(label: match.label),
          ),
          const SizedBox(height: 12),
          const Text('Cultural Match Score', style: companyProfileSectionTitle),
          const SizedBox(height: 14),
          const Text(
            'You and this company both chose your top 5\n'
            'values and preferences. This score shows how\n'
            'closely they align.',
            style: companyProfileBodyStyle,
          ),
          const SizedBox(height: 14),
          const Text('You both care about:', style: companyProfileBodyStyle),
          const SizedBox(height: 8),
          ...match.sharedValues.map(_CompanyMatchBullet.new),
          if (match.description.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(match.description, style: companyProfileBodyStyle),
          ],
        ],
      ),
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

class _CompanyImageTile extends StatelessWidget {
  const _CompanyImageTile({
    required this.imageAsset,
    required this.height,
    required this.borderRadius,
  });

  final String imageAsset;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (imageAsset.isEmpty) {
      return CompanyVisualPlaceholder(
        title: 'Workspace placeholder',
        subtitle: 'Replace with approved media later.',
        height: height,
        iconName: 'home',
        borderRadius: borderRadius,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        imageAsset,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _CompanyGalleryPlaceholderGrid extends StatelessWidget {
  const _CompanyGalleryPlaceholderGrid();

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(width: 4);
    return Column(
      children: const [
        Row(
          children: [
            Expanded(
              child: CompanyVisualPlaceholder(
                title: 'Office life',
                subtitle: 'Gallery placeholder',
                height: 154,
                iconName: 'team',
                borderRadius: 18,
              ),
            ),
            gap,
            Expanded(
              child: CompanyVisualPlaceholder(
                title: 'Team moments',
                subtitle: 'Gallery placeholder',
                height: 154,
                iconName: 'learning-hub',
                borderRadius: 18,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: CompanyVisualPlaceholder(
                title: 'Projects',
                subtitle: '',
                height: 90,
                iconName: 'assessment',
                borderRadius: 14,
              ),
            ),
            gap,
            Expanded(
              child: CompanyVisualPlaceholder(
                title: 'Events',
                subtitle: '',
                height: 90,
                iconName: 'calendar',
                borderRadius: 14,
              ),
            ),
            gap,
            Expanded(
              child: CompanyVisualPlaceholder(
                title: 'More',
                subtitle: '+10',
                height: 90,
                iconName: 'blog',
                borderRadius: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CulturalMatchGauge extends StatelessWidget {
  const _CulturalMatchGauge({required this.label});

  final String label;

  double get _value {
    switch (label.toLowerCase()) {
      case 'high':
        return 0.82;
      case 'medium':
        return 0.58;
      default:
        return 0.34;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 156,
            height: 156,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 14,
              backgroundColor: IthakiTheme.softGray,
              valueColor: const AlwaysStoppedAnimation<Color>(
                IthakiTheme.softGray,
              ),
            ),
          ),
          SizedBox(
            width: 156,
            height: 156,
            child: CircularProgressIndicator(
              value: _value,
              strokeWidth: 14,
              valueColor: const AlwaysStoppedAnimation<Color>(
                IthakiTheme.primaryPurple,
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const IthakiIcon(
                'team',
                size: 28,
                color: IthakiTheme.primaryPurple,
              ),
              const SizedBox(height: 10),
              Text(label, style: companyProfileTitleStyle),
              const SizedBox(height: 4),
              Text(
                'Shared values alignment',
                style: companyProfileBodyStyle.copyWith(
                  color: IthakiTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompanyMatchBullet extends StatelessWidget {
  const _CompanyMatchBullet(this.value);

  final String value;

  String get _emoji {
    final normalized = value.toLowerCase();
    if (normalized.contains('sustain')) return '🌱';
    if (normalized.contains('team')) return '🧑‍🤝‍🧑';
    if (normalized.contains('learn')) return '📚';
    return '•';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_emoji, style: companyProfileBodyStyle),
          const SizedBox(width: 6),
          Expanded(child: Text(value, style: companyProfileBodyStyle)),
        ],
      ),
    );
  }
}

const companyProfileTabStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const companyProfileHeroTitleStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: IthakiTheme.textPrimary,
);

const companyProfileHeroSubtitleStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: IthakiTheme.softGraphite,
);

const companyProfileTitleStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: IthakiTheme.textPrimary,
);

const companyProfileCardTitleStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 16,
  fontWeight: FontWeight.w700,
  color: IthakiTheme.textPrimary,
);

const companyProfileSectionHeaderStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 15,
  fontWeight: FontWeight.w700,
  color: IthakiTheme.textPrimary,
);

const companyProfileSectionTitle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 17,
  fontWeight: FontWeight.w700,
  color: IthakiTheme.textPrimary,
);

const companyProfileBodyStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 14,
  height: 1.5,
  color: IthakiTheme.textPrimary,
);

const companyProfileMetaLabelStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 12,
  color: IthakiTheme.textSecondary,
);

const companyProfileMetaValueStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 14,
  color: IthakiTheme.textPrimary,
);

const companyProfilePostMetaStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 13,
  color: IthakiTheme.textSecondary,
);

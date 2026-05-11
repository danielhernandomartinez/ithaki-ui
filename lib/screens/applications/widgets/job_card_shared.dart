import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../utils/match_colors.dart';

class JobCardCompanyLogo extends StatelessWidget {
  final String initials;
  final Color logoColor;

  const JobCardCompanyLogo({
    super.key,
    required this.initials,
    required this.logoColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: logoColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: logoColor,
          letterSpacing: -0.4,
        ),
      ),
    );
  }
}

class JobCardMatchBadge extends StatelessWidget {
  final int matchPercentage;
  final String matchLabel;

  const JobCardMatchBadge({
    super.key,
    required this.matchPercentage,
    required this.matchLabel,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = getMatchBgColor(matchLabel);
    final gradientColors = getMatchGradientColors(matchLabel);
    final pct = matchPercentage;

    return Container(
      width: double.infinity,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: bgColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const SizedBox.expand(),
          FractionallySizedBox(
            widthFactor: pct / 100,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: gradientColors),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: IthakiTheme.backgroundWhite,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$pct%',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      matchLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JobCardCategoryTag extends StatelessWidget {
  final String category;

  const JobCardCategoryTag({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: IthakiTheme.badgeLime,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: IthakiTheme.textPrimary,
          height: 1.45,
        ),
      ),
    );
  }
}

class JobCardDetailItem extends StatelessWidget {
  final String icon;
  final String label;

  const JobCardDetailItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IthakiIcon(icon, size: 20, color: IthakiTheme.textPrimary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.32,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

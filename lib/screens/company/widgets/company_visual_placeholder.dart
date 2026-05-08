import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import 'company_profile_styles.dart';

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
    final compact = height < 120;
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
            padding: EdgeInsets.all(compact ? 10 : 20),
            child: compact
                ? Row(
                    children: [
                      _PlaceholderIcon(
                        iconName: iconName,
                        size: 34,
                        iconSize: 18,
                        borderRadius: 12,
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: _PlaceholderText(title, subtitle)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _PlaceholderIcon(
                        iconName: iconName,
                        size: 48,
                        iconSize: 24,
                        borderRadius: 16,
                      ),
                      const SizedBox(height: 16),
                      _PlaceholderText(title, subtitle),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon({
    required this.iconName,
    required this.size,
    required this.iconSize,
    required this.borderRadius,
  });

  final String iconName;
  final double size;
  final double iconSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Center(
        child: IthakiIcon(
          iconName,
          size: iconSize,
          color: IthakiTheme.primaryPurple,
        ),
      ),
    );
  }
}

class _PlaceholderText extends StatelessWidget {
  const _PlaceholderText(this.title, this.subtitle);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: companyProfileCardTitleStyle,
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: companyProfileBodyStyle.copyWith(
              color: IthakiTheme.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

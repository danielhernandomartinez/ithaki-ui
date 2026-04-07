import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../models/applications_models.dart';
import '../../../routes.dart';
import '../../../utils/match_colors.dart';

class ApplicationCard extends StatelessWidget {
  final Application application;

  const ApplicationCard({
    super.key,
    required this.application,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AppliedHeader(application: application),
          const SizedBox(height: 10),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          _JobInfo(
            application: application,
            onViewApplication: () => context.push(
              Routes.applicationDetailFor(application.id),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppliedHeader extends StatelessWidget {
  final Application application;
  const _AppliedHeader({required this.application});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                application.appliedAt,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                  height: 1.5,
                  letterSpacing: -0.32,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _StatusBadge(label: application.status.label),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'You applied with your Ithaki CV',
          style: TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: IthakiTheme.textPrimary,
            height: 1.5,
            letterSpacing: -0.32,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  const _StatusBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9DEFF),
        borderRadius: BorderRadius.circular(16),
      ),
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
      ),
    );
  }
}

class _JobInfo extends StatelessWidget {
  final Application application;
  final VoidCallback? onViewApplication;
  const _JobInfo({required this.application, this.onViewApplication});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          application.postedAgo,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: IthakiTheme.softGraphite,
            height: 1.5,
            letterSpacing: -0.24,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CompanyLogo(application: application),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    application.jobTitle,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: IthakiTheme.textPrimary,
                      height: 1.45,
                      letterSpacing: -0.36,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    application.companyName,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: IthakiTheme.softGraphite,
                      height: 1.4,
                      letterSpacing: -0.28,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
        const SizedBox(height: 8),
        Text(
          application.salary,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: IthakiTheme.textPrimary,
            height: 1.5,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 8),
        _MatchBadge(application: application),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
        const SizedBox(height: 12),
        _CategoryTag(category: application.category),
        const SizedBox(height: 12),
        _DetailsGrid(application: application),
        const SizedBox(height: 12),
        _ActionButtons(
          applicationId: application.id,
          onViewApplication: onViewApplication,
        ),
      ],
    );
  }
}


class _CompanyLogo extends StatelessWidget {
  final Application application;
  const _CompanyLogo({required this.application});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: application.companyLogoColor.withValues(alpha:0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      alignment: Alignment.center,
      child: Text(
        application.companyInitials,
        style: TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: application.companyLogoColor,
          letterSpacing: -0.4,
        ),
      ),
    );
  }
}

class _MatchBadge extends StatelessWidget {
  final Application application;
  const _MatchBadge({required this.application});

  @override
  Widget build(BuildContext context) {
    final bgColor = getMatchBgColor(application.matchLabel);
    final gradientColors = getMatchGradientColors(application.matchLabel);
    final pct = application.matchPercentage;

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
                      color: Colors.white,
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
                      application.matchLabel,
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

class _CategoryTag extends StatelessWidget {
  final String category;
  const _CategoryTag({required this.category});

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

class _DetailsGrid extends StatelessWidget {
  final Application application;
  const _DetailsGrid({required this.application});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 12,
      children: [
        _DetailItem(icon: 'location', label: application.location),
        _DetailItem(icon: 'company-profile', label: application.workplaceType),
        _DetailItem(icon: 'clock', label: application.employmentType),
        _DetailItem(icon: 'level', label: application.experienceLevel),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String icon;
  final String label;
  const _DetailItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IthakiIcon(icon, size: 20, color: IthakiTheme.textPrimary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.32,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String applicationId;
  final VoidCallback? onViewApplication;
  const _ActionButtons({
    required this.applicationId,
    this.onViewApplication,
  });

  static const _spacing = 8.0;
  // minimum width each button needs before we wrap to two rows
  static const _minBtnWidth = 130.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fitsInOneRow =
            constraints.maxWidth >= _minBtnWidth * 2 + _spacing;

        final outline = IthakiButton(
          'View Job Details',
          variant: IthakiButtonVariant.outline,
          onPressed: () => context.push(Routes.jobDetailFor(applicationId)),
        );
        final primary = IthakiButton(
          'View Application',
          onPressed: onViewApplication ?? () {},
        );

        if (fitsInOneRow) {
          return Row(
            children: [
              Expanded(child: outline),
              const SizedBox(width: _spacing),
              Expanded(child: primary),
            ],
          );
        }

        // Two rows, each button full-width, centred
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            outline,
            const SizedBox(height: _spacing),
            primary,
          ],
        );
      },
    );
  }
}

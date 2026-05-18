import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/applications_models.dart';
import '../../../routes.dart';
import '../../../utils/localized_dates.dart';
import 'job_card_shared.dart';

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
          const Divider(
              height: 1, thickness: 1, color: IthakiTheme.borderLight),
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
    final isDraft = application.status.isDraft;
    final isArchived = application.status.isArchived;

    final l = AppLocalizations.of(context)!;
    String subtitle;
    if (isDraft) {
      subtitle = '';
    } else if (application.status == ApplicationStatus.closed) {
      subtitle = l.cardJobClosed;
    } else {
      subtitle = l.cardAppliedWithCv;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                formatAppliedAt(context, application.appliedAt),
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
            _StatusBadge(
              label: application.status.label,
              isArchived: isArchived,
            ),
          ],
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
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
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final bool isArchived;
  const _StatusBadge({required this.label, this.isArchived = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color:
            isArchived ? IthakiTheme.lightGray : IthakiTheme.accentPurpleLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color:
              isArchived ? IthakiTheme.textSecondary : IthakiTheme.textPrimary,
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
    final isDraft = application.status.isDraft;
    final isArchived = application.status.isArchived;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatPostedAgo(context, application.postedAgo),
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
            JobCardCompanyLogo(
              initials: application.companyInitials,
              logoColor: application.companyLogoColor,
            ),
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
        const Divider(height: 1, thickness: 1, color: IthakiTheme.borderLight),
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
        JobCardMatchBadge(
          matchPercentage: application.matchPercentage,
          matchLabel: application.matchLabel,
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 1, color: IthakiTheme.borderLight),
        const SizedBox(height: 12),
        JobCardCategoryTag(category: application.category),
        const SizedBox(height: 12),
        Wrap(
          spacing: 5,
          runSpacing: 12,
          children: [
            if (application.location.isNotEmpty)
              JobCardDetailItem(icon: 'location', label: application.location),
            if (application.workplaceType.isNotEmpty)
              JobCardDetailItem(
                  icon: 'company-profile', label: application.workplaceType),
            if (application.employmentType.isNotEmpty)
              JobCardDetailItem(
                  icon: 'clock', label: application.employmentType),
            if (application.experienceLevel.isNotEmpty)
              JobCardDetailItem(
                  icon: 'level', label: application.experienceLevel),
          ],
        ),
        const SizedBox(height: 12),
        _ActionButtons(
          application: application,
          applicationId: application.id,
          isDraft: isDraft,
          isArchived: isArchived,
          onViewApplication: onViewApplication,
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Application application;
  final String applicationId;
  final bool isDraft;
  final bool isArchived;
  final VoidCallback? onViewApplication;
  const _ActionButtons({
    required this.application,
    required this.applicationId,
    this.isDraft = false,
    this.isArchived = false,
    this.onViewApplication,
  });

  static const _spacing = 8.0;
  static const _minBtnWidth = 130.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fitsInOneRow =
            constraints.maxWidth >= _minBtnWidth * 2 + _spacing;

        final l = AppLocalizations.of(context)!;
        final outline = IthakiButton(
          l.viewJobDetails,
          variant: IthakiButtonVariant.outline,
          onPressed: () => context.push(
            Routes.jobDetailFor(applicationId),
            extra: application,
          ),
        );

        // Archived: only "View Job Details"
        if (isArchived) {
          return SizedBox(width: double.infinity, child: outline);
        }

        // Draft: "View Job Details" + "Continue"
        // Active: "View Job Details" + "View Application"
        final primary = isDraft
            ? IthakiButton(
                l.continueApplication,
                onPressed: () => context.push(
                  Routes.jobDetailFor(applicationId),
                  extra: application,
                ),
              )
            : IthakiButton(
                l.viewApplication,
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

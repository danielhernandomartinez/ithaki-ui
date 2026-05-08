import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/assessment_models.dart';
import '../../../models/profile_models.dart';
import 'cv_atoms.dart';

class CvExperienceCard extends StatelessWidget {
  const CvExperienceCard({
    super.key,
    required this.experience,
    required this.showEditButton,
    this.onEditPressed,
  });

  final WorkExperience experience;
  final bool showEditButton;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final endDate =
        experience.currentlyWorkHere ? l.present : experience.endDate ?? '';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 15,
                color: IthakiTheme.textPrimary,
                height: 1.35,
              ),
              text: l.experienceAtCompany(
                experience.jobTitle,
                experience.companyName,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l.periodWithDuration(
              experience.startDate,
              endDate,
              experience.duration,
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  CvMetaValue(
                    width: width,
                    icon: 'location',
                    value: experience.location,
                  ),
                  CvMetaValue(
                    width: width,
                    icon: 'jobs',
                    value: experience.workplace,
                  ),
                  CvMetaValue(
                    width: width,
                    icon: 'clock',
                    value: experience.jobType,
                  ),
                  CvMetaValue(
                    width: width,
                    icon: 'resume',
                    value: experience.experienceLevel,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 14),
          Text(
            experience.summary ?? '',
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: IthakiTheme.textPrimary,
            ),
          ),
          if (showEditButton && onEditPressed != null) ...[
            const SizedBox(height: 14),
            IthakiOutlineButton(
              l.editWorkExperience,
              icon: const IthakiIcon('edit-pencil', size: 18),
              onPressed: onEditPressed,
              borderRadius: 22,
            ),
          ],
        ],
      ),
    );
  }
}

class CvEducationCard extends StatelessWidget {
  const CvEducationCard({
    super.key,
    required this.education,
    required this.showEditButton,
    this.onEditPressed,
  });

  final Education education;
  final bool showEditButton;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final endDate =
        education.currentlyStudyHere ? l.present : education.endDate ?? '';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 15,
                color: IthakiTheme.textPrimary,
                height: 1.45,
              ),
              text: l.educationAtInstitution(
                education.fieldOfStudy,
                education.institutionName,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l.periodWithDuration(
              education.startDate,
              endDate,
              education.duration,
            ),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 14),
          CvMetaValue(
            width: double.infinity,
            icon: 'location',
            value: education.location,
          ),
          const SizedBox(height: 12),
          CvMetaValue(
            width: double.infinity,
            icon: 'resume',
            value: education.degreeType,
          ),
          if (showEditButton && onEditPressed != null) ...[
            const SizedBox(height: 14),
            IthakiOutlineButton(
              l.editEducation,
              icon: const IthakiIcon('edit-pencil', size: 18),
              onPressed: onEditPressed,
              borderRadius: 22,
            ),
          ],
        ],
      ),
    );
  }
}

class CvFileCard extends StatelessWidget {
  const CvFileCard({
    super.key,
    required this.file,
    required this.isPublished,
    this.onDelete,
  });

  final UploadedFile file;
  final bool isPublished;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: IthakiTheme.softGray.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'PDF',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.softGraphite,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      file.size,
                      style: const TextStyle(
                        fontSize: 13,
                        color: IthakiTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: IthakiOutlineButton(
                  l.open,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.openingFile(file.name))),
                    );
                  },
                  borderRadius: 22,
                ),
              ),
              if (!isPublished && onDelete != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: IthakiOutlineButton(
                    l.delete,
                    icon: const IthakiIcon('delete', size: 18),
                    onPressed: onDelete,
                    borderRadius: 22,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class CvAssessmentCard extends StatelessWidget {
  const CvAssessmentCard({
    super.key,
    required this.assessment,
    required this.onToggle,
  });

  final Assessment assessment;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final result = assessment.lastResult;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: IthakiTheme.primaryPurpleLight.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Center(
                  child: IthakiIcon(
                    assessment.iconName,
                    size: 22,
                    color: IthakiTheme.primaryPurple,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assessment.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.assessmentCategoryLabel(assessment.category),
                      style: const TextStyle(
                        fontSize: 14,
                        color: IthakiTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: IthakiTheme.primaryPurpleLight.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                result.level,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: IthakiOutlineButton(
                result.shownInCV
                    ? l.assessmentHideFromCV
                    : l.assessmentShowInCV,
                icon: const IthakiIcon('eye-closed', size: 18),
                onPressed: onToggle,
                borderRadius: 22,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

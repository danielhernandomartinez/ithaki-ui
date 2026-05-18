import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/profile_models.dart';
import 'cv_atoms.dart';

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

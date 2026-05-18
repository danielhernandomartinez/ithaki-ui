import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
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
                  CvMetaValue(width: width, icon: 'location', value: experience.location),
                  CvMetaValue(width: width, icon: 'jobs', value: experience.workplace),
                  CvMetaValue(width: width, icon: 'clock', value: experience.jobType),
                  CvMetaValue(width: width, icon: 'resume', value: experience.experienceLevel),
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

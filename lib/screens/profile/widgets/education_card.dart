import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../models/profile_models.dart';

class EducationCard extends StatelessWidget {
  final Education education;
  final VoidCallback onEditTap;

  const EducationCard({
    super.key,
    required this.education,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final duration = education.duration;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: IthakiTheme.bodyRegular.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary,
                    ),
                    children: [
                      TextSpan(text: education.fieldOfStudy),
                      TextSpan(
                        text: '  at  ',
                        style: IthakiTheme.bodyRegular.copyWith(
                          fontWeight: FontWeight.w400,
                          color: IthakiTheme.textSecondary,
                        ),
                      ),
                      TextSpan(text: education.institutionName),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onEditTap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: IthakiTheme.backgroundWhite,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: IthakiTheme.borderLight),
                  ),
                  child: const IthakiIcon(
                    'edit-pencil',
                    size: 16,
                    color: IthakiTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            [
              education.currentlyStudyHere
                  ? '${education.startDate} - Present'
                  : '${education.startDate} - ${education.endDate ?? ''}',
              if (duration.isNotEmpty) '($duration)',
            ].join(' '),
            style: IthakiTheme.bodySmall.copyWith(
              fontSize: 13,
              color: IthakiTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: IthakiTheme.placeholderBg),
          const SizedBox(height: 10),
          if (education.location.isNotEmpty)
            IthakiMetaCell(
              'location',
              education.location,
              alignIconTop: true,
            ),
          if (education.degreeType.isNotEmpty) ...[
            const SizedBox(height: 6),
            IthakiMetaCell(
              'book',
              education.degreeType,
              alignIconTop: true,
            ),
          ],
        ],
      ),
    );
  }
}

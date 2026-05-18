import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/assessment_models.dart';

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
                result.shownInCV ? l.assessmentHideFromCV : l.assessmentShowInCV,
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

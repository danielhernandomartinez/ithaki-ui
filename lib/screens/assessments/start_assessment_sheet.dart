import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/assessment_provider.dart';

class StartAssessmentSheet extends StatelessWidget {
  final Assessment assessment;
  final VoidCallback onStart;

  const StartAssessmentSheet(
      {super.key, required this.assessment, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.assessmentStartTitle,
                  style: IthakiTheme.headingMedium
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const IthakiIcon('x-close',
                    size: 22, color: IthakiTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l.assessmentStartSubtitle,
            style:
                IthakiTheme.bodySmall.copyWith(color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: IthakiTheme.borderLight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: IthakiTheme.accentPurpleLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: IthakiIcon(assessment.iconName,
                            size: 22, color: IthakiTheme.primaryPurple),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(assessment.title,
                              style: IthakiTheme.bodySmallSemiBold),
                          Text(
                            assessment.category,
                            style: IthakiTheme.bodySmall
                                .copyWith(color: IthakiTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    _MetaItem(
                      icon: 'clock',
                      label: l.assessmentApproxDuration,
                      value: l.durationMinutes(assessment.durationMinutes),
                    ),
                    const SizedBox(width: 24),
                    _MetaItem(
                      icon: 'assessment',
                      label: l.assessmentQuestionsLabel,
                      value: l.questionsCount(assessment.questionCount),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _MetaItem(
                  icon: 'flag',
                  label: l.languageFieldLabel,
                  value: assessment.language,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(l.assessmentBeforeStart, style: IthakiTheme.bodySmallSemiBold),
          const SizedBox(height: 8),
          ...assessment.beforeYouStart.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 8),
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: IthakiTheme.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: IthakiTheme.bodySmall
                          .copyWith(color: IthakiTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          IthakiButton(l.assessmentStartNow, onPressed: onStart),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _MetaItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: IthakiTheme.bodySmall
              .copyWith(color: IthakiTheme.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            IthakiIcon(icon, size: 14, color: IthakiTheme.textSecondary),
            const SizedBox(width: 4),
            Text(value, style: IthakiTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}

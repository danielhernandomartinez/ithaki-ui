// lib/widgets/assessment_card.dart
import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../l10n/app_localizations.dart';
import '../models/assessment_models.dart';

class AssessmentCard extends StatelessWidget {
  final Assessment assessment;
  final VoidCallback? onTestDetails;
  final VoidCallback? onStartTest;
  final VoidCallback? onContinue;
  final VoidCallback? onViewDetails;
  final VoidCallback? onShowInCV;

  const AssessmentCard({
    super.key,
    required this.assessment,
    this.onTestDetails,
    this.onStartTest,
    this.onContinue,
    this.onViewDetails,
    this.onShowInCV,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(assessment: assessment),
          const SizedBox(height: 8),
          Text(
            assessment.description,
            style: IthakiTheme.bodySmall.copyWith(color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          _Meta(assessment: assessment),
          if (assessment.status == AssessmentStatus.completed &&
              assessment.lastResult != null) ...[
            const SizedBox(height: 12),
            _ScoreRow(result: assessment.lastResult!),
          ],
          const SizedBox(height: 12),
          _Actions(
            assessment: assessment,
            onTestDetails: onTestDetails,
            onStartTest: onStartTest,
            onContinue: onContinue,
            onViewDetails: onViewDetails,
            onShowInCV: onShowInCV,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Assessment assessment;
  const _Header({required this.assessment});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(assessment.category,
                  style: IthakiTheme.bodySmall
                      .copyWith(color: IthakiTheme.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  final Assessment assessment;
  const _Meta({required this.assessment});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Row(
      children: [
        Text(l.questionsCount(assessment.questionCount),
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary)),
        const SizedBox(width: 16),
        Text(l.durationMinutes(assessment.durationMinutes),
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary)),
      ],
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final AssessmentResult result;
  const _ScoreRow({required this.result});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Row(
      children: [
        Text(l.assessmentYourScore,
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary)),
        const Spacer(),
        Text('${result.score}/${result.maxScore}',
            style: IthakiTheme.bodySmallBold),
      ],
    );
  }
}

class _Actions extends StatelessWidget {
  final Assessment assessment;
  final VoidCallback? onTestDetails;
  final VoidCallback? onStartTest;
  final VoidCallback? onContinue;
  final VoidCallback? onViewDetails;
  final VoidCallback? onShowInCV;

  const _Actions({
    required this.assessment,
    this.onTestDetails,
    this.onStartTest,
    this.onContinue,
    this.onViewDetails,
    this.onShowInCV,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return switch (assessment.status) {
      AssessmentStatus.notStarted => Row(
          children: [
            Expanded(
              child: IthakiOutlineButton(
                l.testDetails,
                onPressed: onTestDetails,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: IthakiButton(l.startTest, onPressed: onStartTest),
            ),
          ],
        ),
      AssessmentStatus.inProgress => Row(
          children: [
            Expanded(
              child: IthakiOutlineButton(
                l.testDetails,
                onPressed: onTestDetails,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: IthakiButton(l.continueButton, onPressed: onContinue),
            ),
          ],
        ),
      AssessmentStatus.completed => Row(
          children: [
            Expanded(
              child: IthakiOutlineButton(
                l.viewDetails,
                onPressed: onViewDetails,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: IthakiButton(
                assessment.lastResult?.shownInCV == true
                    ? l.inCv
                    : l.showInCv,
                onPressed: onShowInCV,
              ),
            ),
          ],
        ),
    };
  }
}

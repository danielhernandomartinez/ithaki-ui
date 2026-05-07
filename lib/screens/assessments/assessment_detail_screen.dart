// lib/screens/assessments/assessment_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/assessment_provider.dart';
import '../../routes.dart';

class AssessmentDetailScreen extends ConsumerWidget {
  final String assessmentId;
  const AssessmentDetailScreen({super.key, required this.assessmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final assessmentsAsync = ref.watch(assessmentsListProvider);

    return assessmentsAsync.when(
      loading: () => Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        appBar: IthakiAppBar(showBackButton: true),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        appBar: IthakiAppBar(showBackButton: true),
        body: Center(child: Text(l.errorMessage(e.toString()))),
      ),
      data: (assessments) {
        final assessment =
            assessments.where((a) => a.id == assessmentId).firstOrNull;
        if (assessment == null) {
          return Scaffold(
            backgroundColor: IthakiTheme.backgroundViolet,
            appBar: IthakiAppBar(showBackButton: true),
            body: Center(child: Text(l.assessmentNotFound)),
          );
        }
        return _DetailBody(assessment: assessment);
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  final Assessment assessment;
  const _DetailBody({required this.assessment});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: l.appBarTitleIthaki),
      body: IthakiScreenLayout(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Icon + title + category
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: IthakiTheme.accentPurpleLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: IthakiIcon(assessment.iconName,
                          size: 26, color: IthakiTheme.primaryPurple),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(assessment.title,
                            style: IthakiTheme.headingMedium
                                .copyWith(fontWeight: FontWeight.w700)),
                        Text(assessment.category,
                            style: IthakiTheme.captionRegular
                                .copyWith(color: IthakiTheme.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _MetaRow(assessment: assessment),
              const SizedBox(height: 20),
              Text(l.assessmentAboutThis,
                  style: IthakiTheme.bodyRegular
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(assessment.description,
                  style: IthakiTheme.bodyRegular
                      .copyWith(color: IthakiTheme.textSecondary)),
              if (assessment.usedFor.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(l.assessmentUsedFor,
                    style: IthakiTheme.bodyRegular
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...assessment.usedFor.map(_buildBullet),
              ],
              if (assessment.beforeYouStart.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(l.assessmentBeforeStart,
                    style: IthakiTheme.bodyRegular
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...assessment.beforeYouStart.map(_buildBullet),
              ],
              const SizedBox(height: 28),
              IthakiButton(
                l.assessmentStartNow,
                onPressed: () =>
                    context.push(Routes.assessmentQuizFor(assessment.id)),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: IthakiTheme.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(text,
                style: IthakiTheme.bodyRegular
                    .copyWith(color: IthakiTheme.textSecondary)),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final Assessment assessment;
  const _MetaRow({required this.assessment});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Row(
        children: [
          _MetaItem(
            iconName: 'clock',
            label: l.assessmentApproxDuration,
            value: l.durationMinutes(assessment.durationMinutes),
          ),
          _MetaDivider(),
          _MetaItem(
            iconName: 'assessment',
            label: l.assessmentQuestionsLabel,
            value: '${assessment.questionCount}',
          ),
          _MetaDivider(),
          _MetaItem(
            iconName: 'flag',
            label: l.assessmentLevel,
            value: assessment.language,
          ),
        ],
      ),
    );
  }
}

class _MetaDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      width: 1,
      height: 36,
      color: IthakiTheme.borderLight,
      margin: const EdgeInsets.symmetric(horizontal: 12));
}

class _MetaItem extends StatelessWidget {
  final String iconName;
  final String label;
  final String value;

  const _MetaItem(
      {required this.iconName, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: IthakiTheme.captionRegular
                  .copyWith(color: IthakiTheme.textSecondary)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IthakiIcon(iconName, size: 14, color: IthakiTheme.textSecondary),
              const SizedBox(width: 4),
              Text(value, style: IthakiTheme.captionRegular),
            ],
          ),
        ],
      ),
    );
  }
}

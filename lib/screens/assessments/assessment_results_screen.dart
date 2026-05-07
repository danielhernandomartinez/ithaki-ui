// lib/screens/assessments/assessment_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/assessment_provider.dart';
import '../../routes.dart';
import '../../widgets/assessment_card.dart';

String _formatDate(DateTime dt) {
  const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  return '${dt.day.toString().padLeft(2,'0')}-${months[dt.month-1]}-${dt.year}';
}

String _formatMonthYear(DateTime dt) {
  const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  return '${months[dt.month-1]} ${dt.year}';
}

class AssessmentResultsScreen extends ConsumerWidget {
  final String assessmentId;
  const AssessmentResultsScreen({super.key, required this.assessmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final resultAsync = ref.watch(assessmentResultProvider(assessmentId));
    final assessmentsAsync = ref.watch(assessmentsListProvider);

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: l.appBarTitleIthaki),
      body: resultAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorMessage(e.toString()))),
        data: (result) {
          if (result == null) {
            return Center(child: Text(l.quizNoResults));
          }

          final assessments = assessmentsAsync.value ?? [];
          final assessment =
              assessments.where((a) => a.id == assessmentId).firstOrNull;
          final recommended = assessments
              .where((a) =>
                  a.status == AssessmentStatus.notStarted &&
                  a.id != assessmentId)
              .take(2)
              .toList();

          return IthakiScreenLayout(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (assessment != null)
                    _AssessmentHeader(assessment: assessment, result: result),
                  const SizedBox(height: 20),
                  _ScoreCard(result: result),
                  if (result.skillBreakdowns.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _SkillBreakdownSection(result: result),
                  ],
                  if (result.keyInsights.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _KeyInsightsSection(result: result),
                  ],
                  if (result.previousResults.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _PreviousResultsSection(result: result),
                  ],
                  if (recommended.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(l.assessmentsRecommendedForYou,
                        style: IthakiTheme.bodySmall
                            .copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      l.assessmentsRecommendedSubtitle,
                      style: IthakiTheme.bodySmall
                          .copyWith(color: IthakiTheme.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    ...recommended.map((a) => AssessmentCard(
                          assessment: a,
                          onTestDetails: () =>
                              context.push(Routes.assessmentDetailFor(a.id)),
                          onStartTest: () =>
                              context.push(Routes.assessmentQuizFor(a.id)),
                        )),
                  ],
                  const SizedBox(height: 20),
                  _ProfileSection(
                    result: result,
                    onToggle: (show) => ref
                        .read(assessmentResultProvider(assessmentId).notifier)
                        .toggleCV(show: show),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AssessmentHeader extends StatelessWidget {
  final Assessment assessment;
  final AssessmentResult result;
  const _AssessmentHeader({required this.assessment, required this.result});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Row(
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
                  style: IthakiTheme.bodySmall
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 16)),
              Text(assessment.category,
                  style: IthakiTheme.bodySmall
                      .copyWith(color: IthakiTheme.textSecondary)),
              Text(
                l.assessmentTakenLabel(_formatDate(result.takenAt)),
                style: IthakiTheme.bodySmall
                    .copyWith(color: IthakiTheme.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final AssessmentResult result;
  const _ScoreCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.assessmentYourScore,
                    style: IthakiTheme.bodySmall
                        .copyWith(color: IthakiTheme.textSecondary)),
                Text('${result.score}/${result.maxScore}',
                    style: IthakiTheme.bodySmall
                        .copyWith(fontWeight: FontWeight.w800, fontSize: 32)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.assessmentLevel,
                  style: IthakiTheme.bodySmall
                      .copyWith(color: IthakiTheme.textSecondary)),
              Text(result.level,
                  style: IthakiTheme.bodySmall
                      .copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillBreakdownSection extends StatelessWidget {
  final AssessmentResult result;
  const _SkillBreakdownSection({required this.result});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.assessmentSkillBreakdown,
              style:
                  IthakiTheme.bodySmall.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            l.assessmentSkillBreakdownSubtitle,
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          ...result.skillBreakdowns.map((s) => _SkillRow(skill: s)),
        ],
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  final SkillBreakdown skill;
  const _SkillRow({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(skill.name, style: IthakiTheme.bodySmall),
              Text('${skill.score.toStringAsFixed(skill.score % 1 == 0 ? 0 : 1)}/${skill.maxScore.toInt()}',
                  style: IthakiTheme.bodySmall
                      .copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: skill.score / skill.maxScore,
              backgroundColor: IthakiTheme.matchBarBg,
              color: IthakiTheme.primaryPurple,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyInsightsSection extends StatelessWidget {
  final AssessmentResult result;
  const _KeyInsightsSection({required this.result});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.assessmentKeyInsights,
              style:
                  IthakiTheme.bodySmall.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...result.keyInsights.map((insight) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
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
                      child: Text(insight,
                          style: IthakiTheme.bodySmall
                              .copyWith(color: IthakiTheme.textSecondary)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _PreviousResultsSection extends StatelessWidget {
  final AssessmentResult result;
  const _PreviousResultsSection({required this.result});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.assessmentPreviousResults,
              style:
                  IthakiTheme.bodySmall.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: IthakiTheme.accentPurpleLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.assessmentYouImproving,
                    style: IthakiTheme.bodySmall
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(
                  l.assessmentImprovingSubtitle,
                  style: IthakiTheme.bodySmall
                      .copyWith(color: IthakiTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...result.previousResults.map((prev) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_formatMonthYear(prev.takenAt),
                        style: IthakiTheme.bodySmall
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l.assessmentYourScore,
                            style: IthakiTheme.bodySmall),
                        Text('${prev.score}/${prev.maxScore}',
                            style: IthakiTheme.bodySmall
                                .copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l.assessmentLevel, style: IthakiTheme.bodySmall),
                        Text(prev.level,
                            style: IthakiTheme.bodySmall
                                .copyWith(color: IthakiTheme.textSecondary)),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final AssessmentResult result;
  final void Function(bool) onToggle;

  const _ProfileSection({required this.result, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.assessmentMeansForProfile,
              style:
                  IthakiTheme.bodySmall.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            l.assessmentResultsConfirmSkills,
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiOutlineButton(
            result.shownInCV ? l.assessmentHideFromCV : l.assessmentShowInCV,
            onPressed: () => onToggle(!result.shownInCV),
          ),
        ],
      ),
    );
  }
}

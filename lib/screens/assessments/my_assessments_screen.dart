// lib/screens/assessments/my_assessments_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/tour_provider.dart';
import '../../routes.dart';
import '../../utils/ithaki_bottom_sheet.dart';
import '../../widgets/assessment_card.dart';
import '../../widgets/main_panel_scaffold.dart';
import 'continue_assessment_sheet.dart';
import 'start_assessment_sheet.dart';

class MyAssessmentsScreen extends ConsumerStatefulWidget {
  const MyAssessmentsScreen({super.key});

  @override
  ConsumerState<MyAssessmentsScreen> createState() =>
      _MyAssessmentsScreenState();
}

class _MyAssessmentsScreenState extends ConsumerState<MyAssessmentsScreen> {
  void _onStartTest(BuildContext context, Assessment assessment) {
    showIthakiBottomSheet<void>(
      context: context,
      builder: (_) => StartAssessmentSheet(
        assessment: assessment,
        onStart: () {
          Navigator.pop(context);
          context.push(Routes.assessmentQuizFor(assessment.id));
        },
      ),
    );
  }

  void _onContinue(BuildContext context, Assessment assessment) {
    showIthakiBottomSheet<void>(
      context: context,
      builder: (_) => ContinueAssessmentSheet(
        assessment: assessment,
        onContinue: () {
          Navigator.pop(context);
          context.push(Routes.assessmentQuizFor(assessment.id));
        },
        onStartOver: () {
          Navigator.pop(context);
          ref.read(quizProvider(assessment.id).notifier).reset();
          context.push(Routes.assessmentQuizFor(assessment.id));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(homeProvider);
    final assessmentsAsync = ref.watch(assessmentsListProvider);
    final grouped = ref.watch(assessmentsGroupedProvider);
    final tourState = ref.watch(tourProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    final tourKeys = ref.watch(tourKeysProvider);

    return MainPanelScaffold(
      currentRoute: Routes.assessments,
      avatarInitials: homeAsync.value?.userInitials ?? '',
      avatarUrl: homeAsync.value?.userPhotoUrl,
      bodyBuilder: (context, ref, topOffset) => assessmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(AppLocalizations.of(context)!.errorMessage(e.toString())),
        ),
        data: (_) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: topOffset),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: KeyedSubtree(
                  key: tourState?.currentStep == 13 ? tourKeys[13] : null,
                  child: IthakiButton(
                    AppLocalizations.of(context)!.assessmentStartNew,
                    onPressed: grouped.recommended.isNotEmpty
                        ? () => _onStartTest(context, grouped.recommended.first)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (grouped.inProgress.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SectionHeader(
                    AppLocalizations.of(context)!
                        .assessmentsInProgressTitle(grouped.inProgress.length),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!.assessmentsInProgressSubtitle,
                    style: IthakiTheme.bodySmall
                        .copyWith(color: IthakiTheme.textSecondary),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: grouped.inProgress
                        .map(
                          (a) => AssessmentCard(
                            assessment: a,
                            onTestDetails: () =>
                                context.push(Routes.assessmentDetailFor(a.id)),
                            onContinue: () => _onContinue(context, a),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
              if (grouped.recommended.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SectionHeader(
                    AppLocalizations.of(context)!.assessmentsRecommendedForYou,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!
                        .assessmentsRecommendedSubtitle,
                    style: IthakiTheme.bodySmall
                        .copyWith(color: IthakiTheme.textSecondary),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: grouped.recommended
                        .map(
                          (a) => AssessmentCard(
                            assessment: a,
                            onTestDetails: () =>
                                context.push(Routes.assessmentDetailFor(a.id)),
                            onStartTest: () => _onStartTest(context, a),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
              if (grouped.completed.isNotEmpty) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _SectionHeader(
                    AppLocalizations.of(context)!.assessmentsCompletedTitle,
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    AppLocalizations.of(context)!.assessmentsCompletedSubtitle,
                    style: IthakiTheme.bodySmall
                        .copyWith(color: IthakiTheme.textSecondary),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: grouped.completed
                        .map(
                          (a) => AssessmentCard(
                            assessment: a,
                            onViewDetails: () =>
                                context.push(Routes.assessmentResultsFor(a.id)),
                            onShowInCV: () => ref
                                .read(assessmentsListProvider.notifier)
                                .toggleCV(a.id),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
              SizedBox(height: MediaQuery.paddingOf(context).bottom + 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: IthakiTheme.headingMedium.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

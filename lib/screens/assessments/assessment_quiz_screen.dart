// lib/screens/assessments/assessment_quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/assessment_provider.dart';
import '../../routes.dart';
import 'widgets/quiz_bottom_buttons.dart';
import 'widgets/quiz_leave_sheet.dart';
import 'widgets/quiz_processing_overlay.dart';
import 'widgets/quiz_progress_bar.dart';
import 'widgets/quiz_question_options.dart';

class AssessmentQuizScreen extends ConsumerStatefulWidget {
  final String assessmentId;
  const AssessmentQuizScreen({super.key, required this.assessmentId});

  @override
  ConsumerState<AssessmentQuizScreen> createState() =>
      _AssessmentQuizScreenState();
}

class _AssessmentQuizScreenState extends ConsumerState<AssessmentQuizScreen> {
  bool _processingNavigated = false;

  Future<void> _showLeaveDialog() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuizLeaveSheet(
        onLeave: () async {
          Navigator.pop(context);
          await ref
              .read(quizProvider(widget.assessmentId).notifier)
              .saveAndExit();
          if (mounted) context.pop();
        },
        onContinue: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> _showProcessingAndNavigate() async {
    if (_processingNavigated) return;
    _processingNavigated = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const QuizProcessingOverlay(),
    );
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      context.pushReplacement(Routes.assessmentResultsFor(widget.assessmentId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final quizState = ref.watch(quizProvider(widget.assessmentId));

    ref.listen(quizProvider(widget.assessmentId), (prev, next) {
      if (!_processingNavigated && next.isProcessing) {
        _showProcessingAndNavigate();
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _showLeaveDialog();
      },
      child: Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        appBar: IthakiAppBar(showBackButton: false, title: l.appBarTitleIthaki),
        body: quizState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _QuizBody(
                assessmentId: widget.assessmentId,
                state: quizState,
                onBack: _showLeaveDialog,
              ),
      ),
    );
  }
}

class _QuizBody extends ConsumerWidget {
  final String assessmentId;
  final QuizState state;
  final VoidCallback onBack;

  const _QuizBody({
    required this.assessmentId,
    required this.state,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = state.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    final l = AppLocalizations.of(context)!;
    final notifier = ref.read(quizProvider(assessmentId).notifier);
    final currentAnswer = state.answers[question.id];

    return IthakiScreenLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          QuizProgressBar(
            current: state.currentIndex + 1,
            total: state.questions.length,
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: IthakiTheme.backgroundWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.currentIndex + 1}/${state.questions.length}',
                  style: IthakiTheme.bodySmall
                      .copyWith(color: IthakiTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  question.text,
                  style: IthakiTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _subtitle(l, question),
                  style: IthakiTheme.bodySmall
                      .copyWith(color: IthakiTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: QuizQuestionOptions(
              question: question,
              currentAnswer: currentAnswer,
              onAnswer: (value) => notifier.answer(question.id, value),
            ),
          ),
          QuizBottomButtons(
            showBack: state.currentIndex > 0,
            canNext: state.hasAnswerForCurrent,
            onBack: onBack,
            onNext: () => notifier.next(),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
        ],
      ),
    );
  }

  String _subtitle(AppLocalizations l, Question q) {
    return switch (q) {
      MultiSelectQuestion m => l.quizSelectUpToAnswers(m.maxSelections),
      RangeNumberQuestion r =>
        l.rangeNumberSubtitle(r.min, r.max, r.minLabel, r.maxLabel),
      RangeSymbolQuestion() => l.quizSelectBestReflects,
      _ => l.quizSelectOneAnswer,
    };
  }
}

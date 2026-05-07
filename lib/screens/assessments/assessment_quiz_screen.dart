// lib/screens/assessments/assessment_quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/assessment_provider.dart';
import '../../routes.dart';

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
      builder: (_) => _LeaveSheet(
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
      builder: (_) => const _ProcessingOverlay(),
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

    final notifier = ref.read(quizProvider(assessmentId).notifier);
    final currentAnswer = state.answers[question.id];

    return IthakiScreenLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _ProgressBar(
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
                  _subtitle(context, question),
                  style: IthakiTheme.bodySmall
                      .copyWith(color: IthakiTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _QuestionOptions(
              question: question,
              currentAnswer: currentAnswer,
              onAnswer: (value) => notifier.answer(question.id, value),
            ),
          ),
          _BottomButtons(
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

  String _subtitle(BuildContext context, Question q) {
    final l = AppLocalizations.of(context)!;
    return switch (q) {
      MultiSelectQuestion m => l.quizSelectUpToAnswers(m.maxSelections),
      RangeNumberQuestion r =>
        l.rangeNumberSubtitle(r.min, r.max, r.minLabel, r.maxLabel),
      RangeSymbolQuestion() => l.quizSelectBestReflects,
      _ => l.quizSelectOneAnswer,
    };
  }
}

class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;
  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$current/$total',
          style:
              IthakiTheme.bodySmall.copyWith(color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: current / total,
            backgroundColor: IthakiTheme.borderLight,
            color: IthakiTheme.primaryPurple,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _QuestionOptions extends StatelessWidget {
  final Question question;
  final dynamic currentAnswer;
  final void Function(dynamic) onAnswer;

  const _QuestionOptions({
    required this.question,
    required this.currentAnswer,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: switch (question) {
        SingleSelectQuestion q => _SingleSelectOptions(
            question: q,
            selected: currentAnswer as String?,
            onSelect: onAnswer,
          ),
        MultiSelectQuestion q => _MultiSelectOptions(
            question: q,
            selected: (currentAnswer as List?)?.cast<String>() ?? [],
            onSelect: onAnswer,
          ),
        RangeNumberQuestion q => _RangeNumberOptions(
            question: q,
            selected: currentAnswer as int?,
            onSelect: onAnswer,
          ),
        RangeSymbolQuestion q => _RangeSymbolOptions(
            question: q,
            selected: currentAnswer as int?,
            onSelect: onAnswer,
          ),
        ImageSelectQuestion q => _ImageSelectOptions(
            question: q,
            selected: currentAnswer as String?,
            onSelect: onAnswer,
          ),
      },
    );
  }
}

class _OptionTile extends StatelessWidget {
  final Widget child;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.child,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? IthakiTheme.primaryPurple
                : IthakiTheme.borderLight,
            width: selected ? 2 : 1,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _SingleSelectOptions extends StatelessWidget {
  final SingleSelectQuestion question;
  final String? selected;
  final void Function(String) onSelect;

  const _SingleSelectOptions({
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: question.options
          .map(
            (opt) => _OptionTile(
              selected: selected == opt,
              onTap: () => onSelect(opt),
              child: Text(opt, style: IthakiTheme.bodySmall),
            ),
          )
          .toList(),
    );
  }
}

class _MultiSelectOptions extends StatelessWidget {
  final MultiSelectQuestion question;
  final List<String> selected;
  final void Function(List<String>) onSelect;

  const _MultiSelectOptions({
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: question.options.map((opt) {
        final isSelected = selected.contains(opt);
        return _OptionTile(
          selected: isSelected,
          onTap: () {
            final updated = List<String>.from(selected);
            if (isSelected) {
              updated.remove(opt);
            } else if (updated.length < question.maxSelections) {
              updated.add(opt);
            }
            onSelect(updated);
          },
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? IthakiTheme.primaryPurple
                        : IthakiTheme.borderLight,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  color: isSelected
                      ? IthakiTheme.primaryPurple
                      : Colors.transparent,
                ),
                child: isSelected
                    ? const Center(
                        child: Text(
                          '✓',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                      )
                    : null,
              ),
              Expanded(child: Text(opt, style: IthakiTheme.bodySmall)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _RangeNumberOptions extends StatelessWidget {
  final RangeNumberQuestion question;
  final int? selected;
  final void Function(int) onSelect;

  const _RangeNumberOptions({
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            question.minLabel,
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary),
          ),
        ),
        ...List.generate(
          question.max - question.min + 1,
          (i) {
            final value = question.min + i;
            return _OptionTile(
              selected: selected == value,
              onTap: () => onSelect(value),
              child: Center(
                child: Text(
                  '$value',
                  style: IthakiTheme.bodySmall
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            question.maxLabel,
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _RangeSymbolOptions extends StatelessWidget {
  final RangeSymbolQuestion question;
  final int? selected;
  final void Function(int) onSelect;

  const _RangeSymbolOptions({
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        final idx = entry.key;
        final opt = entry.value;
        return _OptionTile(
          selected: selected == idx,
          onTap: () => onSelect(idx),
          child: Column(
            children: [
              Text(opt.emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                opt.label,
                style: IthakiTheme.bodySmall.copyWith(color: opt.color),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ImageSelectOptions extends StatelessWidget {
  final ImageSelectQuestion question;
  final String? selected;
  final void Function(String) onSelect;

  const _ImageSelectOptions({
    required this.question,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            question.imageAsset,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 180,
              color: IthakiTheme.placeholderBg,
              child: Center(
                child: IthakiIcon(
                  'upload-cloud',
                  size: 40,
                  color: IthakiTheme.textSecondary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...question.options.map(
          (opt) => _OptionTile(
            selected: selected == opt,
            onTap: () => onSelect(opt),
            child: Text(opt, style: IthakiTheme.bodySmall),
          ),
        ),
      ],
    );
  }
}

class _BottomButtons extends StatelessWidget {
  final bool showBack;
  final bool canNext;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const _BottomButtons({
    required this.showBack,
    required this.canNext,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          if (showBack) ...[
            Expanded(child: IthakiOutlineButton(l.backButton, onPressed: onBack)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: IthakiButton(l.nextButton, onPressed: canNext ? onNext : null),
          ),
        ],
      ),
    );
  }
}

class _LeaveSheet extends StatelessWidget {
  final VoidCallback onLeave;
  final VoidCallback onContinue;

  const _LeaveSheet({required this.onLeave, required this.onContinue});

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
                  l.assessmentLeaveTitle,
                  style: IthakiTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onContinue,
                child: IthakiIcon('delete', size: 24, color: IthakiTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.assessmentLeaveSubtitle,
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: IthakiOutlineButton(l.assessmentLeaveButton, onPressed: onLeave)),
              const SizedBox(width: 8),
              Expanded(
                  child: IthakiButton(l.continueButton, onPressed: onContinue)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProcessingOverlay extends StatelessWidget {
  const _ProcessingOverlay();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: IthakiTheme.accentPurpleLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: IthakiIcon(
                  'assessment',
                  size: 22,
                  color: IthakiTheme.primaryPurple,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Processing your results!',
              style: IthakiTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "You've successfully completed the assessment. We're now generating your results — this will only take a moment.",
              style: IthakiTheme.bodySmall
                  .copyWith(color: IthakiTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                backgroundColor: IthakiTheme.borderLight,
                color: IthakiTheme.primaryPurple,
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

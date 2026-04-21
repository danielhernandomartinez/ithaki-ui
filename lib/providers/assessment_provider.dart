// lib/providers/assessment_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/assessment_models.dart';
import '../repositories/assessment_repository.dart';

export '../models/assessment_models.dart';

// ─── Assessments List ──────────────────────────────────────────────────────────

class AssessmentsListNotifier extends AsyncNotifier<List<Assessment>> {
  @override
  Future<List<Assessment>> build() =>
      ref.watch(assessmentRepositoryProvider).getAssessments();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(assessmentRepositoryProvider).getAssessments(),
    );
  }
}

final assessmentsListProvider =
    AsyncNotifierProvider<AssessmentsListNotifier, List<Assessment>>(
        AssessmentsListNotifier.new);

// ─── Quiz ──────────────────────────────────────────────────────────────────────

class QuizState {
  final List<Question> questions;
  final int currentIndex;
  final Map<String, dynamic> answers;
  final bool isLoading;
  final bool isProcessing;

  const QuizState({
    this.questions = const [],
    this.currentIndex = 0,
    this.answers = const {},
    this.isLoading = true,
    this.isProcessing = false,
  });

  Question? get currentQuestion =>
      questions.isEmpty ? null : questions[currentIndex];

  bool get isLastQuestion =>
      questions.isNotEmpty && currentIndex == questions.length - 1;

  bool get hasAnswerForCurrent {
    final q = currentQuestion;
    if (q == null) return false;
    final val = answers[q.id];
    if (val == null) return false;
    if (val is List) return val.isNotEmpty;
    return true;
  }

  QuizState copyWith({
    List<Question>? questions,
    int? currentIndex,
    Map<String, dynamic>? answers,
    bool? isLoading,
    bool? isProcessing,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      isLoading: isLoading ?? this.isLoading,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class QuizNotifier extends Notifier<QuizState> {
  final String assessmentId;

  QuizNotifier(this.assessmentId);

  @override
  QuizState build() {
    _init();
    return const QuizState();
  }

  Future<void> _init() async {
    final repo = ref.read(assessmentRepositoryProvider);
    final results = await Future.wait([
      repo.getQuestions(assessmentId),
      repo.getProgress(assessmentId),
    ]);
    final questions = results[0] as List<Question>;
    final progress = results[1] as AssessmentProgress?;
    state = state.copyWith(
      questions: questions,
      currentIndex: progress?.currentQuestionIndex ?? 0,
      answers: progress?.answers ?? {},
      isLoading: false,
    );
  }

  void answer(String questionId, dynamic value) {
    final updated = Map<String, dynamic>.from(state.answers);
    updated[questionId] = value;
    state = state.copyWith(answers: updated);
  }

  Future<void> next() async {
    if (!state.hasAnswerForCurrent) return;
    if (state.isLastQuestion) {
      await _submit();
    } else {
      final newIndex = state.currentIndex + 1;
      state = state.copyWith(currentIndex: newIndex);
      await _saveProgress();
    }
  }

  void back() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  Future<void> saveAndExit() async {
    final progress = AssessmentProgress(
      assessmentId: assessmentId,
      currentQuestionIndex: state.currentIndex,
      answers: state.answers,
    );
    await ref.read(assessmentRepositoryProvider).saveProgress(progress);
  }

  Future<void> reset() async {
    await ref.read(assessmentRepositoryProvider).clearProgress(assessmentId);
    state = state.copyWith(currentIndex: 0, answers: {});
  }

  Future<void> _saveProgress() async {
    final progress = AssessmentProgress(
      assessmentId: assessmentId,
      currentQuestionIndex: state.currentIndex,
      answers: state.answers,
    );
    await ref.read(assessmentRepositoryProvider).saveProgress(progress);
  }

  Future<void> _submit() async {
    state = state.copyWith(isProcessing: true);
    await ref
        .read(assessmentRepositoryProvider)
        .submitAnswers(assessmentId, state.answers);
    ref.invalidate(assessmentsListProvider);
    ref.invalidate(assessmentResultProvider(assessmentId));
  }
}

final quizProvider =
    NotifierProvider.family<QuizNotifier, QuizState, String>(
        (arg) => QuizNotifier(arg));

// ─── Results ───────────────────────────────────────────────────────────────────

class ResultNotifier extends AsyncNotifier<AssessmentResult?> {
  final String assessmentId;

  ResultNotifier(this.assessmentId);

  @override
  Future<AssessmentResult?> build() =>
      ref.watch(assessmentRepositoryProvider).getResult(assessmentId);

  Future<void> toggleCV({required bool show}) async {
    await ref
        .read(assessmentRepositoryProvider)
        .toggleShowInCV(assessmentId, show: show);
    state = AsyncData(state.value?.copyWith(shownInCV: show));
    ref.invalidate(assessmentsListProvider);
  }
}

final assessmentResultProvider =
    AsyncNotifierProvider.family<ResultNotifier, AssessmentResult?, String>(
        (arg) => ResultNotifier(arg));

# My Assessments Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the complete My Assessments feature — list, detail, quiz (5 question types), and results screens — with mock data and a clean repository interface for future API integration.

**Architecture:** Abstract `AssessmentRepository` with a mock implementation; three Riverpod providers (list `AsyncNotifier`, quiz `NotifierProvider.family`, results `FutureProvider.family`); four new GoRouter routes; shared `AssessmentCard` widget. No hardcoded colors — all `IthakiTheme.*` tokens.

**Tech Stack:** Flutter/Dart 3, Riverpod 3.3, GoRouter 17, `ithaki_design_system` (IthakiTheme, IthakiIcon, IthakiButton, IthakiAppBar, IthakiScreenLayout)

---

## File Map

| Action | File | Responsibility |
|--------|------|----------------|
| Create | `lib/models/assessment_models.dart` | All data models + enums |
| Create | `lib/repositories/assessment_repository.dart` | Abstract interface + mock + `Provider` |
| Create | `lib/providers/assessment_provider.dart` | 3 Riverpod providers (list, quiz, results) |
| Create | `lib/widgets/assessment_card.dart` | Reusable assessment card |
| Create | `lib/screens/assessments/my_assessments_screen.dart` | List screen |
| Create | `lib/screens/assessments/assessment_detail_screen.dart` | Detail/info screen |
| Create | `lib/screens/assessments/assessment_quiz_screen.dart` | Quiz screen (all question types + dialogs) |
| Create | `lib/screens/assessments/assessment_results_screen.dart` | Results screen |
| Modify | `lib/routes.dart` | Add 4 route constants |
| Modify | `lib/router.dart` | Add 4 GoRoute entries + imports |

---

## Task 1: Models

**Files:**
- Create: `lib/models/assessment_models.dart`

- [ ] **Step 1: Create the models file**

```dart
// lib/models/assessment_models.dart
import 'package:flutter/material.dart';

enum AssessmentStatus { notStarted, inProgress, completed }

enum QuestionType { singleSelect, multiSelect, rangeNumber, rangeSymbol, imageSelect }

class Assessment {
  final String id;
  final String title;
  final String category;
  final String description;
  final String iconName;
  final int questionCount;
  final int durationMinutes;
  final String language;
  final AssessmentStatus status;
  final AssessmentResult? lastResult;
  final List<String> usedFor;
  final List<String> beforeYouStart;

  const Assessment({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.iconName,
    required this.questionCount,
    required this.durationMinutes,
    required this.language,
    required this.status,
    this.lastResult,
    this.usedFor = const [],
    this.beforeYouStart = const [],
  });

  Assessment copyWith({AssessmentStatus? status, AssessmentResult? lastResult}) {
    return Assessment(
      id: id,
      title: title,
      category: category,
      description: description,
      iconName: iconName,
      questionCount: questionCount,
      durationMinutes: durationMinutes,
      language: language,
      status: status ?? this.status,
      lastResult: lastResult ?? this.lastResult,
      usedFor: usedFor,
      beforeYouStart: beforeYouStart,
    );
  }
}

sealed class Question {
  final String id;
  final String text;
  final QuestionType type;

  const Question({required this.id, required this.text, required this.type});
}

class SingleSelectQuestion extends Question {
  final List<String> options;
  const SingleSelectQuestion({
    required super.id,
    required super.text,
    required this.options,
  }) : super(type: QuestionType.singleSelect);
}

class MultiSelectQuestion extends Question {
  final List<String> options;
  final int maxSelections;
  const MultiSelectQuestion({
    required super.id,
    required super.text,
    required this.options,
    required this.maxSelections,
  }) : super(type: QuestionType.multiSelect);
}

class RangeNumberQuestion extends Question {
  final int min;
  final int max;
  final String minLabel;
  final String maxLabel;
  const RangeNumberQuestion({
    required super.id,
    required super.text,
    required this.min,
    required this.max,
    required this.minLabel,
    required this.maxLabel,
  }) : super(type: QuestionType.rangeNumber);
}

class SymbolOption {
  final String emoji;
  final String label;
  final Color color;
  const SymbolOption({required this.emoji, required this.label, required this.color});
}

class RangeSymbolQuestion extends Question {
  final List<SymbolOption> options;
  const RangeSymbolQuestion({
    required super.id,
    required super.text,
    required this.options,
  }) : super(type: QuestionType.rangeSymbol);
}

class ImageSelectQuestion extends Question {
  final String imageAsset;
  final List<String> options;
  const ImageSelectQuestion({
    required super.id,
    required super.text,
    required this.imageAsset,
    required this.options,
  }) : super(type: QuestionType.imageSelect);
}

class AssessmentProgress {
  final String assessmentId;
  final int currentQuestionIndex;
  final Map<String, dynamic> answers;

  const AssessmentProgress({
    required this.assessmentId,
    required this.currentQuestionIndex,
    required this.answers,
  });

  AssessmentProgress copyWith({int? currentQuestionIndex, Map<String, dynamic>? answers}) {
    return AssessmentProgress(
      assessmentId: assessmentId,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      answers: answers ?? this.answers,
    );
  }
}

class SkillBreakdown {
  final String name;
  final double score;
  final double maxScore;
  const SkillBreakdown({required this.name, required this.score, required this.maxScore});
}

class AssessmentResult {
  final String assessmentId;
  final int score;
  final int maxScore;
  final String level;
  final DateTime takenAt;
  final List<SkillBreakdown> skillBreakdowns;
  final List<String> keyInsights;
  final List<AssessmentResult> previousResults;
  final bool shownInCV;

  const AssessmentResult({
    required this.assessmentId,
    required this.score,
    required this.maxScore,
    required this.level,
    required this.takenAt,
    required this.skillBreakdowns,
    required this.keyInsights,
    this.previousResults = const [],
    this.shownInCV = false,
  });

  AssessmentResult copyWith({bool? shownInCV}) {
    return AssessmentResult(
      assessmentId: assessmentId,
      score: score,
      maxScore: maxScore,
      level: level,
      takenAt: takenAt,
      skillBreakdowns: skillBreakdowns,
      keyInsights: keyInsights,
      previousResults: previousResults,
      shownInCV: shownInCV ?? this.shownInCV,
    );
  }
}
```

- [ ] **Step 2: Verify no Dart errors**

```bash
cd C:/Users/User/Desktop/Ithaki && flutter analyze lib/models/assessment_models.dart
```

Expected: no issues found.

- [ ] **Step 3: Commit**

```bash
git add lib/models/assessment_models.dart
git commit -m "feat(assessments): add data models"
```

---

## Task 2: Repository (abstract + mock)

**Files:**
- Create: `lib/repositories/assessment_repository.dart`

- [ ] **Step 1: Create the repository file**

```dart
// lib/repositories/assessment_repository.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/assessment_models.dart';
import '../services/api_client.dart';

// ─── Abstract interface ────────────────────────────────────────────────────────

abstract class AssessmentRepository {
  Future<List<Assessment>> getAssessments();
  Future<List<Question>> getQuestions(String assessmentId);
  Future<AssessmentProgress?> getProgress(String assessmentId);
  Future<void> saveProgress(AssessmentProgress progress);
  Future<void> clearProgress(String assessmentId);
  Future<AssessmentResult?> getResult(String assessmentId);
  Future<AssessmentResult> submitAnswers(String assessmentId, Map<String, dynamic> answers);
  Future<void> toggleShowInCV(String assessmentId, {required bool show});
}

// ─── Mock data helpers ─────────────────────────────────────────────────────────

AssessmentResult _mockResultFor(String assessmentId) {
  return AssessmentResult(
    assessmentId: assessmentId,
    score: 78,
    maxScore: 100,
    level: 'Strong problem-solving skills',
    takenAt: DateTime(2026, 3, 3),
    skillBreakdowns: const [
      SkillBreakdown(name: 'Identifying the problem', score: 4, maxScore: 5),
      SkillBreakdown(name: 'Analyzing information', score: 3.5, maxScore: 5),
      SkillBreakdown(name: 'Choosing solutions', score: 4, maxScore: 5),
      SkillBreakdown(name: 'Handling uncertainty', score: 3, maxScore: 5),
    ],
    keyInsights: const [
      'You are effective at identifying core problems and evaluating possible solutions.',
      'You tend to make practical decisions based on available information.',
      'You may take more time when situations are unclear or lack structure.',
    ],
    previousResults: [
      AssessmentResult(
        assessmentId: assessmentId,
        score: 60,
        maxScore: 100,
        level: 'Average problem-solving skills',
        takenAt: DateTime(2025, 9, 1),
        skillBreakdowns: const [],
        keyInsights: const [],
      ),
      AssessmentResult(
        assessmentId: assessmentId,
        score: 41,
        maxScore: 100,
        level: 'Weak problem-solving skills',
        takenAt: DateTime(2024, 9, 1),
        skillBreakdowns: const [],
        keyInsights: const [],
      ),
    ],
    shownInCV: false,
  );
}

List<Question> _mockQuestionsFor(String assessmentId) {
  return [
    const SingleSelectQuestion(
      id: 'q1',
      text: 'You receive unclear instructions for a task. What do you do first?',
      options: [
        'Ask for clarification before starting',
        'Start the task and adjust later',
        'Wait until more information is provided',
        'Ask a colleague to decide',
      ],
    ),
    const MultiSelectQuestion(
      id: 'q2',
      text: 'Which of the following help you stay productive at work?',
      options: [
        'Planning tasks in advance',
        'Taking short breaks',
        'Working without interruptions',
        'Switching between tasks frequently',
      ],
      maxSelections: 3,
    ),
    ImageSelectQuestion(
      id: 'q3',
      text: 'How would you respond to this message?',
      imageAsset: 'assets/images/ai_banner_bg.png',
      options: const [
        'Ask the client to clarify their request',
        'Confirm understanding and propose next steps',
        'Forward the message to a colleague',
      ],
    ),
    RangeNumberQuestion(
      id: 'q4',
      text: 'How often do you plan your tasks before starting work?',
      min: 1,
      max: 5,
      minLabel: 'Never',
      maxLabel: 'Always',
    ),
    RangeSymbolQuestion(
      id: 'q5',
      text: 'How confident do you feel when working under pressure?',
      options: [
        SymbolOption(emoji: '😟', label: 'Not confident at all', color: Colors.red.shade400),
        SymbolOption(emoji: '😐', label: 'Not confident', color: Colors.orange.shade400),
        SymbolOption(emoji: '🙂', label: 'Not sure', color: Colors.grey),
        SymbolOption(emoji: '😀', label: 'Confident', color: Colors.green.shade600),
        SymbolOption(emoji: '😄', label: 'Very confident', color: Colors.green.shade700),
      ],
    ),
  ];
}

// ─── Mock implementation ───────────────────────────────────────────────────────

class MockAssessmentRepository implements AssessmentRepository {
  final Map<String, AssessmentProgress> _progress = {};
  final Map<String, AssessmentResult> _results = {
    'adaptability': _mockResultFor('adaptability'),
    'teamwork': _mockResultFor('teamwork'),
    'english': _mockResultFor('english'),
  };
  final Map<String, bool> _shownInCV = {};

  final List<Assessment> _assessments = [
    Assessment(
      id: 'digital-skills',
      title: 'Digital Skills Assessment',
      category: 'Skills Assessment',
      description: 'Assess your ability to work with common digital tools and everyday tasks.',
      iconName: 'assessment',
      questionCount: 20,
      durationMinutes: 30,
      language: 'English',
      status: AssessmentStatus.inProgress,
      usedFor: [
        'Analyze information and identify key issues',
        'Respond to common challenges at work',
      ],
      beforeYouStart: [
        'The assessment consists of short questions based on real work scenarios.',
        'Try to answer honestly, based on how you would usually act at work.',
        'You can pause and continue later — your progress will be saved.',
        'Once started, your answers will be used to calculate your final result.',
      ],
    ),
    Assessment(
      id: 'decision-making',
      title: 'Decision-Making Style Assessment',
      category: 'Skills Assessment',
      description: 'Evaluate how you make choices in work and everyday situations.',
      iconName: 'assessment',
      questionCount: 20,
      durationMinutes: 30,
      language: 'English',
      status: AssessmentStatus.inProgress,
      usedFor: [
        'Analyze how you approach decisions under pressure',
        'Identify your preferred decision-making style',
      ],
      beforeYouStart: [
        'The assessment consists of short questions based on real work scenarios.',
        'Try to answer honestly, based on how you would usually act at work.',
        'You can pause and continue later — your progress will be saved.',
        'Once started, your answers will be used to calculate your final result.',
      ],
    ),
    Assessment(
      id: 'problem-solving',
      title: 'Problem-Solving Assessment',
      category: 'Skills Assessment',
      description: 'Evaluate how you approach and resolve work-related problems.',
      iconName: 'assessment',
      questionCount: 20,
      durationMinutes: 30,
      language: 'English',
      status: AssessmentStatus.notStarted,
      usedFor: [
        'Analyze information and identify key issues',
        'Respond to common challenges at work',
      ],
      beforeYouStart: [
        'The assessment consists of short questions based on real work scenarios.',
        'Try to answer honestly, based on how you would usually act at work.',
        'You can pause and continue later — your progress will be saved.',
        'Once started, your answers will be used to calculate your final result.',
      ],
    ),
    Assessment(
      id: 'work-pace',
      title: 'Work Pace & Focus Assessment',
      category: 'Work Style Assessment',
      description: 'Balancing speed, focus, and quality.',
      iconName: 'assessment',
      questionCount: 20,
      durationMinutes: 30,
      language: 'English',
      status: AssessmentStatus.notStarted,
      usedFor: [
        'Measure your ability to manage time and maintain focus',
        'Identify patterns in how you balance speed and quality',
      ],
      beforeYouStart: [
        'The assessment consists of short questions based on real work scenarios.',
        'Try to answer honestly, based on how you would usually act at work.',
        'You can pause and continue later — your progress will be saved.',
        'Once started, your answers will be used to calculate your final result.',
      ],
    ),
    Assessment(
      id: 'adaptability',
      title: 'Adaptability Assessment',
      category: 'Skills Assessment',
      description: 'Measures how well you adapt to change, learn new things, and handle uncertainty.',
      iconName: 'assessment',
      questionCount: 20,
      durationMinutes: 30,
      language: 'English',
      status: AssessmentStatus.completed,
      usedFor: [
        'Understand how you respond to change and unexpected situations',
        'Identify your resilience and flexibility at work',
      ],
      beforeYouStart: [
        'The assessment consists of short questions based on real work scenarios.',
        'Try to answer honestly, based on how you would usually act at work.',
        'You can pause and continue later — your progress will be saved.',
        'Once started, your answers will be used to calculate your final result.',
      ],
    ),
    Assessment(
      id: 'teamwork',
      title: 'Teamwork Skills Assessment',
      category: 'Skills Assessment',
      description: 'Evaluates how you collaborate, communicate, and contribute as part of a team.',
      iconName: 'assessment',
      questionCount: 20,
      durationMinutes: 30,
      language: 'English',
      status: AssessmentStatus.completed,
      usedFor: [
        'Analyze how you collaborate with others',
        'Identify your communication style in team settings',
      ],
      beforeYouStart: [
        'The assessment consists of short questions based on real work scenarios.',
        'Try to answer honestly, based on how you would usually act at work.',
        'You can pause and continue later — your progress will be saved.',
        'Once started, your answers will be used to calculate your final result.',
      ],
    ),
    Assessment(
      id: 'english',
      title: 'English Proficiency Assessment',
      category: 'Language Assessment',
      description: 'Assesses your ability to use English in professional situations.',
      iconName: 'assessment',
      questionCount: 20,
      durationMinutes: 30,
      language: 'English',
      status: AssessmentStatus.completed,
      usedFor: [
        'Evaluate your English reading and comprehension skills',
        'Measure your ability to communicate in professional contexts',
      ],
      beforeYouStart: [
        'The assessment consists of short questions based on real work scenarios.',
        'Try to answer honestly, based on how you would usually act at work.',
        'You can pause and continue later — your progress will be saved.',
        'Once started, your answers will be used to calculate your final result.',
      ],
    ),
  ];

  @override
  Future<List<Assessment>> getAssessments() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _assessments.map((a) {
      final result = _results[a.id];
      final shown = _shownInCV[a.id] ?? false;
      return a.copyWith(
        lastResult: result?.copyWith(shownInCV: shown),
      );
    }).toList();
  }

  @override
  Future<List<Question>> getQuestions(String assessmentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockQuestionsFor(assessmentId);
  }

  @override
  Future<AssessmentProgress?> getProgress(String assessmentId) async {
    return _progress[assessmentId];
  }

  @override
  Future<void> saveProgress(AssessmentProgress progress) async {
    _progress[progress.assessmentId] = progress;
    final idx = _assessments.indexWhere((a) => a.id == progress.assessmentId);
    if (idx != -1 && _assessments[idx].status == AssessmentStatus.notStarted) {
      _assessments[idx] = _assessments[idx].copyWith(status: AssessmentStatus.inProgress);
    }
  }

  @override
  Future<void> clearProgress(String assessmentId) async {
    _progress.remove(assessmentId);
  }

  @override
  Future<AssessmentResult?> getResult(String assessmentId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final shown = _shownInCV[assessmentId] ?? false;
    return _results[assessmentId]?.copyWith(shownInCV: shown);
  }

  @override
  Future<AssessmentResult> submitAnswers(String assessmentId, Map<String, dynamic> answers) async {
    await Future.delayed(const Duration(seconds: 2));
    final result = _mockResultFor(assessmentId);
    _results[assessmentId] = result;
    _progress.remove(assessmentId);
    final idx = _assessments.indexWhere((a) => a.id == assessmentId);
    if (idx != -1) {
      _assessments[idx] = _assessments[idx].copyWith(
        status: AssessmentStatus.completed,
        lastResult: result,
      );
    }
    return result;
  }

  @override
  Future<void> toggleShowInCV(String assessmentId, {required bool show}) async {
    _shownInCV[assessmentId] = show;
  }
}

// ─── Provider ──────────────────────────────────────────────────────────────────

const bool _useMockAssessments = true; // flip to false when API is ready

final assessmentRepositoryProvider = Provider<AssessmentRepository>(
  (ref) => _useMockAssessments
      ? MockAssessmentRepository()
      : throw UnimplementedError('ApiAssessmentRepository not yet implemented'),
);
```

- [ ] **Step 2: Verify no Dart errors**

```bash
flutter analyze lib/repositories/assessment_repository.dart
```

Expected: no issues found.

- [ ] **Step 3: Commit**

```bash
git add lib/repositories/assessment_repository.dart
git commit -m "feat(assessments): add repository interface and mock implementation"
```

---

## Task 3: Providers

**Files:**
- Create: `lib/providers/assessment_provider.dart`

- [ ] **Step 1: Create the providers file**

```dart
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
    if (val is List) return (val as List).isNotEmpty;
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

class QuizNotifier extends FamilyNotifier<QuizState, String> {
  @override
  QuizState build(String assessmentId) {
    _init(assessmentId);
    return const QuizState();
  }

  Future<void> _init(String assessmentId) async {
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

  Future<void> saveAndExit(String assessmentId) async {
    final progress = AssessmentProgress(
      assessmentId: assessmentId,
      currentQuestionIndex: state.currentIndex,
      answers: state.answers,
    );
    await ref.read(assessmentRepositoryProvider).saveProgress(progress);
  }

  Future<void> reset(String assessmentId) async {
    await ref.read(assessmentRepositoryProvider).clearProgress(assessmentId);
    state = state.copyWith(currentIndex: 0, answers: {});
  }

  Future<void> _saveProgress() async {
    final assessmentId = arg;
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
        .submitAnswers(arg, state.answers);
    ref.invalidate(assessmentsListProvider);
    ref.invalidate(assessmentResultProvider(arg));
  }
}

final quizProvider =
    NotifierProvider.family<QuizNotifier, QuizState, String>(QuizNotifier.new);

// ─── Results ───────────────────────────────────────────────────────────────────

class ResultNotifier extends FamilyAsyncNotifier<AssessmentResult?, String> {
  @override
  Future<AssessmentResult?> build(String assessmentId) =>
      ref.watch(assessmentRepositoryProvider).getResult(assessmentId);

  Future<void> toggleCV({required bool show}) async {
    await ref
        .read(assessmentRepositoryProvider)
        .toggleShowInCV(arg, show: show);
    state = AsyncData(state.value?.copyWith(shownInCV: show));
    ref.invalidate(assessmentsListProvider);
  }
}

final assessmentResultProvider =
    AsyncNotifierProvider.family<ResultNotifier, AssessmentResult?, String>(
        ResultNotifier.new);
```

- [ ] **Step 2: Verify no Dart errors**

```bash
flutter analyze lib/providers/assessment_provider.dart
```

Expected: no issues found.

- [ ] **Step 3: Commit**

```bash
git add lib/providers/assessment_provider.dart
git commit -m "feat(assessments): add Riverpod providers (list, quiz, results)"
```

---

## Task 4: AssessmentCard widget

**Files:**
- Create: `lib/widgets/assessment_card.dart`

- [ ] **Step 1: Create the widget**

```dart
// lib/widgets/assessment_card.dart
import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

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
                  style: IthakiTheme.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600)),
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
    return Row(
      children: [
        Text('${assessment.questionCount} questions',
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary)),
        const SizedBox(width: 16),
        Text('${assessment.durationMinutes} min',
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
    return Row(
      children: [
        Text('Your Score',
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary)),
        const Spacer(),
        Text('${result.score}/${result.maxScore}',
            style: IthakiTheme.bodyMedium
                .copyWith(fontWeight: FontWeight.w700)),
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
    return switch (assessment.status) {
      AssessmentStatus.notStarted => Row(
          children: [
            Expanded(
              child: IthakiOutlineButton(
                'Test Details',
                onPressed: onTestDetails,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: IthakiButton('Start Test', onPressed: onStartTest),
            ),
          ],
        ),
      AssessmentStatus.inProgress => Row(
          children: [
            Expanded(
              child: IthakiOutlineButton(
                'Test Details',
                onPressed: onTestDetails,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: IthakiButton('Continue', onPressed: onContinue),
            ),
          ],
        ),
      AssessmentStatus.completed => Row(
          children: [
            Expanded(
              child: IthakiOutlineButton(
                'View Details',
                onPressed: onViewDetails,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: IthakiButton(
                assessment.lastResult?.shownInCV == true
                    ? 'In CV'
                    : 'Show in CV',
                onPressed: onShowInCV,
              ),
            ),
          ],
        ),
    };
  }
}
```

- [ ] **Step 2: Verify no Dart errors**

```bash
flutter analyze lib/widgets/assessment_card.dart
```

Expected: no issues found.

- [ ] **Step 3: Commit**

```bash
git add lib/widgets/assessment_card.dart
git commit -m "feat(assessments): add AssessmentCard widget"
```

---

## Task 5: Routes + Router

**Files:**
- Modify: `lib/routes.dart`
- Modify: `lib/router.dart`

- [ ] **Step 1: Add route constants to `lib/routes.dart`**

Add inside the `Routes` abstract class, after the `careerAssistant` constant:

```dart
  // Assessments
  static const assessments = '/assessments';
  static const assessmentDetail = '/assessments/:id';
  static String assessmentDetailFor(String id) => '/assessments/$id';
  static const assessmentQuiz = '/assessments/:id/quiz';
  static String assessmentQuizFor(String id) => '/assessments/$id/quiz';
  static const assessmentResults = '/assessments/:id/results';
  static String assessmentResultsFor(String id) => '/assessments/$id/results';
```

- [ ] **Step 2: Add imports to `lib/router.dart`**

Add after the existing screen imports:

```dart
import 'screens/assessments/my_assessments_screen.dart';
import 'screens/assessments/assessment_detail_screen.dart';
import 'screens/assessments/assessment_quiz_screen.dart';
import 'screens/assessments/assessment_results_screen.dart';
```

- [ ] **Step 3: Add GoRoute entries to `lib/router.dart`**

Add after the `careerAssistant` GoRoute entry:

```dart
      GoRoute(
        path: Routes.assessments,
        builder: (context, state) => const MyAssessmentsScreen(),
      ),
      GoRoute(
        path: Routes.assessmentDetail,
        builder: (context, state) => AssessmentDetailScreen(
          assessmentId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: Routes.assessmentQuiz,
        builder: (context, state) => AssessmentQuizScreen(
          assessmentId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: Routes.assessmentResults,
        builder: (context, state) => AssessmentResultsScreen(
          assessmentId: state.pathParameters['id']!,
        ),
      ),
```

- [ ] **Step 4: Verify no Dart errors**

```bash
flutter analyze lib/routes.dart lib/router.dart
```

Expected: no issues found.

- [ ] **Step 5: Commit**

```bash
git add lib/routes.dart lib/router.dart
git commit -m "feat(assessments): add routes"
```

---

## Task 6: MyAssessmentsScreen

**Files:**
- Create: `lib/screens/assessments/my_assessments_screen.dart`

- [ ] **Step 1: Create the screen**

```dart
// lib/screens/assessments/my_assessments_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/home_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/assessment_card.dart';
import '../../widgets/profile_menu_panel.dart';

class MyAssessmentsScreen extends ConsumerStatefulWidget {
  const MyAssessmentsScreen({super.key});

  @override
  ConsumerState<MyAssessmentsScreen> createState() => _MyAssessmentsScreenState();
}

class _MyAssessmentsScreenState extends ConsumerState<MyAssessmentsScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;

  @override
  void initState() {
    super.initState();
    _panels = PanelMenuController(setState)..init(this);
  }

  @override
  void dispose() {
    _panels.dispose();
    super.dispose();
  }

  void _onStartTest(BuildContext context, Assessment assessment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _StartAssessmentSheet(
        assessment: assessment,
        onStart: () {
          Navigator.pop(context);
          context.push(Routes.assessmentQuizFor(assessment.id));
        },
      ),
    );
  }

  void _onContinue(BuildContext context, Assessment assessment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ContinueAssessmentSheet(
        assessment: assessment,
        onContinue: () {
          Navigator.pop(context);
          context.push(Routes.assessmentQuizFor(assessment.id));
        },
        onStartOver: () {
          Navigator.pop(context);
          ref.read(quizProvider(assessment.id).notifier).reset(assessment.id);
          context.push(Routes.assessmentQuizFor(assessment.id));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeData = ref.watch(homeProvider).value;
    final assessmentsAsync = ref.watch(assessmentsListProvider);

    final shell = Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        onMenuTap: _panels.openNav,
        onAvatarTap: _panels.openProfile,
      ),
      body: assessmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (assessments) {
          final inProgress = assessments
              .where((a) => a.status == AssessmentStatus.inProgress)
              .toList();
          final recommended = assessments
              .where((a) => a.status == AssessmentStatus.notStarted)
              .toList();
          final completed = assessments
              .where((a) => a.status == AssessmentStatus.completed)
              .toList();

          return IthakiScreenLayout(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  IthakiButton(
                    'Start New Assessment',
                    onPressed: recommended.isNotEmpty
                        ? () => _onStartTest(context, recommended.first)
                        : null,
                  ),
                  const SizedBox(height: 24),
                  if (inProgress.isNotEmpty) ...[
                    _SectionHeader(
                        'Assessments in Progress (${inProgress.length})'),
                    Text(
                      'You have assessments in progress. Complete them to see your results.',
                      style: IthakiTheme.bodySmall
                          .copyWith(color: IthakiTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ...inProgress.map((a) => AssessmentCard(
                          assessment: a,
                          onTestDetails: () => context
                              .push(Routes.assessmentDetailFor(a.id)),
                          onContinue: () => _onContinue(context, a),
                        )),
                  ],
                  if (recommended.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _SectionHeader('Assessments recommended for you'),
                    Text(
                      'We recommend these assessments to help you validate your skills.',
                      style: IthakiTheme.bodySmall
                          .copyWith(color: IthakiTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ...recommended.map((a) => AssessmentCard(
                          assessment: a,
                          onTestDetails: () => context
                              .push(Routes.assessmentDetailFor(a.id)),
                          onStartTest: () => _onStartTest(context, a),
                        )),
                  ],
                  if (completed.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _SectionHeader('Your Completed Assessments'),
                    Text(
                      'Here are your completed assessments and results.',
                      style: IthakiTheme.bodySmall
                          .copyWith(color: IthakiTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ...completed.map((a) => AssessmentCard(
                          assessment: a,
                          onViewDetails: () => context
                              .push(Routes.assessmentResultsFor(a.id)),
                          onShowInCV: () => ref
                              .read(assessmentResultProvider(a.id).notifier)
                              .toggleCV(show: !(a.lastResult?.shownInCV ?? false)),
                        )),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );

    return Stack(children: [
      shell,
      AppNavDrawer(
        slideAnim: _panels.slideAnim,
        navItems: navItems,
        onClose: _panels.closeNav,
        onLogout: () => ref.read(authRepositoryProvider).logout(),
      ),
      ProfileMenuPanel(
        slideAnim: _panels.profileSlideAnim,
        homeData: homeData,
        onClose: _panels.closeProfile,
      ),
    ]);
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text,
          style: IthakiTheme.headingSmall
              .copyWith(fontWeight: FontWeight.w700)),
    );
  }
}

// ─── Dialogs ───────────────────────────────────────────────────────────────────

class _StartAssessmentSheet extends StatelessWidget {
  final Assessment assessment;
  final VoidCallback onStart;

  const _StartAssessmentSheet({required this.assessment, required this.onStart});

  @override
  Widget build(BuildContext context) {
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
                child: Text('Start the Assessment',
                    style: IthakiTheme.headingSmall
                        .copyWith(fontWeight: FontWeight.w700)),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('You are about to start the following assessment',
              style: IthakiTheme.bodySmall
                  .copyWith(color: IthakiTheme.textSecondary)),
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
                              style: IthakiTheme.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600)),
                          Text(assessment.category,
                              style: IthakiTheme.bodySmall.copyWith(
                                  color: IthakiTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    _MetaItem(
                        icon: Icons.access_time,
                        label: 'Approximate Duration',
                        value: '${assessment.durationMinutes} min'),
                    const SizedBox(width: 24),
                    _MetaItem(
                        icon: Icons.assignment_outlined,
                        label: 'Questions',
                        value: '${assessment.questionCount} questions'),
                  ],
                ),
                const SizedBox(height: 12),
                _MetaItem(
                    icon: Icons.language,
                    label: 'Language',
                    value: assessment.language),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Before you start',
              style: IthakiTheme.bodyMedium
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...assessment.beforeYouStart.map((item) => Padding(
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
                      child: Text(item,
                          style: IthakiTheme.bodySmall
                              .copyWith(color: IthakiTheme.textSecondary)),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 20),
          IthakiButton('Start now', onPressed: onStart),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetaItem({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary, fontSize: 11)),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, size: 14, color: IthakiTheme.textSecondary),
            const SizedBox(width: 4),
            Text(value, style: IthakiTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}

class _ContinueAssessmentSheet extends StatelessWidget {
  final Assessment assessment;
  final VoidCallback onContinue;
  final VoidCallback onStartOver;

  const _ContinueAssessmentSheet({
    required this.assessment,
    required this.onContinue,
    required this.onStartOver,
  });

  @override
  Widget build(BuildContext context) {
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
                child: Text('Continue your assessment?',
                    style: IthakiTheme.headingSmall
                        .copyWith(fontWeight: FontWeight.w700)),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "You've already started this assessment and have saved progress. Would you like to continue where you left off or start over?",
            style:
                IthakiTheme.bodySmall.copyWith(color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: IthakiOutlineButton('Start over', onPressed: onStartOver)),
              const SizedBox(width: 8),
              Expanded(child: IthakiButton('Continue', onPressed: onContinue)),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Verify no Dart errors**

```bash
flutter analyze lib/screens/assessments/my_assessments_screen.dart
```

Expected: no issues found.

- [ ] **Step 3: Commit**

```bash
git add lib/screens/assessments/my_assessments_screen.dart
git commit -m "feat(assessments): add My Assessments list screen"
```

---

## Task 7: AssessmentDetailScreen

**Files:**
- Create: `lib/screens/assessments/assessment_detail_screen.dart`

- [ ] **Step 1: Create the screen**

```dart
// lib/screens/assessments/assessment_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/assessment_provider.dart';
import '../../routes.dart';

class AssessmentDetailScreen extends ConsumerWidget {
  final String assessmentId;
  const AssessmentDetailScreen({super.key, required this.assessmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        body: Center(child: Text('Error: $e')),
      ),
      data: (assessments) {
        final assessment =
            assessments.where((a) => a.id == assessmentId).firstOrNull;
        if (assessment == null) {
          return Scaffold(
            backgroundColor: IthakiTheme.backgroundViolet,
            appBar: IthakiAppBar(showBackButton: true),
            body: const Center(child: Text('Assessment not found')),
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
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: 'Ithaki'),
      body: IthakiScreenLayout(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
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
                            style: IthakiTheme.headingSmall
                                .copyWith(fontWeight: FontWeight.w700)),
                        Text(assessment.category,
                            style: IthakiTheme.bodySmall
                                .copyWith(color: IthakiTheme.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _MetaRow(assessment: assessment),
              const SizedBox(height: 20),
              Text('About this assessment',
                  style: IthakiTheme.bodyMedium
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(assessment.description,
                  style: IthakiTheme.bodySmall
                      .copyWith(color: IthakiTheme.textSecondary)),
              if (assessment.usedFor.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('What this assessment is used for',
                    style: IthakiTheme.bodyMedium
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...assessment.usedFor.map(_buildBullet),
              ],
              if (assessment.beforeYouStart.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text('Before you start',
                    style: IthakiTheme.bodyMedium
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...assessment.beforeYouStart.map(_buildBullet),
              ],
              const SizedBox(height: 28),
              IthakiButton(
                'Start Test',
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
                style: IthakiTheme.bodySmall
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Row(
        children: [
          _Item(
              icon: Icons.access_time,
              label: 'Duration',
              value: '${assessment.durationMinutes} min'),
          _Divider(),
          _Item(
              icon: Icons.assignment_outlined,
              label: 'Questions',
              value: '${assessment.questionCount}'),
          _Divider(),
          _Item(
              icon: Icons.language,
              label: 'Language',
              value: assessment.language),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1, height: 36, color: IthakiTheme.borderLight,
        margin: const EdgeInsets.symmetric(horizontal: 12));
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Item({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: IthakiTheme.bodySmall
                  .copyWith(color: IthakiTheme.textSecondary, fontSize: 11)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: IthakiTheme.textSecondary),
              const SizedBox(width: 4),
              Text(value, style: IthakiTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Verify no Dart errors**

```bash
flutter analyze lib/screens/assessments/assessment_detail_screen.dart
```

Expected: no issues found.

- [ ] **Step 3: Commit**

```bash
git add lib/screens/assessments/assessment_detail_screen.dart
git commit -m "feat(assessments): add Assessment Detail screen"
```

---

## Task 8: AssessmentQuizScreen

**Files:**
- Create: `lib/screens/assessments/assessment_quiz_screen.dart`

- [ ] **Step 1: Create the quiz screen**

```dart
// lib/screens/assessments/assessment_quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../models/assessment_models.dart';
import '../../providers/assessment_provider.dart';
import '../../routes.dart';

class AssessmentQuizScreen extends ConsumerStatefulWidget {
  final String assessmentId;
  const AssessmentQuizScreen({super.key, required this.assessmentId});

  @override
  ConsumerState<AssessmentQuizScreen> createState() => _AssessmentQuizScreenState();
}

class _AssessmentQuizScreenState extends ConsumerState<AssessmentQuizScreen> {
  bool _processingNavigated = false;

  Future<bool> _onWillPop() async {
    final state = ref.read(quizProvider(widget.assessmentId));
    if (state.isProcessing) return false;
    await _showLeaveDialog();
    return false;
  }

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
              .saveAndExit(widget.assessmentId);
          if (mounted) context.pop();
        },
        onContinue: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider(widget.assessmentId));

    if (quizState.isProcessing && !_processingNavigated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showProcessingAndNavigate();
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _onWillPop();
      },
      child: Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        appBar: IthakiAppBar(showBackButton: false, title: 'Ithaki'),
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

  Future<void> _showProcessingAndNavigate() async {
    if (_processingNavigated) return;
    _processingNavigated = true;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ProcessingOverlay(),
    );
    if (mounted) {
      context.pushReplacement(Routes.assessmentResultsFor(widget.assessmentId));
    }
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
              current: state.currentIndex + 1, total: state.questions.length),
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
                Text(question.text,
                    style: IthakiTheme.headingSmall
                        .copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  _subtitle(question),
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

  String _subtitle(Question q) {
    return switch (q) {
      MultiSelectQuestion m => 'Select up to ${m.maxSelections} answers',
      RangeNumberQuestion r =>
        'Select a number from ${r.min} to ${r.max}, where ${r.min} means "${r.minLabel}" and ${r.max} means "${r.maxLabel}".',
      RangeSymbolQuestion() => 'Select the option that best reflects how you usually feel.',
      _ => 'Select only one answer',
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
        Text('$current/$total',
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary)),
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
            color: selected ? IthakiTheme.primaryPurple : IthakiTheme.borderLight,
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
          .map((opt) => _OptionTile(
                selected: selected == opt,
                onTap: () => onSelect(opt),
                child: Text(opt, style: IthakiTheme.bodySmall),
              ))
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
                  color: isSelected ? IthakiTheme.primaryPurple : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
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
          child: Text(question.minLabel,
              style: IthakiTheme.bodySmall
                  .copyWith(color: IthakiTheme.textSecondary)),
        ),
        ...List.generate(
          question.max - question.min + 1,
          (i) {
            final value = question.min + i;
            return _OptionTile(
              selected: selected == value,
              onTap: () => onSelect(value),
              child: Center(
                child: Text('$value',
                    style: IthakiTheme.bodyMedium
                        .copyWith(fontWeight: FontWeight.w500)),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(question.maxLabel,
              style: IthakiTheme.bodySmall
                  .copyWith(color: IthakiTheme.textSecondary)),
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
              Text(opt.label,
                  style: IthakiTheme.bodySmall.copyWith(color: opt.color)),
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
                child: IthakiIcon('upload-cloud',
                    size: 40, color: IthakiTheme.textSecondary),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...question.options
            .map((opt) => _OptionTile(
                  selected: selected == opt,
                  onTap: () => onSelect(opt),
                  child: Text(opt, style: IthakiTheme.bodySmall),
                ))
            .toList(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          if (showBack) ...[
            Expanded(
                child: IthakiOutlineButton('Back', onPressed: onBack)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: IthakiButton(
              'Next',
              onPressed: canNext ? onNext : null,
            ),
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
                child: Text('Leave this page?',
                    style: IthakiTheme.headingSmall
                        .copyWith(fontWeight: FontWeight.w700)),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: onContinue,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "You're about to leave this assessment. Your progress will be saved automatically, and you can continue later.",
            style:
                IthakiTheme.bodySmall.copyWith(color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: IthakiOutlineButton('Leave', onPressed: onLeave)),
              const SizedBox(width: 8),
              Expanded(
                  child: IthakiButton('Continue', onPressed: onContinue)),
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
                child: IthakiIcon('assessment',
                    size: 22, color: IthakiTheme.primaryPurple),
              ),
            ),
            const SizedBox(height: 16),
            Text('Processing your results!',
                style: IthakiTheme.headingSmall
                    .copyWith(fontWeight: FontWeight.w700)),
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
```

- [ ] **Step 2: Verify no Dart errors**

```bash
flutter analyze lib/screens/assessments/assessment_quiz_screen.dart
```

Expected: no issues found.

- [ ] **Step 3: Commit**

```bash
git add lib/screens/assessments/assessment_quiz_screen.dart
git commit -m "feat(assessments): add Quiz screen with 5 question types"
```

---

## Task 9: AssessmentResultsScreen

**Files:**
- Create: `lib/screens/assessments/assessment_results_screen.dart`

- [ ] **Step 1: Create the screen**

```dart
// lib/screens/assessments/assessment_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'package:intl/intl.dart';

import '../../providers/assessment_provider.dart';
import '../../routes.dart';
import '../../widgets/assessment_card.dart';

class AssessmentResultsScreen extends ConsumerWidget {
  final String assessmentId;
  const AssessmentResultsScreen({super.key, required this.assessmentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultAsync = ref.watch(assessmentResultProvider(assessmentId));
    final assessmentsAsync = ref.watch(assessmentsListProvider);

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: 'Ithaki'),
      body: resultAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (result) {
          if (result == null) {
            return const Center(child: Text('No results found'));
          }

          final assessments = assessmentsAsync.value ?? [];
          final assessment =
              assessments.where((a) => a.id == assessmentId).firstOrNull;
          final recommended = assessments
              .where((a) =>
                  a.status == AssessmentStatus.notStarted && a.id != assessmentId)
              .take(2)
              .toList();

          return IthakiScreenLayout(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (assessment != null) _AssessmentHeader(assessment: assessment, result: result),
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
                    Text('Assessments recommended for you',
                        style: IthakiTheme.headingSmall
                            .copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('We recommend these assessments to help you validate your skills.',
                        style: IthakiTheme.bodySmall
                            .copyWith(color: IthakiTheme.textSecondary)),
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
                    assessmentId: assessmentId,
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
                  style: IthakiTheme.headingSmall
                      .copyWith(fontWeight: FontWeight.w700)),
              Text(assessment.category,
                  style: IthakiTheme.bodySmall
                      .copyWith(color: IthakiTheme.textSecondary)),
              Text(
                'Taken: ${DateFormat('dd-MM-yyyy').format(result.takenAt)}',
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
                Text('Your Score',
                    style: IthakiTheme.bodySmall
                        .copyWith(color: IthakiTheme.textSecondary)),
                Text('${result.score}/${result.maxScore}',
                    style: IthakiTheme.headingLarge
                        .copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Level',
                  style: IthakiTheme.bodySmall
                      .copyWith(color: IthakiTheme.textSecondary)),
              Text(result.level, style: IthakiTheme.bodySmall),
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
          Text('Skill breakdown',
              style: IthakiTheme.bodyMedium
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            'This breakdown shows how your results are distributed across key skill areas.',
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
              Text('${skill.score}/${skill.maxScore.toInt()}',
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
          Text('Key insights',
              style: IthakiTheme.bodyMedium
                  .copyWith(fontWeight: FontWeight.w700)),
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
          Text('Previous results',
              style: IthakiTheme.bodyMedium
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: IthakiTheme.accentPurpleLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('You improving!',
                    style: IthakiTheme.bodySmall
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(
                  'Your results show steady improvement in how you approach and resolve work-related problems.',
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
                    Text(DateFormat('MMMM yyyy').format(prev.takenAt),
                        style: IthakiTheme.bodySmall
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Your Score', style: IthakiTheme.bodySmall),
                        Text('${prev.score}/${prev.maxScore}',
                            style: IthakiTheme.bodySmall
                                .copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Level', style: IthakiTheme.bodySmall),
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
  final String assessmentId;
  final AssessmentResult result;
  final void Function(bool) onToggle;

  const _ProfileSection({
    required this.assessmentId,
    required this.result,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
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
          Text('What this means for your profile',
              style: IthakiTheme.bodyMedium
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'This result confirms your problem-solving skills, which are reflected in your job applications on the platform.',
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiOutlineButton(
            result.shownInCV ? 'Hide from CV' : 'Show result in my CV',
            onPressed: () => onToggle(!result.shownInCV),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Add `intl` dependency check**

Check if `intl` is already in `pubspec.yaml`:

```bash
grep "intl:" C:/Users/User/Desktop/Ithaki/pubspec.yaml
```

`intl` is NOT in pubspec.yaml — add `intl: ^0.20.0` under `dependencies` and run:

```bash
flutter pub get
```

- [ ] **Step 3: Verify no Dart errors**

```bash
flutter analyze lib/screens/assessments/assessment_results_screen.dart
```

Expected: no issues found.

- [ ] **Step 4: Commit**

```bash
git add lib/screens/assessments/assessment_results_screen.dart pubspec.yaml pubspec.lock
git commit -m "feat(assessments): add Assessment Results screen"
```

---

## Task 10: Wire navigation in constants + smoke test

**Files:**
- Modify: `lib/constants/nav_items.dart` (add assessments nav item if needed)

- [ ] **Step 1: Check nav items file**

```bash
cat C:/Users/User/Desktop/Ithaki/lib/constants/nav_items.dart
```

If assessments nav item is not present, add it in the correct position:

```dart
NavItem(
  icon: 'assessment',
  label: 'My Assessments',
  route: Routes.assessments,
),
```

- [ ] **Step 2: Full analysis**

```bash
flutter analyze lib/
```

Expected: no issues found.

- [ ] **Step 3: Build check (no device needed)**

```bash
flutter build apk --debug --dart-define=ITHAKI_API_BASE_URL=https://api.odyssea.com/talent/staging 2>&1 | tail -5
```

Expected: `Built build/app/outputs/flutter-apk/app-debug.apk`

- [ ] **Step 4: Commit**

```bash
git add lib/constants/nav_items.dart
git commit -m "feat(assessments): wire nav item and verify full build"
```

---

## Self-Review Checklist

- [x] Models cover all 5 question types + assessment status + progress + results with previous results + shownInCV
- [x] Repository abstract interface matches mock implementation method signatures exactly
- [x] `quizProvider` uses `FamilyNotifier` with `arg` accessor (Riverpod 3 pattern)
- [x] `assessmentResultProvider` uses `FamilyAsyncNotifier` with `arg` accessor
- [x] `PopScope` wraps quiz screen for Android back button interception
- [x] `_processingNavigated` flag prevents double navigation to results
- [x] `SymbolOption.color` uses `Color` type — implementation must use `IthakiTheme.*` or close color approximations (noted in Task 2 mock data)
- [x] `intl` package required for `DateFormat` in results screen — checked in Task 9
- [x] All 4 routes added to both `routes.dart` and `router.dart`
- [x] `AssessmentCard` covers all 3 status variants (notStarted, inProgress, completed)

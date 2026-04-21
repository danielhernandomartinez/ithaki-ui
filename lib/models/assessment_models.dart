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

  Assessment copyWith({
    String? id,
    String? title,
    String? category,
    String? description,
    String? iconName,
    int? questionCount,
    int? durationMinutes,
    String? language,
    AssessmentStatus? status,
    AssessmentResult? lastResult,
    List<String>? usedFor,
    List<String>? beforeYouStart,
  }) {
    return Assessment(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      questionCount: questionCount ?? this.questionCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      language: language ?? this.language,
      status: status ?? this.status,
      lastResult: lastResult ?? this.lastResult,
      usedFor: usedFor ?? this.usedFor,
      beforeYouStart: beforeYouStart ?? this.beforeYouStart,
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

  AssessmentProgress copyWith({
    String? assessmentId,
    int? currentQuestionIndex,
    Map<String, dynamic>? answers,
  }) {
    return AssessmentProgress(
      assessmentId: assessmentId ?? this.assessmentId,
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

  AssessmentResult copyWith({
    String? assessmentId,
    int? score,
    int? maxScore,
    String? level,
    DateTime? takenAt,
    List<SkillBreakdown>? skillBreakdowns,
    List<String>? keyInsights,
    List<AssessmentResult>? previousResults,
    bool? shownInCV,
  }) {
    return AssessmentResult(
      assessmentId: assessmentId ?? this.assessmentId,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
      level: level ?? this.level,
      takenAt: takenAt ?? this.takenAt,
      skillBreakdowns: skillBreakdowns ?? this.skillBreakdowns,
      keyInsights: keyInsights ?? this.keyInsights,
      previousResults: previousResults ?? this.previousResults,
      shownInCV: shownInCV ?? this.shownInCV,
    );
  }
}

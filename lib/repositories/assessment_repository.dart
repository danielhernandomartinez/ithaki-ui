import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/assessment_models.dart';
import '../services/api_client.dart';

// ---------------------------------------------------------------------------
// Abstract interface
// ---------------------------------------------------------------------------

abstract class AssessmentRepository {
  Future<List<Assessment>> getAssessments();
  Future<List<Question>> getQuestions(String assessmentId);
  Future<AssessmentProgress?> getProgress(String assessmentId);
  Future<void> saveProgress(AssessmentProgress progress);
  Future<void> clearProgress(String assessmentId);
  Future<AssessmentResult?> getResult(String assessmentId);
  Future<AssessmentResult> submitAnswers(
    String assessmentId,
    Map<String, dynamic> answers,
  );
  Future<void> toggleShowInCV(String assessmentId, {required bool show});
}

// ---------------------------------------------------------------------------
// Shared mock data helpers
// ---------------------------------------------------------------------------

AssessmentResult _mockResultFor(String assessmentId) {
  return AssessmentResult(
    assessmentId: assessmentId,
    score: 78,
    maxScore: 100,
    level: 'Strong problem-solving skills',
    takenAt: DateTime(2026, 3, 3),
    skillBreakdowns: const [
      SkillBreakdown(name: 'Critical Thinking', score: 82.0, maxScore: 100.0),
      SkillBreakdown(name: 'Pattern Recognition', score: 75.0, maxScore: 100.0),
      SkillBreakdown(name: 'Logical Reasoning', score: 79.0, maxScore: 100.0),
      SkillBreakdown(name: 'Decision Speed', score: 70.0, maxScore: 100.0),
    ],
    keyInsights: const [
      'You excel at identifying patterns under pressure.',
      'Your logical reasoning is above average for this role category.',
      'Consider practising time-limited decision scenarios to improve speed.',
    ],
    previousResults: [
      AssessmentResult(
        assessmentId: assessmentId,
        score: 60,
        maxScore: 100,
        level: 'Developing',
        takenAt: DateTime(2025, 9, 1),
        skillBreakdowns: const [],
        keyInsights: const [],
      ),
      AssessmentResult(
        assessmentId: assessmentId,
        score: 41,
        maxScore: 100,
        level: 'Beginner',
        takenAt: DateTime(2024, 9, 1),
        skillBreakdowns: const [],
        keyInsights: const [],
      ),
    ],
  );
}

const List<Question> _mockQuestions = [
  // 1. SingleSelectQuestion
  SingleSelectQuestion(
    id: 'q1',
    text: 'Which of the following best describes your primary work style?',
    options: [
      'I prefer working independently on focused tasks',
      'I thrive in collaborative team environments',
      'I adapt easily between solo and team work',
      'I prefer leading and coordinating others',
    ],
  ),
  // 2. MultiSelectQuestion
  MultiSelectQuestion(
    id: 'q2',
    text: 'Which tools do you use regularly in your work? (Select up to 3)',
    options: [
      'Spreadsheets (Excel / Google Sheets)',
      'Project management software (Jira, Trello, etc.)',
      'Communication platforms (Slack, Teams)',
      'Design tools (Figma, Adobe XD)',
      'Code editors (VS Code, IntelliJ)',
      'Data analysis tools (Python, R)',
    ],
    maxSelections: 3,
  ),
  // 3. ImageSelectQuestion
  ImageSelectQuestion(
    id: 'q3',
    text: 'Looking at the scenario depicted, which response would you choose?',
    imageAsset: 'assets/images/ai_banner_bg.png',
    options: [
      'Escalate to a manager immediately',
      'Gather more information before acting',
      'Implement a quick interim solution',
      'Consult colleagues for their perspective',
    ],
  ),
  // 4. RangeNumberQuestion
  RangeNumberQuestion(
    id: 'q4',
    text: 'How comfortable are you working under tight deadlines?',
    min: 1,
    max: 5,
    minLabel: 'Very uncomfortable',
    maxLabel: 'Very comfortable',
  ),
  // 5. RangeSymbolQuestion
  RangeSymbolQuestion(
    id: 'q5',
    text: 'How do you feel when you receive unexpected changes to a project?',
    options: [
      SymbolOption(emoji: '😞', label: 'Very stressed', color: Colors.red),
      SymbolOption(
        emoji: '😟',
        label: 'Somewhat stressed',
        color: Colors.orange,
      ),
      SymbolOption(emoji: '😐', label: 'Neutral', color: Colors.amber),
      SymbolOption(
        emoji: '🙂',
        label: 'Fairly comfortable',
        color: Colors.lightGreen,
      ),
      SymbolOption(
        emoji: '😄',
        label: 'Very comfortable',
        color: Colors.green,
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Mock implementation
// ---------------------------------------------------------------------------

class MockAssessmentRepository implements AssessmentRepository {
  final Map<String, AssessmentProgress> _progress = {};

  final Map<String, AssessmentResult> _results = {
    'adaptability': _mockResultFor('adaptability'),
    'teamwork': _mockResultFor('teamwork'),
    'english': _mockResultFor('english'),
  };

  final Map<String, bool> _shownInCV = {};

  final List<Assessment> _assessments = [
    const Assessment(
      id: 'digital-skills',
      title: 'Digital Skills',
      category: 'Technology',
      description:
          'Assess your proficiency with digital tools and technologies used in modern workplaces.',
      iconName: 'assessment',
      questionCount: 5,
      durationMinutes: 8,
      language: 'English',
      status: AssessmentStatus.inProgress,
      usedFor: ['Tech roles', 'Administrative roles', 'Remote work positions'],
      beforeYouStart: [
        'Find a quiet place with no distractions.',
        'Read each question carefully before answering.',
      ],
    ),
    const Assessment(
      id: 'decision-making',
      title: 'Decision Making',
      category: 'Cognitive',
      description:
          'Evaluate your ability to make sound decisions quickly and under pressure.',
      iconName: 'assessment',
      questionCount: 5,
      durationMinutes: 10,
      language: 'English',
      status: AssessmentStatus.inProgress,
      usedFor: ['Management roles', 'Leadership positions', 'Operations'],
      beforeYouStart: [
        'Answer honestly — there are no universally right answers.',
        'Trust your instincts on time-pressured questions.',
      ],
    ),
    const Assessment(
      id: 'problem-solving',
      title: 'Problem Solving',
      category: 'Cognitive',
      description:
          'Test your analytical thinking and creative problem-solving capabilities.',
      iconName: 'assessment',
      questionCount: 5,
      durationMinutes: 12,
      language: 'English',
      status: AssessmentStatus.notStarted,
      usedFor: ['Engineering roles', 'Consulting', 'Research positions'],
      beforeYouStart: [
        'You can go back and change answers before submitting.',
        'There is no time limit — take your time.',
      ],
    ),
    const Assessment(
      id: 'work-pace',
      title: 'Work Pace & Focus',
      category: 'Work Style',
      description:
          'Understand your preferred working rhythm and concentration style.',
      iconName: 'assessment',
      questionCount: 5,
      durationMinutes: 7,
      language: 'English',
      status: AssessmentStatus.notStarted,
      usedFor: ['All roles', 'Remote work', 'Self-management'],
      beforeYouStart: [
        'Reflect on your typical day at work.',
        'Choose the answer that best matches your natural tendencies.',
      ],
    ),
    const Assessment(
      id: 'adaptability',
      title: 'Adaptability',
      category: 'Soft Skills',
      description:
          'Measure how well you respond to change, uncertainty, and new environments.',
      iconName: 'assessment',
      questionCount: 5,
      durationMinutes: 8,
      language: 'English',
      status: AssessmentStatus.completed,
      usedFor: [
        'Dynamic work environments',
        'Startups',
        'Cross-functional roles'
      ],
      beforeYouStart: [
        'Think about real situations you have faced when answering.',
      ],
    ),
    const Assessment(
      id: 'teamwork',
      title: 'Teamwork & Collaboration',
      category: 'Soft Skills',
      description:
          'Explore your teamwork style and how you contribute to group success.',
      iconName: 'assessment',
      questionCount: 5,
      durationMinutes: 9,
      language: 'English',
      status: AssessmentStatus.completed,
      usedFor: ['Team-based roles', 'Customer-facing roles', 'Project work'],
      beforeYouStart: [
        'Consider how you actually behave in teams, not how you think you should.',
      ],
    ),
    const Assessment(
      id: 'english',
      title: 'English Proficiency',
      category: 'Language',
      description:
          'Evaluate your reading, comprehension, and communication skills in English.',
      iconName: 'assessment',
      questionCount: 5,
      durationMinutes: 15,
      language: 'English',
      status: AssessmentStatus.completed,
      usedFor: [
        'International roles',
        'Client-facing positions',
        'Documentation roles'
      ],
      beforeYouStart: [
        'Complete this assessment without using a dictionary or translation tool.',
        'Read each passage carefully before answering comprehension questions.',
      ],
    ),
  ];

  @override
  Future<List<Assessment>> getAssessments() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _assessments.map((a) {
      final result = _results[a.id];
      if (result == null) return a;
      final shownInCV = _shownInCV[a.id] ?? result.shownInCV;
      return a.copyWith(lastResult: result.copyWith(shownInCV: shownInCV));
    }).toList();
  }

  @override
  Future<List<Question>> getQuestions(String assessmentId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _mockQuestions;
  }

  @override
  Future<AssessmentProgress?> getProgress(String assessmentId) async {
    return _progress[assessmentId];
  }

  @override
  Future<void> saveProgress(AssessmentProgress progress) async {
    _progress[progress.assessmentId] = progress;
    // Promote notStarted → inProgress
    final idx = _assessments.indexWhere((a) => a.id == progress.assessmentId);
    if (idx != -1 && _assessments[idx].status == AssessmentStatus.notStarted) {
      _assessments[idx] =
          _assessments[idx].copyWith(status: AssessmentStatus.inProgress);
    }
  }

  @override
  Future<void> clearProgress(String assessmentId) async {
    _progress.remove(assessmentId);
  }

  @override
  Future<AssessmentResult?> getResult(String assessmentId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final result = _results[assessmentId];
    if (result == null) return null;
    final shownInCV = _shownInCV[assessmentId] ?? result.shownInCV;
    return result.copyWith(shownInCV: shownInCV);
  }

  @override
  Future<AssessmentResult> submitAnswers(
    String assessmentId,
    Map<String, dynamic> answers,
  ) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    final result = _mockResultFor(assessmentId);
    _results[assessmentId] = result;
    await clearProgress(assessmentId);
    final idx = _assessments.indexWhere((a) => a.id == assessmentId);
    if (idx != -1) {
      _assessments[idx] =
          _assessments[idx].copyWith(status: AssessmentStatus.completed);
    }
    return result;
  }

  @override
  Future<void> toggleShowInCV(
    String assessmentId, {
    required bool show,
  }) async {
    _shownInCV[assessmentId] = show;
  }
}

class ApiAssessmentRepository implements AssessmentRepository {
  ApiAssessmentRepository({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  List<dynamic> _extractList(dynamic body) {
    if (body is List) return body;
    if (body is Map) {
      for (final key in const ['content', 'data', 'items', 'questions']) {
        final value = body[key];
        if (value is List) return value;
      }
    }
    return const [];
  }

  Map<String, dynamic>? _extractMap(dynamic body) {
    if (body is Map<String, dynamic>) return body;
    if (body is Map) return body.cast<String, dynamic>();
    return null;
  }

  List<String> _stringList(dynamic raw) {
    if (raw is! List) return const [];
    return raw
        .map((item) {
          if (item is Map) {
            return item['label'] ??
                item['title'] ??
                item['text'] ??
                item['value'] ??
                item['name'];
          }
          return item;
        })
        .whereType<String>()
        .where((value) => value.trim().isNotEmpty)
        .toList();
  }

  AssessmentStatus _status(dynamic raw) {
    final value = raw is Map
        ? (raw['value'] ?? raw['name'] ?? raw['title']).toString()
        : raw?.toString() ?? '';
    final normalized = value.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (normalized.contains('complete')) return AssessmentStatus.completed;
    if (normalized.contains('progress')) return AssessmentStatus.inProgress;
    return AssessmentStatus.notStarted;
  }

  Assessment _assessmentFromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['assessmentId'] ?? '').toString();
    return Assessment(
      id: id,
      title: (json['title'] ?? json['name'] ?? '').toString(),
      category: (json['category'] is Map
                  ? (json['category']['title'] ?? json['category']['name'])
                  : json['category'])
              ?.toString() ??
          '',
      description: (json['description'] ?? '').toString(),
      iconName: (json['iconName'] ?? json['icon'] ?? 'assessment').toString(),
      questionCount:
          ((json['questionCount'] ?? json['questionsCount'] ?? 0) as num?)
                  ?.toInt() ??
              0,
      durationMinutes:
          ((json['durationMinutes'] ?? json['duration'] ?? 0) as num?)
                  ?.toInt() ??
              0,
      language: (json['language'] ?? '').toString(),
      status: _status(json['status']),
      lastResult: _extractMap(json['lastResult'] ?? json['result']) == null
          ? null
          : _resultFromJson(
              _extractMap(json['lastResult'] ?? json['result'])!,
              fallbackAssessmentId: id,
            ),
      usedFor: _stringList(json['usedFor']),
      beforeYouStart: _stringList(json['beforeYouStart']),
    );
  }

  Question _questionFromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['questionId'] ?? '').toString();
    final text =
        (json['text'] ?? json['title'] ?? json['question'] ?? '').toString();
    final type =
        (json['type'] ?? json['questionType'] ?? '').toString().toLowerCase();
    final options = _stringList(json['options']);

    if (type.contains('multi')) {
      return MultiSelectQuestion(
        id: id,
        text: text,
        options: options,
        maxSelections:
            ((json['maxSelections'] ?? options.length) as num?)?.toInt() ??
                options.length,
      );
    }
    if (type.contains('range') && type.contains('symbol')) {
      return RangeSymbolQuestion(
        id: id,
        text: text,
        options: options
            .map((label) =>
                SymbolOption(emoji: '', label: label, color: Colors.grey))
            .toList(),
      );
    }
    if (type.contains('range')) {
      return RangeNumberQuestion(
        id: id,
        text: text,
        min: ((json['min'] ?? 1) as num?)?.toInt() ?? 1,
        max: ((json['max'] ?? 5) as num?)?.toInt() ?? 5,
        minLabel: (json['minLabel'] ?? '').toString(),
        maxLabel: (json['maxLabel'] ?? '').toString(),
      );
    }
    if (type.contains('image')) {
      return ImageSelectQuestion(
        id: id,
        text: text,
        imageAsset: (json['imageAsset'] ?? json['imageUrl'] ?? '').toString(),
        options: options,
      );
    }
    return SingleSelectQuestion(id: id, text: text, options: options);
  }

  AssessmentProgress _progressFromJson(Map<String, dynamic> json) {
    final answersRaw = json['answers'];
    return AssessmentProgress(
      assessmentId: (json['assessmentId'] ?? '').toString(),
      currentQuestionIndex:
          ((json['currentQuestionIndex'] ?? json['questionIndex'] ?? 0) as num?)
                  ?.toInt() ??
              0,
      answers: answersRaw is Map<String, dynamic>
          ? answersRaw
          : answersRaw is Map
              ? answersRaw.cast<String, dynamic>()
              : const {},
    );
  }

  AssessmentResult _resultFromJson(
    Map<String, dynamic> json, {
    String? fallbackAssessmentId,
  }) {
    return AssessmentResult(
      assessmentId:
          (json['assessmentId'] ?? fallbackAssessmentId ?? '').toString(),
      score: ((json['score'] ?? 0) as num?)?.toInt() ?? 0,
      maxScore: ((json['maxScore'] ?? 100) as num?)?.toInt() ?? 100,
      level: (json['level'] ?? json['summary'] ?? '').toString(),
      takenAt: DateTime.tryParse(
              (json['takenAt'] ?? json['createdAt'] ?? '').toString()) ??
          DateTime.now(),
      skillBreakdowns: _extractList(json['skillBreakdowns'])
          .whereType<Map>()
          .map((item) => item.cast<String, dynamic>())
          .map(
            (item) => SkillBreakdown(
              name: (item['name'] ?? item['title'] ?? '').toString(),
              score: ((item['score'] ?? 0) as num?)?.toDouble() ?? 0,
              maxScore: ((item['maxScore'] ?? 100) as num?)?.toDouble() ?? 100,
            ),
          )
          .toList(),
      keyInsights: _stringList(json['keyInsights'] ?? json['insights']),
      previousResults: _extractList(json['previousResults'])
          .whereType<Map>()
          .map(
            (item) => _resultFromJson(
              item.cast<String, dynamic>(),
              fallbackAssessmentId: fallbackAssessmentId,
            ),
          )
          .toList(),
      shownInCV: json['shownInCV'] == true || json['showInCv'] == true,
    );
  }

  @override
  Future<List<Assessment>> getAssessments() async {
    final res = await _api.get('/assessments');
    if (res.statusCode != 200) {
      throw Exception('Failed to load assessments: ${res.statusCode}');
    }
    final body = jsonDecode(res.body);
    return _extractList(body)
        .whereType<Map>()
        .map((item) => _assessmentFromJson(item.cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<List<Question>> getQuestions(String assessmentId) async {
    final res = await _api.get('/assessments/$assessmentId/questions');
    if (res.statusCode != 200) {
      throw Exception('Failed to load assessment questions: ${res.statusCode}');
    }
    final body = jsonDecode(res.body);
    return _extractList(body)
        .whereType<Map>()
        .map((item) => _questionFromJson(item.cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<AssessmentProgress?> getProgress(String assessmentId) async {
    final res =
        await _api.get('/job-seeker/me/assessments/$assessmentId/progress');
    if (res.statusCode == 404) return null;
    if (res.statusCode != 200) {
      throw Exception('Failed to load assessment progress: ${res.statusCode}');
    }
    final map = _extractMap(jsonDecode(res.body));
    return map == null ? null : _progressFromJson(map);
  }

  @override
  Future<void> saveProgress(AssessmentProgress progress) => _api.postJson(
        '/job-seeker/me/assessments/${progress.assessmentId}/progress',
        {
          'currentQuestionIndex': progress.currentQuestionIndex,
          'answers': progress.answers,
        },
      );

  @override
  Future<void> clearProgress(String assessmentId) => _api.postJson(
        '/job-seeker/me/assessments/$assessmentId/progress/clear',
        {},
      );

  @override
  Future<AssessmentResult?> getResult(String assessmentId) async {
    final res =
        await _api.get('/job-seeker/me/assessments/$assessmentId/result');
    if (res.statusCode == 404) return null;
    if (res.statusCode != 200) {
      throw Exception('Failed to load assessment result: ${res.statusCode}');
    }
    final map = _extractMap(jsonDecode(res.body));
    return map == null
        ? null
        : _resultFromJson(map, fallbackAssessmentId: assessmentId);
  }

  @override
  Future<AssessmentResult> submitAnswers(
    String assessmentId,
    Map<String, dynamic> answers,
  ) async {
    final token = await _api.requireToken();
    final uri = _api.uri('/job-seeker/me/assessments/$assessmentId/submit');
    final res = await _api.client
        .post(
          uri,
          headers: _api.jsonHeaders(token: token),
          body: jsonEncode({'answers': answers}),
        )
        .timeout(ApiClient.timeout);
    ApiClient.log('POST', uri, res.statusCode);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception(_api.readErrorBody(res));
    }
    final map = _extractMap(jsonDecode(res.body));
    if (map == null) {
      throw Exception('Assessment submit response was empty');
    }
    return _resultFromJson(map, fallbackAssessmentId: assessmentId);
  }

  @override
  Future<void> toggleShowInCV(String assessmentId, {required bool show}) =>
      _api.postJson(
        '/job-seeker/me/assessments/$assessmentId/cv',
        {'shownInCV': show},
      );
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final assessmentRepositoryProvider = Provider<AssessmentRepository>(
  (ref) => AppConfig.shouldUseMockData
      ? MockAssessmentRepository()
      : ApiAssessmentRepository(apiClient: ref.watch(apiClientProvider)),
);

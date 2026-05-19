import 'dart:convert';

import 'package:flutter/material.dart';

import '../../models/assessment_models.dart';
import '../../services/api_client.dart';
import '../assessment_repository.dart';

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
      throw Exception(
        'Failed to load assessments (${res.statusCode}): ${_api.readErrorBody(res)}',
      );
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
      throw Exception(
        'Failed to load assessment questions (${res.statusCode}): ${_api.readErrorBody(res)}',
      );
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
      throw Exception(
        'Failed to load assessment progress (${res.statusCode}): ${_api.readErrorBody(res)}',
      );
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
      throw Exception(
        'Failed to load assessment result (${res.statusCode}): ${_api.readErrorBody(res)}',
      );
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

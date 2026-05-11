import '../../data/mock_assessment_data.dart';
import '../../models/assessment_models.dart';
import '../assessment_repository.dart';

class MockAssessmentRepository implements AssessmentRepository {
  final Map<String, AssessmentProgress> _progress = {};

  final Map<String, AssessmentResult> _results = {
    'adaptability': mockResultFor('adaptability'),
    'teamwork': mockResultFor('teamwork'),
    'english': mockResultFor('english'),
  };

  final Map<String, bool> _shownInCV = {};

  final List<Assessment> _assessments = List.of(mockAssessments);

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
    return mockAssessmentQuestions;
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
    final result = mockResultFor(assessmentId);
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

import '../models/assessment_models.dart';

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

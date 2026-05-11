import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/assessment_models.dart';
import '../services/api_client.dart';
import 'assessment/api_assessment_repository.dart';
import 'assessment/mock_assessment_repository.dart';

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

final assessmentRepositoryProvider = Provider<AssessmentRepository>(
  (ref) => AppConfig.shouldUseMockData
      ? MockAssessmentRepository()
      : ApiAssessmentRepository(apiClient: ref.watch(apiClientProvider)),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/job_detail_models.dart';
import '../repositories/job_detail_repository.dart';
import '../services/api_client.dart';

final jobDetailRepositoryProvider = Provider<JobDetailRepository>(
  (ref) => AppConfig.shouldUseMockData
      ? MockJobDetailRepository()
      : ApiJobDetailRepository(apiClient: ref.watch(apiClientProvider)),
);

final jobDetailProvider = FutureProvider.family<JobDetail, String>(
  (ref, jobId) async {
    try {
      return await ref.watch(jobDetailRepositoryProvider).getJobDetail(jobId);
    } catch (_) {
      if (AppConfig.shouldUseMockData) {
        return MockJobDetailRepository().getJobDetail(jobId);
      }
      rethrow;
    }
  },
);

class JobDetailInteractionState {
  const JobDetailInteractionState({
    this.hasReminder = false,
    this.isNotInterested = false,
  });

  final bool hasReminder;
  final bool isNotInterested;

  JobDetailInteractionState copyWith({
    bool? hasReminder,
    bool? isNotInterested,
  }) {
    return JobDetailInteractionState(
      hasReminder: hasReminder ?? this.hasReminder,
      isNotInterested: isNotInterested ?? this.isNotInterested,
    );
  }
}

class JobDetailInteractionNotifier extends Notifier<JobDetailInteractionState> {
  JobDetailInteractionNotifier(this.jobId);

  final String jobId;

  @override
  JobDetailInteractionState build() => const JobDetailInteractionState();

  void setReminder() {
    state = state.copyWith(hasReminder: true);
  }

  void deleteReminder() {
    state = state.copyWith(hasReminder: false);
  }

  void markNotInterested() {
    state = state.copyWith(isNotInterested: true);
  }

  void undoNotInterested() {
    state = state.copyWith(isNotInterested: false);
  }
}

final jobDetailInteractionProvider = NotifierProvider.family<
    JobDetailInteractionNotifier, JobDetailInteractionState, String>(
  JobDetailInteractionNotifier.new,
);

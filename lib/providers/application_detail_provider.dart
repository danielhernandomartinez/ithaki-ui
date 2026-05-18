import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/application_detail_models.dart';
import '../repositories/application_detail_repository.dart';
import '../services/api_client.dart';
import 'profile_provider.dart';

final applicationDetailRepositoryProvider =
    Provider<ApplicationDetailRepository>(
  (ref) => AppConfig.useMockData
      ? MockApplicationDetailRepository()
      : ApiApplicationDetailRepository(apiClient: ref.watch(apiClientProvider)),
);

final applicationDetailProvider =
    FutureProvider.family<ApplicationDetail?, String>((ref, id) async {
  final detail = await ref
      .watch(applicationDetailRepositoryProvider)
      .getApplicationDetail(id);
  if (detail == null) return null;

  final basics = ref.watch(profileBasicsProvider).value;
  if (basics == null || basics.firstName.isEmpty) return detail;

  final candidate = detail.candidate.copyWith(
    name: '${basics.firstName} ${basics.lastName}'.trim(),
    email: basics.email.isNotEmpty ? basics.email : null,
    phone: basics.phone.isNotEmpty ? basics.phone : null,
    gender: basics.gender.isNotEmpty ? basics.gender : null,
    citizenship: basics.citizenship.isNotEmpty ? basics.citizenship : null,
    photoUrl: basics.photoUrl,
  );

  return detail.copyWith(candidate: candidate);
});

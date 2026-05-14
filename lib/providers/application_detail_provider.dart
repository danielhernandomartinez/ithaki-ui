import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/application_detail_models.dart';
import '../repositories/application_detail_repository.dart';
import 'profile_provider.dart';

final applicationDetailRepositoryProvider =
    Provider<ApplicationDetailRepository>(
  (ref) => MockApplicationDetailRepository(),
);

final applicationDetailProvider =
    Provider.family<ApplicationDetail?, String>((ref, id) {
  final detail =
      ref.watch(applicationDetailRepositoryProvider).getApplicationDetail(id);
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

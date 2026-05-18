import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/applications_models.dart';
import '../repositories/invitations_repository.dart';
import '../services/api_client.dart';
import 'swr_async_notifier.dart';

final invitationsRepositoryProvider = Provider<InvitationsRepository>(
  (ref) => AppConfig.useMockData
      ? MockInvitationsRepository()
      : ApiInvitationsRepository(apiClient: ref.watch(apiClientProvider)),
);

final invitationsProvider =
    AsyncNotifierProvider<InvitationsNotifier, List<Invitation>>(
  InvitationsNotifier.new,
);

final pendingDismissIdProvider =
    NotifierProvider<PendingDismissNotifier, String?>(
  PendingDismissNotifier.new,
);

class PendingDismissNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  // ignore: use_setters_to_change_properties
  void set(String? id) => state = id;
}

class InvitationsNotifier extends SwrAsyncNotifier<List<Invitation>> {
  Timer? _dismissTimer;

  @override
  String get cacheKey => 'invitations';

  @override
  Future<List<Invitation>> build() {
    ref.onDispose(() => _dismissTimer?.cancel());
    return super.build();
  }

  @override
  Future<List<Invitation>> load() =>
      ref.read(invitationsRepositoryProvider).getInvitations();

  void scheduleDismiss(String invitationId, String dismissedAt) {
    _dismissTimer?.cancel();
    ref.read(pendingDismissIdProvider.notifier).set(invitationId);
    _dismissTimer = Timer(const Duration(seconds: 5), () async {
      await dismiss(invitationId, dismissedAt);
      if (ref.mounted) {
        ref.read(pendingDismissIdProvider.notifier).set(null);
      }
    });
  }

  void cancelDismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    ref.read(pendingDismissIdProvider.notifier).set(null);
  }

  Future<void> dismiss(String invitationId, String dismissedAt) async {
    await ref
        .read(invitationsRepositoryProvider)
        .dismissInvitation(invitationId);
    final updated = state.value?.map((i) {
          if (i.id != invitationId) return i;
          return i.copyWith(isDismissed: true, dismissedAt: dismissedAt);
        }).toList() ??
        [];
    state = AsyncData(updated);
    cacheValue(updated);
  }
}

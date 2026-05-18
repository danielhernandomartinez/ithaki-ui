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

class InvitationsNotifier extends SwrAsyncNotifier<List<Invitation>> {
  @override
  String get cacheKey => 'invitations';

  @override
  Future<List<Invitation>> load() =>
      ref.read(invitationsRepositoryProvider).getInvitations();

  Future<void> dismiss(String invitationId) async {
    await ref
        .read(invitationsRepositoryProvider)
        .dismissInvitation(invitationId);
    final updated = state.value?.map((i) {
          if (i.id != invitationId) return i;
          return i.copyWith(isDismissed: true, dismissedAt: _nowLabel());
        }).toList() ??
        [];
    state = AsyncData(updated);
    cacheValue(updated);
  }

  static String _nowLabel() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return 'Today, $h:$m';
  }
}

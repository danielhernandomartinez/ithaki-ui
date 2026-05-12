import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notifications_models.dart';
import '../repositories/notifications_repository.dart';

class NotificationsNotifier extends AsyncNotifier<List<NotificationItem>> {
  @override
  Future<List<NotificationItem>> build() {
    return ref.read(notificationsRepositoryProvider).getNotifications();
  }

  Future<void> markAllAsRead() async {
    final current = state.value ?? const <NotificationItem>[];
    state = AsyncData([
      for (final item in current) item.copyWith(isUnread: false),
    ]);
    await ref.read(notificationsRepositoryProvider).markAllAsRead();
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<NotificationItem>>(
  NotificationsNotifier.new,
);

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final items = ref.watch(notificationsProvider).value ?? const [];
  return items.where((item) => item.isUnread).length;
});

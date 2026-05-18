import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/notifications_models.dart';
import '../repositories/notifications_repository.dart';
import '../services/api_client.dart';
import 'swr_async_notifier.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>(
  (ref) => AppConfig.useMockData
      ? MockNotificationsRepository()
      : ApiNotificationsRepository(apiClient: ref.watch(apiClientProvider)),
);

class NotificationsNotifier extends SwrAsyncNotifier<List<NotificationItem>> {
  @override
  String get cacheKey => 'notifications';

  @override
  Future<List<NotificationItem>> load() =>
      ref.read(notificationsRepositoryProvider).getNotifications();

  Future<void> markAllAsRead() async {
    final current = state.value ?? const <NotificationItem>[];
    final updated = [
      for (final item in current) item.copyWith(isUnread: false),
    ];
    state = AsyncData(updated);
    cacheValue(updated);
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

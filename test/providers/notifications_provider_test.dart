import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ithaki_ui/models/notifications_models.dart';
import 'package:ithaki_ui/providers/notifications_provider.dart';
import 'package:ithaki_ui/repositories/notifications_repository.dart';

class _FakeNotificationsRepository implements NotificationsRepository {
  bool markedAllAsRead = false;

  @override
  Future<List<NotificationItem>> getNotifications() async => const [
        NotificationItem(
          id: 'from-repository',
          kind: NotificationKind.applicationReminder,
          title: 'Repository notification',
          message: 'This came from the repository.',
          timestampLabel: 'Now',
          isUnread: true,
        ),
      ];

  @override
  Future<void> markAllAsRead() async {
    markedAllAsRead = true;
  }
}

void main() {
  test('notificationsProvider loads notifications from repository', () async {
    final repository = _FakeNotificationsRepository();
    final container = ProviderContainer.test(
      overrides: [
        notificationsRepositoryProvider.overrideWithValue(repository),
      ],
    );

    final items = await container.read(notificationsProvider.future);

    expect(items.single.id, 'from-repository');
    expect(items.single.title, 'Repository notification');
  });

  test('markAllAsRead persists via repository and updates unread count',
      () async {
    final repository = _FakeNotificationsRepository();
    final container = ProviderContainer.test(
      overrides: [
        notificationsRepositoryProvider.overrideWithValue(repository),
      ],
    );

    await container.read(notificationsProvider.future);
    await container.read(notificationsProvider.notifier).markAllAsRead();

    expect(repository.markedAllAsRead, isTrue);
    expect(container.read(unreadNotificationsCountProvider), 0);
    expect(
      container.read(notificationsProvider).requireValue.single.isUnread,
      isFalse,
    );
  });
}

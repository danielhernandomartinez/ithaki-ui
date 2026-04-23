import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/notifications_models.dart';

class NotificationsNotifier extends Notifier<List<NotificationItem>> {
  @override
  List<NotificationItem> build() {
    return const [
      NotificationItem(
        id: 'application-viewed-1',
        kind: NotificationKind.applicationViewed,
        title: 'Your application was viewed!',
        message: 'TechWave has viewed your application. Get ready!',
        timestampLabel: 'Today, 09:00',
        isUnread: true,
      ),
      NotificationItem(
        id: 'application-sent-1',
        kind: NotificationKind.applicationSent,
        title: 'Application sent successfully',
        message:
            'Your application for Front-End Developer at TechWave has been submitted. You can track its status on My Applications.',
        timestampLabel: 'Today, 09:00',
        isUnread: true,
      ),
      NotificationItem(
        id: 'invitation-received-1',
        kind: NotificationKind.invitationReceived,
        title: 'Invitation received',
        message:
            'Your received an invitation to the job for Front-End Developer at TechWave. You can check it on My Applications.',
        timestampLabel: 'Today, 09:00',
      ),
      NotificationItem(
        id: 'application-declined-1',
        kind: NotificationKind.applicationDeclined,
        title: 'Application declined',
        message:
            'Unfortunately, you were not selected for this position. You can explore similar openings on Jobs.',
        timestampLabel: 'Today, 09:00',
      ),
      NotificationItem(
        id: 'application-reminder-1',
        kind: NotificationKind.applicationReminder,
        title: 'Application Reminder',
        message:
            'In one week application will be closed for Front-End Developer at TechnoSound. Complete your application!',
        timestampLabel: 'Today, 09:00',
      ),
      NotificationItem(
        id: 'application-viewed-2',
        kind: NotificationKind.applicationViewed,
        title: 'Your application was viewed!',
        message: 'TechWave has viewed your application. Get ready!',
        timestampLabel: 'Today, 09:00',
      ),
      NotificationItem(
        id: 'application-viewed-3',
        kind: NotificationKind.applicationViewed,
        title: 'Your application was viewed!',
        message: 'TechWave has viewed your application. Get ready!',
        timestampLabel: 'Today, 09:00',
      ),
    ];
  }

  void markAllAsRead() {
    state = [
      for (final item in state) item.copyWith(isUnread: false),
    ];
  }
}

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, List<NotificationItem>>(
  NotificationsNotifier.new,
);

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final items = ref.watch(notificationsProvider);
  return items.where((item) => item.isUnread).length;
});

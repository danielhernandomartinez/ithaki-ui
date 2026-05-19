import 'dart:convert';

import '../models/notifications_models.dart';
import '../services/api_client.dart';
import '../utils/api_mappers.dart' as mapper;

abstract class NotificationsRepository {
  Future<List<NotificationItem>> getNotifications();
  Future<void> markAllAsRead();
}

class MockNotificationsRepository implements NotificationsRepository {
  @override
  Future<List<NotificationItem>> getNotifications() async => const [
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
              'You received an invitation for Front-End Developer at TechWave. You can check it on My Applications.',
          timestampLabel: 'Today, 09:00',
        ),
      ];

  @override
  Future<void> markAllAsRead() async {}
}

class ApiNotificationsRepository implements NotificationsRepository {
  ApiNotificationsRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<List<NotificationItem>> getNotifications() async {
    final response = await _api.get('/notifications');
    if (response.statusCode != 200) return const [];
    if (response.body.trim().isEmpty) return const [];

    final decoded = jsonDecode(response.body);
    return mapper
        .extractList(decoded)
        .whereType<Map>()
        .map((item) => _parseNotification(Map<String, dynamic>.from(item)))
        .where((item) => item.title.isNotEmpty || item.message.isNotEmpty)
        .toList();
  }

  @override
  Future<void> markAllAsRead() =>
      _api.postJson('/notifications/mark-all-read', {});

  static NotificationItem _parseNotification(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['notificationId'] ?? '').toString();
    final title = (json['title'] ?? json['subject'] ?? '').toString();
    final message = (json['message'] ??
            json['body'] ??
            json['description'] ??
            json['content'] ??
            '')
        .toString();
    final timestampLabel =
        (json['timestampLabel'] ?? json['createdAt'] ?? json['timestamp'] ?? '')
            .toString();
    final kind = _parseKind(
      (json['kind'] ?? json['type'] ?? json['category'] ?? '').toString(),
    );
    final isUnread = json['isUnread'] == true ||
        json['unread'] == true ||
        json['read'] == false ||
        (json.containsKey('readAt') && json['readAt'] == null);

    return NotificationItem(
      id: id.isNotEmpty ? id : '${kind.name}-$timestampLabel-$title',
      kind: kind,
      title: title,
      message: message,
      timestampLabel: timestampLabel,
      isUnread: isUnread,
    );
  }

  static NotificationKind _parseKind(String value) {
    final normalized = value.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (normalized.contains('sent') || normalized.contains('submitted')) {
      return NotificationKind.applicationSent;
    }
    if (normalized.contains('invite')) {
      return NotificationKind.invitationReceived;
    }
    if (normalized.contains('declined') || normalized.contains('rejected')) {
      return NotificationKind.applicationDeclined;
    }
    if (normalized.contains('reminder')) {
      return NotificationKind.applicationReminder;
    }
    return NotificationKind.applicationViewed;
  }
}

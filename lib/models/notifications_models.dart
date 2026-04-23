enum NotificationKind {
  applicationViewed,
  applicationSent,
  invitationReceived,
  applicationDeclined,
  applicationReminder,
}

class NotificationItem {
  final String id;
  final NotificationKind kind;
  final String title;
  final String message;
  final String timestampLabel;
  final bool isUnread;

  const NotificationItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.message,
    required this.timestampLabel,
    this.isUnread = false,
  });

  NotificationItem copyWith({
    NotificationKind? kind,
    String? title,
    String? message,
    String? timestampLabel,
    bool? isUnread,
  }) {
    return NotificationItem(
      id: id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      message: message ?? this.message,
      timestampLabel: timestampLabel ?? this.timestampLabel,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}

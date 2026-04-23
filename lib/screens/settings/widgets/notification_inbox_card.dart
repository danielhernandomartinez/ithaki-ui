import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../models/notifications_models.dart';

class NotificationInboxCard extends StatelessWidget {
  const NotificationInboxCard({
    super.key,
    required this.item,
  });

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: item.isUnread
            ? IthakiTheme.chipActive
            : IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
        border: item.isUnread
            ? Border.all(color: IthakiTheme.primaryPurple, width: 1.2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NotificationIcon(kind: item.kind),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.title,
                  style: IthakiTheme.bodySmallBold.copyWith(
                    height: 1.2,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                item.timestampLabel,
                style: IthakiTheme.bodySmall.copyWith(
                  color: IthakiTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.message,
            style: IthakiTheme.bodyRegular.copyWith(
              color: const Color(0xFF454545),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.kind});

  final NotificationKind kind;

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case NotificationKind.applicationViewed:
      case NotificationKind.applicationSent:
      case NotificationKind.invitationReceived:
        return const IthakiIcon(
          'rocket',
          size: 22,
          color: IthakiTheme.primaryPurple,
        );
      case NotificationKind.applicationDeclined:
        return Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: IthakiTheme.primaryPurple, width: 1.6),
          ),
          alignment: Alignment.center,
          child: Container(
            width: 8,
            height: 1.6,
            color: IthakiTheme.primaryPurple,
          ),
        );
      case NotificationKind.applicationReminder:
        return const IthakiIcon(
          'clock',
          size: 22,
          color: IthakiTheme.primaryPurple,
        );
    }
  }
}

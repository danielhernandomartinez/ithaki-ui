import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/home_provider.dart';
import '../../providers/notifications_provider.dart';
import 'widgets/notification_inbox_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);
    final notifier = ref.read(notificationsProvider.notifier);
    final homeData = ref.watch(homeProvider).value;
    final avatarInitials = homeData?.userInitials.isNotEmpty == true
        ? homeData!.userInitials
        : 'AA';

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        avatarInitials: avatarInitials,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.viewPaddingOf(context).bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: _PlatformPill(label: 'ithaki.com')),
            const SizedBox(height: 16),
            _buildSummaryCard(
              unreadCount: unreadCount,
              onMarkAllAsRead: unreadCount == 0 ? null : notifier.markAllAsRead,
            ),
            const SizedBox(height: 14),
            ...notifications.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NotificationInboxCard(item: item),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: IthakiTheme.borderLight),
            IthakiFooter(
              brandName: 'Odyssea',
              copyright:
                  'Copyright © Ithaki 2025. #1 Job-Seeker service in\nGreece',
              privacyLabel: 'Privacy Policy',
              termsLabel: 'Terms of Use',
              socialIcons: const [
                IthakiIcon('tiktok', size: 24, color: IthakiTheme.softGraphite),
                IthakiIcon('youtube',
                    size: 24, color: IthakiTheme.softGraphite),
                IthakiIcon('instagram',
                    size: 24, color: IthakiTheme.softGraphite),
                IthakiIcon('linkedin',
                    size: 24, color: IthakiTheme.softGraphite),
                IthakiIcon('facebook',
                    size: 24, color: IthakiTheme.softGraphite),
                IthakiIcon('x', size: 24, color: IthakiTheme.softGraphite),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required int unreadCount,
    required VoidCallback? onMarkAllAsRead,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: IthakiTheme.headingLarge.copyWith(
              color: IthakiTheme.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Here you can see all your news. Stay up to\ndate with important updates.',
            style: IthakiTheme.bodyRegular.copyWith(
              color: IthakiTheme.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You have $unreadCount new notifications',
            style: IthakiTheme.bodyRegular.copyWith(
              color: IthakiTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onMarkAllAsRead,
            style: OutlinedButton.styleFrom(
              foregroundColor: IthakiTheme.textPrimary,
              minimumSize: const Size.fromHeight(40),
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: IthakiTheme.softGraphite),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: Text(
              'Mark all as read',
              style: IthakiTheme.bodyRegular.copyWith(
                color: IthakiTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformPill extends StatelessWidget {
  const _PlatformPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        label,
        style: IthakiTheme.bodySmall.copyWith(
          color: IthakiTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

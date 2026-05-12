import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/home_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../routes.dart';
import '../../widgets/main_panel_scaffold.dart';
import 'widgets/notification_inbox_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);
    final notifier = ref.read(notificationsProvider.notifier);
    final homeData = ref.watch(homeProvider).value;
    final avatarInitials = homeData?.userInitials.isNotEmpty == true
        ? homeData!.userInitials
        : 'AA';

    return MainPanelScaffold(
      currentRoute: Routes.settingsNotifications,
      avatarInitials: avatarInitials,
      avatarUrl: homeData?.userPhotoUrl,
      bodyBuilder: (context, ref, topOffset) => SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: topOffset + 12,
          bottom: MediaQuery.viewPaddingOf(context).bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryCard(
              unreadCount: unreadCount,
              onMarkAllAsRead: unreadCount == 0
                  ? null
                  : () {
                      notifier.markAllAsRead();
                    },
              l10n: AppLocalizations.of(context)!,
            ),
            notificationsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  AppLocalizations.of(context)!.errorMessage(error.toString()),
                  style: IthakiTheme.bodyRegular.copyWith(
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
              data: (notifications) => Column(
                children: [
                  const SizedBox(height: 14),
                  ...notifications.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NotificationInboxCard(item: item),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.unreadCount,
    required this.onMarkAllAsRead,
    required this.l10n,
  });

  final int unreadCount;
  final VoidCallback? onMarkAllAsRead;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
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
            l10n.notificationsLabel,
            style: IthakiTheme.headingLarge.copyWith(
              color: IthakiTheme.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.notificationsScreenSubtitle,
            style: IthakiTheme.bodyRegular.copyWith(
              color: IthakiTheme.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.notificationsUnreadCount(unreadCount),
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
              l10n.markAllAsRead,
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

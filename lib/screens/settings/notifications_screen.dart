import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../constants/nav_items.dart';
import '../../l10n/app_localizations.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/home_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/profile_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import 'widgets/notification_inbox_card.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;

  @override
  void initState() {
    super.initState();
    _panels = PanelMenuController(setState)..init(this);
  }

  @override
  void dispose() {
    _panels.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);
    final notifier = ref.read(notificationsProvider.notifier);
    final homeData = ref.watch(homeProvider).value;
    final avatarInitials = homeData?.userInitials.isNotEmpty == true
        ? homeData!.userInitials
        : 'AA';
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        menuOpen: _panels.menuOpen,
        profileOpen: _panels.profileOpen,
        avatarInitials: avatarInitials,
        avatarUrl: homeData?.userPhotoUrl,
        onNotificationsPressed: () => context.go(Routes.settingsNotifications),
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: topOffset + 12,
              bottom: MediaQuery.viewPaddingOf(context).bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(
                  unreadCount: unreadCount,
                  onMarkAllAsRead:
                      unreadCount == 0 ? null : notifier.markAllAsRead,
                  l10n: AppLocalizations.of(context)!,
                ),
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
          if (_panels.menuOpen || _panels.profileOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _panels.closeMenu();
                  _panels.closeProfile();
                },
                child: Container(color: Colors.transparent),
              ),
            ),
          if (_panels.profileOpen ||
              _panels.profileCtrl.status != AnimationStatus.dismissed)
            Positioned(
              top: topOffset - 14,
              left: 16,
              right: 16,
              bottom: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SlideTransition(
                  position: _panels.profileSlideAnim,
                  child: ProfileMenuPanel(
                    onItemTap: (item) {
                      _panels.closeProfile();
                      if (item.route.isNotEmpty) context.push(item.route);
                    },
                    onLogOut: () {
                      _panels.closeProfile();
                      ref
                          .read(authRepositoryProvider)
                          .logout()
                          .whenComplete(() {
                        resetProfileProviders(ref);
                        if (context.mounted) context.go(Routes.root);
                      });
                    },
                  ),
                ),
              ),
            ),
          if (_panels.menuOpen ||
              _panels.menuCtrl.status != AnimationStatus.dismissed)
            Positioned(
              top: topOffset - 14,
              left: 16,
              right: 16,
              bottom: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SlideTransition(
                  position: _panels.slideAnim,
                  child: AppNavDrawer(
                    currentRoute: Routes.settingsNotifications,
                    profileProgress: ref.watch(profileCompletionProvider),
                    items: kAppNavItems,
                    onItemTap: (item) {
                      _panels.closeMenu();
                      context.go(item.route);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required int unreadCount,
    required VoidCallback? onMarkAllAsRead,
    required AppLocalizations l10n,
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

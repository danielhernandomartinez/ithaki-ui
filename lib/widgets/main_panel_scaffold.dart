import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../constants/nav_items.dart';
import '../l10n/app_localizations.dart';
import '../mixins/panel_menu_mixin.dart';
import '../providers/profile_provider.dart';
import '../repositories/auth_repository.dart';
import '../routes.dart';
import '../utils/layout_offsets.dart';
import 'app_nav_drawer.dart';
import 'profile_menu_panel.dart';

typedef MainPanelBodyBuilder = Widget Function(
  BuildContext context,
  WidgetRef ref,
  double topOffset,
);

typedef MainPanelOverlayBuilder = List<Widget> Function(
  BuildContext context,
  WidgetRef ref,
  double topOffset,
);

class MainPanelScaffold extends ConsumerStatefulWidget {
  const MainPanelScaffold({
    super.key,
    required this.currentRoute,
    required this.bodyBuilder,
    this.overlayBuilder,
    this.avatarInitials = '',
    this.avatarUrl,
    this.title,
    this.showBackButton = false,
    this.enableNavDrawer = true,
    this.onMenuPressed,
    this.onBeforePanelAction,
    this.onNavItemTap,
    this.onNotificationsPressed,
    this.extendBodyBehindAppBar = true,
  });

  final String currentRoute;
  final MainPanelBodyBuilder bodyBuilder;
  final MainPanelOverlayBuilder? overlayBuilder;
  final String avatarInitials;
  final String? avatarUrl;
  final String? title;
  final bool showBackButton;
  final bool enableNavDrawer;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onBeforePanelAction;
  final void Function(BuildContext context, NavItem item)? onNavItemTap;
  final VoidCallback? onNotificationsPressed;
  final bool extendBodyBehindAppBar;

  @override
  ConsumerState<MainPanelScaffold> createState() => _MainPanelScaffoldState();
}

class _MainPanelScaffoldState extends ConsumerState<MainPanelScaffold>
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

  void _toggleMenu() {
    if (widget.onMenuPressed != null) {
      widget.onBeforePanelAction?.call();
      widget.onMenuPressed!.call();
      return;
    }
    if (!widget.enableNavDrawer) return;
    widget.onBeforePanelAction?.call();
    _panels.toggleMenu();
  }

  void _toggleProfile() {
    widget.onBeforePanelAction?.call();
    _panels.toggleProfile();
  }

  void _closePanels() {
    widget.onBeforePanelAction?.call();
    _panels.closeMenu();
    _panels.closeProfile();
  }

  void _handleNavItemTap(NavItem item) {
    widget.onBeforePanelAction?.call();
    _panels.closeMenu();
    if (widget.onNavItemTap != null) {
      widget.onNavItemTap!(context, item);
      return;
    }
    if (item.route != widget.currentRoute) {
      context.go(item.route);
    }
  }

  void _handleProfileItemTap(ProfileMenuItem item) {
    widget.onBeforePanelAction?.call();
    _panels.closeProfile();
    navigateToProfileMenuRoute(context, item);
  }

  void _handleNotificationsPressed() {
    widget.onBeforePanelAction?.call();
    _panels.closeMenu();
    _panels.closeProfile();
    if (widget.currentRoute == Routes.settingsNotifications) return;
    if (widget.onNotificationsPressed != null) {
      widget.onNotificationsPressed!.call();
      return;
    }
    context.push(Routes.settingsNotifications);
  }

  void _handleLogOut() {
    widget.onBeforePanelAction?.call();
    _panels.closeProfile();
    final router = GoRouter.of(context);
    ref.read(authRepositoryProvider).logout().whenComplete(() {
      resetProfileProviders(ref);
      if (mounted) router.go(Routes.root);
    });
  }

  @override
  Widget build(BuildContext context) {
    final topOffset = context.ithakiTopOffset;
    final title =
        widget.title ?? AppLocalizations.of(context)!.appBarTitleIthaki;
    final router = GoRouter.of(context);
    final shouldReturnHomeOnBack =
        widget.currentRoute != Routes.home && !router.canPop();
    final shouldHandleBack =
        _panels.menuOpen || _panels.profileOpen || shouldReturnHomeOnBack;

    return PopScope(
      canPop: !shouldHandleBack,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_panels.menuOpen || _panels.profileOpen) {
          _closePanels();
          return;
        }
        if (shouldReturnHomeOnBack) context.go(Routes.home);
      },
      child: Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        appBar: IthakiAppBar(
          showMenuAndAvatar: true,
          showBackButton: widget.showBackButton,
          title: title,
          menuOpen: widget.enableNavDrawer && _panels.menuOpen,
          profileOpen: _panels.profileOpen,
          avatarInitials: widget.avatarInitials,
          avatarUrl: widget.avatarUrl,
          onNotificationsPressed: _handleNotificationsPressed,
          onMenuPressed: _toggleMenu,
          onAvatarPressed: _toggleProfile,
        ),
        body: Stack(
          children: [
            widget.bodyBuilder(context, ref, topOffset),
            ...?widget.overlayBuilder?.call(context, ref, topOffset),
            if (_panels.menuOpen || _panels.profileOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closePanels,
                  behavior: HitTestBehavior.translucent,
                  child: const ColoredBox(color: Colors.transparent),
                ),
              ),
            if (widget.enableNavDrawer &&
                (_panels.menuOpen ||
                    _panels.menuCtrl.status != AnimationStatus.dismissed))
              _Panel(
                topOffset: topOffset,
                child: SlideTransition(
                  position: _panels.slideAnim,
                  child: AppNavDrawer(
                    currentRoute: widget.currentRoute,
                    profileProgress: ref.watch(profileCompletionProvider),
                    items: buildNavItems(AppLocalizations.of(context)!),
                    onItemTap: _handleNavItemTap,
                  ),
                ),
              ),
            if (_panels.profileOpen ||
                _panels.profileCtrl.status != AnimationStatus.dismissed)
              _Panel(
                topOffset: topOffset,
                child: SlideTransition(
                  position: _panels.profileSlideAnim,
                  child: ProfileMenuPanel(
                    onItemTap: _handleProfileItemTap,
                    onLogOut: _handleLogOut,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.topOffset, required this.child});

  final double topOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topOffset - 14,
      left: 16,
      right: 16,
      bottom: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: child,
      ),
    );
  }
}

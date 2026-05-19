import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../constants/nav_items.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
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

enum _OpenPanel { menu, profile }

class _MainPanelScaffoldState extends ConsumerState<MainPanelScaffold> {
  static const _panelAnimationDuration = Duration(milliseconds: 250);

  _OpenPanel? _openPanel;

  bool get _menuOpen => _openPanel == _OpenPanel.menu;
  bool get _profileOpen => _openPanel == _OpenPanel.profile;
  bool get _hasOpenPanel => _openPanel != null;

  void _setOpenPanel(_OpenPanel? panel) {
    if (_openPanel == panel) return;
    setState(() => _openPanel = panel);
  }

  void _handleBackPressed() {
    widget.onBeforePanelAction?.call();
    if (_hasOpenPanel) {
      _closePanels();
      return;
    }
    if (context.canPop()) {
      context.pop();
      return;
    }
    if (widget.currentRoute != Routes.home) {
      context.go(Routes.home);
    }
  }

  void _handleMenuPressed() {
    if (widget.onMenuPressed != null) {
      widget.onBeforePanelAction?.call();
      widget.onMenuPressed!.call();
      return;
    }
    if (widget.showBackButton) {
      _handleBackPressed();
      return;
    }
    if (!widget.enableNavDrawer) return;
    widget.onBeforePanelAction?.call();
    _setOpenPanel(_menuOpen ? null : _OpenPanel.menu);
  }

  void _toggleProfile() {
    widget.onBeforePanelAction?.call();
    _setOpenPanel(_profileOpen ? null : _OpenPanel.profile);
  }

  void _closePanels() {
    widget.onBeforePanelAction?.call();
    _setOpenPanel(null);
  }

  void _clearPanels() {
    _setOpenPanel(null);
  }

  void _closeMenu() {
    if (_menuOpen) _setOpenPanel(null);
  }

  void _closeProfile() {
    if (_profileOpen) _setOpenPanel(null);
  }

  void _handleNavItemTap(NavItem item) {
    widget.onBeforePanelAction?.call();
    _closeMenu();
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
    _closeProfile();
    navigateToProfileMenuRoute(context, item);
  }

  void _handleNotificationsPressed() {
    widget.onBeforePanelAction?.call();
    _clearPanels();
    if (widget.currentRoute == Routes.settingsNotifications) return;
    if (widget.onNotificationsPressed != null) {
      widget.onNotificationsPressed!.call();
      return;
    }
    context.push(Routes.settingsNotifications);
  }

  void _handleLogOut() {
    widget.onBeforePanelAction?.call();
    _closeProfile();
    final router = GoRouter.of(context);
    ref.read(authRepositoryProvider).logout().whenComplete(() {
      resetProfileProviders(ref);
      if (mounted) router.go(Routes.root);
    });
  }

  Widget _activePanel(BuildContext context) {
    switch (_openPanel) {
      case _OpenPanel.menu:
        if (!widget.enableNavDrawer) {
          return const SizedBox.shrink(key: ValueKey('no-panel'));
        }
        return AppNavDrawer(
          key: const ValueKey('menu-panel'),
          currentRoute: widget.currentRoute,
          profileProgress: ref.watch(profileCompletionProvider),
          items: buildNavItems(AppLocalizations.of(context)!),
          onItemTap: _handleNavItemTap,
        );
      case _OpenPanel.profile:
        return ProfileMenuPanel(
          key: const ValueKey('profile-panel'),
          onItemTap: _handleProfileItemTap,
          onLogOut: _handleLogOut,
        );
      case null:
        return const SizedBox.shrink(key: ValueKey('no-panel'));
    }
  }

  Widget _buildPanelTransition(Widget child, Animation<double> animation) {
    final position = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

    return SlideTransition(position: position, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final topOffset = context.ithakiTopOffset;
    final title =
        widget.title ?? AppLocalizations.of(context)!.appBarTitleIthaki;
    final router = GoRouter.of(context);
    final shouldReturnHomeOnBack =
        widget.currentRoute != Routes.home && !router.canPop();
    final shouldHandleBack = _hasOpenPanel || shouldReturnHomeOnBack;

    return PopScope(
      canPop: !shouldHandleBack,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_hasOpenPanel) {
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
          menuOpen: widget.enableNavDrawer && _menuOpen,
          profileOpen: _profileOpen,
          avatarInitials: widget.avatarInitials,
          avatarUrl: widget.avatarUrl,
          onNotificationsPressed: _handleNotificationsPressed,
          onMenuPressed: _handleMenuPressed,
          onAvatarPressed: _toggleProfile,
        ),
        body: Stack(
          children: [
            widget.bodyBuilder(context, ref, topOffset),
            ...?widget.overlayBuilder?.call(context, ref, topOffset),
            if (_hasOpenPanel)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closePanels,
                  behavior: HitTestBehavior.translucent,
                  child: const ColoredBox(color: Colors.transparent),
                ),
              ),
            _Panel(
              topOffset: topOffset,
              child: AnimatedSwitcher(
                duration: _panelAnimationDuration,
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeOut,
                transitionBuilder: _buildPanelTransition,
                child: _activePanel(context),
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

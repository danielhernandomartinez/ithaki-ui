import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/applications_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/profile_provider.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import '../../constants/nav_items.dart';
import 'widgets/application_card.dart';

class MyApplicationsScreen extends ConsumerStatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  ConsumerState<MyApplicationsScreen> createState() =>
      _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends ConsumerState<MyApplicationsScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _panels = PanelMenuController(setState)..init(this);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _panels.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeData = ref.watch(homeProvider).value;
    final applications = ref.watch(applicationsProvider);
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        menuOpen: _panels.menuOpen,
        profileOpen: _panels.profileOpen,
        avatarInitials: homeData?.userInitials ?? 'CI',
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(
        children: [
          // ─── Main content ──────────────────────────────────────
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: topOffset),
                const SizedBox(height: 16),

                // Tab bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _ApplicationsTabBar(controller: _tabController),
                ),
                const SizedBox(height: 16),

                // Content card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: IthakiTheme.backgroundWhite,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Track all the jobs you've applied for and see their current status. You can also review invitations you've accepted or find past applications in your archive.",
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: IthakiTheme.textPrimary,
                          letterSpacing: -0.32,
                        ),
                      ),
                      // Application cards list
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: applications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) =>
                            ApplicationCard(application: applications[index]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // AI Assistant banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IthakiGradientBanner(
                    title: "Don't know what to do next?",
                    subtitle:
                        'On average, employers review applications within the first week. You can always ask me for help with your next steps.',
                    buttonLabel: 'Ask Career Assistant',
                    buttonIcon: const IthakiIcon(
                        'ai', size: 18, color: IthakiTheme.backgroundWhite),
                    onButtonPressed: () {},
                    backgroundImage: const DecorationImage(
                      image: AssetImage('assets/images/ai_banner_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                    height: MediaQuery.paddingOf(context).bottom + 16),
              ],
            ),
          ),

          // ─── Dim overlay ───────────────────────────────────────
          if (_panels.menuOpen || _panels.profileOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  _panels.closeMenu();
                  _panels.closeProfile();
                },
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),

          // ─── Nav menu panel ────────────────────────────────────
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
                    currentRoute: Routes.myApplications,
                    profileProgress:
                        ref.watch(profileCompletionProvider),
                    items: kAppNavItems,
                    onItemTap: (item) {
                      _panels.closeMenu();
                      if (item.route != Routes.myApplications) {
                        context.go(item.route);
                      }
                    },
                  ),
                ),
              ),
            ),

          // ─── Profile menu panel ────────────────────────────────
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
                    onLogOut: _panels.closeProfile,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Tab bar ──────────────────────────────────────────────────────────────────

class _ApplicationsTabBar extends StatefulWidget {
  final TabController controller;
  const _ApplicationsTabBar({required this.controller});

  @override
  State<_ApplicationsTabBar> createState() => _ApplicationsTabBarState();
}

class _ApplicationsTabBarState extends State<_ApplicationsTabBar> {
  static const _tabs = ['My Applications', 'My Invitations (3)', 'Drafts'];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: IthakiTheme.chipActive,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final isActive = widget.controller.index == i;
              return Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : 6),
                child: GestureDetector(
                  onTap: () => widget.controller.animateTo(i),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? IthakiTheme.backgroundWhite
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _tabs[i],
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive
                            ? IthakiTheme.textPrimary
                            : IthakiTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import 'widgets/job_search_tab_bar.dart';
import 'widgets/job_search_search_bar.dart';
import 'widgets/job_search_list.dart';

class JobSearchScreen extends ConsumerStatefulWidget {
  const JobSearchScreen({super.key});

  @override
  ConsumerState<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends ConsumerState<JobSearchScreen>
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
    final topOffset =
        MediaQuery.of(context).padding.top + kToolbarHeight + 16;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        menuOpen: _panels.menuOpen,
        profileOpen: _panels.profileOpen,
        avatarInitials: ref.watch(profileBasicsProvider).value?.initials ?? '',
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(
        children: [
          // ─── Main content ──────────────────────────────────
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: topOffset + 12),
                const JobSearchTabBar(),
                const SizedBox(height: 12),
                const JobSearchSearchBar(),
                const SizedBox(height: 12),
                const JobSearchList(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IthakiGradientBanner(
                    title: 'Not sure how to find the right job?',
                    subtitle:
                        "Career Assistant can help you if you're not sure where to start!",
                    buttonLabel: 'Ask Career Assistant',
                    buttonIcon:
                        const IthakiIcon('ai', size: 18, color: Colors.white),
                    onButtonPressed: () {},
                    backgroundImage: const DecorationImage(
                      image: AssetImage('assets/images/ai_banner_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(height: 1, color: IthakiTheme.borderLight),
                ),
                IthakiFooter(
                  brandName: 'Odyssea',
                  copyright:
                      'Copyright © Ithaki 2025. #1 Job-Seeker service in Greece',
                  privacyLabel: 'Privacy Policy',
                  termsLabel: 'Terms of Use',
                  socialIcons: const [
                    IthakiIcon('tiktok',
                        size: 24, color: IthakiTheme.softGraphite),
                    IthakiIcon('youtube',
                        size: 24, color: IthakiTheme.softGraphite),
                    IthakiIcon('instagram',
                        size: 24, color: IthakiTheme.softGraphite),
                    IthakiIcon('linkedin',
                        size: 24, color: IthakiTheme.softGraphite),
                    IthakiIcon('facebook',
                        size: 24, color: IthakiTheme.softGraphite),
                    IthakiIcon('x',
                        size: 24, color: IthakiTheme.softGraphite),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ),

          // ─── Dim overlay ───────────────────────────────────
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

          // ─── Nav menu panel ────────────────────────────────
          if (_panels.menuOpen ||
              _panels.menuCtrl.status != AnimationStatus.dismissed)
            Positioned(
              top: topOffset - 14,
              left: 16, right: 16, bottom: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SlideTransition(
                  position: _panels.slideAnim,
                  child: AppNavDrawer(
                    currentRoute: Routes.jobSearch,
                    profileProgress: ref.watch(profileCompletionProvider),
                    items: kAppNavItems,
                    onItemTap: (item) {
                      _panels.closeMenu();
                      if (item.route != Routes.jobSearch) {
                        context.go(item.route);
                      }
                    },
                  ),
                ),
              ),
            ),

          // ─── Profile menu panel ────────────────────────────
          if (_panels.profileOpen ||
              _panels.profileCtrl.status != AnimationStatus.dismissed)
            Positioned(
              top: topOffset - 14,
              left: 16, right: 16, bottom: 40,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../repositories/home_repository.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import 'widgets/home_greeting_header.dart';
import 'widgets/home_search_section.dart';
import 'widgets/home_jobs_section.dart';
import 'widgets/home_courses_section.dart';
import 'widgets/home_news_section.dart';
import 'widgets/home_questions_section.dart';
import 'widgets/home_profile_completion_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;
  String _selectedRoute = '/home';

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
    final homeRepo = ref.watch(homeRepositoryProvider);
    final topOffset =
        MediaQuery.of(context).padding.top + kToolbarHeight + 16;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        menuOpen: _panels.menuOpen,
        profileOpen: _panels.profileOpen,
        avatarInitials: homeRepo.userInitials,
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(
        children: [
          // ─── Main content ─────────────────────────────────────
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeGreetingHeader(topOffset: topOffset),
                const SizedBox(height: 12),

                if (homeRepo.isNewUser) ...[
                  const HomeProfileCompletionCard(),
                  const SizedBox(height: 12),
                ],

                IthakiCard(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const HomeSearchSection(),
                ),
                const SizedBox(height: 12),
                IthakiCard(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const HomeJobsSection(),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IthakiGradientBanner(
                    title: 'Not sure how to find the right job?',
                    subtitle: "Career Assistant can help if you're not sure where to start!",
                    buttonLabel: 'Ask Career Assistant',
                    buttonIcon: const IthakiIcon('ai', size: 18, color: Colors.white),
                    onButtonPressed: () {},
                    backgroundImage: const DecorationImage(
                      image: AssetImage('assets/images/ai_banner_bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                IthakiCard(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: IthakiStatCard(
                    title: 'Your CV Success',
                    rows: [
                      IthakiStatRowData(
                        icon: const IthakiIcon('eye', size: 18, color: IthakiTheme.primaryPurple),
                        label: 'Views',
                        value: homeRepo.cvStats.views,
                        change: homeRepo.cvStats.viewsChange,
                      ),
                      IthakiStatRowData(
                        icon: const IthakiIcon('envelope', size: 18, color: IthakiTheme.primaryPurple),
                        label: 'Invitations',
                        value: homeRepo.cvStats.invitations,
                        change: homeRepo.cvStats.invitationsChange,
                      ),
                      IthakiStatRowData(
                        icon: const IthakiIcon('applications', size: 22, color: IthakiTheme.primaryPurple),
                        label: 'Applications Sent',
                        value: homeRepo.cvStats.applicationsSent,
                      ),
                      IthakiStatRowData(
                        icon: const IthakiIcon('rocket', size: 22, color: IthakiTheme.primaryPurple),
                        label: 'Interviews',
                        value: homeRepo.cvStats.interviews,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                IthakiCard(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const HomeCoursesSection(),
                ),
                const SizedBox(height: 12),
                IthakiCard(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const HomeNewsSection(),
                ),
                const SizedBox(height: 12),
                IthakiCard(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const HomeQuestionsSection(),
                ),
                const SizedBox(height: 12),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ),

          // ─── Dim overlay ──────────────────────────────────────
          if (_panels.menuOpen || _panels.profileOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () { _panels.closeMenu(); _panels.closeProfile(); },
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),

          // ─── Nav menu panel ───────────────────────────────────
          if (_panels.menuOpen || _panels.menuCtrl.status != AnimationStatus.dismissed)
            Positioned(
              top: topOffset - 14,
              left: 16, right: 16, bottom: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SlideTransition(
                  position: _panels.slideAnim,
                  child: AppNavDrawer(
                    currentRoute: _selectedRoute,
                    profileProgress: ref.watch(profileCompletionProvider),
                    items: kAppNavItems,
                    onItemTap: (item) {
                      setState(() => _selectedRoute = item.route);
                      _panels.closeMenu();
                      if (item.route != Routes.home) context.go(item.route);
                    },
                  ),
                ),
              ),
            ),

          // ─── Profile menu panel ───────────────────────────────
          if (_panels.profileOpen || _panels.profileCtrl.status != AnimationStatus.dismissed)
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

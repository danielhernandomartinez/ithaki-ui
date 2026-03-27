import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/profile_provider.dart';
import '../../constants/nav_items.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../widgets/profile_header_card.dart';
import '../../widgets/profile_tab_bar.dart';

import 'tabs/profile_job_preferences_tab.dart';
import 'tabs/profile_about_me_tab.dart';
import 'tabs/profile_skills_tab.dart';
import 'tabs/profile_work_experience_tab.dart';
import 'tabs/profile_education_tab.dart';
import 'tabs/profile_files_tab.dart';
import 'tabs/profile_values_tab.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;
  int _tabIndex = 0;

  static const _tabs = [
    'Job Preferences',
    'About Me',
    'Skills',
    'Work Experience',
    'Education',
    'Files',
    'Values',
  ];

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

  Widget _buildTabContent() {
    switch (_tabIndex) {
      case 0: return const ProfileJobPreferencesTab();
      case 1: return const ProfileAboutMeTab();
      case 2: return const ProfileSkillsTab();
      case 3: return const ProfileWorkExperienceTab();
      case 4: return const ProfileEducationTab();
      case 5: return const ProfileFilesTab();
      case 6: return const ProfileValuesTab();
      default: return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final basics = ref.watch(profileBasicsProvider);
    final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight + 16;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        menuOpen: _panels.menuOpen,
        avatarInitials:
            '${basics.firstName.isNotEmpty ? basics.firstName[0] : '?'}${basics.lastName.isNotEmpty ? basics.lastName[0] : '?'}',
        onMenuPressed: _panels.toggleMenu,
        profileOpen: _panels.profileOpen,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: topOffset - 14),
            ProfileHeaderCard(basics: basics),
            const SizedBox(height: 12),
            ProfileTabBar(
              tabs: _tabs,
              selectedIndex: _tabIndex,
              onTabSelected: (i) => setState(() => _tabIndex = i),
            ),
            const SizedBox(height: 12),
            _buildTabContent(),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const IthakiIcon('resume', size: 16),
                      label: const Text('Open CV'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        foregroundColor: IthakiTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push(Routes.settings),
                      icon: const IthakiIcon('settings', size: 16),
                      label: const Text('Account Settings'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        foregroundColor: IthakiTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.viewPaddingOf(context).bottom + 32),
          ]),
        ),
        if (_panels.menuOpen || _panels.profileOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: () { _panels.closeMenu(); _panels.closeProfile(); },
              child: Container(color: Colors.transparent),
            ),
          ),
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
                  onLogOut: () {
                    _panels.closeProfile();
                    context.go(Routes.root);
                  },
                ),
              ),
            ),
          ),
        if (_panels.menuOpen || _panels.menuCtrl.status != AnimationStatus.dismissed)
          Positioned(
            top: topOffset - 14,
            left: 16, right: 16, bottom: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SlideTransition(
                position: _panels.slideAnim,
                child: AppNavDrawer(
                  currentRoute: Routes.profile,
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
      ]),
    );
  }
}

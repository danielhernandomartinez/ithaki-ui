import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../providers/profile_provider.dart';
import '../../providers/tour_provider.dart';
import '../../repositories/auth_repository.dart';
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
      case 0:
        return const ProfileJobPreferencesTab();
      case 1:
        return const ProfileAboutMeTab();
      case 2:
        return const ProfileSkillsTab();
      case 3:
        return const ProfileWorkExperienceTab();
      case 4:
        return const ProfileEducationTab();
      case 5:
        return const ProfileFilesTab();
      case 6:
        return const ProfileValuesTab();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final basicsAsync = ref.watch(profileBasicsProvider);
    if (basicsAsync.isLoading) {
      return const Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (basicsAsync.hasError) {
      return Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off_rounded,
                    size: 48, color: IthakiTheme.textSecondary),
                const SizedBox(height: 16),
                Text(
                  'Couldn\'t load your profile.\nCheck your connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: IthakiTheme.textSecondary),
                ),
                const SizedBox(height: 24),
                IthakiButton(
                  'Retry',
                  onPressed: () => ref.invalidate(profileBasicsProvider),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final basics = basicsAsync.requireValue;
    final tourState = ref.watch(tourProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    final tourKeys = ref.watch(tourKeysProvider);
    final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight + 16;

    final isPartial = ref.watch(profilePartialLoadProvider);

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        menuOpen: _panels.menuOpen,
        avatarInitials: basics.initials,
        onMenuPressed: _panels.toggleMenu,
        profileOpen: _panels.profileOpen,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: topOffset - 14),
            if (isPartial)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Colors.amber.shade800, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Some profile data couldn\'t be loaded. Showing cached data.',
                        style: TextStyle(
                          color: Colors.amber.shade900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            KeyedSubtree(
              key: tourState?.currentStep == 10 ? tourKeys[10] : null,
              child: ProfileHeaderCard(basics: basics),
            ),
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
                color: IthakiTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => setState(() => _tabIndex = 5),
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
                    ref.read(authRepositoryProvider).logout().whenComplete(() {
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

import 'dart:io';

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
            _buildHeaderCard(basics),
            const SizedBox(height: 12),
            _buildTabBar(),
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
                    context.go('/login');
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

  // ─── Header Card ──────────────────────────────────────────────────

  Widget _buildHeaderCard(ProfileBasics basics) {
    final prefs = ref.watch(profileJobPreferencesProvider);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: IthakiTheme.primaryPurple,
            backgroundImage: basics.photoUrl != null
                ? FileImage(File(basics.photoUrl!))
                : null,
            child: basics.photoUrl == null
                ? Text(
                    '${basics.firstName.isNotEmpty ? basics.firstName[0] : '?'}${basics.lastName.isNotEmpty ? basics.lastName[0] : '?'}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '${basics.firstName} ${basics.lastName}',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: IthakiTheme.textPrimary),
            ),
            Text(
              prefs.jobInterests.isNotEmpty
                  ? prefs.jobInterests.first.title
                  : prefs.jobType.isNotEmpty
                      ? prefs.jobType
                      : 'Job Seeker',
              style: const TextStyle(
                  fontSize: 14, color: IthakiTheme.textSecondary),
            ),
          ]),
        ]),
        const SizedBox(height: 12),
        _contactRow(const IthakiIcon('envelope', size: 16), basics.email),
        const SizedBox(height: 4),
        _contactRow(const IthakiIcon('phone', size: 20), basics.phone),
        const SizedBox(height: 8),
        const Text(
          "Employers won't see your contact details until you apply for a job or accept an invitation.",
          style: TextStyle(fontSize: 12, color: IthakiTheme.textSecondary),
        ),
        const Divider(height: 24),
        Row(children: [
          Expanded(child: _infoCell('Gender', basics.gender)),
          Expanded(child: _infoCell('Age', _calcAge(basics.dateOfBirth))),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: _infoCell('Citizenship', basics.citizenship)),
          Expanded(child: _infoCell('Location', basics.residence)),
        ]),
        const SizedBox(height: 12),
        IthakiOutlineButton(
          'Edit Profile Basics',
          icon: const IthakiIcon('edit-pencil', size: 16),
          onPressed: () => context.push(Routes.profileBasics),
          borderRadius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ]),
    );
  }

  // ─── Tab Bar ──────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE9DEFF),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _tabs.asMap().entries.map((e) {
              final selected = e.key == _tabIndex;
              return Padding(
                padding: EdgeInsets.only(
                    left: e.key == 0 ? 0 : 6),
                child: GestureDetector(
                  onTap: () => setState(() => _tabIndex = e.key),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      e.value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected
                            ? IthakiTheme.textPrimary
                            : IthakiTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ─── Tab Content Dispatcher ───────────────────────────────────────

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

  // ─── Small Helpers ────────────────────────────────────────────────

  Widget _contactRow(Widget icon, String text) => Row(children: [
        icon,
        const SizedBox(width: 6),
        Text(text,
            style: const TextStyle(
                fontSize: 13, color: IthakiTheme.textSecondary)),
      ]);

  Widget _infoCell(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: IthakiTheme.textSecondary)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
        ],
      );

  String _calcAge(String dob) {
    final parts = dob.split('-');
    if (parts.length < 3) return '';
    final year = int.tryParse(parts[2]);
    if (year == null) return '';
    final age = DateTime.now().year - year;
    return '$age';
  }
}

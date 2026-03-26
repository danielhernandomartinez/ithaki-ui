import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../models/profile_models.dart';
import '../../providers/profile_provider.dart';
import '../../utils/language_utils.dart';
import '../../utils/profile_date_utils.dart';
import '../../constants/nav_items.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import '../../widgets/profile_meta_cell.dart';
import '../../widgets/upload_files_sheet.dart';

class _CompRow {
  final String label;
  final String value;
  const _CompRow(this.label, this.value);
}

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  int _tabIndex = 0;
  bool _menuOpen = false;
  bool _avatarOpen = false;
  late final AnimationController _menuCtrl;
  late final AnimationController _avatarCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<Offset> _avatarSlideAnim;
  final _avatarKey = GlobalKey();


  @override
  void initState() {
    super.initState();
    _menuCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _menuCtrl.addStatusListener((_) => setState(() {}));
    _slideAnim = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _menuCtrl, curve: Curves.easeOut));
    _avatarCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _avatarCtrl.addStatusListener((_) => setState(() {}));
    _avatarSlideAnim = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _avatarCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _menuCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
    _menuOpen ? _menuCtrl.forward() : _menuCtrl.reverse();
  }

  void _toggleAvatarMenu() {
    _closeMenu();
    setState(() => _avatarOpen = !_avatarOpen);
    _avatarOpen ? _avatarCtrl.forward() : _avatarCtrl.reverse();
  }

  void _closeAvatarMenu() {
    if (!_avatarOpen) return;
    setState(() => _avatarOpen = false);
    _avatarCtrl.reverse();
  }

  void _closeMenu() {
    if (!_menuOpen) return;
    setState(() => _menuOpen = false);
    _menuCtrl.reverse();
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
    final profile = ref.watch(profileProvider);
    final topOffset = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        menuOpen: _menuOpen,
        avatarInitials:
            '${profile.firstName.isNotEmpty ? profile.firstName[0] : '?'}${profile.lastName.isNotEmpty ? profile.lastName[0] : '?'}',
        onMenuPressed: _toggleMenu,
        avatarKey: _avatarKey,
        profileOpen: _avatarOpen,
        onAvatarPressed: _toggleAvatarMenu,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: topOffset + 16),
            _buildHeaderCard(profile),
            const SizedBox(height: 12),
            _buildTabBar(),
            const SizedBox(height: 12),
            _buildTabContent(profile),
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
        if (_menuOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeMenu,
              child: Container(color: Colors.black26),
            ),
          ),
        if (_avatarOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeAvatarMenu,
              child: Container(color: Colors.black26),
            ),
          ),
        if (_avatarOpen || _avatarCtrl.status != AnimationStatus.dismissed)
          Positioned(
            top: topOffset - 14,
            left: 16, right: 16, bottom: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SlideTransition(
                position: _avatarSlideAnim,
                child: ProfileMenuPanel(
                  onItemTap: (item) {
                    _closeAvatarMenu();
                    if (item.route.isNotEmpty) context.push(item.route);
                  },
                  onLogOut: () {
                    _closeAvatarMenu();
                    context.go('/login');
                  },
                ),
              ),
            ),
          ),
        if (_menuOpen || _menuCtrl.status != AnimationStatus.dismissed)
          Positioned(
            top: topOffset + 16,
            left: 16, right: 16, bottom: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SlideTransition(
                position: _slideAnim,
                child: AppNavDrawer(
                  currentRoute: '/profile',
                  profileProgress: 0.25,
                  items: kAppNavItems,
                  onItemTap: (item) {
                    _closeMenu();
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

  Widget _buildHeaderCard(ProfileState profile) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: IthakiTheme.primaryPurple,
              backgroundImage: profile.photoUrl != null
                  ? FileImage(File(profile.photoUrl!))
                  : null,
              child: profile.photoUrl == null
                  ? Text(
                      '${profile.firstName.isNotEmpty ? profile.firstName[0] : '?'}${profile.lastName.isNotEmpty ? profile.lastName[0] : '?'}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '${profile.firstName} ${profile.lastName}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: IthakiTheme.textPrimary),
              ),
              Text(
                profile.jobInterests.isNotEmpty
                    ? profile.jobInterests.first.title
                    : profile.jobType.isNotEmpty
                        ? profile.jobType
                        : 'Job Seeker',
                style: const TextStyle(
                    fontSize: 14, color: IthakiTheme.textSecondary),
              ),
            ]),
          ]),
          const SizedBox(height: 12),
          _contactRow(const IthakiIcon('envelope', size: 16), profile.email),
          const SizedBox(height: 4),
          _contactRow(const IthakiIcon('phone', size: 20), profile.phone),
          const SizedBox(height: 8),
          const Text(
            "Employers won't see your contact details until you apply for a job or accept an invitation.",
            style: TextStyle(fontSize: 12, color: IthakiTheme.textSecondary),
          ),
          const Divider(height: 24),
          Row(children: [
            Expanded(child: _infoCell('Gender', profile.gender)),
            Expanded(child: _infoCell('Age', _calcAge(profile.dateOfBirth))),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _infoCell('Citizenship', profile.citizenship)),
            Expanded(child: _infoCell('Location', profile.residence)),
          ]),
          const SizedBox(height: 12),
          _iconOutlineButton(
              const IthakiIcon('edit-pencil', size: 16),
              'Edit Profile Basics',
              () => context.push(Routes.profileBasics)),
        ]),
      );

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

  Widget _buildTabContent(ProfileState profile) {
    switch (_tabIndex) {
      case 0:
        return _buildJobPreferencesTab(profile);
      case 1:
        return _buildAboutMeTab(profile);
      case 2:
        return _buildSkillsTab(profile);
      case 3:
        return _buildWorkExperienceTab(profile);
      case 4:
        return _buildEducationTab(profile);
      case 5:
        return _buildFilesTab(profile);
      case 6:
        return _buildValuesTab(profile);
      default:
        return const SizedBox.shrink();
    }
  }

  // ─── Tab: Job Preferences ─────────────────────────────────────────

  Widget _buildJobPreferencesTab(ProfileState profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Job Preferences',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: IthakiTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'This shows the job you are currently looking for. You can change this anytime.',
          style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary),
        ),
        const SizedBox(height: 16),
        if (profile.jobInterests.isNotEmpty) ...[
          const Text(
            'Job Interests',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary),
          ),
          const SizedBox(height: 8),
          ...profile.jobInterests.map(_jobInterestCard),
          const SizedBox(height: 8),
        ],
        const Text(
          'Preferences',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary),
        ),
        const SizedBox(height: 8),
        _prefGrid(profile),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.push(Routes.profileJobPreferences),
          icon: const IthakiIcon('edit-pencil', size: 16),
          label: const Text('Edit Jobs Preferences'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            foregroundColor: IthakiTheme.textPrimary,
          ),
        ),
      ]),
    );
  }

  Widget _jobInterestCard(JobInterest jobInterest) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        height: 78,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: const IthakiIcon('rocket', size: 20,
                color: IthakiTheme.primaryPurple),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(jobInterest.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary)),
                  Text(jobInterest.category,
                      style: const TextStyle(
                          fontSize: 13, color: IthakiTheme.textSecondary)),
                ]),
          ),
        ]),
      );

  Widget _prefGrid(ProfileState profile) {
    final salary = profile.preferNotToSpecifySalary
        ? 'Not specified'
        : profile.expectedSalary != null
            ? '${profile.expectedSalary!.toStringAsFixed(0)} € / month'
            : '—';
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Row(children: [
          Expanded(child: _prefCell('briefcase-work', 'Workspace',
              profile.workplace.isNotEmpty ? profile.workplace : '—')),
          const SizedBox(width: 10),
          Expanded(child: _prefCell('clock', 'Job Type',
              profile.jobType.isNotEmpty ? profile.jobType : '—')),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _prefCell('level', 'Level',
              profile.positionLevel.isNotEmpty ? profile.positionLevel : '—')),
          const SizedBox(width: 10),
          Expanded(child: _prefCell('bank-note', 'Desired Salary', salary)),
        ]),
      ]),
    );
  }

  Widget _prefCell(String iconName, String label, String value) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        IthakiIcon(iconName, size: 16, color: IthakiTheme.softGraphite),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: IthakiTheme.textSecondary)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary)),
      ]);

  // ─── Tab: About Me ────────────────────────────────────────────────

  Widget _buildAboutMeTab(ProfileState profile) {
    if (profile.bio.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('About Me',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text(
            'Add a few words about yourself to help employers understand who you are and what you do.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          _iconOutlineButton(const IthakiIcon('plus', size: 16),
              'Add About Me Information', () => context.push(Routes.profileAboutMe)),
        ]),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── About ──────────────────────────────────────────────
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('About Me',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 12),
          Text(profile.bio,
              style: const TextStyle(
                  fontSize: 16,
                  color: IthakiTheme.textPrimary,
                  height: 1.5)),
        ]),
        const SizedBox(height: 20),
        // ── Video Introduction ─────────────────────────────────
        if (profile.videoUrl != null) ...[
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Video Introduction',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                height: 190,
                color: const Color(0xFF040404),
                alignment: Alignment.center,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0x801E1E1E),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      size: 28, color: Colors.white),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 20),
        ],
        // ── Edit button ────────────────────────────────────────
        OutlinedButton.icon(
          onPressed: () => context.push(Routes.profileAboutMe),
          icon: const IthakiIcon('edit-pencil', size: 20),
          label: const Text('Edit About Me & Video Introduction'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: IthakiTheme.softGraphite),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            minimumSize: const Size(0, 40),
            foregroundColor: IthakiTheme.textPrimary,
          ),
        ),
      ]),
    );
  }

  // ─── Tab: Skills ──────────────────────────────────────────────────

  Widget _buildSkillsTab(ProfileState profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _skillsCard(profile),
        const SizedBox(height: 8),
        _competenciesCard(profile),
        const SizedBox(height: 8),
        _languagesCard(profile),
      ],
    );
  }

  Widget _skillsCard(ProfileState profile) {
    final hasSkills =
        profile.hardSkills.isNotEmpty || profile.softSkills.isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Skills',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary)),
        const SizedBox(height: 8),
        if (!hasSkills) ...[
          const Text(
            'Add your technical and soft skills to help employers find and evaluate you.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          _autoOutlineButton(const IthakiIcon('plus', size: 16),
              'Add Skills', () => context.push(Routes.profileSkills)),
        ] else ...[
          if (profile.hardSkills.isNotEmpty) ...[
            const Text('Hard Skills',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: profile.hardSkills.map(_skillBadge).toList(),
            ),
            const SizedBox(height: 16),
          ],
          if (profile.softSkills.isNotEmpty) ...[
            const Text('Soft Skills',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: profile.softSkills.map(_skillBadge).toList(),
            ),
            const SizedBox(height: 16),
          ],
          _autoOutlineButton(const IthakiIcon('edit-pencil', size: 16),
              'Edit Skills', () => context.push(Routes.profileSkills)),
        ],
      ]),
    );
  }

  Widget _competenciesCard(ProfileState profile) {
    final comp = profile.competencies;
    final rows = <_CompRow>[];
    if (profile.relocationReadiness.isNotEmpty) {
      rows.add(_CompRow('Willing to relocate', profile.relocationReadiness));
    }
    if ((comp['workPermit'] ?? '').isNotEmpty) {
      rows.add(_CompRow('Work Permit', comp['workPermit']!));
    }
    if ((comp['computerSkills'] ?? '').isNotEmpty) {
      rows.add(_CompRow('Computer Skills', comp['computerSkills']!));
    }
    if ((comp['drivingLicense'] ?? '').isNotEmpty) {
      final cat = comp['licenseCategory'] ?? '';
      final value = comp['drivingLicense'] == 'Yes' && cat.isNotEmpty
          ? 'Category $cat'
          : comp['drivingLicense']!;
      rows.add(_CompRow('Driving Licence', value));
    }
    final hasData = rows.isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Competencies',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary)),
        const SizedBox(height: 8),
        if (!hasData) ...[
          const Text(
            'Select the skills that best represent your qualifications and professional expertise.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          _autoOutlineButton(const IthakiIcon('plus', size: 16),
              'Add Competencies', () => context.push(Routes.profileCompetencies)),
        ] else ...[
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(r.label,
                        style: const TextStyle(
                            fontSize: 14, color: IthakiTheme.textSecondary)),
                    Text(r.value,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: IthakiTheme.textPrimary)),
                  ],
                ),
              )),
          _autoOutlineButton(const IthakiIcon('edit-pencil', size: 16),
              'Edit Competencies', () => context.push(Routes.profileCompetencies)),
        ],
      ]),
    );
  }

  Widget _languagesCard(ProfileState profile) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Languages',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 12),
          ...profile.languages.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      IthakiFlag(langCode(l.language), width: 20, height: 20),
                      const SizedBox(width: 8),
                      Text(l.language,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: IthakiTheme.textSecondary)),
                    ]),
                    Text(l.proficiency,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: IthakiTheme.textPrimary)),
                  ],
                ),
              )),
          _autoOutlineButton(
            profile.languages.isEmpty
                ? const IthakiIcon('plus', size: 16)
                : const IthakiIcon('edit-pencil', size: 16),
            profile.languages.isEmpty ? 'Add Languages' : 'Edit Languages',
            () => context.push(Routes.profileLanguages),
          ),
        ]),
      );

  Widget _skillBadge(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 16, color: IthakiTheme.textPrimary)),
      );

  // ─── Tab: Work Experience ─────────────────────────────────────────

  Widget _buildWorkExperienceTab(ProfileState profile) {
    if (profile.workExperiences.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Work Experience',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text(
            'Add details about your previous roles and companies',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          _iconOutlineButton(const IthakiIcon('plus', size: 16),
              'Add Work Experience',
              () => context.push(Routes.profileWorkExperience)),
        ]),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...profile.workExperiences.asMap().entries.map((entry) {
          final index = entry.key;
          final exp = entry.value;
          final endLabel = exp.currentlyWorkHere ? 'Present' : (exp.endDate ?? '');
          final duration = _calcDuration(exp.startDate, exp.currentlyWorkHere ? null : exp.endDate);
          return Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // ── Header row ──────────────────────────────────────
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary),
                      children: [
                        TextSpan(text: exp.jobTitle),
                        const TextSpan(
                            text: '  at  ',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: IthakiTheme.textSecondary)),
                        TextSpan(text: exp.companyName),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => context.push(Routes.profileWorkExperienceEdit,
                      extra: WorkExperienceEditExtra(index: index, exp: exp).toMap()),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: IthakiTheme.borderLight),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const IthakiIcon('edit-pencil',
                        size: 16, color: IthakiTheme.textSecondary),
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              // ── Date + duration ─────────────────────────────────
              Text(
                '${exp.startDate} - $endLabel${duration.isNotEmpty ? ' ($duration)' : ''}',
                style: const TextStyle(
                    fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 10),
              // ── Metadata 2-col grid ─────────────────────────────
              Row(children: [
                if (exp.location.isNotEmpty)
                  Expanded(child: _metaCell(Icons.location_on_outlined, exp.location)),
                if (exp.workplace.isNotEmpty)
                  Expanded(child: _metaCell(Icons.business_outlined, exp.workplace)),
              ]),
              if (exp.jobType.isNotEmpty || exp.experienceLevel.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(children: [
                  if (exp.jobType.isNotEmpty)
                    Expanded(child: _metaCell(Icons.access_time_outlined, exp.jobType)),
                  if (exp.experienceLevel.isNotEmpty)
                    Expanded(child: _metaCell(Icons.bar_chart_outlined, exp.experienceLevel)),
                ]),
              ],
              // ── Summary ─────────────────────────────────────────
              if (exp.summary != null && exp.summary!.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 10),
                Text(exp.summary!,
                    style: const TextStyle(
                        fontSize: 13,
                        color: IthakiTheme.textPrimary,
                        height: 1.5)),
              ],
            ]),
          );
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _iconOutlineButton(const IthakiIcon('plus', size: 16),
              'Add Work Experience',
              () => context.push(Routes.profileWorkExperience))),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _metaCell(IconData icon, String label) =>
      ProfileMetaCell(icon, label, flexible: true, fontSize: 13);


  // ─── Tab: Education ───────────────────────────────────────────────

  Widget _buildEducationTab(ProfileState profile) {
    if (profile.educations.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Education',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text(
            'Add information about your educational background, degree, and field of study.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          _iconOutlineButton(const IthakiIcon('plus', size: 16),
              'Add Education', () => context.push(Routes.profileEducation)),
        ]),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...profile.educations.asMap().entries.map((entry) {
          final edu = entry.value;
          final endLabel =
              edu.currentlyStudyHere ? 'Present' : (edu.endDate ?? '');
          return Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(edu.institutionName,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 2),
              Text('${edu.degreeType} – ${edu.fieldOfStudy}',
                  style: const TextStyle(
                      fontSize: 13, color: IthakiTheme.textSecondary)),
              const SizedBox(height: 2),
              Text('${edu.startDate} – $endLabel',
                  style: const TextStyle(
                      fontSize: 12, color: IthakiTheme.softGraphite)),
              const SizedBox(height: 12),
              _iconOutlineButton(const IthakiIcon('edit-pencil', size: 16),
                  'Edit', () => context.push(Routes.profileEducation)),
            ]),
          );
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _iconOutlineButton(const IthakiIcon('plus', size: 16),
              'Add Education', () => context.push(Routes.profileEducation)),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  // ─── Tab: Files ───────────────────────────────────────────────────

  void _openUpload() => UploadFilesSheet.show(context, onContinue: (files) {
        for (final f in files) {
          ref.read(profileProvider.notifier).addFile(f);
        }
      });

  Widget _buildFilesTab(ProfileState profile) {
    if (profile.files.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('My Files',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text(
            'Upload certificates, CV, photos, or any other files that showcase your qualifications.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          _iconOutlineButton(
            const IthakiIcon('upload-cloud', size: 16),
            'Upload Documents',
            _openUpload,
          ),
        ]),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('My Files',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary)),
        const SizedBox(height: 16),
        ...profile.files.asMap().entries.map((entry) {
          final i = entry.key;
          final f = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Text('PDF',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: IthakiTheme.softGraphite)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.name,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: IthakiTheme.textPrimary)),
                      Text(f.size,
                          style: const TextStyle(
                              fontSize: 12, color: IthakiTheme.textSecondary)),
                    ]),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Open',
                    style: TextStyle(color: IthakiTheme.primaryPurple)),
              ),
              TextButton(
                onPressed: () =>
                    ref.read(profileProvider.notifier).deleteFile(i),
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ]),
          );
        }),
        const SizedBox(height: 4),
        _iconOutlineButton(
          const IthakiIcon('upload-cloud', size: 16),
          'Upload Documents',
          _openUpload,
        ),
      ]),
    );
  }

  // ─── Tab: Values ──────────────────────────────────────────────────

  Widget _buildValuesTab(ProfileState profile) {
    if (profile.values.isEmpty) {
      return _emptyCard(
        message: 'No values added yet.',
        button: _iconOutlineButton(const IthakiIcon('edit-pencil', size: 16),
            'Update Values', () => context.push(Routes.profileValues)),
      );
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: profile.values.map(_chip).toList(),
        ),
        const SizedBox(height: 12),
        _iconOutlineButton(const IthakiIcon('edit-pencil', size: 16),
            'Update Values', () => context.push(Routes.profileValues)),
      ]),
    );
  }

  // ─── Sticky Bottom Bar ────────────────────────────────────────────

  // ─── Small Helpers ────────────────────────────────────────────────

  Widget _emptyCard({required String message, required Widget button}) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(message,
              style: const TextStyle(
                  fontSize: 14, color: IthakiTheme.textSecondary)),
          const SizedBox(height: 12),
          button,
        ]),
      );

  Widget _chip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F2FE),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFDDD5F8)),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 13, color: IthakiTheme.primaryPurple)),
      );

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

  Widget _iconOutlineButton(Widget icon, String label, VoidCallback onPressed) =>
      IthakiOutlineButton(
        label,
        icon: icon,
        onPressed: onPressed,
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      );

  Widget _autoOutlineButton(Widget icon, String label, VoidCallback onPressed) =>
      OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(label),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: IthakiTheme.softGraphite),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          foregroundColor: IthakiTheme.textPrimary,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
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

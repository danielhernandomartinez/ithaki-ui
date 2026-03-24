import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../data/mock_home_data.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _menuCtrl;
  late final Animation<Offset> _slideAnim;
  bool _menuOpen = false;

  late final AnimationController _profileCtrl;
  late final Animation<Offset> _profileSlideAnim;
  bool _profileOpen = false;

  static const _navItems = [
    NavItem(icon: 'home',         label: 'Home',             route: '/home'),
    NavItem(icon: 'jobs',         label: 'Job Search',       route: '/job-search'),
    NavItem(icon: 'applications', label: 'My Applications',  route: '/applications', badge: 3),
    NavItem(icon: 'ai',           label: 'Career Assistant', route: '/career-assistant'),
    NavItem(icon: 'assessment',   label: 'My Assessments',   route: '/assessments'),
    NavItem(icon: 'learning-hub', label: 'Learning Hub',     route: '/learning-hub'),
    NavItem(icon: 'blog',         label: 'Blog & News',      route: '/blog'),
  ];

  @override
  void initState() {
    super.initState();
    _menuCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _menuCtrl.addStatusListener((_) => setState(() {}));
    _slideAnim = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _menuCtrl, curve: Curves.easeOut));

    _profileCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _profileCtrl.addStatusListener((_) => setState(() {}));
    _profileSlideAnim = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _profileCtrl, curve: Curves.easeOut));

  }

  @override
  void dispose() {
    _menuCtrl.dispose();
    _profileCtrl.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_profileOpen) _closeProfile();
    setState(() => _menuOpen = !_menuOpen);
    _menuOpen ? _menuCtrl.forward() : _menuCtrl.reverse();
  }

  void _closeMenu() {
    if (!_menuOpen) return;
    setState(() => _menuOpen = false);
    _menuCtrl.reverse();
  }

  void _toggleProfile() {
    if (_menuOpen) _closeMenu();
    setState(() => _profileOpen = !_profileOpen);
    _profileOpen ? _profileCtrl.forward() : _profileCtrl.reverse();
  }

  void _closeProfile() {
    if (!_profileOpen) return;
    setState(() => _profileOpen = false);
    _profileCtrl.reverse();
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
        menuOpen: _menuOpen,
        profileOpen: _profileOpen,
        avatarInitials: MockHomeData.userInitials,
        onMenuPressed: _toggleMenu,
        onAvatarPressed: _toggleProfile,
      ),
      body: Stack(
        children: [
          // ─── Main content ─────────────────────────────────────
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGreetingHeader(topOffset),
                const SizedBox(height: 12),

                if (MockHomeData.isNewUser) ...[
                  _buildProfileCompletionCard(),
                  const SizedBox(height: 12),
                ],

                _buildSectionCard(child: _buildSearchContent()),
                const SizedBox(height: 12),
                _buildSectionCard(child: _buildJobsContent()),
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
                _buildSectionCard(
                  child: IthakiStatCard(
                    title: 'Your CV Success',
                    rows: [
                      IthakiStatRowData(
                        icon: const IthakiIcon('eye', size: 18, color: IthakiTheme.primaryPurple),
                        label: 'Views',
                        value: MockHomeData.cvStats.views,
                        change: MockHomeData.cvStats.viewsChange,
                      ),
                      IthakiStatRowData(
                        icon: const IthakiIcon('envelope', size: 18, color: IthakiTheme.primaryPurple),
                        label: 'Invitations',
                        value: MockHomeData.cvStats.invitations,
                        change: MockHomeData.cvStats.invitationsChange,
                      ),
                      IthakiStatRowData(
                        icon: const IthakiIcon('applications', size: 22, color: IthakiTheme.primaryPurple),
                        label: 'Applications Sent',
                        value: MockHomeData.cvStats.applicationsSent,
                      ),
                      IthakiStatRowData(
                        icon: const IthakiIcon('rocket', size: 22, color: IthakiTheme.primaryPurple),
                        label: 'Interviews',
                        value: MockHomeData.cvStats.interviews,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildSectionCard(child: _buildCoursesContent()),
                const SizedBox(height: 12),
                _buildSectionCard(child: _buildNewsContent()),
                const SizedBox(height: 12),
                _buildSectionCard(child: _buildQuestionsContent()),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(height: 1, color: IthakiTheme.borderLight),
                ),
                IthakiFooter(
                  brandName: 'Odyssea',
                  copyright: 'Copyright © Ithaki 2025. #1 Job-Seeker service in Greece',
                  privacyLabel: 'Privacy Policy',
                  termsLabel: 'Terms of Use',
                  socialIcons: const [
                    IthakiIcon('tiktok',    size: 24, color: IthakiTheme.softGraphite),
                    IthakiIcon('youtube',   size: 24, color: IthakiTheme.softGraphite),
                    IthakiIcon('instagram', size: 24, color: IthakiTheme.softGraphite),
                    IthakiIcon('linkedin',  size: 24, color: IthakiTheme.softGraphite),
                    IthakiIcon('facebook',  size: 24, color: IthakiTheme.softGraphite),
                    IthakiIcon('x',         size: 24, color: IthakiTheme.softGraphite),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ),

          // ─── Dim overlay ──────────────────────────────────────
          if (_menuOpen || _profileOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () { _closeMenu(); _closeProfile(); },
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),

          // ─── Nav menu panel ───────────────────────────────────
          if (_menuOpen || _menuCtrl.status != AnimationStatus.dismissed)
            Positioned(
              top: topOffset,
              left: 16, right: 16, bottom: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SlideTransition(
                  position: _slideAnim,
                  child: AppNavDrawer(
                    currentRoute: '/home',
                    profileProgress: 0.25,
                    items: _navItems,
                    onItemTap: (item) {
                      _closeMenu();
                      if (item.route != '/home') context.go(item.route);
                    },
                  ),
                ),
              ),
            ),

          // ─── Profile menu panel ───────────────────────────────
          if (_profileOpen || _profileCtrl.status != AnimationStatus.dismissed)
            Positioned(
              top: topOffset + 4,
              left: 16, right: 16, bottom: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SlideTransition(
                  position: _profileSlideAnim,
                  child: ProfileMenuPanel(
                    onItemTap: (item) {
                      _closeProfile();
                      if (item.route.isNotEmpty) context.push(item.route);
                    },
                    onLogOut: _closeProfile,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── White Section Card Wrapper ───────────────────────────────────

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }

  // ─── Greeting Header ─────────────────────────────────────────────

  Widget _buildGreetingHeader(double topOffset) {
    return Container(
      margin: EdgeInsets.only(
        top: topOffset + 12,
        left: 16,
        right: 16,
        bottom: 0,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, ${MockHomeData.userName}!',
            style: IthakiTheme.headingLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "Here's a quick overview of your latest job matches, updates, and helpful tips to move your career forward.",
            style: IthakiTheme.bodyRegular.copyWith(
              color: IthakiTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Search + Chips ───────────────────────────────────────────────

  Widget _buildSearchContent() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: IthakiTheme.borderLight),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search by job title',
              hintStyle: TextStyle(color: IthakiTheme.softGraphite),
              prefixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: IthakiIcon('search', size: 20,
                      color: IthakiTheme.softGraphite),
                ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MockHomeData.filterChips
              .map((label) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: IthakiTheme.borderLight),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  // ─── Job Recommendations ──────────────────────────────────────────

  Widget _buildJobsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Smart Job Recommendations', style: IthakiTheme.headingMedium),
        const SizedBox(height: 12),
        ...MockHomeData.jobs.map(
          (job) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: IthakiJobRecommendationCard(
              companyName: job.companyName,
              companyInitials: job.companyInitials,
              companyColor: job.companyColor,
              jobTitle: job.jobTitle,
              salary: job.salary,
              matchPercentage: job.matchPercentage,
              matchLabel: job.matchLabel,
              location: job.location,
              workMode: job.workMode,
              employmentType: job.employmentType,
              level: job.level,
            ),
          ),
        ),
        const SizedBox(height: 4),
        _buildPurpleButton('View All'),
      ],
    );
  }

  // ─── Courses ──────────────────────────────────────────────────────

  Widget _buildCoursesContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recommended Courses', style: IthakiTheme.headingMedium),
        const SizedBox(height: 4),
        Text(
          "Boost your skills with courses that help you grow faster and stay aligned with today's industry standards. Learn at your own pace and strengthen the experience on your profile.",
          style: IthakiTheme.bodyRegular.copyWith(
            color: IthakiTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        ...MockHomeData.courses.map(
          (course) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: IthakiCourseCard(
              title: course.title,
              tags: course.tags,
              description: course.description,
              format: course.format,
              duration: course.duration,
              level: course.level,
            ),
          ),
        ),
        const SizedBox(height: 4),
        _buildPurpleButton('View All'),
      ],
    );
  }

  // ─── News ─────────────────────────────────────────────────────────

  Widget _buildNewsContent() {
    final newsList = MockHomeData.news;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Latest News', style: IthakiTheme.headingMedium),
        const SizedBox(height: 12),
        for (int i = 0; i < newsList.length; i++) ...[
          IthakiNewsTile(
            tag: newsList[i].tag,
            date: newsList[i].date,
            title: newsList[i].title,
          ),
          if (i < newsList.length - 1)
            const Divider(height: 24, color: IthakiTheme.borderLight),
        ],
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              // TODO: Navigate to all news
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: IthakiTheme.borderLight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Discover All News',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Questions ────────────────────────────────────────────────────

  Widget _buildQuestionsContent() {
    return Column(
      children: [
        const Row(
          children: [
            IthakiIcon('help',
                size: 24, color: IthakiTheme.accentPurpleLight),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Have questions?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Let us help you!',
            style: TextStyle(
                fontSize: 14, color: IthakiTheme.textSecondary),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              // TODO: Connect to booking
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: IthakiTheme.borderLight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'Book Call with Counselor',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Shared Helpers ───────────────────────────────────────────────

  // ─── Product Tour Card ────────────────────────────────────────────

  // ─── Profile Completion Card ──────────────────────────────────────

  Widget _buildProfileCompletionCard() {
    final completedCount = MockHomeData.profileItems.where((i) => i.completed).length;
    final total = MockHomeData.profileItems.length;
    final progress = completedCount / total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ColoredBox(
        color: const Color(0xFFDACCF8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Sección blanca: barra + checklist ─────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Complete your profile',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  IthakiHatchProgressBar(progress: progress),
                  const SizedBox(height: 12),
                  ...MockHomeData.profileItems.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(
                            color: item.completed ? IthakiTheme.textPrimary : IthakiTheme.softGray,
                            shape: BoxShape.circle,
                          ),
                          child: item.completed ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 14,
                              color: item.completed ? IthakiTheme.textPrimary : IthakiTheme.textSecondary,
                              fontWeight: item.completed ? FontWeight.w500 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            ),

            // ─── Sección #daccf8: welcome + benefits + button ──
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Ithaki!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: IthakiTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Fill in the missing information to unlock your full experience on the platform. A complete profile helps you get better job matches and more employer invitations.",
                    style: TextStyle(fontSize: 13, color: IthakiTheme.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Benefits of completing your profile',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  ...MockHomeData.profileBenefits.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check, size: 16, color: IthakiTheme.primaryPurple),
                        const SizedBox(width: 8),
                        Expanded(child: Text(b, overflow: TextOverflow.ellipsis, maxLines: 3, style: const TextStyle(fontSize: 13, color: IthakiTheme.textSecondary, height: 1.4))),
                      ],
                    ),
                  )),
                  const SizedBox(height: 14),
                  _buildPurpleButton('Fill Profile'),
                ],
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildPurpleButton(String label, {VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: IthakiTheme.primaryPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

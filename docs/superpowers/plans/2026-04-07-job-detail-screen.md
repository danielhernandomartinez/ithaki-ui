# Job Detail Screen Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a full Job Detail screen, accessible from the "To Job Details" button in ApplicationDetailsScreen, matching the Figma design (node 3:2998).

**Architecture:** New `JobDetailScreen` as a `ConsumerStatefulWidget` with `PanelMenuController`. Mock data lives in a `Provider.family` keyed by job id. The screen is a single `SingleChildScrollView` + `Stack` (for overlay panels) with a `bottomNavigationBar` sticky bar.

**Tech Stack:** Flutter, Riverpod 3, GoRouter 17, ithaki_design_system

---

### Task 1: Model — `lib/models/job_detail_models.dart`

**Files:**
- Create: `lib/models/job_detail_models.dart`

- [ ] Create the file with these classes:

```dart
import 'package:flutter/material.dart';

class JobReview {
  final String authorName;
  final String authorRole;
  final String authorInitials;
  final Color authorColor;
  final double rating;
  final String text;

  const JobReview({
    required this.authorName,
    required this.authorRole,
    required this.authorInitials,
    required this.authorColor,
    required this.rating,
    required this.text,
  });
}

class RecommendedJob {
  final String jobTitle;
  final String companyName;
  final String companyInitials;
  final Color companyColor;
  final String salary;
  final int matchPercentage;
  final String matchLabel;
  final String location;
  final String employmentType;

  const RecommendedJob({
    required this.jobTitle,
    required this.companyName,
    required this.companyInitials,
    required this.companyColor,
    required this.salary,
    required this.matchPercentage,
    required this.matchLabel,
    required this.location,
    required this.employmentType,
  });
}

class JobDetailCompany {
  final String name;
  final String industry;
  final Color logoColor;
  final String logoInitials;
  final String totalReviews;
  final double averageRating;
  final String description;

  const JobDetailCompany({
    required this.name,
    required this.industry,
    required this.logoColor,
    required this.logoInitials,
    required this.totalReviews,
    required this.averageRating,
    required this.description,
  });
}

class JobDetail {
  final String id;
  // Status card
  final String appliedAt;
  final String statusLabel;
  final String deadline;
  // Job header
  final String postedDate;
  final String jobTitle;
  final String companyName;
  final Color companyLogoColor;
  final String companyLogoInitials;
  // Match
  final int matchPercentage;
  final String matchLabel;
  // Details grid
  final String location;
  final String jobType;
  final String salaryRange;
  final String workplace;
  final String experienceLevel;
  final String languages;
  // Content sections
  final String description;
  final List<String> requirements;
  final List<String> skills;
  final String communication;
  final String niceToHave;
  final String whatWeOffer;
  // Reviews
  final List<JobReview> reviews;
  // Recommended
  final RecommendedJob recommended;
  // Company
  final JobDetailCompany company;
  // Sticky bar
  final String salary;

  const JobDetail({
    required this.id,
    required this.appliedAt,
    required this.statusLabel,
    required this.deadline,
    required this.postedDate,
    required this.jobTitle,
    required this.companyName,
    required this.companyLogoColor,
    required this.companyLogoInitials,
    required this.matchPercentage,
    required this.matchLabel,
    required this.location,
    required this.jobType,
    required this.salaryRange,
    required this.workplace,
    required this.experienceLevel,
    required this.languages,
    required this.description,
    required this.requirements,
    required this.skills,
    required this.communication,
    required this.niceToHave,
    required this.whatWeOffer,
    required this.reviews,
    required this.recommended,
    required this.company,
    required this.salary,
  });
}
```

- [ ] Run `flutter analyze lib/models/job_detail_models.dart` — expect: No issues found.

---

### Task 2: Provider — `lib/providers/job_detail_provider.dart`

**Files:**
- Create: `lib/providers/job_detail_provider.dart`

- [ ] Create the file with mock data:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job_detail_models.dart';

final jobDetailProvider =
    Provider.family<JobDetail?, String>((ref, id) => _mockDetails[id]);

const _mockCompany = JobDetailCompany(
  name: 'TechWave Group',
  industry: 'IT and Web Development',
  logoColor: Color(0xFF1E88E5),
  logoInitials: 'TW',
  totalReviews: '24 total reviews',
  averageRating: 4.5,
  description:
      'TechWave is a dynamic software company focused on creating modern web applications and digital tools. Our team values clean design, efficient code, and a collaborative culture.',
);

const _mockRecommended = RecommendedJob(
  jobTitle: 'Junior Front-End Developer',
  companyName: 'Nexora',
  companyInitials: 'NX',
  companyColor: Color(0xFF905CFF),
  salary: '2,000 € / month',
  matchPercentage: 100,
  matchLabel: 'STRONG MATCH',
  location: 'Athens',
  employmentType: 'Full-Time',
);

final _mockDetails = <String, JobDetail>{
  '1': const JobDetail(
    id: '1',
    appliedAt: 'You applied today, 09:30',
    statusLabel: 'Submitted',
    deadline: 'It has a deadline Application - 19 November 2025',
    postedDate: 'Posted 10-11-2025',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'TechWave Group',
    companyLogoColor: Color(0xFF1E88E5),
    companyLogoInitials: 'TW',
    matchPercentage: 100,
    matchLabel: 'STRONG MATCH',
    location: 'Thessaloniki',
    jobType: 'Full-Time',
    salaryRange: '€1,000–€1,400',
    workplace: 'Office',
    experienceLevel: 'Entry',
    languages: 'English, Greek',
    description:
        'TechWave is looking for a motivated Junior Front-End Developer to join our growing team and collaborate closely with designers and developers to bring digital products to life.\n\nAs a Junior Front-End Developer you will work with HTML, CSS, JavaScript, and React. You will report to a Senior Developer who will guide and mentor you in best practices. The team uses modern tools with agile development.\n\nThis is a great opportunity for someone with a passion for front-end development and who is eager to grow in a professional setting.',
    requirements: [
      'Basic understanding of HTML, CSS, and JavaScript',
      'Basic understanding of any front-end framework is a plus',
      'Willingness to learn and grow in a fast-paced environment',
      'Experience with version control tools like Git or similar',
      'Familiarity with version control systems (Git or similar)',
      'Willingness to learn and accept feedback gracefully',
    ],
    skills: [
      'English',
      'Greek',
      'HTML',
      'CSS',
      'JavaScript',
      'React',
      'NEXT.js',
      'TypeScript',
    ],
    communication: 'Responsive Design',
    niceToHave:
        'Experience with Git or GitHub\nFamiliarity with any CSS framework (Bootstrap, Tailwind)\nBasic knowledge of RESTful APIs',
    whatWeOffer:
        'Cosy office in the city center\nCareer growth opportunities in line with company growth\nModern tech stack and a collaborative culture',
    reviews: [
      JobReview(
        authorName: 'Eva Karitsas',
        authorRole: 'IT — Employee',
        authorInitials: 'EK',
        authorColor: Color(0xFF905CFF),
        rating: 5.0,
        text:
            'This role offers a good opportunity for growth and skill building.',
      ),
      JobReview(
        authorName: 'Nikos Papadakis',
        authorRole: 'IT — Employee',
        authorInitials: 'NP',
        authorColor: Color(0xFF1E88E5),
        rating: 4.0,
        text: 'Good team, friendly environment and interesting projects.',
      ),
    ],
    recommended: _mockRecommended,
    company: _mockCompany,
    salary: '1,500 € / month',
  ),
  '2': const JobDetail(
    id: '2',
    appliedAt: 'You applied on 16 November, 11:30',
    statusLabel: 'Viewed',
    deadline: 'It has a deadline Application - 19 November 2025',
    postedDate: 'Posted 10-11-2025',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'TechWave Group',
    companyLogoColor: Color(0xFF1E88E5),
    companyLogoInitials: 'TW',
    matchPercentage: 100,
    matchLabel: 'STRONG MATCH',
    location: 'Thessaloniki',
    jobType: 'Full-Time',
    salaryRange: '€1,000–€1,400',
    workplace: 'Office',
    experienceLevel: 'Entry',
    languages: 'English, Greek',
    description:
        'TechWave is looking for a motivated Junior Front-End Developer to join our growing team and collaborate closely with designers and developers to bring digital products to life.\n\nAs a Junior Front-End Developer you will work with HTML, CSS, JavaScript, and React. You will report to a Senior Developer who will guide and mentor you in best practices.',
    requirements: [
      'Basic understanding of HTML, CSS, and JavaScript',
      'Basic understanding of any front-end framework is a plus',
      'Willingness to learn and grow in a fast-paced environment',
      'Experience with version control tools like Git or similar',
    ],
    skills: ['English', 'Greek', 'HTML', 'CSS', 'JavaScript', 'React'],
    communication: 'Responsive Design',
    niceToHave:
        'Experience with Git or GitHub\nFamiliarity with any CSS framework',
    whatWeOffer:
        'Cosy office in the city center\nCareer growth opportunities in line with company growth',
    reviews: [
      JobReview(
        authorName: 'Eva Karitsas',
        authorRole: 'IT — Employee',
        authorInitials: 'EK',
        authorColor: Color(0xFF905CFF),
        rating: 5.0,
        text: 'This role offers a good opportunity for growth and skill building.',
      ),
    ],
    recommended: _mockRecommended,
    company: _mockCompany,
    salary: '1,500 € / month',
  ),
};
```

- [ ] Run `flutter analyze lib/providers/job_detail_provider.dart` — expect: No issues found.

---

### Task 3: Route — add `jobDetail` to `routes.dart` and `router.dart`

**Files:**
- Modify: `lib/routes.dart`
- Modify: `lib/router.dart`

- [ ] In `lib/routes.dart`, inside `abstract final class Routes`, add after `applicationDetail`:

```dart
static const jobDetail = '/applications/:id/job';
static String jobDetailFor(String applicationId) => '/applications/$applicationId/job';
```

- [ ] In `lib/router.dart`, add import at top:

```dart
import 'screens/applications/job_detail_screen.dart';
```

- [ ] In `lib/router.dart`, inside the nested `routes:` of the `/applications` GoRoute, add a sibling route after the `:id` route:

```dart
GoRoute(
  path: ':id/job',
  builder: (context, state) {
    final id = state.pathParameters['id'] ?? '';
    return JobDetailScreen(applicationId: id);
  },
),
```

Note: this goes at the TOP-LEVEL routes list (sibling of the `/applications` route), NOT nested inside it, because GoRouter nested routes would make the path `/applications/:id/:id/job`. Add it as a top-level route with full path `/applications/:id/job`.

Actually, the correct approach: add it as a sibling top-level route with path `Routes.jobDetail` = `/applications/:id/job`:

```dart
GoRoute(
  path: Routes.jobDetail,
  builder: (context, state) {
    final id = state.pathParameters['id'] ?? '';
    return JobDetailScreen(applicationId: id);
  },
),
```

- [ ] Run `flutter analyze lib/router.dart lib/routes.dart` — expect: No issues found.

---

### Task 4: Screen — `lib/screens/applications/job_detail_screen.dart`

**Files:**
- Create: `lib/screens/applications/job_detail_screen.dart`

- [ ] Create the screen file. The screen follows the exact same `ConsumerStatefulWidget` + `PanelMenuController` + `Stack` body pattern as `MyApplicationsScreen`. Full file:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../models/job_detail_models.dart';
import '../../providers/home_provider.dart';
import '../../providers/job_detail_provider.dart';
import '../../providers/profile_provider.dart';
import '../../routes.dart';
import '../../utils/match_colors.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final String applicationId;
  const JobDetailScreen({super.key, required this.applicationId});

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen>
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
    final detail = ref.watch(jobDetailProvider(widget.applicationId));
    final homeData = ref.watch(homeProvider).value;
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    if (detail == null) {
      return const Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
      bottomNavigationBar: _StickyBar(detail: detail),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: topOffset),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _StatusCard(detail: detail),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _JobCard(detail: detail),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _ReviewsCard(detail: detail),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _RecommendedCard(job: detail.recommended),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _CompanyCard(company: detail.company),
                ),
                SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
              ],
            ),
          ),

          // Dim overlay
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

          // Nav menu
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

          // Profile panel
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

// ─── Status card ──────────────────────────────────────────────────────────────

class _StatusCard extends StatelessWidget {
  final JobDetail detail;
  const _StatusCard({required this.detail});

  static Color _badgeColor(String label) {
    switch (label) {
      case 'Submitted':
        return const Color(0xFFE9DEFF);
      case 'Viewed':
        return const Color(0xFFE9E9E9);
      case 'Interview':
        return const Color(0xFFD8E5F9);
      case 'Offer':
        return const Color(0xFFD6F5D0);
      case 'Rejected':
        return const Color(0xFFFFE0E0);
      default:
        return const Color(0xFFE9E9E9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  detail.appliedAt,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: IthakiTheme.textPrimary,
                    letterSpacing: -0.32,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _badgeColor(detail.statusLabel),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  detail.statusLabel,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            detail.deadline,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.softGraphite,
              letterSpacing: -0.28,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Job card ─────────────────────────────────────────────────────────────────

class _JobCard extends StatelessWidget {
  final JobDetail detail;
  const _JobCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final bgColor = getMatchBgColor(detail.matchLabel);
    final gradientColors = getMatchGradientColors(detail.matchLabel);

    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Posted date
          Text(
            detail.postedDate,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF4B4B4B),
              letterSpacing: -0.28,
            ),
          ),
          const SizedBox(height: 12),

          // Company + title
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: detail.companyLogoColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: Text(
                  detail.companyLogoInitials,
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: detail.companyLogoColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.jobTitle,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary,
                        letterSpacing: -0.44,
                      ),
                    ),
                    Text(
                      detail.companyName,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: IthakiTheme.softGraphite,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Details grid
          Wrap(
            spacing: 0,
            runSpacing: 12,
            children: [
              _DetailCell(icon: 'location', value: detail.location),
              _DetailCell(icon: 'clock', value: detail.jobType),
              _DetailCell(
                  value: detail.salaryRange, semibold: true),
              _DetailCell(icon: 'company-profile', value: detail.workplace),
              _DetailCell(icon: 'level', value: detail.experienceLevel),
              _DetailCell(icon: 'globe', value: detail.languages, wide: true),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),

          // Match bar
          Container(
            width: double.infinity,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: bgColor,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                const SizedBox.expand(),
                FractionallySizedBox(
                  widthFactor: detail.matchPercentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: gradientColors),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${detail.matchPercentage}%',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: IthakiTheme.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            detail.matchLabel,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: IthakiTheme.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),

          // Why this match
          const Text(
            'Curious why you match this job?',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: IthakiTheme.textPrimary,
              letterSpacing: -0.32,
            ),
          ),
          const SizedBox(height: 4),
          IthakiButton(
            'Ask Career Assistant',
            variant: IthakiButtonVariant.outline,
            onPressed: () {},
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 16),

          // Description
          _SectionTitle('About the company'),
          const SizedBox(height: 8),
          Text(
            detail.description,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 16),

          // Requirements
          _SectionTitle('Requirements'),
          const SizedBox(height: 8),
          ...detail.requirements.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(
                            fontSize: 15, color: IthakiTheme.textPrimary)),
                    Expanded(
                      child: Text(
                        r,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: IthakiTheme.textPrimary,
                          height: 1.5,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 16),

          // Skills
          _SectionTitle('Skills'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: detail.skills
                .map((s) => _SkillChip(label: s))
                .toList(),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 16),

          // Communication
          _SectionTitle('Communication'),
          const SizedBox(height: 8),
          Text(
            detail.communication,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 16),

          // Nice to have
          _SectionTitle('Nice to have'),
          const SizedBox(height: 8),
          Text(
            detail.niceToHave,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 16),

          // What we offer
          _SectionTitle('What we offer'),
          const SizedBox(height: 8),
          Text(
            detail.whatWeOffer,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Noto Sans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: IthakiTheme.textPrimary,
        letterSpacing: -0.36,
      ),
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String? icon;
  final String value;
  final bool semibold;
  final bool wide;

  const _DetailCell({
    this.icon,
    required this.value,
    this.semibold = false,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wide ? double.infinity : 160,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IthakiIcon(icon!, size: 18, color: IthakiTheme.softGraphite),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: semibold ? 18 : 15,
                fontWeight:
                    semibold ? FontWeight.w600 : FontWeight.w400,
                color: IthakiTheme.textPrimary,
                letterSpacing: semibold ? -0.36 : -0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: IthakiTheme.chipActive,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Noto Sans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: IthakiTheme.textPrimary,
        ),
      ),
    );
  }
}

// ─── Reviews card ─────────────────────────────────────────────────────────────

class _ReviewsCard extends StatelessWidget {
  final JobDetail detail;
  const _ReviewsCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Employee Reviews',
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                  letterSpacing: -0.36,
                ),
              ),
              Text(
                detail.company.totalReviews,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: IthakiTheme.softGraphite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                detail.company.averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              _StarRow(rating: detail.company.averageRating),
            ],
          ),
          const SizedBox(height: 12),
          ...detail.reviews.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ReviewItem(review: r),
              )),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final double rating;
  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        return IthakiIcon(
          filled ? 'star-filled' : 'star',
          size: 18,
          color: filled
              ? const Color(0xFFFFB800)
              : IthakiTheme.borderLight,
        );
      }),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final JobReview review;
  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: review.authorColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  review.authorInitials,
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: review.authorColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    Text(
                      review.authorRole,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: IthakiTheme.softGraphite,
                      ),
                    ),
                  ],
                ),
              ),
              _StarRow(rating: review.rating),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.text,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Recommended card ─────────────────────────────────────────────────────────

class _RecommendedCard extends StatelessWidget {
  final RecommendedJob job;
  const _RecommendedCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final bgColor = getMatchBgColor(job.matchLabel);
    final gradientColors = getMatchGradientColors(job.matchLabel);

    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended for you',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary,
              letterSpacing: -0.36,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: job.companyColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: Text(
                  job.companyInitials,
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: job.companyColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.jobTitle,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.textPrimary,
                        letterSpacing: -0.32,
                      ),
                    ),
                    Text(
                      job.companyName,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: IthakiTheme.softGraphite,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            job.salary,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary,
              letterSpacing: -0.36,
            ),
          ),
          const SizedBox(height: 8),
          // Match bar
          Container(
            width: double.infinity,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: bgColor,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                const SizedBox.expand(),
                FractionallySizedBox(
                  widthFactor: job.matchPercentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: gradientColors),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${job.matchPercentage}%',
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: IthakiTheme.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            job.matchLabel,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: IthakiTheme.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IthakiIcon('location', size: 16, color: IthakiTheme.softGraphite),
              const SizedBox(width: 4),
              Text(
                job.location,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  color: IthakiTheme.softGraphite,
                ),
              ),
              const SizedBox(width: 12),
              IthakiIcon('clock', size: 16, color: IthakiTheme.softGraphite),
              const SizedBox(width: 4),
              Text(
                job.employmentType,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 14,
                  color: IthakiTheme.softGraphite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: IthakiButton(
                  'Save Job',
                  variant: IthakiButtonVariant.outline,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: IthakiButton(
                  'View Job',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Company card ─────────────────────────────────────────────────────────────

class _CompanyCard extends StatelessWidget {
  final JobDetailCompany company;
  const _CompanyCard({required this.company});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About the Company',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary,
              letterSpacing: -0.36,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: company.logoColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: Text(
                  company.logoInitials,
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: company.logoColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company.name,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.textPrimary,
                        letterSpacing: -0.32,
                      ),
                    ),
                    Text(
                      company.industry,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: IthakiTheme.softGraphite,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          Text(
            company.description,
            style: const TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: IthakiTheme.textPrimary,
              height: 1.5,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          IthakiButton(
            'Company Profile',
            variant: IthakiButtonVariant.outline,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ─── Sticky bar ───────────────────────────────────────────────────────────────

class _StickyBar extends StatelessWidget {
  final JobDetail detail;
  const _StickyBar({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: IthakiTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E1E).withValues(alpha: 0.15),
            offset: const Offset(0, 4),
            blurRadius: 14,
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              detail.salary,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.32,
              ),
            ),
          ),
          const Spacer(),
          IthakiButton(
            'Save Job',
            variant: IthakiButtonVariant.outline,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          IthakiButton(
            'Apply',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
```

- [ ] Run `flutter analyze lib/screens/applications/job_detail_screen.dart` — expect: No issues found.

---

### Task 5: Wire the "To Job Details" button

**Files:**
- Modify: `lib/screens/applications/application_details_screen.dart`

- [ ] In `_StickyBottomBar`, add `applicationId` parameter:

```dart
class _StickyBottomBar extends StatelessWidget {
  final VoidCallback onTap;
  const _StickyBottomBar({required this.onTap});
```

Replace with:

```dart
class _StickyBottomBar extends StatelessWidget {
  final String applicationId;
  const _StickyBottomBar({required this.applicationId});
```

- [ ] Update `_StickyBottomBar.build` to navigate:

```dart
child: IthakiButton(
  'To Job Details',
  onPressed: () => context.push(Routes.jobDetailFor(applicationId)),
),
```

- [ ] Update the call site in `_ApplicationDetailsScreenState.build`:

```dart
bottomNavigationBar: _StickyBottomBar(
  applicationId: widget.applicationId,
),
```

- [ ] Run `flutter analyze lib/screens/applications/application_details_screen.dart` — expect: No issues found.

---

### Task 6: Final check

- [ ] Run `flutter analyze lib/` — expect: No issues found.

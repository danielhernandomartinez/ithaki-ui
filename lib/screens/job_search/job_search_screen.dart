import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../data/mock_job_search_data.dart';
import '../../data/mock_home_data.dart';
import '../../providers/profile_provider.dart';
import '../../utils/match_colors.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';

class JobSearchScreen extends ConsumerStatefulWidget {
  const JobSearchScreen({super.key});

  @override
  ConsumerState<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends ConsumerState<JobSearchScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;
  int _selectedTab = 0;
  int _currentPage = 1;
  final Set<int> _savedJobIndices = {};
  Set<String> _selectedCategories = {};
  Set<String> _selectedLocations = {};
  Set<String> _selectedWorkModes = {};
  Set<String> _selectedEmploymentTypes = {};
  Set<String> _selectedLevels = {};

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
        avatarInitials: MockHomeData.userInitials,
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(
        children: [
          // ─── Main content ─────────────────────────────────
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: topOffset + 12),
                _buildTabBar(),
                const SizedBox(height: 12),
                _buildSearchAndFilters(),
                const SizedBox(height: 12),
                _buildJobsSection(),
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
                SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 16),
              ],
            ),
          ),

          // ─── Dim overlay ──────────────────────────────────
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

          // ─── Nav menu panel ───────────────────────────────
          if (_panels.menuOpen || _panels.menuCtrl.status != AnimationStatus.dismissed)
            Positioned(
              top: topOffset - 14,
              left: 16, right: 16, bottom: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: SlideTransition(
                  position: _panels.slideAnim,
                  child: AppNavDrawer(
                    currentRoute: Routes.jobSearch,
                    profileProgress: ref.watch(profileProvider).profileCompletion,
                    items: kAppNavItems,
                    onItemTap: (item) {
                      _panels.closeMenu();
                      if (item.route != Routes.jobSearch) context.go(item.route);
                    },
                  ),
                ),
              ),
            ),

          // ─── Profile menu panel ───────────────────────────
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

  // ─── Tab Bar (All Jobs / Saved) ──────────────────────────────────

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Color(0xFFE9DEFF),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _buildTabItem('All Jobs', 0),
            const SizedBox(width: 4),
            _buildTabItem('Saved (${MockJobSearchData.savedCount})', 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : const Color(0x00FFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? IthakiTheme.textPrimary
                  : IthakiTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Search + Filters ────────────────────────────────────────────

  int get _activeFilterCount =>
      _selectedCategories.length +
      _selectedLocations.length +
      _selectedWorkModes.length +
      _selectedEmploymentTypes.length +
      _selectedLevels.length;

  Widget _buildSearchAndFilters() {
    final count = _activeFilterCount;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Search field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: IthakiTheme.lightGraphite),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search by job title',
                  hintStyle: TextStyle(color: IthakiTheme.softGraphite),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: IthakiIcon('search',
                        size: 20, color: IthakiTheme.lightGraphite),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Filters row
            GestureDetector(
              onTap: _openFiltersSheet,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: count > 0
                        ? IthakiTheme.primaryPurple
                        : IthakiTheme.borderLight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    IthakiIcon(
                      'filter',
                      size: 18,
                      color: count > 0
                          ? IthakiTheme.primaryPurple
                          : IthakiTheme.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        count > 0 ? 'Filters ($count)' : 'Filters',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: count > 0
                              ? IthakiTheme.primaryPurple
                              : IthakiTheme.textPrimary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: count > 0
                          ? IthakiTheme.primaryPurple
                          : IthakiTheme.softGraphite,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFiltersSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FiltersSheet(
        selectedCategories: _selectedCategories,
        selectedLocations: _selectedLocations,
        selectedWorkModes: _selectedWorkModes,
        selectedEmploymentTypes: _selectedEmploymentTypes,
        selectedLevels: _selectedLevels,
        onApply: (categories, locations, workModes, employmentTypes, levels) {
          setState(() {
            _selectedCategories = categories;
            _selectedLocations = locations;
            _selectedWorkModes = workModes;
            _selectedEmploymentTypes = employmentTypes;
            _selectedLevels = levels;
          });
        },
      ),
    );
  }

  // ─── Jobs Section (count + cards + pagination in one white bubble) ─

  Widget _buildJobsSection() {
    final jobs = MockJobSearchData.jobs;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results count
          Text(
            '${_formatNumber(MockJobSearchData.totalJobs)} jobs found',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: IthakiTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Job cards
          for (int i = 0; i < jobs.length; i++) ...[
            IthakiJobSearchCard(
              jobTitle: jobs[i].jobTitle,
              companyName: jobs[i].companyName,
              salary: jobs[i].salary,
              matchPercentage: jobs[i].matchPercentage,
              matchLabel: jobs[i].matchLabel,
              matchGradientColors: getMatchGradientColors(jobs[i].matchLabel),
              matchBackgroundColor: getMatchBgColor(jobs[i].matchLabel),
              category: jobs[i].category,
              location: jobs[i].location,
              workMode: jobs[i].workMode,
              employmentType: jobs[i].employmentType,
              level: jobs[i].level,
              postedAgo: jobs[i].postedAgo,
              isSaved: _savedJobIndices.contains(i),
              onSave: () {
                setState(() {
                  if (_savedJobIndices.contains(i)) {
                    _savedJobIndices.remove(i);
                  } else {
                    _savedJobIndices.add(i);
                  }
                });
              },
              onView: () {},
            ),
            if (i < jobs.length - 1) const SizedBox(height: 12),
          ],
          const SizedBox(height: 16),
          // Pagination
          _buildPagination(),
        ],
      ),
    );
  }

  // ─── Pagination ──────────────────────────────────────────────────

  Widget _buildPagination() {
    const totalPages = MockJobSearchData.totalPages;

    // Build page numbers to show: 1 2 3 ... 25
    final pages = <int>[];
    if (totalPages <= 5) {
      for (int i = 1; i <= totalPages; i++) {
        pages.add(i);
      }
    } else {
      // Show first 3 pages, ellipsis, last page
      pages.addAll([1, 2, 3]);
      // We'll handle the ellipsis and last page in the builder
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Page numbers
          for (final page in pages) ...[
            _buildPageButton(page),
            const SizedBox(width: 6),
          ],
          if (totalPages > 5) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '...',
                style: TextStyle(
                  fontSize: 15,
                  color: IthakiTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 6),
            _buildPageButton(totalPages),
            const SizedBox(width: 6),
          ],
          // Next arrow
          GestureDetector(
            onTap: _currentPage < totalPages
                ? () => setState(() => _currentPage++)
                : null,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: IthakiTheme.borderLight),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.chevron_right,
                size: 20,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ],
      );
  }

  Widget _buildPageButton(int page) {
    final isSelected = _currentPage == page;
    return GestureDetector(
      onTap: () => setState(() => _currentPage = page),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? IthakiTheme.primaryPurple : Colors.transparent,
          border: isSelected
              ? null
              : Border.all(color: IthakiTheme.borderLight),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          '$page',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : IthakiTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────


  String _formatNumber(int number) {
    if (number >= 1000) {
      final str = number.toString();
      final buffer = StringBuffer();
      for (int i = 0; i < str.length; i++) {
        if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
        buffer.write(str[i]);
      }
      return buffer.toString();
    }
    return number.toString();
  }
}

// ─── Filters Bottom Sheet ──────────────────────────────────────────

class _FiltersSheet extends StatefulWidget {
  final Set<String> selectedCategories;
  final Set<String> selectedLocations;
  final Set<String> selectedWorkModes;
  final Set<String> selectedEmploymentTypes;
  final Set<String> selectedLevels;
  final void Function(
    Set<String> categories,
    Set<String> locations,
    Set<String> workModes,
    Set<String> employmentTypes,
    Set<String> levels,
  ) onApply;

  const _FiltersSheet({
    required this.selectedCategories,
    required this.selectedLocations,
    required this.selectedWorkModes,
    required this.selectedEmploymentTypes,
    required this.selectedLevels,
    required this.onApply,
  });

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late Set<String> _categories;
  late Set<String> _locations;
  late Set<String> _workModes;
  late Set<String> _employmentTypes;
  late Set<String> _levels;

  @override
  void initState() {
    super.initState();
    _categories = Set.from(widget.selectedCategories);
    _locations = Set.from(widget.selectedLocations);
    _workModes = Set.from(widget.selectedWorkModes);
    _employmentTypes = Set.from(widget.selectedEmploymentTypes);
    _levels = Set.from(widget.selectedLevels);
  }

  void _clearAll() {
    setState(() {
      _categories.clear();
      _locations.clear();
      _workModes.clear();
      _employmentTypes.clear();
      _levels.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close,
                        size: 22, color: IthakiTheme.textPrimary),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Scrollable filter sections
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildSection(
                    'Category',
                    [
                      'Design and Creative',
                      'IT and Web Development',
                      'Sales',
                      'Customer Service',
                      'Admin and Secretarial',
                      'Marketing',
                      'Logistics and Supply Chain',
                      'Arts, Entertainment and Music',
                    ],
                    _categories,
                    (v) => setState(() => _categories = v),
                  ),
                  _buildSection(
                    'Location',
                    ['Athens', 'Thessaloniki', 'Chalkida'],
                    _locations,
                    (v) => setState(() => _locations = v),
                  ),
                  _buildSection(
                    'Work Mode',
                    ['On-site', 'Remote', 'Hybrid'],
                    _workModes,
                    (v) => setState(() => _workModes = v),
                  ),
                  _buildSection(
                    'Employment Type',
                    ['Full-Time', 'Part-Time', 'Contract', 'Freelance', 'Internship'],
                    _employmentTypes,
                    (v) => setState(() => _employmentTypes = v),
                  ),
                  _buildSection(
                    'Level',
                    ['Entry', 'Junior', 'Mid-level', 'Senior', 'Lead'],
                    _levels,
                    (v) => setState(() => _levels = v),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Bottom buttons
            Padding(
              padding: EdgeInsets.fromLTRB(
                  24, 12, 24, MediaQuery.of(context).padding.bottom + 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: _clearAll,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: IthakiTheme.borderLight),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: IthakiTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onApply(
                            _categories,
                            _locations,
                            _workModes,
                            _employmentTypes,
                            _levels,
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: IthakiTheme.primaryPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<String> options,
    Set<String> selected,
    ValueChanged<Set<String>> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: IthakiTheme.fieldLabel),
          const SizedBox(height: 10),
          IthakiChipGroup(
            options: options,
            selected: selected,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

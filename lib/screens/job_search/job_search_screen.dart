import 'dart:async';
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
import '../../data/countries.dart';
import '../../services/city_search_service.dart';

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
  final Map<String, Set<String>> _filters = {
    'Location': {},
    'Industry': {},
    'Skills': {},
    'Job Type': {},
    'Workplace': {},
    'Experience Level': {},
    'Salary': {},
    'Travel': {},
  };

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
                    profileProgress: ref.watch(profileCompletionProvider),
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
      _filters.values.fold(0, (sum, s) => sum + s.length);

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
        filters: _filters,
        onApply: (updated) => setState(() {
          for (final e in updated.entries) {
            _filters[e.key] = e.value;
          }
        }),
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

const _kFilterOptions = {
  'Location':         ['Athens', 'Thessaloniki', 'Remote', 'Chalkida', 'Patras'],
  'Industry':         ['IT & Web Development', 'Design & Creative', 'Sales', 'Marketing', 'Customer Service', 'Logistics', 'Finance', 'Healthcare'],
  'Skills':           ['Flutter', 'React', 'Python', 'Figma', 'SQL', 'Node.js', 'Swift', 'Kotlin'],
  'Job Type':         ['Full-Time', 'Part-Time', 'Contract', 'Freelance', 'Internship'],
  'Workplace':        ['On-site', 'Remote', 'Hybrid'],
  'Experience Level': ['Entry', 'Junior', 'Mid-level', 'Senior', 'Lead'],
  'Salary':           ['< 1 000 €', '1 000 – 2 000 €', '2 000 – 3 500 €', '3 500 – 5 000 €', '> 5 000 €'],
  'Travel':           ['No travel', 'Occasional', 'Frequent', 'International'],
};

class _FiltersSheet extends StatefulWidget {
  final Map<String, Set<String>> filters;
  final void Function(Map<String, Set<String>>) onApply;

  const _FiltersSheet({required this.filters, required this.onApply});

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late Map<String, Set<String>> _local;

  @override
  void initState() {
    super.initState();
    _local = {for (final e in widget.filters.entries) e.key: Set.from(e.value)};
  }

  void _openSubSheet(String filterName) {
    if (filterName == 'Location') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _LocationFilterSheet(
          selected: Set.from(_local['Location'] ?? {}),
          onConfirm: (selected) =>
              setState(() => _local['Location'] = selected),
        ),
      );
      return;
    }
    final options = _kFilterOptions[filterName] ?? [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSubSheet(
        title: filterName,
        options: options,
        selected: Set.from(_local[filterName] ?? {}),
        onConfirm: (selected) => setState(() => _local[filterName] = selected),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filters',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary)),
                IconButton(
                  icon: const Icon(Icons.close,
                      size: 22, color: IthakiTheme.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // ── Filter rows ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: _kFilterOptions.keys.map((name) {
                final count = (_local[name] ?? {}).length;
                return GestureDetector(
                  onTap: () => _openSubSheet(name),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Row(children: [
                      Expanded(
                        child: Text(name,
                            style: const TextStyle(
                                fontSize: 15,
                                color: IthakiTheme.textPrimary)),
                      ),
                      if (count > 0)
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: IthakiTheme.primaryPurple,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text('$count',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ),
                      const Icon(Icons.chevron_right,
                          color: IthakiTheme.softGraphite, size: 20),
                    ]),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // ── Buttons ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(
                      () => _local.updateAll((_, __) => {})),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Reset Filters'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: IthakiTheme.borderLight),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    foregroundColor: IthakiTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_local);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IthakiTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Apply Filters',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Sub Sheet ───────────────────────────────────────────────

class _FilterSubSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final Set<String> selected;
  final void Function(Set<String>) onConfirm;

  const _FilterSubSheet({
    required this.title,
    required this.options,
    required this.selected,
    required this.onConfirm,
  });

  @override
  State<_FilterSubSheet> createState() => _FilterSubSheetState();
}

class _FilterSubSheetState extends State<_FilterSubSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: IthakiTheme.textPrimary)),
                IconButton(
                  icon: const Icon(Icons.close,
                      size: 22, color: IthakiTheme.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IthakiChipGroup(
              options: widget.options,
              selected: _selected,
              onChanged: (v) => setState(() => _selected = v),
            ),
          ),
          const SizedBox(height: 20),
          // Confirm button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onConfirm(_selected);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: IthakiTheme.primaryPurple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Done',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Location Filter Sheet ──────────────────────────────────────────

class _LocationFilterSheet extends ConsumerStatefulWidget {
  final Set<String> selected;
  final void Function(Set<String>) onConfirm;

  const _LocationFilterSheet(
      {required this.selected, required this.onConfirm});

  @override
  ConsumerState<_LocationFilterSheet> createState() =>
      _LocationFilterSheetState();
}

class _LocationFilterSheetState extends ConsumerState<_LocationFilterSheet> {
  SearchItem? _country;
  final _searchCtrl = TextEditingController();
  Timer? _debounce;
  List<CityResult> _results = [];
  bool _loading = false;
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selected);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _pickCountry() {
    SearchBottomSheet.show(context, 'Select Country', allCountries,
        (item) => setState(() {
              _country = item;
              _searchCtrl.clear();
              _results = [];
            }));
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 2) {
      setState(() => _results = []);
      return;
    }
    _debounce = Timer(
        const Duration(milliseconds: 400), () => _search(value.trim()));
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    final results = await ref
        .read(citySearchServiceProvider)
        .search(query, countryCode: _country?.id);
    if (mounted) setState(() { _results = results; _loading = false; });
  }

  void _toggle(String city) => setState(() =>
      _selected.contains(city) ? _selected.remove(city) : _selected.add(city));

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding + 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 16, 20, 0),
            child: Row(children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    size: 22, color: IthakiTheme.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              const Text('Location',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: IthakiTheme.textPrimary)),
            ]),
          ),
          const SizedBox(height: 12),

          // ── Country picker ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: _pickCountry,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: _country != null
                          ? IthakiTheme.primaryPurple
                          : IthakiTheme.borderLight),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(children: [
                  if (_country != null) ...[
                    IthakiFlag(_country!.id, width: 22, height: 16),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      _country?.label ?? 'Select a country first',
                      style: TextStyle(
                        fontSize: 14,
                        color: _country != null
                            ? IthakiTheme.textPrimary
                            : IthakiTheme.softGraphite,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down,
                      color: IthakiTheme.softGraphite),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── City search ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchCtrl,
              enabled: _country != null,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: _country != null
                    ? 'Search city in ${_country!.label}…'
                    : 'Search for Location',
                hintStyle: const TextStyle(
                    color: IthakiTheme.softGraphite, fontSize: 14),
                prefixIcon:
                    const Icon(Icons.search, color: IthakiTheme.softGraphite),
                suffixIcon: _loading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2)))
                    : null,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: IthakiTheme.borderLight)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: IthakiTheme.borderLight)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                        color: IthakiTheme.primaryPurple, width: 1.5)),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: Color(0xFFEEEEEE))),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: _country == null,
                fillColor: const Color(0xFFF8F8F8),
              ),
            ),
          ),

          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // ── Checkbox list ─────────────────────────────────
          Expanded(
            child: ListView(
              children: [
                // "All" row
                CheckboxListTile(
                  value: _selected.isEmpty,
                  onChanged: (_) => setState(() => _selected.clear()),
                  title: const Text('All',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: IthakiTheme.textPrimary)),
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: IthakiTheme.primaryPurple,
                  checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                // Selected cities not currently in results
                ..._selected
                    .where((city) => !_results.any((r) => r.city == city))
                    .map((city) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CheckboxListTile(
                              value: true,
                              onChanged: (_) => _toggle(city),
                              title: Text(city,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: IthakiTheme.textPrimary)),
                              controlAffinity:
                                  ListTileControlAffinity.trailing,
                              activeColor: IthakiTheme.primaryPurple,
                              checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            const Divider(
                                height: 1, color: Color(0xFFF0F0F0)),
                          ],
                        )),
                // API results
                ..._results.map((r) {
                  final isChosen = _selected.contains(r.city);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CheckboxListTile(
                        value: isChosen,
                        onChanged: (_) => _toggle(r.city),
                        title: Text(r.city,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: isChosen
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: IthakiTheme.textPrimary)),
                        subtitle: r.country.isNotEmpty
                            ? Text(r.country,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: IthakiTheme.textSecondary))
                            : null,
                        controlAffinity: ListTileControlAffinity.trailing,
                        activeColor: IthakiTheme.primaryPurple,
                        checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    ],
                  );
                }),
              ],
            ),
          ),

          // ── Buttons ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _selected.clear()),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: IthakiTheme.borderLight),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    foregroundColor: IthakiTheme.textPrimary,
                  ),
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onConfirm(_selected);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: IthakiTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Apply Filter',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

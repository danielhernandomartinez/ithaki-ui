import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../l10n/app_localizations.dart';
import '../../../mixins/panel_menu_mixin.dart';
import '../../../models/employer_dashboard_models.dart';
import '../../../routes.dart';
import '../../../providers/employer_dashboard_provider.dart';
import '../../../widgets/app_nav_drawer.dart';
import '../../../widgets/profile_menu_panel.dart';
import '../../../constants/nav_items.dart';
import 'widgets/dashboard_stats_section.dart';
import 'widgets/job_post_card.dart';

class EmployerDashboardScreen extends ConsumerStatefulWidget {
  const EmployerDashboardScreen({super.key});

  @override
  ConsumerState<EmployerDashboardScreen> createState() =>
      _EmployerDashboardScreenState();
}

class _EmployerDashboardScreenState
    extends ConsumerState<EmployerDashboardScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String _selectedRoute = '/employer/dashboard';
  int _selectedTab = 0; // 0 = Active, 1 = Archived
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _panels = PanelMenuController(setState)..init(this);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _panels.dispose();
    super.dispose();
  }

  List<JobPost> _filtered(List<JobPost> posts) {
    if (_searchQuery.isEmpty) return posts;
    final q = _searchQuery.toLowerCase();
    return posts.where((p) => p.title.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    return ref.watch(employerDashboardProvider).when(
          loading: () => const Scaffold(
            backgroundColor: IthakiTheme.backgroundViolet,
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Scaffold(
            backgroundColor: IthakiTheme.backgroundViolet,
            body: Center(child: Text(e.toString())),
          ),
          data: (data) => Scaffold(
            backgroundColor: IthakiTheme.backgroundViolet,
            extendBodyBehindAppBar: true,
            appBar: IthakiAppBar(
              showMenuAndAvatar: true,
              menuOpen: _panels.menuOpen,
              profileOpen: _panels.profileOpen,
              onMenuPressed: _panels.toggleMenu,
              onAvatarPressed: _panels.toggleProfile,
            ),
            body: Stack(
              children: [
                // ── Main scroll content ───────────────────────
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: topOffset),

                      // ── Greeting card ─────────────────────
                      IthakiCard(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.dashboardGreeting(data.userName),
                              style: IthakiTheme.headingLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.dashboardSubtitle,
                              style: IthakiTheme.bodySecondary,
                            ),
                            const SizedBox(height: 16),
                            DashboardStatsSection(
                              data: data,
                              onToggleStats: () => ref
                                  .read(employerDashboardProvider.notifier)
                                  .toggleStats(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ── Job Posts card ────────────────────
                      IthakiCard(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.jobPostsTitle,
                                style: IthakiTheme.headingMedium),
                            const SizedBox(height: 8),
                            Text(
                              l10n.jobPostsEmptyDescription,
                              style: IthakiTheme.bodySecondary,
                            ),
                            const SizedBox(height: 16),
                            IthakiButton(l10n.createJobPost),
                            const SizedBox(height: 16),

                            // ── Tab bar ───────────────────────
                            _TabBar(
                              selected: _selectedTab,
                              activeLabel: l10n.dashboardActiveJobPosts,
                              archivedLabel: l10n.dashboardArchivedJobPosts,
                              onSelect: (i) =>
                                  setState(() => _selectedTab = i),
                            ),
                            const SizedBox(height: 12),

                            // ── Search ────────────────────────
                            SizedBox(
                              height: 44,
                              child: TextField(
                                controller: _searchController,
                                style: IthakiTheme.bodySmall,
                                decoration: InputDecoration(
                                  hintText: l10n.searchByJobTitle,
                                  hintStyle: IthakiTheme.hintSmall,
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(left: 12, right: 8),
                                    child: IthakiIcon('search',
                                        size: 18,
                                        color: IthakiTheme.lightGraphite),
                                  ),
                                  prefixIconConstraints:
                                      const BoxConstraints(minWidth: 0),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: IthakiTheme.borderLight),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: IthakiTheme.borderLight),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: IthakiTheme.primaryPurple),
                                  ),
                                  filled: true,
                                  fillColor: IthakiTheme.backgroundWhite,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // ── Count row ─────────────────────
                            _buildCountRow(context, l10n, data),
                            const SizedBox(height: 12),

                            // ── List or empty state ───────────
                            _buildJobList(l10n, data),
                          ],
                        ),
                      ),

                      SizedBox(
                          height: MediaQuery.paddingOf(context).bottom + 24),
                    ],
                  ),
                ),

                // ── Panels ───────────────────────────────────
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
                          currentRoute: _selectedRoute,
                          items: kAppNavItems,
                          onItemTap: (item) {
                            setState(() => _selectedRoute = item.route);
                            _panels.closeMenu();
                          },
                        ),
                      ),
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
                          onItemTap: (item) => _panels.closeProfile(),
                          onLogOut: () => _panels.closeProfile(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
  }

  Widget _buildCountRow(
      BuildContext context, AppLocalizations l10n, EmployerDashboardData data) {
    final posts =
        _selectedTab == 0 ? data.activeJobPosts : data.archivedJobPosts;
    final filtered = _filtered(posts);
    return Row(
      children: [
        Text(
          l10n.dashboardJobPostsCount(filtered.length),
          style: IthakiTheme.bodySmallBold,
        ),
        const Spacer(),
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: IthakiTheme.softGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: IthakiIcon('settings',
                size: 18, color: IthakiTheme.softGraphite),
          ),
        ),
      ],
    );
  }

  Widget _buildJobList(AppLocalizations l10n, EmployerDashboardData data) {
    final posts =
        _selectedTab == 0 ? data.activeJobPosts : data.archivedJobPosts;
    final filtered = _filtered(posts);

    if (filtered.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          l10n.dashboardNoJobPosts,
          style: IthakiTheme.bodySecondary,
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Divider(color: IthakiTheme.borderLight, height: 1),
      ),
      itemBuilder: (_, i) => JobPostCard(
        jobPost: filtered[i],
        onDetails: () => context.push(
          Routes.employerJobDetailFor(filtered[i].id),
          extra: filtered[i],
        ),
        onAiMatcher: () {},
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final int selected;
  final String activeLabel;
  final String archivedLabel;
  final ValueChanged<int> onSelect;

  const _TabBar({
    required this.selected,
    required this.activeLabel,
    required this.archivedLabel,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _Tab(
            label: activeLabel,
            isSelected: selected == 0,
            onTap: () => onSelect(0),
          ),
          _Tab(
            label: archivedLabel,
            isSelected: selected == 1,
            onTap: () => onSelect(1),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? IthakiTheme.backgroundWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Center(
            child: Text(
              label,
              style: IthakiTheme.bodySmallSemiBold.copyWith(
                color: isSelected
                    ? IthakiTheme.textPrimary
                    : IthakiTheme.softGraphite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

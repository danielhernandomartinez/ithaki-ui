import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../models/company_models.dart';
import '../../providers/company_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/job_search_provider.dart';
import '../../providers/profile_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../utils/match_colors.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';

class CompanyProfileScreen extends ConsumerStatefulWidget {
  final String companyId;
  const CompanyProfileScreen({super.key, required this.companyId});

  @override
  ConsumerState<CompanyProfileScreen> createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends ConsumerState<CompanyProfileScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;
  late final TabController _tabController;
  static const _tabs = ['Vacancies', 'About Company', 'Events'];

  @override
  void initState() {
    super.initState();
    _panels = PanelMenuController(setState)..init(this);
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _panels.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeData = ref.watch(homeProvider).value;
    final companyAsync = ref.watch(companyProvider(widget.companyId));
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        showBackButton: true,
        menuOpen: _panels.menuOpen,
        profileOpen: _panels.profileOpen,
        avatarInitials: homeData?.userInitials ?? 'CI',
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(children: [
        companyAsync.when(
          loading: () => _centered(topOffset, const CircularProgressIndicator()),
          error: (_, __) => _centered(topOffset, Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Could not load company.',
                style: TextStyle(color: IthakiTheme.textPrimary, fontSize: 16)),
            const SizedBox(height: 16),
            IthakiButton('Try Again',
                onPressed: () => ref.invalidate(companyProvider(widget.companyId))),
          ])),
          data: (company) => _Content(
            company: company,
            tabController: _tabController,
            topOffset: topOffset,
          ),
        ),
        if (_panels.menuOpen || _panels.menuCtrl.status != AnimationStatus.dismissed)
          _panel(topOffset, SlideTransition(
            position: _panels.slideAnim,
            child: AppNavDrawer(
              currentRoute: Routes.jobSearch,
              profileProgress: ref.watch(profileCompletionProvider),
              items: kAppNavItems,
              onItemTap: (item) { _panels.closeMenu(); context.go(item.route); },
            ),
          )),
        if (_panels.profileOpen || _panels.profileCtrl.status != AnimationStatus.dismissed)
          _panel(topOffset, SlideTransition(
            position: _panels.profileSlideAnim,
            child: ProfileMenuPanel(
              onItemTap: (item) { _panels.closeProfile(); if (item.route.isNotEmpty) context.push(item.route); },
              onLogOut: () {
                _panels.closeProfile();
                ref.read(authRepositoryProvider).logout().whenComplete(() {
                  resetProfileProviders(ref);
                  if (context.mounted) context.go(Routes.root);
                });
              },
            ),
          )),
        if (_panels.menuOpen || _panels.profileOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: () { _panels.closeMenu(); _panels.closeProfile(); },
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
      ]),
    );
  }

  Widget _centered(double topOffset, Widget child) => Padding(
        padding: EdgeInsets.only(top: topOffset),
        child: Center(child: child),
      );

  Positioned _panel(double topOffset, Widget child) => Positioned(
        top: topOffset - 14, left: 16, right: 16, bottom: 40,
        child: ClipRRect(borderRadius: BorderRadius.circular(30), child: child),
      );
}

// ─── Main content ─────────────────────────────────────────────────────────────

class _Content extends ConsumerWidget {
  final CompanyProfile company;
  final TabController tabController;
  final double topOffset;

  const _Content({
    required this.company,
    required this.tabController,
    required this.topOffset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(jobSearchProvider).value;

    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        SliverToBoxAdapter(child: _CompanyHeader(company: company, topOffset: topOffset)),
        SliverPersistentHeader(
          pinned: true,
          delegate: _TabBarDelegate(TabBar(
            controller: tabController,
            labelColor: IthakiTheme.primaryPurple,
            unselectedLabelColor: IthakiTheme.softGraphite,
            indicatorColor: IthakiTheme.primaryPurple,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
              fontFamily: 'Noto Sans', fontSize: 14, fontWeight: FontWeight.w600,
            ),
            tabs: const [Tab(text: 'Vacancies'), Tab(text: 'About Company'), Tab(text: 'Events')],
          )),
        ),
      ],
      body: TabBarView(
        controller: tabController,
        children: [
          _VacanciesTab(vacancies: company.vacancies, culturalMatch: company.culturalMatch,
              savedIds: searchState?.savedJobIds ?? {}, onToggleSave: (id) {
                ref.read(jobSearchProvider.notifier).toggleSaved(id);
              }, onView: (id) => context.push(Routes.jobSearchDetailFor(id))),
          _AboutTab(company: company),
          _EventsTab(events: company.events, company: company, culturalMatch: company.culturalMatch),
        ],
      ),
    );
  }
}

// ─── Company header ───────────────────────────────────────────────────────────

class _CompanyHeader extends StatelessWidget {
  final CompanyProfile company;
  final double topOffset;
  const _CompanyHeader({required this.company, required this.topOffset});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Hero background
      Container(
        height: topOffset + 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              company.logoColor.withValues(alpha: 0.8),
              const Color(0xFF1A1030),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: company.logoColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                ),
                alignment: Alignment.center,
                child: Text(company.logoInitials,
                    style: TextStyle(
                      fontFamily: 'Noto Sans', fontSize: 20,
                      fontWeight: FontWeight.w700, color: company.logoColor,
                    )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(company.name,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans', fontSize: 20,
                        fontWeight: FontWeight.w700, color: Colors.white,
                      )),
                  Text(company.industry,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans', fontSize: 14,
                        color: Colors.white70,
                      )),
                ]),
              ),
            ]),
          ),
        ),
      ),

      // Meta info
      Container(
        color: IthakiTheme.backgroundWhite,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(children: [
          if (company.teamSize.isNotEmpty)
            _MetaRow(icon: 'team', label: 'Team', value: '${company.teamSize} employees'),
          if (company.location.isNotEmpty)
            _MetaRow(icon: 'location', label: 'Main Office', value: company.location),
          if (company.phone.isNotEmpty)
            _MetaRow(icon: 'phone', label: 'Contact Phone', value: company.phone),
          if (company.email.isNotEmpty)
            _MetaRow(icon: 'envelope', label: 'Email', value: company.email),
          if (company.website.isNotEmpty)
            _MetaRow(icon: 'eye', label: '', value: company.website, isLink: true),
        ]),
      ),
    ]);
  }
}

class _MetaRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final bool isLink;
  const _MetaRow({required this.icon, required this.label, required this.value, this.isLink = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        IthakiIcon(icon, size: 16, color: IthakiTheme.softGraphite),
        const SizedBox(width: 8),
        if (label.isNotEmpty) ...[
          Text('$label: ', style: const TextStyle(
            fontFamily: 'Noto Sans', fontSize: 13, color: IthakiTheme.softGraphite,
          )),
        ],
        Expanded(
          child: Text(value, style: TextStyle(
            fontFamily: 'Noto Sans', fontSize: 13,
            color: isLink ? IthakiTheme.primaryPurple : IthakiTheme.textPrimary,
          )),
        ),
      ]),
    );
  }
}

// ─── Tab: Vacancies ───────────────────────────────────────────────────────────

class _VacanciesTab extends StatelessWidget {
  final List<CompanyVacancy> vacancies;
  final CulturalMatch? culturalMatch;
  final Set<String> savedIds;
  final void Function(String id) onToggleSave;
  final void Function(String id) onView;

  const _VacanciesTab({
    required this.vacancies,
    required this.culturalMatch,
    required this.savedIds,
    required this.onToggleSave,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (vacancies.isNotEmpty)
          Text('${vacancies.length} job${vacancies.length == 1 ? '' : 's'} found',
              style: const TextStyle(
                fontFamily: 'Noto Sans', fontSize: 15,
                fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
              )),
        const SizedBox(height: 12),
        if (vacancies.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No open vacancies at this time.',
                  style: TextStyle(color: IthakiTheme.textSecondary)),
            ),
          )
        else
          ...vacancies.map((v) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: IthakiJobSearchCard(
                  jobTitle: v.jobTitle,
                  companyName: '',
                  salary: v.salary,
                  matchPercentage: v.matchPercentage,
                  matchLabel: v.matchLabel,
                  matchGradientColors: getMatchGradientColors(v.matchLabel),
                  matchBackgroundColor: getMatchBgColor(v.matchLabel),
                  category: v.category,
                  location: v.location,
                  workMode: v.workMode,
                  employmentType: v.employmentType,
                  postedAgo: v.postedAgo,
                  isSaved: savedIds.contains(v.id),
                  onSave: () => onToggleSave(v.id),
                  onView: () => onView(v.id),
                ),
              )),
        if (culturalMatch != null) ...[
          const SizedBox(height: 8),
          _CulturalMatchCard(match: culturalMatch!),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─── Tab: About Company ───────────────────────────────────────────────────────

class _AboutTab extends StatelessWidget {
  final CompanyProfile company;
  const _AboutTab({required this.company});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (company.aboutText.isNotEmpty) ...[
          _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _SectionTitle('About Company'),
            const SizedBox(height: 10),
            Text(company.aboutText,
                style: const TextStyle(
                  fontFamily: 'Noto Sans', fontSize: 14,
                  color: IthakiTheme.textPrimary, height: 1.5,
                )),
          ])),
          const SizedBox(height: 12),
        ],
        if (company.perks.isNotEmpty) ...[
          _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _SectionTitle('Perks & Benefits'),
            const SizedBox(height: 10),
            ...company.perks.map((p) => _Bullet(p)),
          ])),
          const SizedBox(height: 12),
        ],
        if (company.culturalMatch != null) ...[
          _CulturalMatchCard(match: company.culturalMatch!),
          const SizedBox(height: 12),
        ],
        if (company.odysseaRating.isNotEmpty) ...[
          _Card(child: Row(children: [
            const Text('Odyssea: ', style: TextStyle(
              fontFamily: 'Noto Sans', fontSize: 14, color: IthakiTheme.textSecondary,
            )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F5C0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(company.odysseaRating,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 13,
                    fontWeight: FontWeight.w600, color: Color(0xFF6B6B00),
                  )),
            ),
          ])),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─── Tab: Events ──────────────────────────────────────────────────────────────

class _EventsTab extends StatelessWidget {
  final List<CompanyEvent> events;
  final CompanyProfile company;
  final CulturalMatch? culturalMatch;

  const _EventsTab({
    required this.events,
    required this.company,
    required this.culturalMatch,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (events.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text('No upcoming events.',
                  style: TextStyle(color: IthakiTheme.textSecondary)),
            ),
          )
        else
          ...events.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _openEvent(context, e, company),
                  child: _EventCard(event: e, company: company),
                ),
              )),
        if (culturalMatch != null) ...[
          const SizedBox(height: 4),
          _CulturalMatchCard(match: culturalMatch!),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  void _openEvent(BuildContext context, CompanyEvent event, CompanyProfile company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EventDetailSheet(event: event, company: company),
    );
  }
}

class _EventCard extends StatelessWidget {
  final CompanyEvent event;
  final CompanyProfile company;
  const _EventCard({required this.event, required this.company});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: company.logoColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: IthakiTheme.borderLight),
          ),
          alignment: Alignment.center,
          child: Text(company.logoInitials,
              style: TextStyle(
                fontFamily: 'Noto Sans', fontSize: 14,
                fontWeight: FontWeight.w700, color: company.logoColor,
              )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(company.name,
                style: const TextStyle(
                  fontFamily: 'Noto Sans', fontSize: 13,
                  color: IthakiTheme.softGraphite,
                )),
            const SizedBox(height: 2),
            Text(event.title,
                style: const TextStyle(
                  fontFamily: 'Noto Sans', fontSize: 15,
                  fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                )),
            const SizedBox(height: 6),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: IthakiTheme.softGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(children: [
                  const IthakiIcon('calendar', size: 14, color: IthakiTheme.softGraphite),
                  const SizedBox(width: 4),
                  Text(event.date,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans', fontSize: 12,
                        color: IthakiTheme.textPrimary,
                      )),
                ]),
              ),
              if (event.time.isNotEmpty) ...[
                const SizedBox(width: 6),
                Row(children: [
                  const IthakiIcon('clock', size: 14, color: IthakiTheme.softGraphite),
                  const SizedBox(width: 4),
                  Text(event.time,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans', fontSize: 12,
                        color: IthakiTheme.softGraphite,
                      )),
                ]),
              ],
            ]),
            if (event.location.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(children: [
                const IthakiIcon('location', size: 14, color: IthakiTheme.softGraphite),
                const SizedBox(width: 4),
                Text(event.location,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans', fontSize: 12,
                      color: IthakiTheme.softGraphite,
                    )),
              ]),
            ],
          ]),
        ),
      ]),
    );
  }
}

// ─── Event detail bottom sheet ────────────────────────────────────────────────

class _EventDetailSheet extends StatelessWidget {
  final CompanyEvent event;
  final CompanyProfile company;
  const _EventDetailSheet({required this.event, required this.company});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: IthakiTheme.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: company.logoColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: IthakiTheme.borderLight),
                ),
                alignment: Alignment.center,
                child: Text(company.logoInitials,
                    style: TextStyle(
                      fontFamily: 'Noto Sans', fontSize: 14,
                      fontWeight: FontWeight.w700, color: company.logoColor,
                    )),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(event.title,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans', fontSize: 18,
                      fontWeight: FontWeight.w700, color: IthakiTheme.textPrimary,
                    )),
              ),
            ]),
            const SizedBox(height: 16),
            // Date + time + location chips
            Wrap(spacing: 8, runSpacing: 8, children: [
              if (event.date.isNotEmpty)
                _InfoChip(icon: 'calendar', label: event.date),
              if (event.time.isNotEmpty)
                _InfoChip(icon: 'clock', label: event.time),
              if (event.location.isNotEmpty)
                _InfoChip(icon: 'location', label: event.location),
            ]),
            if (event.description.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Event Details',
                  style: TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 15,
                    fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                  )),
              const SizedBox(height: 8),
              Text(event.description,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 14,
                    color: IthakiTheme.textPrimary, height: 1.5,
                  )),
            ],
            if (event.address.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Address',
                  style: TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 15,
                    fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                  )),
              const SizedBox(height: 6),
              Text(event.address,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 14,
                    color: IthakiTheme.textPrimary, height: 1.4,
                  )),
            ],
            if (event.registrationLink.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Registration Link',
                  style: TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 15,
                    fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                  )),
              const SizedBox(height: 6),
              Text(event.registrationLink,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 14,
                    color: IthakiTheme.primaryPurple,
                  )),
            ],
            const SizedBox(height: 20),
            IthakiButton('Register', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        IthakiIcon(icon, size: 14, color: IthakiTheme.softGraphite),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(
          fontFamily: 'Noto Sans', fontSize: 13,
          color: IthakiTheme.textPrimary,
        )),
      ]),
    );
  }
}

// ─── Cultural Match Card ──────────────────────────────────────────────────────

class _CulturalMatchCard extends StatelessWidget {
  final CulturalMatch match;
  const _CulturalMatchCard({required this.match});

  Color get _badgeColor {
    switch (match.label.toLowerCase()) {
      case 'high': return const Color(0xFF4ADE80);
      case 'medium': return const Color(0xFFFFB800);
      default: return IthakiTheme.softGraphite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _SectionTitle('Cultural Match Score'),
        const SizedBox(height: 12),
        Row(children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                _badgeColor,
                _badgeColor.withValues(alpha: 0.6),
              ]),
            ),
            alignment: Alignment.center,
            child: Text(match.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Noto Sans', fontSize: 11,
                  fontWeight: FontWeight.w700, color: Colors.white,
                )),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text('You and this company both chose your top 5 values and preferences. This score shows how closely they align.',
                style: const TextStyle(
                  fontFamily: 'Noto Sans', fontSize: 13,
                  color: IthakiTheme.textPrimary, height: 1.4,
                )),
          ),
        ]),
        if (match.sharedValues.isNotEmpty) ...[
          const SizedBox(height: 10),
          ...match.sharedValues.map((v) => _Bullet(v)),
        ],
        if (match.description.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(match.description,
              style: const TextStyle(
                fontFamily: 'Noto Sans', fontSize: 13,
                color: IthakiTheme.softGraphite, height: 1.4,
              )),
        ],
        const SizedBox(height: 8),
        const Text('Odyssea',
            style: TextStyle(
              fontFamily: 'Noto Sans', fontSize: 12,
              fontWeight: FontWeight.w600, color: IthakiTheme.softGraphite,
            )),
      ]),
    );
  }
}

// ─── Small reusable helpers ───────────────────────────────────────────────────

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(
      color: IthakiTheme.backgroundViolet,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
        ),
        child: tabBar,
      ),
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height + 12;
  @override
  double get minExtent => tabBar.preferredSize.height + 12;
  @override
  bool shouldRebuild(_TabBarDelegate old) => old.tabBar != tabBar;
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
          fontFamily: 'Noto Sans', fontSize: 16,
          fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
        ));
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('• ', style: TextStyle(fontSize: 14, color: IthakiTheme.textPrimary)),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                fontFamily: 'Noto Sans', fontSize: 14,
                color: IthakiTheme.textPrimary, height: 1.4,
              )),
        ),
      ]),
    );
  }
}

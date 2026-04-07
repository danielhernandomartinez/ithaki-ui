import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/home_provider.dart';
import '../../providers/job_detail_provider.dart';
import '../../providers/profile_provider.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import 'widgets/job_detail_cards.dart';

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
      bottomNavigationBar: JobDetailStickyBar(detail: detail),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: topOffset),
                _pad(JobStatusCard(detail: detail)),
                _pad(JobMainCard(detail: detail)),
                _pad(ReviewsCard(detail: detail)),
                _pad(RecommendedCard(job: detail.recommended)),
                _pad(JobDetailCompanyCard(company: detail.company)),
                SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
              ],
            ),
          ),
          if (_panels.menuOpen || _panels.profileOpen)
            Positioned.fill(
              child: GestureDetector(
                onTap: () { _panels.closeMenu(); _panels.closeProfile(); },
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
          if (_panels.menuOpen || _panels.menuCtrl.status != AnimationStatus.dismissed)
            _panel(topOffset, SlideTransition(
              position: _panels.slideAnim,
              child: AppNavDrawer(
                currentRoute: Routes.myApplications,
                profileProgress: ref.watch(profileCompletionProvider),
                items: kAppNavItems,
                onItemTap: (item) { _panels.closeMenu(); context.go(item.route); },
              ),
            )),
          if (_panels.profileOpen || _panels.profileCtrl.status != AnimationStatus.dismissed)
            _panel(topOffset, SlideTransition(
              position: _panels.profileSlideAnim,
              child: ProfileMenuPanel(
                onItemTap: (item) {
                  _panels.closeProfile();
                  if (item.route.isNotEmpty) context.push(item.route);
                },
                onLogOut: _panels.closeProfile,
              ),
            )),
        ],
      ),
    );
  }

  Widget _pad(Widget child) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: child,
      );

  Widget _panel(double topOffset, Widget child) => Positioned(
        top: topOffset - 14, left: 16, right: 16, bottom: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: child,
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/application_detail_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/profile_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import 'widgets/application_detail_cards.dart';

class ApplicationDetailsScreen extends ConsumerStatefulWidget {
  final String applicationId;
  const ApplicationDetailsScreen({super.key, required this.applicationId});

  @override
  ConsumerState<ApplicationDetailsScreen> createState() =>
      _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState
    extends ConsumerState<ApplicationDetailsScreen>
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
    final detail = ref.watch(applicationDetailProvider(widget.applicationId));
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
        avatarUrl: homeData?.userPhotoUrl,
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: topOffset),
                _pad(ApplicationStatusCard(detail: detail)),
                _pad(JobPostBasicsCard(detail: detail)),
                _pad(TalentProfileCard(candidate: detail.candidate)),
                _pad(CoverLetterCard(text: detail.coverLetter)),
                _pad(ScreeningQuestionsCard(questions: detail.screeningQuestions)),
                _pad(ApplicationDetailCompanyCard(company: detail.company)),
                SizedBox(height: MediaQuery.paddingOf(context).bottom + 112),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: ApplicationDetailStickyBar(
                applicationId: widget.applicationId,
              ),
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
                onLogOut: () {
                  _panels.closeProfile();
                  ref.read(authRepositoryProvider).logout().whenComplete(() {
                    resetProfileProviders(ref);
                    if (context.mounted) context.go(Routes.root);
                  });
                },
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

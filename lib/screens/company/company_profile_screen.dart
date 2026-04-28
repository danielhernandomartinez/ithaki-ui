import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/company_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/profile_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import 'company_profile_content.dart';

class CompanyProfileScreen extends ConsumerStatefulWidget {
  const CompanyProfileScreen({super.key, required this.companyId});

  final String companyId;

  @override
  ConsumerState<CompanyProfileScreen> createState() =>
      _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends ConsumerState<CompanyProfileScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _panels = PanelMenuController(setState)..init(this);
    _tabController = TabController(
      length: companyProfileTabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _panels.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyAsync = ref.watch(companyProvider(widget.companyId));
    final homeData = ref.watch(homeProvider).value;
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
        avatarUrl: homeData?.userPhotoUrl,
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(
        children: [
          companyAsync.when(
            loading: () => _Centered(
              topOffset: topOffset,
              child: const CircularProgressIndicator(),
            ),
            error: (_, __) => _Centered(
              topOffset: topOffset,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Could not load company.',
                    style: TextStyle(
                      color: IthakiTheme.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IthakiButton(
                    'Try Again',
                    onPressed: () =>
                        ref.invalidate(companyProvider(widget.companyId)),
                  ),
                ],
              ),
            ),
            data: (company) => CompanyProfileContent(
              company: company,
              tabController: _tabController,
              topOffset: topOffset,
            ),
          ),
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
          if (_panels.menuOpen ||
              _panels.menuCtrl.status != AnimationStatus.dismissed)
            _Panel(
              topOffset: topOffset,
              child: SlideTransition(
                position: _panels.slideAnim,
                child: AppNavDrawer(
                  currentRoute: Routes.jobSearch,
                  profileProgress: ref.watch(profileCompletionProvider),
                  items: kAppNavItems,
                  onItemTap: (item) {
                    _panels.closeMenu();
                    context.go(item.route);
                  },
                ),
              ),
            ),
          if (_panels.profileOpen ||
              _panels.profileCtrl.status != AnimationStatus.dismissed)
            _Panel(
              topOffset: topOffset,
              child: SlideTransition(
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
              ),
            ),
        ],
      ),
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.topOffset, required this.child});

  final double topOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topOffset),
      child: Center(child: child),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.topOffset, required this.child});

  final double topOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topOffset - 14,
      left: 16,
      right: 16,
      bottom: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: child,
      ),
    );
  }
}

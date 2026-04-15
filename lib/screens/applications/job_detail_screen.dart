import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/applications_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/job_detail_provider.dart';
import '../../providers/profile_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import 'widgets/invitation_detail_widgets.dart';
import 'widgets/job_detail_cards.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final String applicationId;
  final bool isInvitation;

  const JobDetailScreen({
    super.key,
    required this.applicationId,
    this.isInvitation = false,
  });

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
      return Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        appBar: IthakiAppBar(showBackButton: true, title: 'Job Details'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'We could not find job details for this application yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: IthakiTheme.textPrimary),
                ),
                const SizedBox(height: 16),
                IthakiButton(
                  'Back to Applications',
                  onPressed: () => context.go(Routes.myApplications),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final invitation = widget.isInvitation
        ? ref
            .watch(invitationsProvider)
            .value
            ?.where((i) => i.id == widget.applicationId)
            .firstOrNull
        : null;

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
      bottomNavigationBar: widget.isInvitation
          ? InvitationStickyBar(
              onAccept: () => _showApplySheet(context),
              onMore: (v) => _handleInvitationMenu(context, v),
            )
          : JobDetailStickyBar(detail: detail),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: topOffset),
                if (widget.isInvitation)
                  _pad(InvitationTopCard(
                    senderInitials: invitation?.senderInitials ?? '',
                    senderName: invitation?.senderName ?? '',
                    senderAvatarColor:
                        invitation?.senderAvatarColor ?? IthakiTheme.primaryPurple,
                    companyName: invitation?.companyName ?? '',
                    message: invitation?.message ?? '',
                    deadline: detail.deadline,
                  ))
                else
                  _pad(JobStatusCard(detail: detail)),
                _pad(JobMainCard(
                  detail: detail,
                  trailingAction: widget.isInvitation
                      ? PopupMenuButton<String>(
                          icon: const IthakiIcon('help', size: 20,
                              color: IthakiTheme.softGraphite),
                          onSelected: (v) => _handleInvitationMenu(context, v),
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                                value: 'decline', child: Text('Decline Invite')),
                            PopupMenuItem(
                                value: 'save', child: Text('Save Job')),
                          ],
                        )
                      : null,
                )),
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
                onTap: () {
                  _panels.closeMenu();
                  _panels.closeProfile();
                },
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
          if (_panels.menuOpen ||
              _panels.menuCtrl.status != AnimationStatus.dismissed)
            _panel(
              topOffset,
              SlideTransition(
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
          if (_panels.profileOpen ||
              _panels.profileCtrl.status != AnimationStatus.dismissed)
            _panel(
              topOffset,
              SlideTransition(
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

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _showApplySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ApplyBottomSheet(),
    );
  }

  void _handleInvitationMenu(BuildContext context, String value) {
    if (value == 'decline') _showDeclineInviteSheet(context);
    // 'save' — stub
  }

  Future<void> _showDeclineInviteSheet(BuildContext outerContext) async {
    final declined = await showModalBottomSheet<bool>(
      context: outerContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          DeclineInviteSheet(invitationId: widget.applicationId),
    );
    if (declined == true && mounted) {
      outerContext.go(Routes.myApplications);
    }
  }

  Widget _pad(Widget child) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: child,
      );

  Positioned _panel(double topOffset, Widget child) => Positioned(
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

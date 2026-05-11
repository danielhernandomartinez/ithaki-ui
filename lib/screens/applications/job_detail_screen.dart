import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../constants/nav_items.dart';
import '../../l10n/app_localizations.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../models/applications_models.dart';
import '../../models/job_detail_models.dart';
import '../../providers/applications_provider.dart';
import '../../providers/invitations_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/job_detail_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/tour_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../utils/job_detail_enricher.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import 'widgets/invitation_top_card.dart';
import 'widgets/invitation_sticky_bar.dart';
import 'widgets/apply_bottom_sheet.dart';
import 'widgets/decline_invite_sheet.dart';
import 'widgets/job_detail_company_card.dart';
import 'widgets/job_detail_sticky_bar.dart';
import 'widgets/job_main_card.dart';
import 'widgets/job_status_card.dart';
import 'widgets/recommended_card.dart';
import 'widgets/reviews_card.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final String applicationId;
  final bool isInvitation;
  final Application? initialApplication;
  final Invitation? initialInvitation;

  const JobDetailScreen({
    super.key,
    required this.applicationId,
    this.isInvitation = false,
    this.initialApplication,
    this.initialInvitation,
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

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    // Resolve the entity for this screen (application or invitation).
    final applications = ref.watch(applicationsProvider);
    final invitations = ref.watch(invitationsProvider);

    final application = widget.isInvitation
        ? null
        : widget.initialApplication ??
            applications.value
                ?.where((a) => a.id == widget.applicationId)
                .firstOrNull;
    final invitation = widget.isInvitation
        ? widget.initialInvitation ??
            invitations.value
                ?.where((i) => i.id == widget.applicationId)
                .firstOrNull
        : null;

    // Guard: entity list still loading.
    final entityLoading = widget.isInvitation
        ? invitations.isLoading && widget.initialInvitation == null
        : applications.isLoading && widget.initialApplication == null;
    if (entityLoading) {
      return _stateScaffold(context, child: const CircularProgressIndicator());
    }

    // Guard: entity list errored.
    final entityError = widget.isInvitation
        ? invitations.hasError && widget.initialInvitation == null
        : applications.hasError && widget.initialApplication == null;
    if (entityError) {
      return _stateScaffold(
        context,
        child: _retryColumn(l.jobCouldNotLoad, onRetry: () {
          if (widget.isInvitation) {
            ref.invalidate(invitationsProvider);
          } else {
            ref.invalidate(applicationsProvider);
          }
        }),
      );
    }

    final jobId = widget.isInvitation ? invitation?.jobId : application?.jobId;
    if (jobId == null || jobId.isEmpty) {
      return _notFoundScaffold(context, l);
    }

    // Fetch job detail; the remaining build is delegated to _buildLoaded.
    return ref.watch(jobDetailProvider(jobId)).when(
          loading: () =>
              _stateScaffold(context, child: const CircularProgressIndicator()),
          error: (_, __) => _stateScaffold(
            context,
            child: _retryColumn(l.jobCouldNotLoad,
                onRetry: () => ref.invalidate(jobDetailProvider(jobId))),
          ),
          data: (apiDetail) => _buildLoaded(
            context,
            detail: enrichJobDetail(
              apiDetail,
              application: application,
              invitation: invitation,
            ),
            invitation: invitation,
          ),
        );
  }

  // ── loaded scaffold ────────────────────────────────────────────────────────

  Widget _buildLoaded(
    BuildContext context, {
    required JobDetail detail,
    required Invitation? invitation,
  }) {
    final l = AppLocalizations.of(context)!;
    final homeData = ref.watch(homeProvider).value;
    final tourState = ref.watch(tourProvider).maybeWhen(
          data: (v) => v,
          orElse: () => null,
        );
    final tourKeys = ref.watch(tourKeysProvider);
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      extendBodyBehindAppBar: true,
      appBar: IthakiAppBar(
        showMenuAndAvatar: true,
        menuOpen: _panels.menuOpen,
        profileOpen: _panels.profileOpen,
        avatarInitials: homeData?.userInitials ?? 'CI',
        avatarUrl: homeData?.userPhotoUrl,
        onNotificationsPressed: () =>
            context.push(Routes.settingsNotifications),
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(
        children: [
          _scrollableContent(context, detail, invitation, tourState, tourKeys,
              topOffset, l),
          _stickyBar(context, detail, invitation),
          if (_panels.menuOpen || _panels.profileOpen) _dismissOverlay(),
          if (_panels.menuOpen ||
              _panels.menuCtrl.status != AnimationStatus.dismissed)
            _panel(
              topOffset,
              SlideTransition(
                position: _panels.slideAnim,
                child: AppNavDrawer(
                  currentRoute: Routes.myApplications,
                  profileProgress: ref.watch(profileCompletionProvider),
                  items: buildNavItems(AppLocalizations.of(context)!),
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
                    navigateToProfileMenuRoute(context, item);
                  },
                  onLogOut: () {
                    _panels.closeProfile();
                    ref
                        .read(authRepositoryProvider)
                        .logout()
                        .whenComplete(() {
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

  Widget _scrollableContent(
    BuildContext context,
    JobDetail detail,
    Invitation? invitation,
    dynamic tourState,
    Map<int, GlobalKey> tourKeys,
    double topOffset,
    AppLocalizations l,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topOffset),
          if (widget.isInvitation)
            _pad(
              KeyedSubtree(
                key: tourState?.currentStep == 9 ? tourKeys[9] : null,
                child: InvitationTopCard(
                  senderInitials: invitation?.senderInitials ?? '',
                  senderName: invitation?.senderName ?? '',
                  senderAvatarColor:
                      invitation?.senderAvatarColor ?? IthakiTheme.primaryPurple,
                  companyName: invitation?.companyName ?? '',
                  message: invitation?.message ?? '',
                  deadline: detail.deadline,
                ),
              ),
            )
          else
            _pad(JobStatusCard(detail: detail)),
          _pad(
            JobMainCard(
              detail: detail,
              trailingAction: widget.isInvitation
                  ? PopupMenuButton<String>(
                      icon: const IthakiIcon(
                        'help',
                        size: 20,
                        color: IthakiTheme.softGraphite,
                      ),
                      onSelected: (value) =>
                          _handleInvitationMenu(context, value),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'decline',
                          child: Text(l.declineButton),
                        ),
                        PopupMenuItem(
                          value: 'save',
                          child: Text(l.viewJob),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          _pad(ReviewsCard(detail: detail)),
          _pad(RecommendedCard(job: detail.recommended)),
          _pad(JobDetailCompanyCard(company: detail.company)),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 140),
        ],
      ),
    );
  }

  Widget _stickyBar(
      BuildContext context, JobDetail detail, Invitation? invitation) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: widget.isInvitation
            ? InvitationStickyBar(
                onAccept: () => _showApplySheet(context),
                onMore: (value) => _handleInvitationMenu(context, value),
              )
            : JobDetailStickyBar(detail: detail),
      ),
    );
  }

  Widget _dismissOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          _panels.closeMenu();
          _panels.closeProfile();
        },
        child: const ColoredBox(color: Colors.transparent),
      ),
    );
  }

  // ── state scaffolds ────────────────────────────────────────────────────────

  Widget _stateScaffold(BuildContext context, {required Widget child}) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: l.jobDetailsTitle),
      body: Center(
        child: Padding(padding: const EdgeInsets.all(24), child: child),
      ),
    );
  }

  Widget _notFoundScaffold(BuildContext context, AppLocalizations l) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: l.jobDetailsTitle),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.jobDetailNotFoundMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16, color: IthakiTheme.textPrimary),
              ),
              const SizedBox(height: 16),
              IthakiButton(
                l.backToApplications,
                onPressed: () => context.go(Routes.myApplications),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _retryColumn(String message, {required VoidCallback onRetry}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style:
              const TextStyle(fontSize: 16, color: IthakiTheme.textPrimary),
        ),
        const SizedBox(height: 16),
        IthakiButton(
          AppLocalizations.of(context)!.tryAgain,
          onPressed: onRetry,
        ),
      ],
    );
  }

  // ── actions ────────────────────────────────────────────────────────────────

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
  }

  Future<void> _showDeclineInviteSheet(BuildContext outerContext) async {
    final declined = await showModalBottomSheet<bool>(
      context: outerContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeclineInviteSheet(invitationId: widget.applicationId),
    );
    if (declined == true && mounted) context.go(Routes.myApplications);
  }

  // ── layout helpers ─────────────────────────────────────────────────────────

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

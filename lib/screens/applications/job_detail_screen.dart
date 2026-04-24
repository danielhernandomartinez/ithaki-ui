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
import '../../providers/home_provider.dart';
import '../../providers/job_detail_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/tour_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import 'widgets/invitation_detail_widgets.dart';
import 'widgets/job_detail_cards.dart';

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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final applications = ref.watch(applicationsProvider);
    final invitations = ref.watch(invitationsProvider);
    final homeData = ref.watch(homeProvider).value;
    final tourState = ref.watch(tourProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    final tourKeys = ref.watch(tourKeysProvider);
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    final application = widget.isInvitation
        ? null
        : widget.initialApplication ??
            applications.value
                ?.where((item) => item.id == widget.applicationId)
                .firstOrNull;
    final invitation = widget.isInvitation
        ? widget.initialInvitation ??
            invitations.value
                ?.where((item) => item.id == widget.applicationId)
                .firstOrNull
        : null;
    final jobId = widget.isInvitation ? invitation?.jobId : application?.jobId;

    if ((widget.isInvitation &&
            invitations.isLoading &&
            widget.initialInvitation == null) ||
        (!widget.isInvitation &&
            applications.isLoading &&
            widget.initialApplication == null)) {
      return _simpleStateScaffold(
        context,
        child: const CircularProgressIndicator(),
      );
    }

    if ((widget.isInvitation &&
            invitations.hasError &&
            widget.initialInvitation == null) ||
        (!widget.isInvitation &&
            applications.hasError &&
            widget.initialApplication == null)) {
      return _simpleStateScaffold(
        context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'We could not load this job right now.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: IthakiTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            IthakiButton(
              'Try Again',
              onPressed: () {
                if (widget.isInvitation) {
                  ref.invalidate(invitationsProvider);
                } else {
                  ref.invalidate(applicationsProvider);
                }
              },
            ),
          ],
        ),
      );
    }

    if (jobId == null || jobId.isEmpty) {
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
                    fontSize: 16,
                    color: IthakiTheme.textPrimary,
                  ),
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

    final detailAsync = ref.watch(jobDetailProvider(jobId));

    return detailAsync.when(
      loading: () => _simpleStateScaffold(
        context,
        child: const CircularProgressIndicator(),
      ),
      error: (error, _) => _simpleStateScaffold(
        context,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'We could not load this job right now.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: IthakiTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            IthakiButton(
              'Try Again',
              onPressed: () => ref.invalidate(jobDetailProvider(jobId)),
            ),
          ],
        ),
      ),
      data: (apiDetail) {
        final detail = _enrichDetail(
          apiDetail,
          application: application,
          invitation: invitation,
        );

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
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: topOffset),
                    if (widget.isInvitation)
                      _pad(
                        KeyedSubtree(
                          key:
                              widget.isInvitation && tourState?.currentStep == 9
                                  ? tourKeys[9]
                                  : null,
                          child: InvitationTopCard(
                            senderInitials: invitation?.senderInitials ?? '',
                            senderName: invitation?.senderName ?? '',
                            senderAvatarColor: invitation?.senderAvatarColor ??
                                IthakiTheme.primaryPurple,
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
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: widget.isInvitation
                      ? InvitationStickyBar(
                          onAccept: () => _showApplySheet(context),
                          onMore: (value) =>
                              _handleInvitationMenu(context, value),
                        )
                      : JobDetailStickyBar(detail: detail),
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
                        if (item.route.isNotEmpty) {
                          context.push(item.route);
                        }
                      },
                      onLogOut: () {
                        _panels.closeProfile();
                        ref
                            .read(authRepositoryProvider)
                            .logout()
                            .whenComplete(() {
                          resetProfileProviders(ref);
                          if (context.mounted) {
                            context.go(Routes.root);
                          }
                        });
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  JobDetail _enrichDetail(
    JobDetail apiDetail, {
    Application? application,
    Invitation? invitation,
  }) {
    final companyName = _pickString(
      apiDetail.companyName,
      application?.companyName,
      invitation?.companyName,
    );
    final companyInitials = _pickString(
      apiDetail.companyLogoInitials,
      application?.companyInitials,
      invitation?.companyInitials,
    );
    final companyColor = apiDetail.companyName.isNotEmpty
        ? apiDetail.companyLogoColor
        : application?.companyLogoColor ??
            invitation?.companyLogoColor ??
            apiDetail.companyLogoColor;
    final postedDate = _pickString(
      apiDetail.postedDate,
      application?.postedAgo,
      invitation?.postedAgo,
    );
    final salary = _pickString(
      apiDetail.salary,
      application?.salary,
      invitation?.salary,
      apiDetail.salaryRange,
    );

    return JobDetail(
      id: apiDetail.id,
      appliedAt: _pickString(
        apiDetail.appliedAt,
        application?.appliedAt,
        invitation?.postedAgo,
      ),
      statusLabel: _pickString(
        apiDetail.statusLabel,
        application?.status.label,
      ),
      deadline: apiDetail.deadline,
      postedDate: postedDate,
      jobTitle: _pickString(
        apiDetail.jobTitle,
        application?.jobTitle,
        invitation?.jobTitle,
      ),
      companyName: companyName,
      companyLogoColor: companyColor,
      companyLogoInitials: companyInitials,
      matchPercentage: _pickInt(
        apiDetail.matchPercentage,
        application?.matchPercentage,
        invitation?.matchPercentage,
      ),
      matchLabel: _pickString(
        apiDetail.matchLabel,
        application?.matchLabel,
        invitation?.matchLabel,
      ),
      location: _pickString(
        apiDetail.location,
        application?.location,
        invitation?.location,
      ),
      jobType: _pickString(
        apiDetail.jobType,
        application?.employmentType,
        invitation?.employmentType,
      ),
      salaryRange: _pickString(
        apiDetail.salaryRange,
        application?.salary,
        invitation?.salary,
      ),
      workplace: _pickString(
        apiDetail.workplace,
        application?.workplaceType,
        invitation?.workplaceType,
      ),
      experienceLevel: _pickString(
        apiDetail.experienceLevel,
        application?.experienceLevel,
        invitation?.experienceLevel,
      ),
      languages: apiDetail.languages,
      description: apiDetail.description,
      requirements: apiDetail.requirements,
      skills: apiDetail.skills,
      communication: apiDetail.communication,
      niceToHave: apiDetail.niceToHave,
      whatWeOffer: apiDetail.whatWeOffer,
      reviews: apiDetail.reviews,
      recommended: apiDetail.recommended,
      company: JobDetailCompany(
        name: _pickString(
          apiDetail.company.name,
          companyName,
        ),
        industry: apiDetail.company.industry,
        logoColor: apiDetail.company.name.isNotEmpty
            ? apiDetail.company.logoColor
            : companyColor,
        logoInitials: _pickString(
          apiDetail.company.logoInitials,
          companyInitials,
        ),
        totalReviews: apiDetail.company.totalReviews,
        averageRating: apiDetail.company.averageRating,
        description: apiDetail.company.description,
      ),
      salary: salary,
    );
  }

  Widget _simpleStateScaffold(
    BuildContext context, {
    required Widget child,
  }) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      appBar: IthakiAppBar(showBackButton: true, title: l.jobDetailsTitle),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: child,
        ),
      ),
    );
  }

  void _showApplySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ApplyBottomSheet(),
    );
  }

  void _handleInvitationMenu(BuildContext context, String value) {
    if (value == 'decline') {
      _showDeclineInviteSheet(context);
    }
  }

  Future<void> _showDeclineInviteSheet(BuildContext outerContext) async {
    final declined = await showModalBottomSheet<bool>(
      context: outerContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeclineInviteSheet(invitationId: widget.applicationId),
    );
    if (declined == true && mounted) {
      context.go(Routes.myApplications);
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

  String _pickString(String? first,
      [String? second, String? third, String? fourth]) {
    for (final value in [first, second, third, fourth]) {
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  int _pickInt(int first, [int? second, int? third]) {
    for (final value in [first, second, third]) {
      if (value != null && value > 0) {
        return value;
      }
    }
    return 0;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/applications_provider.dart';
import 'dart:async';
import '../../providers/home_provider.dart';
import '../../providers/job_detail_provider.dart';
import '../../providers/profile_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import 'widgets/job_detail_cards.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final String applicationId;
  final bool isInvitation;
  const JobDetailScreen({super.key, required this.applicationId, this.isInvitation = false});

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
                  style: TextStyle(
                    fontSize: 16,
                    color: IthakiTheme.textPrimary,
                  ),
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
        ? ref.watch(invitationsProvider).value?.where((i) => i.id == widget.applicationId).firstOrNull
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
          ? _InvitationStickyBar(
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
                  _pad(_InvitationTopCard(
                    senderInitials: invitation?.senderInitials ?? '',
                    senderName: invitation?.senderName ?? '',
                    senderAvatarColor: invitation?.senderAvatarColor ?? IthakiTheme.primaryPurple,
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
                          icon: const Icon(Icons.more_horiz, color: IthakiTheme.softGraphite),
                          onSelected: (v) => _handleInvitationMenu(context, v),
                          itemBuilder: (_) => const [
                            PopupMenuItem(value: 'decline', child: Text('Decline Invite')),
                            PopupMenuItem(value: 'save', child: Text('Save Job')),
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

  void _showApplySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ApplyBottomSheet(),
    );
  }

  void _handleInvitationMenu(BuildContext context, String value) {
    if (value == 'decline') {
      _showDeclineInviteSheet(context);
    }
    // 'save' — stub
  }

  Future<void> _showDeclineInviteSheet(BuildContext outerContext) async {
    final declined = await showModalBottomSheet<bool>(
      context: outerContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DeclineInviteSheet(invitationId: widget.applicationId),
    );
    if (declined == true && mounted) {
      outerContext.go(Routes.myApplications);
    }
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

// ─── Invitation top card ──────────────────────────────────────────────────────

class _InvitationTopCard extends StatelessWidget {
  final String senderInitials;
  final String senderName;
  final Color senderAvatarColor;
  final String companyName;
  final String message;
  final String deadline;

  const _InvitationTopCard({
    required this.senderInitials,
    required this.senderName,
    required this.senderAvatarColor,
    required this.companyName,
    required this.message,
    required this.deadline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sender row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: senderAvatarColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  senderInitials,
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: senderAvatarColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    senderName,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary,
                      letterSpacing: -0.28,
                    ),
                  ),
                  Text(
                    companyName,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 12,
                      color: IthakiTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (message.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 14,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.28,
              ),
            ),
          ],
          if (deadline.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: IthakiTheme.accentPurpleLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IthakiIcon('calendar', size: 16, color: IthakiTheme.primaryPurple),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      deadline,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 13,
                        color: IthakiTheme.textPrimary,
                        letterSpacing: -0.26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Invitation sticky bar ────────────────────────────────────────────────────

class _InvitationStickyBar extends StatelessWidget {
  final VoidCallback onAccept;
  final void Function(String) onMore;

  const _InvitationStickyBar({required this.onAccept, required this.onMore});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: IthakiTheme.borderLight),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E1E).withValues(alpha: 0.15),
            offset: const Offset(0, 4),
            blurRadius: 14,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: IthakiButton('Accept Invite and Apply', onPressed: onAccept)),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: onMore,
            icon: const Icon(Icons.more_horiz, color: IthakiTheme.softGraphite),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'decline', child: Text('Decline Invite')),
              PopupMenuItem(value: 'save', child: Text('Save Job')),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Apply bottom sheet ───────────────────────────────────────────────────────

class _ApplyBottomSheet extends StatelessWidget {
  const _ApplyBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(
        24, 16, 24, MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ready to apply for this role?',
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary,
                  letterSpacing: -0.36,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, size: 20, color: IthakiTheme.softGraphite),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Make sure your talent profile details are up to date before submitting your application. You can also upload your CV.',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              color: IthakiTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          _ApplyOption(
            title: 'Use Ithaki CV',
            subtitle: 'Use your saved CV and profile details to apply.',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ApplyOption(
            title: 'Upload your CV',
            subtitle: 'Upload a new file (PDF or DOC) to apply.',
            onTap: () {},
          ),
          const SizedBox(height: 20),
          IthakiButton('Apply Now', onPressed: () {}),
        ],
      ),
    );
  }
}

class _ApplyOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ApplyOption({required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: IthakiTheme.softGray,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 13,
                color: IthakiTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Decline invite sheet ──────────────────────────────────────────────────────

class _DeclineInviteSheet extends ConsumerStatefulWidget {
  final String invitationId;
  const _DeclineInviteSheet({required this.invitationId});

  @override
  ConsumerState<_DeclineInviteSheet> createState() =>
      _DeclineInviteSheetState();
}

class _DeclineInviteSheetState extends ConsumerState<_DeclineInviteSheet> {
  String? _selectedReason;
  bool _declining = false;

  static const _reasons = [
    'Not interested in this position',
    'Already found a job',
    "Salary doesn't match my expectations",
    "Location doesn't work for me",
    'Other',
  ];

  Future<void> _onDecline() async {
    if (_selectedReason == null || _declining) return;
    setState(() => _declining = true);
    await ref.read(invitationsProvider.notifier).dismiss(widget.invitationId);
    ref.read(invitationDeclinedProvider.notifier).set(true);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final invitation = ref
        .watch(invitationsProvider)
        .value
        ?.where((i) => i.id == widget.invitationId)
        .firstOrNull;

    return Container(
      decoration: const BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.fromLTRB(
        24, 20, 24, MediaQuery.paddingOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Decline Invitation',
                style: TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: IthakiTheme.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: const IthakiIcon('close', size: 20,
                    color: IthakiTheme.softGraphite),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Are you sure you want to decline this invitation?',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              color: IthakiTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // ── Job preview ──────────────────────────────────────────────────────
          if (invitation != null) ...[
            // Sender row
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: invitation.senderAvatarColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    invitation.senderInitials,
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: invitation.senderAvatarColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invitation.senderName,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      invitation.companyName,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 13,
                        color: IthakiTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              invitation.message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 13,
                color: IthakiTheme.textPrimary,
                height: 1.5,
                letterSpacing: -0.26,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
            const SizedBox(height: 10),
            Text(
              invitation.postedAgo,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 12,
                color: IthakiTheme.softGraphite,
              ),
            ),
            const SizedBox(height: 8),
            // Job row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color:
                        invitation.companyLogoColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: IthakiTheme.borderLight),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    invitation.companyInitials,
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: invitation.companyLogoColor,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invitation.jobTitle,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        invitation.companyName,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 13,
                          color: IthakiTheme.softGraphite,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              invitation.salary,
              style: const TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: IthakiTheme.textPrimary,
                letterSpacing: -0.36,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: IthakiTheme.badgeLime,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                invitation.category,
                style: const TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 13,
                  color: IthakiTheme.textPrimary,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ── Reason label ─────────────────────────────────────────────────────
          const Text(
            'Please select a reason',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: IthakiTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),

          // ── Reason dropdown ──────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              color: IthakiTheme.softGray,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: IthakiTheme.borderLight),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedReason,
                isExpanded: true,
                hint: const Text(
                  'Select reason',
                  style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 14,
                    color: IthakiTheme.textSecondary,
                  ),
                ),
                items: _reasons
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(
                            r,
                            style: const TextStyle(
                              fontFamily: 'Noto Sans',
                              fontSize: 14,
                              color: IthakiTheme.textPrimary,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: _declining
                    ? null
                    : (v) => setState(() => _selectedReason = v),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Confirm button ───────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: IthakiButton(
              _declining ? '✓  Declined' : 'Decline Invite',
              onPressed:
                  (_selectedReason == null || _declining) ? null : _onDecline,
            ),
          ),
        ],
      ),
    );
  }
}

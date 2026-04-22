import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../models/job_detail_models.dart';
import '../../providers/home_provider.dart';
import '../../providers/job_detail_provider.dart';
import '../../providers/job_search_provider.dart';
import '../../providers/profile_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../utils/match_colors.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import '../applications/widgets/invitation_detail_widgets.dart';
import 'widgets/report_job_sheet.dart';
import 'widgets/set_reminder_sheet.dart';

class JobSearchDetailScreen extends ConsumerStatefulWidget {
  final String jobId;
  const JobSearchDetailScreen({super.key, required this.jobId});

  @override
  ConsumerState<JobSearchDetailScreen> createState() => _JobSearchDetailScreenState();
}

class _JobSearchDetailScreenState extends ConsumerState<JobSearchDetailScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;
  bool _announcementDismissed = false;
  bool _hasReminder = false;
  bool _isNotInterested = false;
  final _shareKey = GlobalKey();

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
    final homeData = ref.watch(homeProvider).value;
    final detailAsync = ref.watch(jobDetailProvider(widget.jobId));
    final searchState = ref.watch(jobSearchProvider).value;
    final isSaved = searchState?.isSaved(widget.jobId) ?? false;
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    return detailAsync.when(
      loading: () => _shell(context, homeData, topOffset, isSaved,
          child: const Center(child: CircularProgressIndicator())),
      error: (_, __) => _shell(context, homeData, topOffset, isSaved,
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Could not load job.',
                  style: TextStyle(color: IthakiTheme.textPrimary, fontSize: 16)),
              const SizedBox(height: 16),
              IthakiButton('Try Again',
                  onPressed: () => ref.invalidate(jobDetailProvider(widget.jobId))),
            ]),
          )),
      data: (detail) => _shell(context, homeData, topOffset, isSaved,
          detail: detail,
          child: _Body(
            detail: detail,
            isSaved: isSaved,
            hasReminder: _hasReminder,
            isNotInterested: _isNotInterested,
            announcementDismissed: _announcementDismissed,
            onDismissAnnouncement: () => setState(() => _announcementDismissed = true),
            onSave: () => _toggleSave(context, isSaved),
            onApply: () => _showApplySheet(context),
            onNotInterested: () => _onNotInterested(context),
            onUndoNotInterested: () => setState(() => _isNotInterested = false),
            onDeadlineReminder: () => _showReminderSheet(context, detail),
            onDeleteReminder: () => setState(() => _hasReminder = false),
            onReport: () => _showReportSheet(context),
            onShare: () => _showShareMenu(context),
            onAskCareerAssistant: () => context.push(Routes.careerAssistant),
          )),
    );
  }

  Widget _shell(
    BuildContext context,
    dynamic homeData,
    double topOffset,
    bool isSaved, {
    JobDetail? detail,
    required Widget child,
  }) {
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
      bottomNavigationBar: detail != null
          ? _StickyBar(
              isSaved: isSaved,
              isClosed: detail.isClosed,
              onApply: () => _showApplySheet(context),
              onSave: () => _toggleSave(context, isSaved),
            )
          : null,
      body: Stack(children: [
        child,
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
        if (_panels.menuOpen || _panels.menuCtrl.status != AnimationStatus.dismissed)
          _panel(topOffset,
              SlideTransition(
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
              )),
        if (_panels.profileOpen || _panels.profileCtrl.status != AnimationStatus.dismissed)
          _panel(topOffset,
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
              )),
      ]),
    );
  }

  Positioned _panel(double topOffset, Widget child) => Positioned(
        top: topOffset - 14,
        left: 16, right: 16, bottom: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: child,
        ),
      );

  void _toggleSave(BuildContext context, bool isSaved) {
    ref.read(jobSearchProvider.notifier).toggleSaved(widget.jobId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isSaved ? 'Removed from saved jobs.' : 'Job has been saved! Check your saved jobs.'),
      duration: const Duration(seconds: 3),
    ));
  }

  void _showApplySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ApplyBottomSheet(),
    );
  }

  void _onNotInterested(BuildContext context) {
    setState(() => _isNotInterested = true);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Job post has been removed'),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => setState(() => _isNotInterested = false),
      ),
    ));
  }

  Future<void> _showReminderSheet(BuildContext context, JobDetail detail) async {
    final set = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SetReminderSheet(
        jobTitle: detail.jobTitle,
        salary: detail.salary,
        companyName: detail.companyName,
        deadlineDate: detail.deadline,
      ),
    );
    if (set == true && mounted) {
      setState(() => _hasReminder = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Deadline Reminder has been set. We will notify you a week before the deadline'),
        duration: Duration(seconds: 4),
      ));
    }
  }

  Future<void> _showReportSheet(BuildContext context) async {
    final reported = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReportJobSheet(),
    );
    if (reported == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Job post has been reported'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  void _showShareMenu(BuildContext context) {
    final box = _shareKey.currentContext?.findRenderObject() as RenderBox?;
    final position = box != null
        ? RelativeRect.fromRect(
            box.localToGlobal(Offset.zero) & box.size,
            Offset.zero & MediaQuery.sizeOf(context),
          )
        : RelativeRect.fill;
    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      items: const [
        PopupMenuItem(value: 'link', child: _ShareOption(icon: 'resume', label: 'Copy Link')),
        PopupMenuItem(value: 'whatsapp', child: _ShareOption(icon: 'phone', label: 'Share WhatsApp/SMS')),
        PopupMenuItem(value: 'email', child: _ShareOption(icon: 'envelope', label: 'Share in Email')),
        PopupMenuItem(value: 'linkedin', child: _ShareOption(icon: 'team', label: 'Share on LinkedIn')),
      ],
    );
  }
}

// ─── Share option row ─────────────────────────────────────────────────────────

class _ShareOption extends StatelessWidget {
  final String icon;
  final String label;
  const _ShareOption({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      IthakiIcon(icon, size: 18, color: IthakiTheme.softGraphite),
      const SizedBox(width: 12),
      Text(label, style: const TextStyle(fontFamily: 'Noto Sans', fontSize: 15)),
    ]);
  }
}

// ─── Sticky bottom bar ────────────────────────────────────────────────────────

class _StickyBar extends StatelessWidget {
  final bool isSaved;
  final bool isClosed;
  final VoidCallback onApply;
  final VoidCallback onSave;

  const _StickyBar({
    required this.isSaved,
    required this.isClosed,
    required this.onApply,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.all(12),
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
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        IthakiButton(
          isClosed ? 'Job Closed' : 'Apply Now',
          onPressed: isClosed ? null : onApply,
        ),
        const SizedBox(height: 8),
        IthakiButton(
          isSaved ? 'Remove from Saved' : 'Save Job',
          variant: IthakiButtonVariant.outline,
          onPressed: onSave,
        ),
      ]),
    );
  }
}

// ─── Scrollable body ──────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  final JobDetail detail;
  final bool isSaved;
  final bool hasReminder;
  final bool isNotInterested;
  final bool announcementDismissed;
  final VoidCallback onDismissAnnouncement;
  final VoidCallback onSave;
  final VoidCallback onApply;
  final VoidCallback onNotInterested;
  final VoidCallback onUndoNotInterested;
  final VoidCallback onDeadlineReminder;
  final VoidCallback onDeleteReminder;
  final VoidCallback onReport;
  final VoidCallback onShare;
  final VoidCallback onAskCareerAssistant;

  const _Body({
    required this.detail,
    required this.isSaved,
    required this.hasReminder,
    required this.isNotInterested,
    required this.announcementDismissed,
    required this.onDismissAnnouncement,
    required this.onSave,
    required this.onApply,
    required this.onNotInterested,
    required this.onUndoNotInterested,
    required this.onDeadlineReminder,
    required this.onDeleteReminder,
    required this.onReport,
    required this.onShare,
    required this.onAskCareerAssistant,
  });

  @override
  Widget build(BuildContext context) {
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: topOffset),

        // Announcement banner
        if (!announcementDismissed)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _AnnouncementBanner(onDismiss: onDismissAnnouncement),
          ),

        // Match banner
        if (detail.matchPercentage > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _MatchBanner(
              percentage: detail.matchPercentage,
              matchLabel: detail.matchLabel,
              onAskCareerAssistant: onAskCareerAssistant,
            ),
          ),

        // Main job card
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: _MainJobCard(
            detail: detail,
            hasReminder: hasReminder,
            isNotInterested: isNotInterested,
            onDeadlineReminder: onDeadlineReminder,
            onDeleteReminder: onDeleteReminder,
            onReport: onReport,
            onShare: onShare,
            onNotInterested: onNotInterested,
          ),
        ),

        // Odyssea review
        if (detail.odysseaRating.isNotEmpty || detail.odysseaPoints.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _OdysseaReviewCard(
              rating: detail.odysseaRating,
              points: detail.odysseaPoints,
            ),
          ),

        // Recommended
        if (detail.recommended.jobTitle.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _RecommendedSection(jobs: [detail.recommended]),
          ),

        // Company
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: _CompanyCard(company: detail.company),
        ),

        SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
      ]),
    );
  }
}

// ─── Announcement banner ──────────────────────────────────────────────────────

class _AnnouncementBanner extends StatelessWidget {
  final VoidCallback onDismiss;
  const _AnnouncementBanner({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const IthakiIcon('rocket', size: 20, color: IthakiTheme.primaryPurple),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('New on Ithaki! We just released a new feature that makes job search easier.',
                style: TextStyle(
                  fontFamily: 'Noto Sans', fontSize: 14,
                  color: IthakiTheme.textPrimary, height: 1.4,
                )),
            const SizedBox(height: 4),
            const Text('Read more',
                style: TextStyle(
                  fontFamily: 'Noto Sans', fontSize: 13,
                  color: IthakiTheme.textSecondary,
                  decoration: TextDecoration.underline,
                )),
          ]),
        ),
        GestureDetector(
          onTap: onDismiss,
          child: const IthakiIcon('delete', size: 18, color: IthakiTheme.softGraphite),
        ),
      ]),
    );
  }
}

// ─── Match banner ─────────────────────────────────────────────────────────────

class _MatchBanner extends StatelessWidget {
  final int percentage;
  final String matchLabel;
  final VoidCallback onAskCareerAssistant;

  const _MatchBanner({
    required this.percentage,
    required this.matchLabel,
    required this.onAskCareerAssistant,
  });

  Color get _progressColor {
    if (percentage >= 80) return IthakiTheme.matchGreen;
    if (percentage >= 60) return const Color(0xFFFFC44D);
    if (percentage >= 40) return const Color(0xFFFF8A4C);
    return const Color(0xFFFF6B6B);
  }

  String get _matchCopy {
    if (percentage >= 80) return "It's a Strong skills\nMatch!";
    if (percentage >= 60) return "It's a Good skills\nMatch!";
    if (percentage >= 40) return "It's a Partial skills\nMatch!";
    return "It's a Starter skills\nMatch!";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF151515),
            Color(0xFF1D1B28),
            IthakiTheme.primaryPurple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 112,
              height: 112,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(
                  width: 86,
                  height: 86,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                ),
                SizedBox(
                  width: 86,
                  height: 86,
                  child: CircularProgressIndicator(
                    value: percentage.clamp(0, 100).toDouble() / 100,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                  ),
                ),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _matchCopy,
                style: const TextStyle(
                  fontFamily: 'Noto Sans',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.45,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Divider(color: Colors.white.withValues(alpha: 0.18), height: 1),
        const SizedBox(height: 16),
        const Text(
          'Curious why you match this job?',
          style: TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 28),
        GestureDetector(
          onTap: onAskCareerAssistant,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.82),
                width: 1.2,
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IthakiIcon('ai', size: 18, color: Colors.white),
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'Ask Career Assistant',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

// ─── Main job card ────────────────────────────────────────────────────────────

class _MainJobCard extends StatelessWidget {
  final JobDetail detail;
  final bool hasReminder;
  final bool isNotInterested;
  final VoidCallback onDeadlineReminder;
  final VoidCallback onDeleteReminder;
  final VoidCallback onReport;
  final VoidCallback onShare;
  final VoidCallback onNotInterested;

  const _MainJobCard({
    required this.detail,
    required this.hasReminder,
    required this.isNotInterested,
    required this.onDeadlineReminder,
    required this.onDeleteReminder,
    required this.onReport,
    required this.onShare,
    required this.onNotInterested,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Posted + menu
        Row(children: [
          Expanded(
            child: Text('Posted ${detail.postedDate}',
                style: const TextStyle(
                  fontFamily: 'Noto Sans', fontSize: 13,
                  color: IthakiTheme.softGraphite,
                )),
          ),
          if (detail.isClosed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Closed',
                  style: TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 13,
                    color: IthakiTheme.textPrimary,
                  )),
            )
          else
            PopupMenuButton<String>(
              icon: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: IthakiTheme.borderLight),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text('···', style: TextStyle(fontSize: 16, color: IthakiTheme.textPrimary)),
              ),
              onSelected: (v) {
                if (v == 'reminder') onDeadlineReminder();
                if (v == 'report') onReport();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'reminder', child: Text('Deadline Reminder')),
                const PopupMenuItem(value: 'report', child: Text('Report')),
              ],
            ),
        ]),

        // Deadline banner
        if (detail.deadline.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            decoration: BoxDecoration(
              color: IthakiTheme.accentPurpleLight,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: IthakiTheme.backgroundWhite,
                    shape: BoxShape.circle,
                  ),
                  child: const IthakiIcon(
                    'calendar',
                    size: 18,
                    color: IthakiTheme.primaryPurple,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'This job has a deadline! Application\nopen till:',
                        style: TextStyle(
                          fontFamily: 'Noto Sans',
                          fontSize: 16,
                          height: 1.25,
                          fontWeight: FontWeight.w500,
                          color: IthakiTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: IthakiTheme.backgroundWhite,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          detail.deadline,
                          style: const TextStyle(
                            fontFamily: 'Noto Sans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: IthakiTheme.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              ),
          ),
        ],

        // Company header
        const SizedBox(height: 14),
        Row(children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: detail.companyLogoColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: IthakiTheme.borderLight),
            ),
            alignment: Alignment.center,
            child: Text(detail.companyLogoInitials,
                style: TextStyle(
                  fontFamily: 'Noto Sans', fontSize: 16,
                  fontWeight: FontWeight.w700, color: detail.companyLogoColor,
                )),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(detail.jobTitle,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 20,
                    fontWeight: FontWeight.w700, color: IthakiTheme.textPrimary,
                    letterSpacing: -0.4,
                  )),
              Text(detail.companyName,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 14,
                    color: IthakiTheme.softGraphite,
                  )),
            ]),
          ),
        ]),

        // Details grid
        if (_hasAnyDetail(detail)) ...[
          const SizedBox(height: 12),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          const SizedBox(height: 12),
          Wrap(spacing: 0, runSpacing: 10, children: [
            if (detail.location.isNotEmpty)
              _Cell(label: 'Location', icon: 'location', value: detail.location),
            if (detail.jobType.isNotEmpty)
              _Cell(label: 'Job Type', icon: 'clock', value: detail.jobType),
            if (detail.company.industry.isNotEmpty)
              _Cell(label: 'Industry', value: detail.company.industry),
            if (detail.salaryRange.isNotEmpty)
              _Cell(label: 'Salary Range', value: detail.salaryRange, bold: true),
            if (detail.workplace.isNotEmpty)
              _Cell(label: 'Workplace', icon: 'profile', value: detail.workplace),
            if (detail.experienceLevel.isNotEmpty)
              _Cell(
                label: 'Experience Level',
                icon: 'assessment',
                value: detail.experienceLevel,
              ),
            if (detail.languages.isNotEmpty)
              _Cell(
                label: 'Language',
                icon: 'globe',
                value: detail.languages,
                wide: true,
              ),
          ]),
        ],

        // Skills
        if (detail.skills.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Text(
            'Skills required',
            style: TextStyle(
              fontFamily: 'Noto Sans',
              fontSize: 14,
              color: IthakiTheme.softGraphite,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: detail.skills.map((s) => _SkillChip(s)).toList(),
          ),
        ],

        // About the role
        if (detail.description.isNotEmpty) ...[
          const SizedBox(height: 24),
          _JobTextSection(title: 'About the role', body: detail.description),
        ],

        // Responsibilities (communication field)
        if (detail.communication.isNotEmpty) ...[
          const SizedBox(height: 26),
          _JobBulletSection(
            title: 'Responsibilities',
            items: _splitJobBullets(detail.communication),
          ),
        ],

        // Requirements
        if (detail.requirements.isNotEmpty) ...[
          const SizedBox(height: 24),
          _JobBulletSection(title: 'Requirements', items: detail.requirements),
        ],

        // Nice to have
        if (detail.niceToHave.isNotEmpty) ...[
          const SizedBox(height: 14),
          _Section(title: 'Nice to have', body: detail.niceToHave),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE8E8E8)),
        ],

        // We offer
        if (detail.whatWeOffer.isNotEmpty) ...[
          const SizedBox(height: 14),
          _Section(title: 'We offer', body: detail.whatWeOffer),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFE8E8E8)),
        ],

        // Share + Not Interested / Job Removed
        const SizedBox(height: 14),
        if (isNotInterested)
          Row(children: [
            Expanded(
              child: IthakiButton('Share Job',
                  variant: IthakiButtonVariant.outline,
                  onPressed: onShare),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: IthakiButton('Job Removed',
                  variant: IthakiButtonVariant.outline,
                  onPressed: null),
            ),
          ])
        else
          Row(children: [
            Expanded(
              child: IthakiButton('Share Job',
                  variant: IthakiButtonVariant.outline,
                  onPressed: onShare),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: IthakiButton('Not Interested',
                  variant: IthakiButtonVariant.outline,
                  onPressed: onNotInterested),
            ),
          ]),

        // Reminder info
        if (hasReminder) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: IthakiTheme.accentPurpleLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              const IthakiIcon('calendar', size: 18, color: IthakiTheme.primaryPurple),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('You have set a reminder for this job post',
                    style: TextStyle(
                      fontFamily: 'Noto Sans', fontSize: 13,
                      color: IthakiTheme.textPrimary,
                    )),
              ),
            ]),
          ),
          const SizedBox(height: 8),
          IthakiButton('Delete Reminder',
              variant: IthakiButtonVariant.outline,
              onPressed: onDeleteReminder),
        ],
      ]),
    );
  }

  bool _hasAnyDetail(JobDetail d) =>
      d.location.isNotEmpty || d.jobType.isNotEmpty || d.company.industry.isNotEmpty || d.salaryRange.isNotEmpty ||
      d.workplace.isNotEmpty || d.experienceLevel.isNotEmpty || d.languages.isNotEmpty;
}

// ─── Odyssea review card ──────────────────────────────────────────────────────

class _OdysseaReviewCard extends StatelessWidget {
  final String rating;
  final List<String> points;
  const _OdysseaReviewCard({required this.rating, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('Odyssea Review: ',
              style: TextStyle(
                fontFamily: 'Noto Sans', fontSize: 15,
                fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
              )),
          if (rating.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F5C0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(rating,
                    style: const TextStyle(
                      fontFamily: 'Noto Sans', fontSize: 13,
                      fontWeight: FontWeight.w600, color: Color(0xFF6B6B00),
                    )),
                const SizedBox(width: 4),
                const Text('✦', style: TextStyle(fontSize: 12, color: Color(0xFF6B6B00))),
              ]),
            ),
        ]),
        if (points.isNotEmpty) ...[
          const SizedBox(height: 10),
          ...points.map((p) => _Bullet(p)),
        ],
      ]),
    );
  }
}

// ─── Recommended section ──────────────────────────────────────────────────────

class _RecommendedSection extends StatelessWidget {
  final List<RecommendedJob> jobs;
  const _RecommendedSection({required this.jobs});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Recommended for you',
            style: TextStyle(
              fontFamily: 'Noto Sans', fontSize: 16,
              fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
            )),
        ...jobs.map((job) => Padding(
              padding: const EdgeInsets.only(top: 14),
              child: _RecommendedJobTile(job: job),
            )),
      ]),
    );
  }
}

class _RecommendedJobTile extends StatelessWidget {
  final RecommendedJob job;
  const _RecommendedJobTile({required this.job});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: job.companyColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: IthakiTheme.borderLight),
          ),
          alignment: Alignment.center,
          child: Text(job.companyInitials,
              style: TextStyle(
                fontFamily: 'Noto Sans', fontSize: 14,
                fontWeight: FontWeight.w700, color: job.companyColor,
              )),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(job.jobTitle,
                style: const TextStyle(
                  fontFamily: 'Noto Sans', fontSize: 15,
                  fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                )),
            Text(job.companyName,
                style: const TextStyle(
                  fontFamily: 'Noto Sans', fontSize: 13,
                  color: IthakiTheme.softGraphite,
                )),
          ]),
        ),
      ]),
      const SizedBox(height: 10),
      Text(job.salary,
          style: const TextStyle(
            fontFamily: 'Noto Sans', fontSize: 16,
            fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
          )),
      const SizedBox(height: 6),
      Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: getMatchBgColor(job.matchLabel),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(job.matchLabel,
              style: const TextStyle(
                fontFamily: 'Noto Sans', fontSize: 12,
                fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
              )),
        ),
        const SizedBox(width: 8),
        IthakiIcon('location', size: 15, color: IthakiTheme.softGraphite),
        const SizedBox(width: 4),
        Text(job.location,
            style: const TextStyle(fontSize: 13, color: IthakiTheme.softGraphite)),
        const SizedBox(width: 8),
        IthakiIcon('clock', size: 15, color: IthakiTheme.softGraphite),
        const SizedBox(width: 4),
        Text(job.employmentType,
            style: const TextStyle(fontSize: 13, color: IthakiTheme.softGraphite)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(
          child: IthakiButton('Save Job',
              variant: IthakiButtonVariant.outline,
              onPressed: () => context.go(Routes.jobSearch)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: IthakiButton(
            'View Job',
            onPressed: () => context.go(Routes.jobSearch),
          ),
        ),
      ]),
    ]);
  }
}

// ─── Company card ─────────────────────────────────────────────────────────────

class _CompanyCard extends StatelessWidget {
  final JobDetailCompany company;
  const _CompanyCard({required this.company});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('About the Company',
            style: TextStyle(
              fontFamily: 'Noto Sans', fontSize: 16,
              fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
            )),
        const SizedBox(height: 12),
        Row(children: [
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
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(company.name,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 15,
                    fontWeight: FontWeight.w600, color: IthakiTheme.textPrimary,
                  )),
              Text(company.industry,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans', fontSize: 13,
                    color: IthakiTheme.softGraphite,
                  )),
            ]),
          ),
        ]),
        if (company.description.isNotEmpty) ...[
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE8E8E8)),
          const SizedBox(height: 12),
          Text(company.description,
              style: const TextStyle(
                fontFamily: 'Noto Sans', fontSize: 14,
                color: IthakiTheme.textPrimary, height: 1.5,
              )),
        ],
        const SizedBox(height: 12),
        IthakiButton('Company Profile',
            variant: IthakiButtonVariant.outline,
            onPressed: company.id.isNotEmpty
                ? () => context.push(Routes.companyProfileFor(company.id))
                : null),
      ]),
    );
  }
}

// ─── Small reusable widgets ───────────────────────────────────────────────────

class _Cell extends StatelessWidget {
  final String label;
  final String? icon;
  final String value;
  final bool bold;
  final bool wide;
  const _Cell({
    required this.label,
    this.icon,
    required this.value,
    this.bold = false,
    this.wide = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wide ? double.infinity : 155,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 14,
            color: IthakiTheme.softGraphite,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 5),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (icon != null) ...[
            IthakiIcon(icon!, size: 16, color: IthakiTheme.softGraphite),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Noto Sans',
                fontSize: bold ? 17 : 14,
                height: 1.35,
                fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                color: IthakiTheme.textPrimary,
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: IthakiTheme.softGray,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Text(
          '✓',
          style: TextStyle(
            fontSize: 11,
            color: IthakiTheme.softGraphite,
            height: 1,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Noto Sans',
            fontSize: 14,
            height: 1.1,
            color: IthakiTheme.textPrimary,
          ),
        ),
      ]),
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

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _SectionTitle(title),
      const SizedBox(height: 8),
      Text(body,
          style: const TextStyle(
            fontFamily: 'Noto Sans', fontSize: 14,
            color: IthakiTheme.textPrimary, height: 1.5,
          )),
    ]);
  }
}

class _JobTextSection extends StatelessWidget {
  final String title;
  final String body;
  const _JobTextSection({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: _jobSectionTitleStyle),
      const SizedBox(height: 7),
      Text(body, style: _jobSectionBodyStyle),
    ]);
  }
}

class _JobBulletSection extends StatelessWidget {
  final String title;
  final List<String> items;
  const _JobBulletSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: _jobSectionTitleStyle),
      const SizedBox(height: 9),
      ...items.where((item) => item.trim().isNotEmpty).map(_JobBullet.new),
    ]);
  }
}

class _JobBullet extends StatelessWidget {
  final String text;
  const _JobBullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 7, right: 8),
          decoration: const BoxDecoration(
            color: IthakiTheme.borderLight,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(child: Text(text, style: _jobSectionBodyStyle)),
      ]),
    );
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
                color: IthakiTheme.textPrimary, height: 1.5,
              )),
        ),
      ]),
    );
  }
}

List<String> _splitJobBullets(String value) {
  final lines = value
      .split(RegExp(r'\r?\n|•|- '))
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  return lines.length > 1 ? lines : [value.trim()];
}

const _jobSectionTitleStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: IthakiTheme.textPrimary,
);

const _jobSectionBodyStyle = TextStyle(
  fontFamily: 'Noto Sans',
  fontSize: 14,
  height: 1.48,
  color: IthakiTheme.textPrimary,
);

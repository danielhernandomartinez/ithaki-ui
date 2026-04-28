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
import '../../providers/tour_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import '../applications/widgets/invitation_detail_widgets.dart';
import 'widgets/report_job_sheet.dart';
import 'widgets/set_reminder_sheet.dart';
import 'widgets/job_search_detail_sections.dart';

class JobSearchDetailScreen extends ConsumerStatefulWidget {
  final String jobId;
  const JobSearchDetailScreen({super.key, required this.jobId});

  @override
  ConsumerState<JobSearchDetailScreen> createState() =>
      _JobSearchDetailScreenState();
}

class _JobSearchDetailScreenState extends ConsumerState<JobSearchDetailScreen>
    with TickerProviderStateMixin {
  late final PanelMenuController _panels;
  bool _announcementDismissed = false;
  int? _lastAutoOpenedTourStep;
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
    final tourState = ref.watch(tourProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    final tourKeys = ref.watch(tourKeysProvider);
    final isSaved = searchState?.isSaved(widget.jobId) ?? false;
    final interactionState = ref.watch(
      jobDetailInteractionProvider(widget.jobId),
    );
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    _syncTourApplySheet(tourState, tourKeys);

    return detailAsync.when(
      loading: () => _shell(context, homeData, topOffset, isSaved,
          child: const Center(child: CircularProgressIndicator())),
      error: (_, __) => _shell(context, homeData, topOffset, isSaved,
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Could not load job.',
                  style:
                      TextStyle(color: IthakiTheme.textPrimary, fontSize: 16)),
              const SizedBox(height: 16),
              IthakiButton('Try Again',
                  onPressed: () =>
                      ref.invalidate(jobDetailProvider(widget.jobId))),
            ]),
          )),
      data: (detail) => _shell(context, homeData, topOffset, isSaved,
          detail: detail,
          child: JobDetailBody(
            detail: detail,
            tourState: tourState,
            tourKeys: tourKeys,
            isSaved: isSaved,
            hasReminder: interactionState.hasReminder,
            isNotInterested: interactionState.isNotInterested,
            announcementDismissed: _announcementDismissed,
            onDismissAnnouncement: () =>
                setState(() => _announcementDismissed = true),
            onSave: () => _toggleSave(context, isSaved),
            onApply: () => _showApplySheet(context),
            onNotInterested: () => _onNotInterested(context),
            onUndoNotInterested: () => ref
                .read(jobDetailInteractionProvider(widget.jobId).notifier)
                .undoNotInterested(),
            onDeadlineReminder: () => _showReminderSheet(context, detail),
            onDeleteReminder: () => ref
                .read(jobDetailInteractionProvider(widget.jobId).notifier)
                .deleteReminder(),
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
        avatarUrl: homeData?.userPhotoUrl,
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(children: [
        child,
        if (detail != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: JobDetailStickyBar(
                isSaved: isSaved,
                isClosed: detail.isClosed,
                onApply: () => _showApplySheet(context),
                onSave: () => _toggleSave(context, isSaved),
              ),
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
                  currentRoute: Routes.jobSearch,
                  profileProgress: ref.watch(profileCompletionProvider),
                  items: kAppNavItems,
                  onItemTap: (item) {
                    _panels.closeMenu();
                    context.go(item.route);
                  },
                ),
              )),
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
              )),
      ]),
    );
  }

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

  void _toggleSave(BuildContext context, bool isSaved) {
    ref.read(jobSearchProvider.notifier).toggleSaved(widget.jobId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isSaved
          ? 'Removed from saved jobs.'
          : 'Job has been saved! Check your saved jobs.'),
      duration: const Duration(seconds: 3),
    ));
  }

  void _syncTourApplySheet(TourState? tourState, Map<int, GlobalKey> tourKeys) {
    final step = tourState?.currentStep;
    if (step != 6) {
      _lastAutoOpenedTourStep = null;
      return;
    }
    if (_lastAutoOpenedTourStep == step) {
      return;
    }
    _lastAutoOpenedTourStep = step;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showApplySheet(context, highlightKey: tourKeys[6]);
    });
  }

  Future<void> _showApplySheet(BuildContext context,
      {Key? highlightKey}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => KeyedSubtree(
        key: highlightKey,
        child: const ApplyBottomSheet(),
      ),
    );
  }

  void _onNotInterested(BuildContext context) {
    ref
        .read(jobDetailInteractionProvider(widget.jobId).notifier)
        .markNotInterested();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Job post has been removed'),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () => ref
            .read(jobDetailInteractionProvider(widget.jobId).notifier)
            .undoNotInterested(),
      ),
    ));
  }

  Future<void> _showReminderSheet(
      BuildContext context, JobDetail detail) async {
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
    if (set == true && context.mounted) {
      ref
          .read(jobDetailInteractionProvider(widget.jobId).notifier)
          .setReminder();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Deadline Reminder has been set. We will notify you a week before the deadline'),
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
    if (reported == true && context.mounted) {
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
        PopupMenuItem(
            value: 'link',
            child: JobDetailShareOption(icon: 'resume', label: 'Copy Link')),
        PopupMenuItem(
            value: 'whatsapp',
            child: JobDetailShareOption(
                icon: 'phone', label: 'Share WhatsApp/SMS')),
        PopupMenuItem(
            value: 'email',
            child: JobDetailShareOption(
                icon: 'envelope', label: 'Share in Email')),
        PopupMenuItem(
            value: 'linkedin',
            child:
                JobDetailShareOption(icon: 'team', label: 'Share on LinkedIn')),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../models/job_detail_models.dart';
import '../../providers/home_provider.dart';
import '../../providers/job_detail_provider.dart';
import '../../providers/job_search_provider.dart';
import '../../providers/tour_provider.dart';
import '../../routes.dart';
import '../../utils/ithaki_bottom_sheet.dart';
import '../../widgets/main_panel_scaffold.dart';
import '../applications/widgets/apply_bottom_sheet.dart';
import 'widgets/job_detail_body.dart';
import 'widgets/job_detail_primitives.dart';
import 'widgets/job_detail_sticky_bar.dart';
import 'widgets/report_job_sheet.dart';
import 'widgets/set_reminder_sheet.dart';

class JobSearchDetailScreen extends ConsumerStatefulWidget {
  final String jobId;
  const JobSearchDetailScreen({super.key, required this.jobId});

  @override
  ConsumerState<JobSearchDetailScreen> createState() =>
      _JobSearchDetailScreenState();
}

class _JobSearchDetailScreenState extends ConsumerState<JobSearchDetailScreen> {
  bool _announcementDismissed = false;
  int? _lastAutoOpenedTourStep;
  final _shareKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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

    _syncTourApplySheet(tourState, tourKeys);

    return detailAsync.when(
      loading: () => _shell(
        context,
        homeData,
        isSaved,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => _shell(
        context,
        homeData,
        isSaved,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.jobLoadError,
                style: const TextStyle(
                  color: IthakiTheme.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              IthakiButton(
                l.tryAgain,
                onPressed: () =>
                    ref.invalidate(jobDetailProvider(widget.jobId)),
              ),
            ],
          ),
        ),
      ),
      data: (detail) => _shell(
        context,
        homeData,
        isSaved,
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
        ),
      ),
    );
  }

  Widget _shell(
    BuildContext context,
    dynamic homeData,
    bool isSaved, {
    JobDetail? detail,
    required Widget child,
  }) {
    return MainPanelScaffold(
      currentRoute: Routes.jobSearch,
      showBackButton: true,
      avatarInitials: homeData?.userInitials ?? 'CI',
      avatarUrl: homeData?.userPhotoUrl,
      bodyBuilder: (context, ref, topOffset) => child,
      overlayBuilder: detail == null
          ? null
          : (context, ref, topOffset) => [
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
              ],
    );
  }

  void _toggleSave(BuildContext context, bool isSaved) {
    final l = AppLocalizations.of(context)!;
    ref.read(jobSearchProvider.notifier).toggleSaved(widget.jobId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSaved ? l.jobRemovedFromSaved : l.jobSavedMessage),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _syncTourApplySheet(TourState? tourState, Map<int, GlobalKey> tourKeys) {
    final step = tourState?.currentStep;
    if (step != 6) {
      _lastAutoOpenedTourStep = null;
      return;
    }
    if (_lastAutoOpenedTourStep == step) return;
    _lastAutoOpenedTourStep = step;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showApplySheet(context, highlightKey: tourKeys[6]);
    });
  }

  Future<void> _showApplySheet(BuildContext context,
      {Key? highlightKey}) async {
    await showIthakiBottomSheet<void>(
      context: context,
      builder: (_) => KeyedSubtree(
        key: highlightKey,
        child: const ApplyBottomSheet(),
      ),
    );
  }

  void _onNotInterested(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    ref
        .read(jobDetailInteractionProvider(widget.jobId).notifier)
        .markNotInterested();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l.jobPostRemoved),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: l.undo,
          onPressed: () => ref
              .read(jobDetailInteractionProvider(widget.jobId).notifier)
              .undoNotInterested(),
        ),
      ),
    );
  }

  Future<void> _showReminderSheet(
    BuildContext context,
    JobDetail detail,
  ) async {
    final set = await showIthakiBottomSheet<bool>(
      context: context,
      builder: (_) => SetReminderSheet(
        jobTitle: detail.jobTitle,
        salary: detail.salary,
        companyName: detail.companyName,
        deadlineDate: detail.deadline,
      ),
    );
    if (set == true && context.mounted) {
      final l = AppLocalizations.of(context)!;
      ref
          .read(jobDetailInteractionProvider(widget.jobId).notifier)
          .setReminder();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.deadlineReminderSet),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _showReportSheet(BuildContext context) async {
    final reported = await showIthakiBottomSheet<bool>(
      context: context,
      builder: (_) => const ReportJobSheet(),
    );
    if (reported == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.jobReportedMessage),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showShareMenu(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
      items: [
        PopupMenuItem(
          value: 'link',
          child: JobDetailShareOption(icon: 'resume', label: l.copyLink),
        ),
        PopupMenuItem(
          value: 'whatsapp',
          child: JobDetailShareOption(icon: 'phone', label: l.shareWhatsappSms),
        ),
        PopupMenuItem(
          value: 'email',
          child: JobDetailShareOption(icon: 'envelope', label: l.shareInEmail),
        ),
        PopupMenuItem(
          value: 'linkedin',
          child: JobDetailShareOption(icon: 'team', label: l.shareOnLinkedIn),
        ),
      ],
    );
  }
}

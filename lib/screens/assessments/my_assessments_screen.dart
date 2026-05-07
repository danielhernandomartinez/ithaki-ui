// lib/screens/assessments/my_assessments_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../l10n/app_localizations.dart';

import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/tour_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/assessment_card.dart';
import '../../widgets/profile_menu_panel.dart';

class MyAssessmentsScreen extends ConsumerStatefulWidget {
  const MyAssessmentsScreen({super.key});

  @override
  ConsumerState<MyAssessmentsScreen> createState() =>
      _MyAssessmentsScreenState();
}

class _MyAssessmentsScreenState extends ConsumerState<MyAssessmentsScreen>
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

  void _onStartTest(BuildContext context, Assessment assessment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _StartAssessmentSheet(
        assessment: assessment,
        onStart: () {
          Navigator.pop(context);
          context.push(Routes.assessmentQuizFor(assessment.id));
        },
      ),
    );
  }

  void _onContinue(BuildContext context, Assessment assessment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ContinueAssessmentSheet(
        assessment: assessment,
        onContinue: () {
          Navigator.pop(context);
          context.push(Routes.assessmentQuizFor(assessment.id));
        },
        onStartOver: () {
          Navigator.pop(context);
          ref.read(quizProvider(assessment.id).notifier).reset();
          context.push(Routes.assessmentQuizFor(assessment.id));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(homeProvider);
    final assessmentsAsync = ref.watch(assessmentsListProvider);
    final tourState = ref.watch(tourProvider).maybeWhen(
          data: (value) => value,
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
        avatarInitials: homeAsync.value?.userInitials ?? '',
        avatarUrl: homeAsync.value?.userPhotoUrl,
        onNotificationsPressed: () =>
            context.push(Routes.settingsNotifications),
        onMenuPressed: _panels.toggleMenu,
        onAvatarPressed: _panels.toggleProfile,
      ),
      body: Stack(
        children: [
          // ── Main content ────────────────────────────────────────────────────
          assessmentsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(AppLocalizations.of(context)!.errorMessage(e.toString()))),
            data: (assessments) {
              final inProgress = assessments
                  .where((a) => a.status == AssessmentStatus.inProgress)
                  .toList();
              final recommended = assessments
                  .where((a) => a.status == AssessmentStatus.notStarted)
                  .toList();
              final completed = assessments
                  .where((a) => a.status == AssessmentStatus.completed)
                  .toList();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: topOffset),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: KeyedSubtree(
                        key: tourState?.currentStep == 13 ? tourKeys[13] : null,
                        child: IthakiButton(
                          AppLocalizations.of(context)!.assessmentStartNew,
                          onPressed: recommended.isNotEmpty
                              ? () => _onStartTest(context, recommended.first)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (inProgress.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _SectionHeader(
                            AppLocalizations.of(context)!.assessmentsInProgressTitle(inProgress.length)),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          AppLocalizations.of(context)!.assessmentsInProgressSubtitle,
                          style: IthakiTheme.bodySmall
                              .copyWith(color: IthakiTheme.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: inProgress
                              .map((a) => AssessmentCard(
                                    assessment: a,
                                    onTestDetails: () => context
                                        .push(Routes.assessmentDetailFor(a.id)),
                                    onContinue: () => _onContinue(context, a),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                    if (recommended.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _SectionHeader(
                            AppLocalizations.of(context)!.assessmentsRecommendedForYou),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          AppLocalizations.of(context)!.assessmentsRecommendedSubtitle,
                          style: IthakiTheme.bodySmall
                              .copyWith(color: IthakiTheme.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: recommended
                              .map((a) => AssessmentCard(
                                    assessment: a,
                                    onTestDetails: () => context
                                        .push(Routes.assessmentDetailFor(a.id)),
                                    onStartTest: () => _onStartTest(context, a),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                    if (completed.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child:
                            _SectionHeader(AppLocalizations.of(context)!.assessmentsCompletedTitle),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          AppLocalizations.of(context)!.assessmentsCompletedSubtitle,
                          style: IthakiTheme.bodySmall
                              .copyWith(color: IthakiTheme.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: completed
                              .map((a) => AssessmentCard(
                                    assessment: a,
                                    onViewDetails: () => context.push(
                                        Routes.assessmentResultsFor(a.id)),
                                    onShowInCV: () => ref
                                        .read(assessmentResultProvider(a.id)
                                            .notifier)
                                        .toggleCV(
                                            show: !(a.lastResult?.shownInCV ??
                                                false)),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                    SizedBox(height: MediaQuery.paddingOf(context).bottom + 32),
                  ],
                ),
              );
            },
          ),

          // ── Dim overlay ─────────────────────────────────────────────────────
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

          // ── Nav drawer ───────────────────────────────────────────────────────
          if (_panels.menuOpen ||
              _panels.menuCtrl.status != AnimationStatus.dismissed)
            _panel(
              topOffset,
              SlideTransition(
                position: _panels.slideAnim,
                child: AppNavDrawer(
                  currentRoute: Routes.assessments,
                  profileProgress: ref.watch(profileCompletionProvider),
                  items: kAppNavItems,
                  onItemTap: (item) {
                    _panels.closeMenu();
                    if (item.route != Routes.assessments) {
                      context.go(item.route);
                    }
                  },
                ),
              ),
            ),

          // ── Profile panel ────────────────────────────────────────────────────
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

// ─── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: IthakiTheme.headingMedium.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

// ─── Start Assessment Sheet ────────────────────────────────────────────────────

class _StartAssessmentSheet extends StatelessWidget {
  final Assessment assessment;
  final VoidCallback onStart;

  const _StartAssessmentSheet(
      {required this.assessment, required this.onStart});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.assessmentStartTitle,
                  style: IthakiTheme.headingMedium
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const IthakiIcon('x-close',
                    size: 22, color: IthakiTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l.assessmentStartSubtitle,
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: IthakiTheme.borderLight),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: IthakiTheme.accentPurpleLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: IthakiIcon(assessment.iconName,
                            size: 22, color: IthakiTheme.primaryPurple),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assessment.title,
                            style: IthakiTheme.bodySmallSemiBold,
                          ),
                          Text(
                            assessment.category,
                            style: IthakiTheme.bodySmall
                                .copyWith(color: IthakiTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    _MetaItem(
                      icon: 'clock',
                      label: l.assessmentApproxDuration,
                      value: l.durationMinutes(assessment.durationMinutes),
                    ),
                    const SizedBox(width: 24),
                    _MetaItem(
                      icon: 'assessment',
                      label: l.assessmentQuestionsLabel,
                      value: l.questionsCount(assessment.questionCount),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _MetaItem(
                  icon: 'flag',
                  label: l.languageFieldLabel,
                  value: assessment.language,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l.assessmentBeforeStart,
            style: IthakiTheme.bodySmallSemiBold,
          ),
          const SizedBox(height: 8),
          ...assessment.beforeYouStart.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 8),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: IthakiTheme.textSecondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: IthakiTheme.bodySmall
                          .copyWith(color: IthakiTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          IthakiButton(l.assessmentStartNow, onPressed: onStart),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _MetaItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: IthakiTheme.bodySmall
              .copyWith(color: IthakiTheme.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            IthakiIcon(icon, size: 14, color: IthakiTheme.textSecondary),
            const SizedBox(width: 4),
            Text(value, style: IthakiTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}

// ─── Continue Assessment Sheet ─────────────────────────────────────────────────

class _ContinueAssessmentSheet extends StatelessWidget {
  final Assessment assessment;
  final VoidCallback onContinue;
  final VoidCallback onStartOver;

  const _ContinueAssessmentSheet({
    required this.assessment,
    required this.onContinue,
    required this.onStartOver,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.assessmentContinueTitle,
                  style: IthakiTheme.headingMedium
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const IthakiIcon('x-close',
                    size: 22, color: IthakiTheme.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l.assessmentContinueSubtitle,
            style: IthakiTheme.bodySmall
                .copyWith(color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: IthakiOutlineButton(l.assessmentStartOver, onPressed: onStartOver),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: IthakiButton(l.continueButton, onPressed: onContinue),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

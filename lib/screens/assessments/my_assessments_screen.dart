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
import 'continue_assessment_sheet.dart';
import 'start_assessment_sheet.dart';

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
      builder: (_) => StartAssessmentSheet(
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
      builder: (_) => ContinueAssessmentSheet(
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
    final grouped = ref.watch(assessmentsGroupedProvider);
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
            error: (e, _) => Center(
                child: Text(
                    AppLocalizations.of(context)!.errorMessage(e.toString()))),
            data: (_) => SingleChildScrollView(
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
                        onPressed: grouped.recommended.isNotEmpty
                            ? () =>
                                _onStartTest(context, grouped.recommended.first)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (grouped.inProgress.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _SectionHeader(
                          AppLocalizations.of(context)!
                              .assessmentsInProgressTitle(
                                  grouped.inProgress.length)),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppLocalizations.of(context)!
                            .assessmentsInProgressSubtitle,
                        style: IthakiTheme.bodySmall
                            .copyWith(color: IthakiTheme.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: grouped.inProgress
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
                  if (grouped.recommended.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _SectionHeader(AppLocalizations.of(context)!
                          .assessmentsRecommendedForYou),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppLocalizations.of(context)!
                            .assessmentsRecommendedSubtitle,
                        style: IthakiTheme.bodySmall
                            .copyWith(color: IthakiTheme.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: grouped.recommended
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
                  if (grouped.completed.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _SectionHeader(AppLocalizations.of(context)!
                          .assessmentsCompletedTitle),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppLocalizations.of(context)!
                            .assessmentsCompletedSubtitle,
                        style: IthakiTheme.bodySmall
                            .copyWith(color: IthakiTheme.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: grouped.completed
                            .map((a) => AssessmentCard(
                                  assessment: a,
                                  onViewDetails: () => context
                                      .push(Routes.assessmentResultsFor(a.id)),
                                  onShowInCV: () => ref
                                      .read(assessmentsListProvider.notifier)
                                      .toggleCV(a.id),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                  SizedBox(
                      height: MediaQuery.paddingOf(context).bottom + 32),
                ],
              ),
            ),
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
                  items: buildNavItems(AppLocalizations.of(context)!),
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
                    navigateToProfileMenuRoute(context, item);
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/home_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/tour_provider.dart';
import '../../routes.dart';
import '../../tour/tour_welcome_modal.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/main_panel_scaffold.dart';
import '../../widgets/responsive_gradient_banner.dart';
import 'widgets/home_courses_section.dart';
import 'widgets/home_greeting_header.dart';
import 'widgets/home_jobs_section.dart';
import 'widgets/home_news_section.dart';
import 'widgets/home_profile_completion_card.dart';
import 'widgets/home_questions_section.dart';
import 'widgets/home_search_section.dart';
import 'widgets/home_stats_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _scrollController = ScrollController();
  String _selectedRoute = Routes.home;
  bool _welcomeModalScheduled = false;
  int? _lastTourScrollStep;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _maybeShowWelcomeModal(TourState? tourState) {
    final shouldShow = tourState != null &&
        !tourState.tourCompleted &&
        tourState.currentStep == 0 &&
        tourState.welcomeVisible;
    if (!shouldShow || _welcomeModalScheduled) return;
    _welcomeModalScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await TourWelcomeModal.show(context);
      if (mounted) {
        setState(() => _welcomeModalScheduled = false);
      } else {
        _welcomeModalScheduled = false;
      }
    });
  }

  void _syncTourScroll(TourState? tourState, Map<int, GlobalKey> tourKeys) {
    final step = tourState?.currentStep;
    if (step != 1 && step != 12) {
      _lastTourScrollStep = null;
      return;
    }
    if (_lastTourScrollStep == step) return;
    _lastTourScrollStep = step;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (step == 1) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
        return;
      }
      final targetContext = tourKeys[12]?.currentContext;
      if (targetContext != null) {
        Scrollable.ensureVisible(
          targetContext,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          alignment: 0.12,
        );
      }
    });
  }

  Widget _buildLoading() => const Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        body: Center(child: CircularProgressIndicator()),
      );

  Widget _buildError(Object error) => Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        body: Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: IthakiTheme.textPrimary),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final profileCompletion = ref.watch(profileCompletionProvider);
    final tourState = ref.watch(tourProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    final tourKeys = ref.watch(tourKeysProvider);
    final l10n = AppLocalizations.of(context)!;

    _maybeShowWelcomeModal(tourState);
    _syncTourScroll(tourState, tourKeys);

    return ref.watch(homeProvider).when(
          loading: _buildLoading,
          error: (e, _) => _buildError(e),
          data: (homeData) => MainPanelScaffold(
            currentRoute: _selectedRoute,
            avatarInitials: homeData.userInitials,
            avatarUrl: homeData.userPhotoUrl,
            onNavItemTap: (context, NavItem item) {
              setState(() => _selectedRoute = item.route);
              if (item.route != Routes.home) context.go(item.route);
            },
            bodyBuilder: (context, ref, topOffset) => SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeGreetingHeader(topOffset: topOffset),
                  const SizedBox(height: 12),
                  if ((tourState?.tourCompleted ?? false) &&
                      !(tourState?.restartBannerDismissed ?? false)) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ResponsiveGradientBanner(
                        title: l10n.homeNeedRefresher,
                        subtitle: l10n.homeRestartProductTourSubtitle,
                        buttonLabel: l10n.homeRestartProductTour,
                        buttonIcon: const IthakiIcon(
                          'rocket',
                          size: 18,
                          color: IthakiTheme.backgroundWhite,
                        ),
                        onButtonPressed: () =>
                            ref.read(tourProvider.notifier).startTour(),
                        onDismiss: () => ref
                            .read(tourProvider.notifier)
                            .dismissRestartBanner(),
                        backgroundImage: const DecorationImage(
                          image: AssetImage('assets/images/ai_banner_bg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (profileCompletion < 1.0) ...[
                    const HomeProfileCompletionCard(),
                    const SizedBox(height: 12),
                  ],
                  IthakiCard(
                    key: tourKeys[1],
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HomeSearchSection(),
                  ),
                  const SizedBox(height: 12),
                  IthakiCard(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HomeJobsSection(),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ResponsiveGradientBanner(
                      title: l10n.bannerNotSureJob,
                      subtitle: l10n.homeCareerAssistantBannerSubtitle,
                      buttonLabel: l10n.askCareerAssistant,
                      buttonIcon: const IthakiIcon(
                        'ai',
                        size: 18,
                        color: IthakiTheme.backgroundWhite,
                      ),
                      onButtonPressed: () => context.go(Routes.careerAssistant),
                      backgroundImage: const DecorationImage(
                        image: AssetImage('assets/images/ai_banner_bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  IthakiCard(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: HomeStatsCard(
                      title: l10n.homeCvSuccess,
                      rows: [
                        IthakiStatRowData(
                          icon: const IthakiIcon(
                            'eye',
                            size: 18,
                            color: IthakiTheme.primaryPurple,
                          ),
                          label: l10n.homeStatViews,
                          value: homeData.cvStats.views,
                          change: homeData.cvStats.viewsChange,
                        ),
                        IthakiStatRowData(
                          icon: const IthakiIcon(
                            'envelope',
                            size: 18,
                            color: IthakiTheme.primaryPurple,
                          ),
                          label: l10n.homeStatInvitations,
                          value: homeData.cvStats.invitations,
                          change: homeData.cvStats.invitationsChange,
                        ),
                        IthakiStatRowData(
                          icon: const IthakiIcon(
                            'applications',
                            size: 22,
                            color: IthakiTheme.primaryPurple,
                          ),
                          label: l10n.homeStatApplicationsSent,
                          value: homeData.cvStats.applicationsSent,
                        ),
                        IthakiStatRowData(
                          icon: const IthakiIcon(
                            'rocket',
                            size: 22,
                            color: IthakiTheme.primaryPurple,
                          ),
                          label: l10n.homeStatInterviews,
                          value: homeData.cvStats.interviews,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  IthakiCard(
                    key: tourKeys[12],
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HomeCoursesSection(),
                  ),
                  const SizedBox(height: 12),
                  IthakiCard(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HomeNewsSection(),
                  ),
                  const SizedBox(height: 12),
                  IthakiCard(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: const HomeQuestionsSection(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
                ],
              ),
            ),
          ),
        );
  }
}

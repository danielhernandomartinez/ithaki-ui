import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../constants/nav_items.dart';
import '../../l10n/app_localizations.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/cv_provider.dart';
import '../../providers/profile_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import 'widgets/cv_assistant_card.dart';
import 'widgets/cv_data.dart';
import 'widgets/cv_floating_shelf.dart';
import 'widgets/cv_overlays.dart';
import 'widgets/cv_scroll_body.dart';

class MyCvScreen extends ConsumerStatefulWidget {
  const MyCvScreen({super.key});

  @override
  ConsumerState<MyCvScreen> createState() => _MyCvScreenState();
}

class _MyCvScreenState extends ConsumerState<MyCvScreen>
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

  Future<bool> _handleBack(bool isPublished) async {
    if (isPublished) return true;
    _showLeaveWithoutPublishingSheet();
    return false;
  }

  void _showLeaveWithoutPublishingSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => LeaveWithoutPublishingSheet(
        onLeaveWithoutSaving: () {
          Navigator.of(sheetContext).pop();
          if (mounted) context.pop();
        },
        onSaveAndLeave: () {
          Navigator.of(sheetContext).pop();
          if (mounted) context.pop();
        },
      ),
    );
  }

  void _showCareerAssistantSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => const CareerAssistantSheet(),
    );
  }

  Widget _buildLoadingScaffold() => const Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        body: Center(child: CircularProgressIndicator()),
      );

  Widget _buildErrorScaffold(AppLocalizations l) {
    return Scaffold(
      backgroundColor: IthakiTheme.backgroundViolet,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const IthakiIcon(
                'profile',
                size: 40,
                color: IthakiTheme.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                l.cvCouldNotLoadTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: IthakiTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l.cvCouldNotLoadMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 20),
              IthakiButton(
                l.tryAgain,
                onPressed: () => ref.invalidate(profileBasicsProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPanelOverlays(double topOffset) => [
        if (_panels.profileOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _panels.closeProfile,
              child: const ColoredBox(color: Colors.transparent),
            ),
          ),
        if (_panels.profileOpen ||
            _panels.profileCtrl.status != AnimationStatus.dismissed)
          Positioned(
            top: topOffset - 14,
            left: 16,
            right: 16,
            bottom: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SlideTransition(
                position: _panels.profileSlideAnim,
                child: ProfileMenuPanel(
                  onItemTap: (item) {
                    _panels.closeProfile();
                    navigateToProfileMenuRoute(context, item);
                  },
                  onLogOut: () {
                    _panels.closeProfile();
                    final router = GoRouter.of(context);
                    ref
                        .read(authRepositoryProvider)
                        .logout()
                        .whenComplete(() {
                      resetProfileProviders(ref);
                      if (mounted) router.go(Routes.root);
                    });
                  },
                ),
              ),
            ),
          ),
        if (_panels.menuOpen ||
            _panels.menuCtrl.status != AnimationStatus.dismissed)
          Positioned(
            top: topOffset - 14,
            left: 16,
            right: 16,
            bottom: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: SlideTransition(
                position: _panels.slideAnim,
                child: AppNavDrawer(
                  currentRoute: Routes.cv,
                  profileProgress: ref.watch(profileCompletionProvider),
                  items: buildNavItems(AppLocalizations.of(context)!),
                  onItemTap: (item) {
                    _panels.closeMenu();
                    context.go(item.route);
                  },
                ),
              ),
            ),
          ),
      ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final basicsAsync = ref.watch(profileBasicsProvider);
    final basics = basicsAsync.value;
    final aboutMe = ref.watch(profileAboutMeProvider).value;
    final profileSkills = ref.watch(profileSkillsProvider).value;
    final workExperiences = ref.watch(profileWorkExperiencesProvider).value;
    final educations = ref.watch(profileEducationsProvider).value;
    final files = ref.watch(profileFilesProvider).value;
    final jobPreferences = ref.watch(profileJobPreferencesProvider).value;
    final assessments = ref.watch(assessmentsListProvider).value;
    final isPublished = ref.watch(cvPublishedProvider);

    if (basicsAsync.isLoading && basics == null) return _buildLoadingScaffold();
    if (basicsAsync.hasError && basics == null) return _buildErrorScaffold(l);

    final cvData = MyCvData.fromSources(
      basics: basics ?? const ProfileBasics(),
      aboutMe: aboutMe ?? const ProfileAboutMe(),
      skills: profileSkills ?? const ProfileSkills(),
      workExperiences: workExperiences ?? const <WorkExperience>[],
      educations: educations ?? const <Education>[],
      files: files ?? const <UploadedFile>[],
      jobPreferences: jobPreferences ?? const ProfileJobPreferences(),
      assessments: assessments ?? const <Assessment>[],
    );
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    return PopScope(
      canPop: isPublished,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !isPublished) _showLeaveWithoutPublishingSheet();
      },
      child: Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        extendBodyBehindAppBar: true,
        appBar: IthakiAppBar(
          showMenuAndAvatar: true,
          showBackButton: true,
          title: l.appBarTitleIthaki,
          menuOpen: false,
          profileOpen: _panels.profileOpen,
          avatarInitials: cvData.avatarInitials,
          avatarUrl: basicsAsync.value?.photoUrl,
          onNotificationsPressed: () =>
              context.push(Routes.settingsNotifications),
          onMenuPressed: () async {
            final shouldPop = await _handleBack(isPublished);
            if (shouldPop && context.mounted) context.pop();
          },
          onAvatarPressed: _panels.toggleProfile,
        ),
        body: Stack(
          children: [
            CvScrollBody(
              cvData: cvData,
              isPublished: isPublished,
              topOffset: topOffset,
              onAskCareerAssistant: _showCareerAssistantSheet,
            ),
            CvFloatingShelf(isPublished: isPublished),
            ..._buildPanelOverlays(topOffset),
          ],
        ),
      ),
    );
  }
}

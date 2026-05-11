import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/cv_provider.dart';
import '../../providers/profile_provider.dart';
import '../../routes.dart';
import '../../utils/ithaki_bottom_sheet.dart';
import '../../widgets/main_panel_scaffold.dart';
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

class _MyCvScreenState extends ConsumerState<MyCvScreen> {
  Future<bool> _handleBack(bool isPublished) async {
    if (isPublished) return true;
    _showLeaveWithoutPublishingSheet();
    return false;
  }

  void _showLeaveWithoutPublishingSheet() {
    showIthakiBottomSheet<void>(
      context: context,
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
    showIthakiBottomSheet<void>(
      context: context,
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

    return PopScope(
      canPop: isPublished,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !isPublished) _showLeaveWithoutPublishingSheet();
      },
      child: MainPanelScaffold(
        currentRoute: Routes.cv,
        enableNavDrawer: false,
        showBackButton: true,
        title: l.appBarTitleIthaki,
        avatarInitials: cvData.avatarInitials,
        avatarUrl: basicsAsync.value?.photoUrl,
        onMenuPressed: () {
          _handleBack(isPublished).then((shouldPop) {
            if (shouldPop && context.mounted) context.pop();
          });
        },
        bodyBuilder: (context, ref, topOffset) => CvScrollBody(
          cvData: cvData,
          isPublished: isPublished,
          topOffset: topOffset,
          onAskCareerAssistant: _showCareerAssistantSheet,
        ),
        overlayBuilder: (context, ref, topOffset) => [
          CvFloatingShelf(isPublished: isPublished),
        ],
      ),
    );
  }
}

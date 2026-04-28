import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../constants/nav_items.dart';
import '../../mixins/panel_menu_mixin.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/cv_provider.dart';
import '../../providers/profile_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../routes.dart';
import '../../widgets/app_nav_drawer.dart';
import '../../widgets/profile_menu_panel.dart';
import 'widgets/my_cv_sections.dart';

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
    if (isPublished) {
      return true;
    }

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
          if (mounted) {
            context.pop();
          }
        },
        onSaveAndLeave: () {
          Navigator.of(sheetContext).pop();
          if (mounted) {
            context.pop();
          }
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

  @override
  Widget build(BuildContext context) {
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
    final topOffset = MediaQuery.paddingOf(context).top + kToolbarHeight + 16;

    if (basicsAsync.isLoading && basics == null) {
      return const Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (basicsAsync.hasError && basics == null) {
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
                const Text(
                  "Couldn't load your CV.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try refreshing your profile data and open it again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: IthakiTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                IthakiButton(
                  'Retry',
                  onPressed: () => ref.invalidate(profileBasicsProvider),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
        if (!didPop && !isPublished) {
          _showLeaveWithoutPublishingSheet();
        }
      },
      child: Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        extendBodyBehindAppBar: true,
        appBar: IthakiAppBar(
          showMenuAndAvatar: true,
          showBackButton: true,
          title: 'Ithaki',
          menuOpen: false,
          profileOpen: _panels.profileOpen,
          avatarInitials: cvData.avatarInitials,
          avatarUrl: basicsAsync.value?.photoUrl,
          onMenuPressed: () async {
            final shouldPop = await _handleBack(isPublished);
            if (shouldPop && context.mounted) {
              context.pop();
            }
          },
          onAvatarPressed: _panels.toggleProfile,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16,
                topOffset + 8,
                16,
                MediaQuery.viewPaddingOf(context).bottom + 148,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isPublished) ...[
                    const DraftReviewBanner(),
                    const SizedBox(height: 12),
                  ] else ...[
                    CvAssistantCard(onAskPressed: _showCareerAssistantSheet),
                    const SizedBox(height: 12),
                  ],
                  CvHeaderCard(
                    data: cvData,
                    isPublished: isPublished,
                    onLearnMorePressed: _showCareerAssistantSheet,
                    onPublishPressed: () => ref
                        .read(cvPublishedProvider.notifier)
                        .setPublished(true),
                    onReturnToProfilePressed: () =>
                        context.push(Routes.profile),
                  ),
                  const SizedBox(height: 12),
                  CvSectionCard(
                    title: 'About Me',
                    actionLabel: isPublished ? null : 'Edit About Me',
                    onActionPressed: isPublished
                        ? null
                        : () => context.push(Routes.profileAboutMe),
                    child: Text(
                      cvData.aboutMe,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CvSectionCard(
                    title: 'Skills',
                    actionLabel: isPublished ? null : 'Edit Skills',
                    onActionPressed: isPublished
                        ? null
                        : () => context.push(Routes.profileSkills),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: cvData.skills
                          .map((skill) => CvSkillChip(label: skill))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CvSectionCard(
                    title: 'Competencies',
                    actionLabel: isPublished ? null : 'Edit Competencies',
                    onActionPressed: isPublished
                        ? null
                        : () => context.push(Routes.profileCompetencies),
                    child: Column(
                      children: cvData.competencies.entries
                          .map((entry) => CvKeyValueRow(
                                label: entry.key,
                                value: entry.value,
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CvSectionCard(
                    title: 'Work Experience',
                    actionLabel: isPublished ? null : 'Add Work Experience',
                    onActionPressed: isPublished
                        ? null
                        : () => context.push(Routes.profileWorkExperience),
                    child: Column(
                      children: [
                        ...cvData.workExperiences.map(
                          (experience) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CvExperienceCard(
                              experience: experience,
                              showEditButton: !isPublished,
                              onEditPressed: () =>
                                  context.push(Routes.profileWorkExperience),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  CvSectionCard(
                    title: 'Education',
                    actionLabel: isPublished ? null : 'Add Education',
                    onActionPressed: isPublished
                        ? null
                        : () => context.push(Routes.profileEducation),
                    child: Column(
                      children: cvData.educations.map((education) {
                        return CvEducationCard(
                          education: education,
                          showEditButton: !isPublished,
                          onEditPressed: () =>
                              context.push(Routes.profileEducation),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CvSectionCard(
                    title: 'Languages',
                    actionLabel: isPublished ? null : 'Edit Languages',
                    onActionPressed: isPublished
                        ? null
                        : () => context.push(Routes.profileLanguages),
                    child: Column(
                      children: cvData.languages
                          .map((language) => CvLanguageRow(language: language))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CvSectionCard(
                    title: 'My Files',
                    child: Column(
                      children: cvData.files
                          .map(
                            (file) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CvFileCard(
                                file: file,
                                isPublished: isPublished,
                                onDelete: isPublished
                                    ? null
                                    : () {
                                        final current = ref
                                                .read(profileFilesProvider)
                                                .value ??
                                            const <UploadedFile>[];
                                        final index = current.indexWhere(
                                          (currentFile) =>
                                              currentFile.name == file.name,
                                        );
                                        if (index != -1) {
                                          ref
                                              .read(
                                                  profileFilesProvider.notifier)
                                              .delete(index);
                                        }
                                      },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  if (!isPublished) ...[
                    const SizedBox(height: 12),
                    CvAssistantCard(onAskPressed: _showCareerAssistantSheet),
                  ],
                  if (isPublished && cvData.assessmentCards.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    CvSectionCard(
                      title: 'Assessments results',
                      child: Column(
                        children: cvData.assessmentCards.map((assessment) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CvAssessmentCard(
                              assessment: assessment,
                              onToggle: () => ref
                                  .read(assessmentResultProvider(assessment.id)
                                      .notifier)
                                  .toggleCV(
                                    show: !(assessment.lastResult?.shownInCV ??
                                        false),
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.viewPaddingOf(context).bottom + 16,
              child: FloatingActionShelf(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: isPublished
                          ? IthakiOutlineButton(
                              'Go to Profile',
                              onPressed: () => context.push(Routes.profile),
                              borderRadius: 24,
                            )
                          : IthakiButton(
                              'Publish CV',
                              onPressed: () => ref
                                  .read(cvPublishedProvider.notifier)
                                  .setPublished(true),
                            ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: isPublished
                          ? IthakiOutlineButton(
                              'Download CV',
                              icon: const IthakiIcon('resume', size: 18),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'CV download will be available soon.'),
                                  ),
                                );
                              },
                              borderRadius: 24,
                            )
                          : IthakiOutlineButton(
                              'Return to Profile Setup',
                              icon: const IthakiIcon('edit-pencil', size: 18),
                              onPressed: () => context.push(Routes.profile),
                              borderRadius: 24,
                            ),
                    ),
                  ],
                ),
              ),
            ),
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
                      items: kAppNavItems,
                      onItemTap: (item) {
                        _panels.closeMenu();
                        context.go(item.route);
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

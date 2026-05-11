import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../providers/tour_provider.dart';
import '../../routes.dart';
import '../../widgets/main_panel_scaffold.dart';
import '../../widgets/profile_header_card.dart';
import '../../widgets/profile_tab_bar.dart';
import 'tabs/profile_about_me_tab.dart';
import 'tabs/profile_education_tab.dart';
import 'tabs/profile_files_tab.dart';
import 'tabs/profile_job_preferences_tab.dart';
import 'tabs/profile_skills_tab.dart';
import 'tabs/profile_values_tab.dart';
import 'tabs/profile_work_experience_tab.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _tabIndex = 0;

  List<String> _buildTabs(AppLocalizations l) => [
        l.profileTabJobPreferences,
        l.profileTabAboutMe,
        l.profileTabSkills,
        l.profileTabWorkExperience,
        l.profileTabEducation,
        l.profileTabFiles,
        l.profileTabValues,
      ];

  Widget _buildTabContent() {
    switch (_tabIndex) {
      case 0:
        return const ProfileJobPreferencesTab();
      case 1:
        return const ProfileAboutMeTab();
      case 2:
        return const ProfileSkillsTab();
      case 3:
        return const ProfileWorkExperienceTab();
      case 4:
        return const ProfileEducationTab();
      case 5:
        return const ProfileFilesTab();
      case 6:
        return const ProfileValuesTab();
      default:
        return const SizedBox.shrink();
    }
  }

  ButtonStyle _profileActionButtonStyle() {
    return OutlinedButton.styleFrom(
      side: BorderSide(color: Colors.grey.shade300),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      foregroundColor: IthakiTheme.textPrimary,
    );
  }

  Widget _profileActionButton({
    required String label,
    required String icon,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: IthakiIcon(icon, size: 16),
      label: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
      style: _profileActionButtonStyle(),
    );
  }

  Widget _buildProfileActions(AppLocalizations l) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final openCvButton = _profileActionButton(
          label: l.openCv,
          icon: 'resume',
          onPressed: () => context.push(Routes.cv),
        );
        final settingsButton = _profileActionButton(
          label: l.accountSettings,
          icon: 'settings',
          onPressed: () => context.push(Routes.settings),
        );

        if (constraints.maxWidth < 460) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              openCvButton,
              const SizedBox(height: 8),
              settingsButton,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: openCvButton),
            const SizedBox(width: 8),
            Expanded(child: settingsButton),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final basicsAsync = ref.watch(profileBasicsProvider);
    if (basicsAsync.isLoading) {
      return const Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (basicsAsync.hasError) {
      return Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 48,
                  color: IthakiTheme.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  l.profileLoadError,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: IthakiTheme.textSecondary),
                ),
                const SizedBox(height: 24),
                IthakiButton(
                  l.retryButton,
                  onPressed: () => ref.invalidate(profileBasicsProvider),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final basics = basicsAsync.requireValue;
    final tourState = ref.watch(tourProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
    final tourKeys = ref.watch(tourKeysProvider);
    final isPartial = ref.watch(profilePartialLoadProvider);

    return MainPanelScaffold(
      currentRoute: Routes.profile,
      avatarInitials: basics.initials,
      avatarUrl: basics.photoUrl,
      bodyBuilder: (context, ref, topOffset) => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: topOffset - 14),
            if (isPartial)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.amber.shade800,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l.profilePartialLoadWarning,
                        style: TextStyle(
                          color: Colors.amber.shade900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            KeyedSubtree(
              key: tourState?.currentStep == 10 ? tourKeys[10] : null,
              child: ProfileHeaderCard(basics: basics),
            ),
            const SizedBox(height: 12),
            ProfileTabBar(
              tabs: _buildTabs(l),
              selectedIndex: _tabIndex,
              onTabSelected: (i) => setState(() => _tabIndex = i),
            ),
            const SizedBox(height: 12),
            _buildTabContent(),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: IthakiTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _buildProfileActions(l),
            ),
            SizedBox(height: MediaQuery.viewPaddingOf(context).bottom + 32),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/profile_provider.dart';
import '../../providers/tour_provider.dart';
import '../../routes.dart';
import '../../utils/coming_soon.dart';
import '../../widgets/main_panel_scaffold.dart';
import '../../widgets/responsive_gradient_banner.dart';
import 'widgets/job_search_list.dart';
import 'widgets/job_search_search_bar.dart';
import 'widgets/job_search_tab_bar.dart';

class JobSearchScreen extends ConsumerWidget {
  const JobSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tourKeys = ref.watch(tourKeysProvider);
    final basics = ref.watch(profileBasicsProvider).value;

    return MainPanelScaffold(
      currentRoute: Routes.jobSearch,
      avatarInitials: basics?.initials ?? '',
      avatarUrl: basics?.photoUrl,
      bodyBuilder: (context, ref, topOffset) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: topOffset + 12),
            const JobSearchTabBar(),
            const SizedBox(height: 12),
            KeyedSubtree(
              key: tourKeys[2],
              child: const JobSearchSearchBar(),
            ),
            const SizedBox(height: 12),
            const JobSearchList(),
            const SizedBox(height: 16),
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
                onButtonPressed: () => showComingSoonSnackBar(context),
                backgroundImage: const DecorationImage(
                  image: AssetImage('assets/images/ai_banner_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
          ],
        ),
      ),
    );
  }
}

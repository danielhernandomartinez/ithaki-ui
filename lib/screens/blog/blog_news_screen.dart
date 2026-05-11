import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/blog_provider.dart';
import '../../providers/profile_provider.dart';
import '../../routes.dart';
import '../../widgets/main_panel_scaffold.dart';
import 'widgets/blog_article_card.dart';
import 'widgets/blog_category_chips.dart';
import 'widgets/blog_pagination.dart';
import 'widgets/blog_search_bar.dart';

class BlogNewsScreen extends ConsumerWidget {
  const BlogNewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final articles = ref.watch(blogProvider).paginated;
    final basics = ref.watch(profileBasicsProvider).value;

    return MainPanelScaffold(
      currentRoute: Routes.blogNews,
      avatarInitials: basics?.initials ?? '',
      avatarUrl: basics?.photoUrl,
      bodyBuilder: (context, ref, topOffset) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: topOffset + 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.blogNewsTitle, style: IthakiTheme.headingLarge),
                  const SizedBox(height: 4),
                  Text(
                    l10n.blogNewsSubtitle,
                    style: IthakiTheme.captionRegular,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const BlogSearchBar(),
            const SizedBox(height: 12),
            const BlogCategoryChips(),
            const SizedBox(height: 16),
            for (final article in articles) ...[
              BlogArticleCard(article: article),
              const SizedBox(height: 12),
            ],
            const BlogPagination(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IthakiGradientBanner(
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
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
          ],
        ),
      ),
    );
  }
}

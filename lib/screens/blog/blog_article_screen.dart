import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../l10n/app_localizations.dart';
import '../../models/blog_models.dart';
import '../../providers/blog_provider.dart';
import '../../providers/profile_provider.dart';
import '../../routes.dart';
import '../../widgets/main_panel_scaffold.dart';
import 'widgets/blog_article_related.dart';
import 'widgets/blog_article_share_row.dart';

class BlogArticleScreen extends ConsumerWidget {
  final String articleId;

  const BlogArticleScreen({super.key, required this.articleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final basics = ref.watch(profileBasicsProvider).value;
    final article = ref
        .watch(blogProvider)
        .articles
        .where((a) => a.id == articleId)
        .firstOrNull;

    if (article == null) {
      return Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        appBar: IthakiAppBar(showBackButton: true, title: l10n.blogNewsTitle),
        body: Center(
          child: Text(
            l10n.blogArticleNotFound,
            style: const TextStyle(color: IthakiTheme.textPrimary),
          ),
        ),
      );
    }

    return MainPanelScaffold(
      currentRoute: Routes.blogNews,
      avatarInitials: basics?.initials ?? '',
      avatarUrl: basics?.photoUrl,
      bodyBuilder: (context, ref, topOffset) =>
          _ArticleBody(article: article, topOffset: topOffset),
    );
  }
}

class _ArticleBody extends StatelessWidget {
  const _ArticleBody({required this.article, required this.topOffset});

  final BlogArticle article;
  final double topOffset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topOffset - 16),
          Image.asset(
            article.imageAsset,
            height: 260,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(Routes.blogNews);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const IthakiIcon(
                        'arrow-left',
                        size: 16,
                        color: IthakiTheme.primaryPurple,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.backButton,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: IthakiTheme.primaryPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                IthakiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: IthakiTheme.primaryPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(article.title, style: IthakiTheme.headingLarge),
                      const SizedBox(height: 8),
                      Text(
                        article.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: IthakiTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            l10n.blogArticleBy(article.author),
                            style: const TextStyle(
                              fontSize: 12,
                              color: IthakiTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '·',
                            style: TextStyle(color: IthakiTheme.textSecondary),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            article.readTime,
                            style: const TextStyle(
                              fontSize: 12,
                              color: IthakiTheme.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            article.date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: IthakiTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                IthakiCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final section in article.body) ...[
                        if (section.heading != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            section.heading!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: IthakiTheme.textPrimary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        for (final para in section.paragraphs) ...[
                          Text(
                            para,
                            style: const TextStyle(
                              fontSize: 14,
                              color: IthakiTheme.textPrimary,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (article.tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: article.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: IthakiTheme.backgroundWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: IthakiTheme.borderLight),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            fontSize: 13,
                            color: IthakiTheme.textSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 16),
                const BlogArticleShareRow(),
                const SizedBox(height: 24),
                BlogRelatedSection(currentArticleId: article.id),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: IthakiOutlineButton(
                    l10n.blogDiscoverAll,
                    onPressed: () => context.go(Routes.blogNews),
                  ),
                ),
                SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../models/blog_models.dart';
import '../../../providers/blog_provider.dart';
import '../../../routes.dart';
import '../../../l10n/app_localizations.dart';

/// Compact card used in the "Related Articles" section.
class BlogRelatedCard extends StatelessWidget {
  final BlogArticle article;

  const BlogRelatedCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.blogArticleFor(article.id)),
      child: Container(
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: IthakiTheme.borderLight),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: Image.asset(
                article.imageAsset,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: IthakiTheme.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: IthakiTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

/// The full "Related Articles" section with header + list.
class BlogRelatedSection extends ConsumerWidget {
  final String currentArticleId;

  const BlogRelatedSection({super.key, required this.currentArticleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final related = ref
        .watch(blogProvider)
        .articles
        .where((a) => a.id != currentArticleId)
        .take(4)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.blogRelatedArticles, style: IthakiTheme.headingMedium),
        const SizedBox(height: 12),
        for (final a in related) ...[
          BlogRelatedCard(article: a),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

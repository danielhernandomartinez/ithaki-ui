import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../models/blog_models.dart';
import '../../../routes.dart';

class BlogArticleCard extends StatelessWidget {
  final BlogArticle article;

  const BlogArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.blogArticleFor(article.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: IthakiCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(
                article.imageAsset,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category label
                  Text(
                    article.category,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: IthakiTheme.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Title
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: IthakiTheme.headingMedium,
                  ),
                  const SizedBox(height: 6),
                  // Description
                  Text(
                    article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: IthakiTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Author + date row
                  Row(
                    children: [
                      Text(
                        article.author,
                        style: const TextStyle(
                          fontSize: 12,
                          color: IthakiTheme.textSecondary,
                          fontWeight: FontWeight.w500,
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
          ],
        ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../../routes.dart';
import '../models/chat_message.dart';

class ArticleCard extends StatelessWidget {
  final ArticleData card;
  const ArticleCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: IthakiTheme.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IthakiTheme.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.title,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: IthakiTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  card.excerpt,
                  style: const TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 13,
                    color: IthakiTheme.softGraphite,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'by ${card.author}',
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                    Text(
                      card.time,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans',
                        fontSize: 12,
                        color: IthakiTheme.softGraphite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: IthakiTheme.borderLight),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: SizedBox(
              width: double.infinity,
              child: IthakiButton(
                'Read Article',
                onPressed: () => context.push(Routes.blogArticleFor('article_1')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

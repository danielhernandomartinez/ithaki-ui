import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/blog_provider.dart';
import '../../../l10n/app_localizations.dart';

class BlogCategoryChips extends ConsumerWidget {
  const BlogCategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final activeCategory = ref.watch(blogProvider).activeCategory;

    final allLabel = l10n.blogAllCategories;
    final chips = [null, ...kBlogCategories]; // null = "All"

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = chips[i];
          final label = cat ?? allLabel;
          final isActive = cat == activeCategory;
          return GestureDetector(
            onTap: () =>
                ref.read(blogProvider.notifier).setCategory(cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? IthakiTheme.chipActive
                    : IthakiTheme.backgroundWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? IthakiTheme.primaryPurple
                      : IthakiTheme.borderLight,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? IthakiTheme.primaryPurple
                      : IthakiTheme.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

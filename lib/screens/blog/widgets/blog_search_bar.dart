import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/blog_provider.dart';
import '../../../l10n/app_localizations.dart';

class BlogSearchBar extends ConsumerWidget {
  const BlogSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: IthakiTheme.backgroundWhite,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: TextField(
          onChanged: (q) => ref.read(blogProvider.notifier).setSearch(q),
          decoration: InputDecoration(
            hintText: l10n.blogSearchHint,
            hintStyle: const TextStyle(color: IthakiTheme.softGraphite),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(12),
              child: IthakiIcon('search', size: 20, color: IthakiTheme.lightGraphite),
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}

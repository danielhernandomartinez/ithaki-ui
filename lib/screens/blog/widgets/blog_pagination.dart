import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/blog_provider.dart';

class BlogPagination extends ConsumerWidget {
  const BlogPagination({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(blogProvider);
    final total = state.totalPages;
    final current = state.currentPage;

    if (total <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: List.generate(total, (i) {
            final page = i + 1;
            final isActive = page == current;
            return GestureDetector(
              onTap: () => ref.read(blogProvider.notifier).setPage(page),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActive
                      ? IthakiTheme.primaryPurple
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$page',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                    color: isActive
                        ? IthakiTheme.backgroundWhite
                        : IthakiTheme.textSecondary,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

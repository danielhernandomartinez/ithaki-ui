import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/job_search_provider.dart';

class JobSearchTabBar extends ConsumerWidget {
  const JobSearchTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(jobSearchProvider).value?.selectedTab ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFE9DEFF),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _TabItem(label: 'All Jobs', index: 0, selectedTab: selectedTab),
            const SizedBox(width: 4),
            _TabItem(
              label: 'Saved (${ref.watch(jobSearchProvider).value?.savedCount ?? 0})',
              index: 1,
              selectedTab: selectedTab,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends ConsumerWidget {
  final String label;
  final int index;
  final int selectedTab;

  const _TabItem({
    required this.label,
    required this.index,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(jobSearchProvider.notifier).selectTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : const Color(0x00FFFFFF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? IthakiTheme.textPrimary
                  : IthakiTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

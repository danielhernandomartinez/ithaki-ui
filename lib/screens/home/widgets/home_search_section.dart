import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../repositories/home_repository.dart';

class HomeSearchSection extends ConsumerWidget {
  const HomeSearchSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeRepo = ref.watch(homeRepositoryProvider);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: IthakiTheme.borderLight),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search by job title',
              hintStyle: TextStyle(color: IthakiTheme.softGraphite),
              prefixIcon: Padding(
                padding: EdgeInsets.all(12),
                child: IthakiIcon('search', size: 20, color: IthakiTheme.softGraphite),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: homeRepo.filterChips
              .map((label) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: IthakiTheme.borderLight),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        color: IthakiTheme.textPrimary,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

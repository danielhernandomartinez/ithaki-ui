import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';
import '../../../widgets/profile_empty_state_card.dart';
import '../../../widgets/work_experience_card.dart';

class ProfileWorkExperienceTab extends ConsumerWidget {
  const ProfileWorkExperienceTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiences = ref.watch(profileWorkExperiencesProvider).value ?? const [];
    if (experiences.isEmpty) {
      return ProfileEmptyStateCard(
        title: 'Work Experience',
        description: 'Add details about your previous roles and companies',
        buttonLabel: 'Add Work Experience',
        buttonIcon: const IthakiIcon('plus', size: 16),
        onPressed: () => context.push(Routes.profileWorkExperience),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...experiences.asMap().entries.map((entry) =>
            WorkExperienceCard(
              exp: entry.value,
              index: entry.key,
              onEditTap: () => context.push(
                Routes.profileWorkExperienceEdit,
                extra: WorkExperienceEditExtra(
                        index: entry.key, exp: entry.value)
                    .toMap(),
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IthakiOutlineButton(
            'Add Work Experience',
            icon: const IthakiIcon('plus', size: 16),
            onPressed: () => context.push(Routes.profileWorkExperience),
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

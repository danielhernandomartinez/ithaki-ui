import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';
import '../../../widgets/profile_empty_state_card.dart';

class ProfileEducationTab extends ConsumerWidget {
  const ProfileEducationTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final educations = ref.watch(profileEducationsProvider);
    if (educations.isEmpty) {
      return ProfileEmptyStateCard(
        title: 'Education',
        description:
            'Add information about your educational background, degree, and field of study.',
        buttonLabel: 'Add Education',
        buttonIcon: const IthakiIcon('plus', size: 16),
        onPressed: () => context.push(Routes.profileEducation),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...educations.asMap().entries.map((entry) {
          final edu = entry.value;
          final endLabel =
              edu.currentlyStudyHere ? 'Present' : (edu.endDate ?? '');
          return Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(edu.institutionName,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: IthakiTheme.textPrimary)),
              const SizedBox(height: 2),
              Text('${edu.degreeType} – ${edu.fieldOfStudy}',
                  style: const TextStyle(
                      fontSize: 13, color: IthakiTheme.textSecondary)),
              const SizedBox(height: 2),
              Text('${edu.startDate} – $endLabel',
                  style: const TextStyle(
                      fontSize: 12, color: IthakiTheme.softGraphite)),
              const SizedBox(height: 12),
              IthakiOutlineButton(
                'Edit',
                icon: const IthakiIcon('edit-pencil', size: 16),
                onPressed: () => context.push(Routes.profileEducation),
                borderRadius: 20,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ]),
          );
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IthakiOutlineButton(
            'Add Education',
            icon: const IthakiIcon('plus', size: 16),
            onPressed: () => context.push(Routes.profileEducation),
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}

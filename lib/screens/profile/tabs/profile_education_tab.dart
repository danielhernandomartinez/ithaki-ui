import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';

class ProfileEducationTab extends StatelessWidget {
  final ProfileState profile;
  const ProfileEducationTab({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile.educations.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Education',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text(
            'Add information about your educational background, degree, and field of study.',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiOutlineButton(
            'Add Education',
            icon: const IthakiIcon('plus', size: 16),
            onPressed: () => context.push(Routes.profileEducation),
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ]),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...profile.educations.asMap().entries.map((entry) {
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

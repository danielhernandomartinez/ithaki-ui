import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/profile_provider.dart';
import '../../../routes.dart';
import '../../../widgets/profile_meta_cell.dart';

class ProfileWorkExperienceTab extends StatelessWidget {
  final ProfileState profile;
  const ProfileWorkExperienceTab({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile.workExperiences.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Work Experience',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: IthakiTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text(
            'Add details about your previous roles and companies',
            style: TextStyle(fontSize: 14, color: IthakiTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          IthakiOutlineButton(
            'Add Work Experience',
            icon: const IthakiIcon('plus', size: 16),
            onPressed: () => context.push(Routes.profileWorkExperience),
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ]),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...profile.workExperiences.asMap().entries.map((entry) {
          final index = entry.key;
          final exp = entry.value;
          final endLabel = exp.currentlyWorkHere ? 'Present' : (exp.endDate ?? '');
          final duration = exp.duration;
          return Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: IthakiTheme.textPrimary),
                      children: [
                        TextSpan(text: exp.jobTitle),
                        const TextSpan(
                            text: '  at  ',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: IthakiTheme.textSecondary)),
                        TextSpan(text: exp.companyName),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => context.push(Routes.profileWorkExperienceEdit,
                      extra: WorkExperienceEditExtra(index: index, exp: exp).toMap()),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: IthakiTheme.borderLight),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const IthakiIcon('edit-pencil',
                        size: 16, color: IthakiTheme.textSecondary),
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              Text(
                '${exp.startDate} - $endLabel${duration.isNotEmpty ? ' ($duration)' : ''}',
                style: const TextStyle(
                    fontSize: 13, color: IthakiTheme.textSecondary),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 10),
              Row(children: [
                if (exp.location.isNotEmpty)
                  Expanded(child: ProfileMetaCell(Icons.location_on_outlined, exp.location, flexible: true, fontSize: 13)),
                if (exp.workplace.isNotEmpty)
                  Expanded(child: ProfileMetaCell(Icons.business_outlined, exp.workplace, flexible: true, fontSize: 13)),
              ]),
              if (exp.jobType.isNotEmpty || exp.experienceLevel.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(children: [
                  if (exp.jobType.isNotEmpty)
                    Expanded(child: ProfileMetaCell(Icons.access_time_outlined, exp.jobType, flexible: true, fontSize: 13)),
                  if (exp.experienceLevel.isNotEmpty)
                    Expanded(child: ProfileMetaCell(Icons.bar_chart_outlined, exp.experienceLevel, flexible: true, fontSize: 13)),
                ]),
              ],
              if (exp.summary != null && exp.summary!.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 10),
                Text(exp.summary!,
                    style: const TextStyle(
                        fontSize: 13,
                        color: IthakiTheme.textPrimary,
                        height: 1.5)),
              ],
            ]),
          );
        }),
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

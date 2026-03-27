import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../repositories/home_repository.dart';
import 'home_purple_button.dart';

class HomeJobsSection extends ConsumerWidget {
  const HomeJobsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeRepo = ref.watch(homeRepositoryProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Smart Job Recommendations', style: IthakiTheme.headingMedium),
        const SizedBox(height: 12),
        ...homeRepo.jobs.map(
          (job) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: IthakiJobRecommendationCard(
              companyName: job.companyName,
              companyInitials: job.companyInitials,
              companyColor: job.companyColor,
              jobTitle: job.jobTitle,
              salary: job.salary,
              matchPercentage: job.matchPercentage,
              matchLabel: job.matchLabel,
              location: job.location,
              workMode: job.workMode,
              employmentType: job.employmentType,
              level: job.level,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const HomePurpleButton(label: 'View All'),
      ],
    );
  }
}

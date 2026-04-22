import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../providers/home_provider.dart';
import '../../../routes.dart';
import 'home_purple_button.dart';

class HomeCoursesSection extends ConsumerWidget {
  const HomeCoursesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeData = ref.watch(homeProvider).value;
    if (homeData == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recommended Courses', style: IthakiTheme.headingMedium),
        const SizedBox(height: 4),
        Text(
          "Boost your skills with courses that help you grow faster and stay aligned with today's industry standards. Learn at your own pace and strengthen the experience on your profile.",
          style: IthakiTheme.bodyRegular.copyWith(
            color: IthakiTheme.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        ...homeData.courses.map(
          (course) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: IthakiCourseCard(
              title: course.title,
              tags: course.tags,
              description: course.description,
              format: course.format,
              duration: course.duration,
              level: course.level,
            ),
          ),
        ),
        const SizedBox(height: 4),
        HomePurpleButton(
          label: 'View All',
          onPressed: () => context.go(Routes.assessments),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import '../../../data/mock_home_data.dart';
import 'home_purple_button.dart';

class HomeCoursesSection extends StatelessWidget {
  const HomeCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        ...MockHomeData.courses.map(
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
        const HomePurpleButton(label: 'View All'),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.homeRecommendedCourses, style: IthakiTheme.headingMedium),
        const SizedBox(height: 4),
        Text(
          l10n.homeCoursesSubtitle,
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
          label: l10n.viewAll,
          onPressed: () => context.go(Routes.assessments),
        ),
      ],
    );
  }
}

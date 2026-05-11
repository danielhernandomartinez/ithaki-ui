import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../../providers/application_detail_provider.dart';
import '../../providers/home_provider.dart';
import '../../routes.dart';
import '../../widgets/main_panel_scaffold.dart';
import 'widgets/application_detail_company_card.dart';
import 'widgets/application_detail_sticky_bar.dart';
import 'widgets/application_status_card.dart';
import 'widgets/cover_letter_card.dart';
import 'widgets/job_post_basics_card.dart';
import 'widgets/screening_questions_card.dart';
import 'widgets/talent_profile_card.dart';

class ApplicationDetailsScreen extends ConsumerWidget {
  final String applicationId;
  const ApplicationDetailsScreen({super.key, required this.applicationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(applicationDetailProvider(applicationId));
    final homeData = ref.watch(homeProvider).value;

    if (detail == null) {
      return const Scaffold(
        backgroundColor: IthakiTheme.backgroundViolet,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return MainPanelScaffold(
      currentRoute: Routes.myApplications,
      avatarInitials: homeData?.userInitials ?? 'CI',
      avatarUrl: homeData?.userPhotoUrl,
      bodyBuilder: (context, ref, topOffset) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: topOffset),
            _pad(ApplicationStatusCard(detail: detail)),
            _pad(JobPostBasicsCard(detail: detail)),
            _pad(TalentProfileCard(candidate: detail.candidate)),
            _pad(CoverLetterCard(text: detail.coverLetter)),
            _pad(ScreeningQuestionsCard(questions: detail.screeningQuestions)),
            _pad(ApplicationDetailCompanyCard(company: detail.company)),
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 112),
          ],
        ),
      ),
      overlayBuilder: (context, ref, topOffset) => [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            top: false,
            child: ApplicationDetailStickyBar(applicationId: applicationId),
          ),
        ),
      ],
    );
  }
}

Widget _pad(Widget child) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: child,
    );

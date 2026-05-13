import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/models/job_detail_models.dart';
import 'package:ithaki_ui/screens/job_search/widgets/job_detail_body.dart';

void main() {
  testWidgets('job detail deadline uses compact mockup-style date pill',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: JobDetailBody(
            detail: _detail(),
            tourState: null,
            tourKeys: const {},
            isSaved: false,
            hasReminder: false,
            isNotInterested: false,
            announcementDismissed: true,
            onDismissAnnouncement: () {},
            onSave: () {},
            onApply: () {},
            onNotInterested: () {},
            onUndoNotInterested: () {},
            onDeadlineReminder: () {},
            onDeleteReminder: () {},
            onReport: () {},
            onShare: () {},
            onAskCareerAssistant: () {},
          ),
        ),
      ),
    );

    expect(find.text('11 June 2026'), findsOneWidget);
    expect(find.text('Application deadline: 11 June 2026'), findsNothing);
  });
}

JobDetail _detail() => const JobDetail(
      id: 'job-1',
      appliedAt: '',
      statusLabel: '',
      deadline: 'Application deadline: 11 June 2026',
      postedDate: '3 weeks ago',
      jobTitle: 'Construction Worker',
      companyName: 'Quantum Studios',
      companyLogoColor: IthakiTheme.primaryPurple,
      companyLogoInitials: 'QS',
      matchPercentage: 100,
      matchLabel: 'STRONG MATCH',
      location: '',
      jobType: '',
      salaryRange: '',
      workplace: '',
      experienceLevel: '',
      languages: '',
      description: '',
      requirements: [],
      skills: [],
      communication: '',
      niceToHave: '',
      whatWeOffer: '',
      reviews: [],
      recommended: RecommendedJob(
        jobTitle: '',
        companyName: '',
        companyInitials: '',
        companyColor: IthakiTheme.primaryPurple,
        salary: '',
        matchPercentage: 0,
        matchLabel: '',
        location: '',
        employmentType: '',
      ),
      company: JobDetailCompany(
        name: 'Quantum Studios',
        industry: '',
        logoColor: IthakiTheme.primaryPurple,
        logoInitials: 'QS',
        totalReviews: '',
        averageRating: 0,
        description: '',
      ),
      salary: '',
    );

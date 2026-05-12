import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/models/job_search_models.dart';
import 'package:ithaki_ui/repositories/job_search_repository.dart';
import 'package:ithaki_ui/screens/job_search/widgets/job_search_list.dart';

class _JobSearchRepository implements JobSearchRepository {
  @override
  Future<Set<String>> getSavedJobIds() async => {};

  @override
  Future<void> saveJob(String jobId) async {}

  @override
  Future<JobSearchResult> search({
    Map<String, Set<String>> filters = const {},
    String sort = 'Date: Recent',
    int page = 1,
  }) async {
    return JobSearchResult(
      jobs: [
        JobListing(
          id: 'job-$page',
          jobTitle: 'Software Engineer',
          companyName: 'TechWave',
          companyInitials: 'TW',
          companyColor: IthakiTheme.primaryPurple,
          salary: '1,500 \u20ac / month',
          matchPercentage: 90,
          matchLabel: 'STRONG MATCH',
          category: 'IT',
          location: 'Athens',
          workMode: 'Remote',
          employmentType: 'Full-Time',
          level: 'Entry',
        ),
      ],
      totalJobs: 250,
      totalPages: 25,
    );
  }

  @override
  Future<void> unsaveJob(String jobId) async {}
}

Widget _app() {
  return ProviderScope(
    overrides: [
      jobSearchRepositoryProvider.overrideWithValue(_JobSearchRepository()),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('es'),
      home: Scaffold(body: SingleChildScrollView(child: JobSearchList())),
    ),
  );
}

void main() {
  testWidgets('job search pagination announces the current page',
      (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Página 1 de 25'), findsOneWidget);
  });
}

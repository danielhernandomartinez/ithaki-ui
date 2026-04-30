import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/models/employer_dashboard_models.dart';
import 'package:ithaki_ui/screens/employer/dashboard/widgets/job_post_card.dart';
import 'package:ithaki_ui/l10n/app_localizations.dart';

final _mockJob = JobPost(
  id: 'j1',
  title: 'Sales Manager',
  category: 'Retail',
  salary: '1,500 €/month',
  status: JobPostStatus.published,
  views: 10,
  candidates: 2,
  createdAt: DateTime(2025, 10, 1),
);

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('onStatusAction fires with correct action string', (tester) async {
    String? capturedAction;
    await tester.pumpWidget(_wrap(
      JobPostCard(
        jobPost: _mockJob,
        onStatusAction: (action, _) => capturedAction = action,
      ),
    ));
    await tester.tap(find.text('Published'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Boost'));
    await tester.pumpAndSettle();
    expect(capturedAction, 'boost');
  });

  testWidgets('isArchived hides AI Matcher button', (tester) async {
    await tester.pumpWidget(_wrap(
      JobPostCard(
        jobPost: _mockJob.copyWith(status: JobPostStatus.closed),
        isArchived: true,
      ),
    ));
    expect(find.text('AI Matcher'), findsNothing);
    expect(find.text('Details'), findsOneWidget);
  });

  testWidgets('isArchived status chip is not a PopupMenuButton', (tester) async {
    await tester.pumpWidget(_wrap(
      JobPostCard(
        jobPost: _mockJob.copyWith(status: JobPostStatus.closed),
        isArchived: true,
      ),
    ));
    expect(find.byType(PopupMenuButton<String>), findsNothing);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/models/employer_dashboard_models.dart';
import 'package:ithaki_ui/screens/employer/dashboard/widgets/boost_job_post_sheet.dart';
import 'package:ithaki_ui/l10n/app_localizations.dart';

final _job = JobPost(
  id: 'j1', title: 'Truck Driver', category: 'Transport',
  salary: '1,500 €/month', status: JobPostStatus.published,
  views: 0, candidates: 0, createdAt: DateTime(2025),
);

Widget _wrap(Widget w) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: w),
    );

void main() {
  testWidgets('CTA disabled before selection', (tester) async {
    await tester.pumpWidget(_wrap(BoostJobPostSheet(jobPost: _job)));
    final btn = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Change Status'),
    );
    expect(btn.onPressed, isNull);
  });

  testWidgets('CTA enabled after selecting an option', (tester) async {
    await tester.pumpWidget(_wrap(BoostJobPostSheet(jobPost: _job)));
    await tester.tap(find.text('Weekly Boost'));
    await tester.pump();
    final btn = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Change Status'),
    );
    expect(btn.onPressed, isNotNull);
  });

  testWidgets('onConfirm fires when CTA tapped', (tester) async {
    bool confirmed = false;
    await tester.pumpWidget(_wrap(
      BoostJobPostSheet(jobPost: _job, onConfirm: () => confirmed = true),
    ));
    await tester.tap(find.text('Weekly Boost'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Change Status'));
    await tester.pump();
    expect(confirmed, isTrue);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/models/employer_dashboard_models.dart';
import 'package:ithaki_ui/screens/employer/dashboard/widgets/publish_again_sheet.dart';
import 'package:ithaki_ui/l10n/app_localizations.dart';

final _job = JobPost(
  id: 'j1', title: 'Truck Driver', category: 'Transport',
  salary: '1,500 €/month', status: JobPostStatus.closed,
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
    await tester.pumpWidget(_wrap(PublishAgainSheet(jobPost: _job)));
    final btn = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Change Status'),
    );
    expect(btn.onPressed, isNull);
  });

  testWidgets('shows three options', (tester) async {
    await tester.pumpWidget(_wrap(PublishAgainSheet(jobPost: _job)));
    expect(find.text('Publish Again'), findsWidgets);
    expect(find.text('Publish and Weekly Boost'), findsOneWidget);
    expect(find.text('Full-term Boost'), findsOneWidget);
  });

  testWidgets('onConfirm fires after selection', (tester) async {
    bool confirmed = false;
    await tester.pumpWidget(_wrap(
      PublishAgainSheet(jobPost: _job, onConfirm: () => confirmed = true),
    ));
    await tester.tap(find.text('Publish and Weekly Boost'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Change Status'));
    await tester.pump();
    expect(confirmed, isTrue);
  });
}

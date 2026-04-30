import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/models/employer_dashboard_models.dart';
import 'package:ithaki_ui/screens/employer/dashboard/widgets/close_job_sheet.dart';
import 'package:ithaki_ui/l10n/app_localizations.dart';

final _job = JobPost(
  id: 'j1', title: 'Truck Driver', category: 'Transport',
  salary: '1,500 €/month', status: JobPostStatus.boosted,
  views: 0, candidates: 0, createdAt: DateTime(2025),
);

Widget _wrap(Widget w) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: w),
    );

void main() {
  testWidgets('CTA disabled before reason selected', (tester) async {
    await tester.pumpWidget(_wrap(CloseJobSheet(jobPost: _job)));
    final btn = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Change Status'),
    );
    expect(btn.onPressed, isNull);
  });

  testWidgets('onConfirm fires with reason string', (tester) async {
    String? reason;
    await tester.pumpWidget(_wrap(
      CloseJobSheet(jobPost: _job, onConfirm: (r) => reason = r),
    ));
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Position filled').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Change Status'));
    await tester.pump();
    expect(reason, 'Position filled');
  });
}

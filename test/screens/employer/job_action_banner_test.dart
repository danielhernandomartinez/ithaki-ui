import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/screens/employer/dashboard/widgets/job_action_banner.dart';
import 'package:ithaki_ui/l10n/app_localizations.dart';

Widget _wrap(Widget w) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: w),
    );

void main() {
  testWidgets('changesPublished shows correct message', (tester) async {
    await tester.pumpWidget(_wrap(
      JobActionBanner(
        type: JobActionBannerType.changesPublished,
        onDismiss: () {},
      ),
    ));
    expect(
      find.text('The changes to this job post have been successfully saved.'),
      findsOneWidget,
    );
  });

  testWidgets('statusChanged shows correct message', (tester) async {
    await tester.pumpWidget(_wrap(
      JobActionBanner(
        type: JobActionBannerType.statusChanged,
        onDismiss: () {},
      ),
    ));
    expect(
      find.text('The status has been updated successfully.'),
      findsOneWidget,
    );
  });

  testWidgets('onDismiss fires when X tapped', (tester) async {
    bool dismissed = false;
    await tester.pumpWidget(_wrap(
      JobActionBanner(
        type: JobActionBannerType.changesPublished,
        onDismiss: () => dismissed = true,
      ),
    ));
    await tester.tap(find.byType(GestureDetector).last);
    await tester.pump();
    expect(dismissed, isTrue);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/providers/profile_provider.dart';
import 'package:ithaki_ui/screens/settings/tabs/notifications_tab.dart';

class _BasicsNotifier extends ProfileBasicsNotifier {
  @override
  Future<ProfileBasics> build() async => const ProfileBasics(
        firstName: 'Kostas',
        lastName: 'Papadopoulos',
        email: 'kostas@example.com',
        phone: '+30 6961940566',
      );
}

Widget _app() {
  return ProviderScope(
    overrides: [
      profileBasicsProvider.overrideWith(_BasicsNotifier.new),
    ],
    child: MaterialApp(
      theme: IthakiTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
      home: const MediaQuery(
        data: MediaQueryData(
          size: Size(320, 900),
          textScaler: TextScaler.linear(1.1),
        ),
        child: Scaffold(
          backgroundColor: IthakiTheme.backgroundViolet,
          body: SingleChildScrollView(child: NotificationsTab()),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('Spanish notification settings fit on narrow phones',
      (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

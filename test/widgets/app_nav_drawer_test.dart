import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/providers/profile_provider.dart';
import 'package:ithaki_ui/routes.dart';
import 'package:ithaki_ui/screens/profile/profile_screen.dart';
import 'package:ithaki_ui/widgets/app_nav_drawer.dart';

class _BasicsNotifier extends ProfileBasicsNotifier {
  @override
  Future<ProfileBasics> build() async => const ProfileBasics(
        firstName: 'Ana',
        lastName: 'Lopez',
        email: 'ana@example.com',
        phone: '+30 6900000000',
      );
}

class _JobPreferencesNotifier extends ProfileJobPreferencesNotifier {
  @override
  Future<ProfileJobPreferences> build() async => const ProfileJobPreferences();
}

Widget _localizedApp(
  Widget child, {
  Locale locale = const Locale('es'),
}) {
  return ProviderScope(
    child: MaterialApp(
      theme: IthakiTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: Scaffold(body: child),
    ),
  );
}

Widget _profileApp() {
  final router = GoRouter(
    initialLocation: Routes.profile,
    routes: [
      GoRoute(
        path: Routes.profile,
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.cv,
        builder: (_, __) => const Scaffold(body: Text('cv')),
      ),
      GoRoute(
        path: Routes.settings,
        builder: (_, __) => const Scaffold(body: Text('settings')),
      ),
      GoRoute(
        path: Routes.settingsNotifications,
        builder: (_, __) => const Scaffold(body: Text('notifications')),
      ),
      GoRoute(
        path: Routes.profileJobPreferences,
        builder: (_, __) => const Scaffold(body: Text('job-preferences')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      profileBasicsProvider.overrideWith(_BasicsNotifier.new),
      profileJobPreferencesProvider.overrideWith(_JobPreferencesNotifier.new),
    ],
    child: MaterialApp.router(
      theme: IthakiTheme.light,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('es'),
    ),
  );
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('drawer uses resolved Spanish locale when no locale is saved',
      (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        const AppNavDrawer(
          currentRoute: Routes.home,
          items: [],
        ),
      ),
    );

    expect(find.text('Español'), findsOneWidget);

    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();

    expect(find.text('Español'), findsNWidgets(2));
  });

  testWidgets('Spanish profile actions fit on a narrow phone width',
      (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_profileApp());
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

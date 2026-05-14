import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/models/home_models.dart';
import 'package:ithaki_ui/models/notifications_models.dart';
import 'package:ithaki_ui/providers/profile_provider.dart';
import 'package:ithaki_ui/repositories/home_repository.dart';
import 'package:ithaki_ui/repositories/notifications_repository.dart';
import 'package:ithaki_ui/routes.dart';
import 'package:ithaki_ui/screens/settings/notifications_screen.dart';
import 'package:ithaki_ui/widgets/app_nav_drawer.dart';
import 'package:ithaki_ui/widgets/main_panel_scaffold.dart';

class _HomeRepository implements HomeRepository {
  @override
  Future<HomeData> getData() async => HomeData(
        userName: 'Kostas',
        userInitials: 'KL',
        cvStats: CvStats(
          views: 0,
          invitations: 0,
          applicationsSent: 0,
          interviews: 0,
        ),
        jobs: [],
        courses: [],
        news: [],
        isNewUser: false,
        profileItems: [],
        profileBenefits: [],
        filterChips: [],
      );
}

class _NotificationsRepository implements NotificationsRepository {
  @override
  Future<List<NotificationItem>> getNotifications() async => const [];

  @override
  Future<void> markAllAsRead() async {}
}

Widget _app() {
  final router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (_, __) => MainPanelScaffold(
          currentRoute: Routes.home,
          bodyBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
      GoRoute(
        path: Routes.settingsNotifications,
        builder: (_, __) => const NotificationsScreen(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      homeRepositoryProvider.overrideWithValue(_HomeRepository()),
      notificationsRepositoryProvider.overrideWithValue(
        _NotificationsRepository(),
      ),
      profileCompletionProvider.overrideWith((ref) => 1),
    ],
    child: MaterialApp.router(
      theme: IthakiTheme.light,
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
    ),
  );
}

void main() {
  testWidgets('notifications route does not inherit an open nav drawer',
      (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    tester.widget<IthakiAppBar>(find.byType(IthakiAppBar)).onMenuPressed!();
    await tester.pumpAndSettle();
    expect(find.byType(AppNavDrawer), findsOneWidget);

    tester
        .widget<IthakiAppBar>(find.byType(IthakiAppBar))
        .onNotificationsPressed!();
    await tester.pumpAndSettle();

    expect(find.byType(NotificationsScreen), findsOneWidget);
    expect(find.byType(AppNavDrawer), findsNothing);
  });

  testWidgets('notifications app bar button does not open the nav drawer',
      (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    tester
        .widget<IthakiAppBar>(find.byType(IthakiAppBar))
        .onNotificationsPressed!();
    await tester.pumpAndSettle();

    tester.widget<IthakiAppBar>(find.byType(IthakiAppBar)).onMenuPressed!();
    await tester.pumpAndSettle();

    expect(find.byType(NotificationsScreen), findsNothing);
    expect(find.byType(AppNavDrawer), findsNothing);
  });
}

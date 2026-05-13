import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/models/home_models.dart';
import 'package:ithaki_ui/providers/profile_provider.dart';
import 'package:ithaki_ui/repositories/home_repository.dart';
import 'package:ithaki_ui/routes.dart';
import 'package:ithaki_ui/screens/home/home_screen.dart';

class _HomeRepository implements HomeRepository {
  @override
  Future<HomeData> getData() async => const HomeData(
        userName: 'Kostas',
        userInitials: 'KL',
        cvStats: CvStats(
          views: 0,
          invitations: 0,
          applicationsSent: 0,
          interviews: 0,
        ),
        jobs: [
          JobRecommendation(
            id: 'job-1',
            companyName: 'TechWave',
            companyInitials: 'TW',
            companyColor: IthakiTheme.primaryPurple,
            jobTitle: 'Software Engineer',
            salary: '1,500 \u20ac / month',
            matchPercentage: 90,
            matchLabel: 'STRONG MATCH',
            location: 'Athens',
            workMode: 'On-site',
            employmentType: 'Full-Time',
            level: 'Entry',
          ),
        ],
        courses: [],
        news: [],
        isNewUser: false,
        profileItems: [],
        profileBenefits: [],
        filterChips: [],
      );
}

class _BasicsNotifier extends ProfileBasicsNotifier {
  @override
  Future<ProfileBasics> build() async => const ProfileBasics(
        firstName: 'Kostas',
        lastName: 'Lopez',
      );
}

Widget _app() {
  final router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(path: Routes.home, builder: (_, __) => const HomeScreen()),
      GoRoute(
        path: Routes.careerAssistant,
        builder: (_, __) => const Scaffold(body: Text('assistant')),
      ),
      GoRoute(
        path: Routes.settingsNotifications,
        builder: (_, __) => const Scaffold(body: Text('notifications')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      homeRepositoryProvider.overrideWithValue(_HomeRepository()),
      profileBasicsProvider.overrideWith(_BasicsNotifier.new),
      profileCompletionProvider.overrideWith((ref) => 1),
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
  testWidgets('Spanish home banners do not overflow on narrow phones',
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

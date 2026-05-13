import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/providers/profile_provider.dart';
import 'package:ithaki_ui/routes.dart';
import 'package:ithaki_ui/screens/profile/tabs/profile_about_me_tab.dart';
import 'package:ithaki_ui/widgets/profile_video_player.dart';

class _VideoOnlyAboutMeNotifier extends ProfileAboutMeNotifier {
  @override
  Future<ProfileAboutMe> build() async => const ProfileAboutMe(
        videoUrl: 'https://cdn.test/videos/about-me.mp4',
      );
}

Widget _app() {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const ProfileAboutMeTab()),
      GoRoute(
        path: Routes.profileAboutMe,
        builder: (_, __) => const Scaffold(body: Text('edit')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      profileAboutMeProvider.overrideWith(_VideoOnlyAboutMeNotifier.new),
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
  testWidgets('shows video preview when profile has video without bio',
      (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Video Introduction'), findsOneWidget);
    expect(find.byType(ProfileVideoPreview), findsOneWidget);
    expect(find.text('Add About Me Information'), findsNothing);
  });
}

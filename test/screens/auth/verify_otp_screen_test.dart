import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/repositories/auth_repository.dart';
import 'package:ithaki_ui/routes.dart';
import 'package:ithaki_ui/screens/auth/verify_otp_screen.dart';
import 'package:ithaki_ui/screens/auth/welcome_modal_screen.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<LoginSession> loginWithEmail(String email, String password) async =>
      const LoginSession();

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required String phone,
    required String verifyMethod,
    required String techComfort,
    required String systemLanguage,
  }) async {}

  @override
  Future<void> verifyOtp(String otp) async {}

  @override
  Future<void> sendOtp() async {}

  @override
  Future<void> updatePhone(String phone) async {}

  @override
  Future<void> resetPassword(String newPassword) async {}

  @override
  Future<void> logout() async {}
}

GoRouter _router() => GoRouter(
      initialLocation: Routes.verifyOtp,
      routes: [
        GoRoute(
          path: Routes.verifyOtp,
          builder: (_, __) => const VerifyOtpScreen(),
        ),
        GoRoute(
          path: Routes.welcome,
          pageBuilder: (context, state) => CustomTransitionPage(
            opaque: false,
            barrierColor: Colors.transparent,
            child: const WelcomeModalScreen(),
            transitionsBuilder: (context, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          path: Routes.setupLocation,
          builder: (_, __) => const Scaffold(body: Text('setup-location')),
        ),
        GoRoute(
          path: Routes.home,
          builder: (_, __) => const Scaffold(body: Text('home-screen')),
        ),
      ],
    );

Widget _buildApp() => ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
      ],
      child: MaterialApp.router(
        routerConfig: _router(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
      ),
    );

void main() {
  testWidgets('welcome modal opens over the OTP screen after verification',
      (tester) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText), '123456');
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text("Let's verify your Account"), findsOneWidget);
    expect(find.textContaining('Welcome on board!'), findsOneWidget);
  });
}

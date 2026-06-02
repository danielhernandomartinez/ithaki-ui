import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/providers/auth_provider.dart';
import 'package:ithaki_ui/routes.dart';
import 'package:ithaki_ui/screens/auth/verify_otp_screen.dart';
import 'package:ithaki_ui/screens/auth/welcome_modal_screen.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<LoginSession> loginWithEmail(String email, String password) async =>
      const LoginSession();

  @override
  Future<LoginSession> loginWithGoogle(String idToken) async =>
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
  Future<void> forgotPassword(String email) async {}

  @override
  Future<void> resetPassword(String token, String newPassword) async {}

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {}

  @override
  Future<void> logout() async {}
}

class _FailingSendOtpAuthRepository extends _FakeAuthRepository {
  @override
  Future<void> sendOtp() async {
    throw const AuthException(
      'Could not send verification code. Please try again.',
    );
  }
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

Widget _buildApp({AuthRepository? authRepository}) => ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          authRepository ?? _FakeAuthRepository(),
        ),
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

  testWidgets('resend failure shows an error instead of restarting silently',
      (tester) async {
    await tester.pumpWidget(
      _buildApp(authRepository: _FailingSendOtpAuthRepository()),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 26));

    await tester.tap(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText && widget.text.toPlainText() == 'Resend code',
      ),
    );
    await tester.pump();

    expect(
      find.text('Could not send verification code. Please try again.'),
      findsOneWidget,
    );
  });
}

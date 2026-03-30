// test/screens/auth/login_email_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ithaki_ui/repositories/auth_repository.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/routes.dart';
import 'package:ithaki_ui/screens/auth/login_email_screen.dart';

// ── helpers ──────────────────────────────────────────────────────────────────

GoRouter _router() => GoRouter(
      initialLocation: Routes.loginEmail,
      routes: [
        GoRoute(
          path: Routes.loginEmail,
          builder: (_, __) => const LoginEmailScreen(),
        ),
        GoRoute(
          path: Routes.techComfort,
          builder: (_, __) => const Scaffold(body: Text('tech-comfort-screen')),
        ),
        GoRoute(
          path: Routes.forgotPassword,
          builder: (_, __) =>
              const Scaffold(body: Text('forgot-password-screen')),
        ),
        GoRoute(
          path: Routes.loginPhone,
          builder: (_, __) => const Scaffold(body: Text('login-phone-screen')),
        ),
      ],
    );

Widget _buildApp(GoRouter router) => ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(MockAuthRepository()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
      ),
    );

/// Returns the [ButtonStyleButton] ancestor of the "Sign In" label.
ButtonStyleButton _signInButton(WidgetTester tester) {
  final ancestor = find
      .ancestor(
        of: find.text('Sign In'),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      )
      .first;
  return tester.widget<ButtonStyleButton>(ancestor);
}

Future<void> _enterCredentials(
  WidgetTester tester, {
  String email = '',
  String password = '',
}) async {
  await tester.enterText(find.byType(TextField).at(0), email);
  await tester.enterText(find.byType(TextField).at(1), password);
  await tester.pump();
}

// ── tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('LoginEmailScreen', () {
    // ── layout ────────────────────────────────────────────────────────────────

    group('layout', () {
      testWidgets('shows the login heading', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.text('Login to Ithaki Talent'), findsOneWidget);
      });

      testWidgets('shows email and password text fields', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsNWidgets(2));
      });

      testWidgets('shows remember-me checkbox unchecked by default',
          (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
        expect(checkbox.value, isFalse);
      });

      testWidgets('shows forgot-password link', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.text('Forgot your password?'), findsOneWidget);
      });

      testWidgets('shows Sign In button', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.text('Sign In'), findsOneWidget);
      });

      testWidgets('shows Sign in with Google button', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.text('Sign in with Google'), findsOneWidget);
      });

      testWidgets('shows phone-login footer', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(
          find.text('Prefer phone? You can sign in with phone instead.'),
          findsOneWidget,
        );
        expect(find.text('Sign in with Phone'), findsOneWidget);
      });

      testWidgets('shows Sign Up action in the app bar', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.text('Sign Up'), findsOneWidget);
      });
    });

    // ── sign-in button state ──────────────────────────────────────────────────

    group('Sign In button', () {
      testWidgets('is disabled when both fields are empty', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(_signInButton(tester).onPressed, isNull);
      });

      testWidgets('is disabled when email has no @ symbol', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await _enterCredentials(tester,
            email: 'invalidemail.com', password: 'password123');

        expect(_signInButton(tester).onPressed, isNull);
      });

      testWidgets('is disabled when email has no dot', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await _enterCredentials(tester,
            email: 'user@nodot', password: 'password123');

        expect(_signInButton(tester).onPressed, isNull);
      });

      testWidgets('is disabled with valid email but empty password',
          (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await _enterCredentials(tester,
            email: 'user@example.com', password: '');

        expect(_signInButton(tester).onPressed, isNull);
      });

      testWidgets('is enabled with valid email and non-empty password',
          (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await _enterCredentials(tester,
            email: 'user@example.com', password: 'password123');

        expect(_signInButton(tester).onPressed, isNotNull);
      });

      testWidgets('updates state correctly as user types', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        // Initially disabled
        expect(_signInButton(tester).onPressed, isNull);

        // Valid email but no password — still disabled
        await _enterCredentials(tester, email: 'user@example.com');
        expect(_signInButton(tester).onPressed, isNull);

        // Both valid — enabled
        await tester.enterText(find.byType(TextField).at(1), 'secret');
        await tester.pump();
        expect(_signInButton(tester).onPressed, isNotNull);

        // Clear password — disabled again
        await tester.enterText(find.byType(TextField).at(1), '');
        await tester.pump();
        expect(_signInButton(tester).onPressed, isNull);
      });
    });

    // ── remember-me checkbox ─────────────────────────────────────────────────

    group('Remember me checkbox', () {
      testWidgets('toggles to checked on first tap', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
      });

      testWidgets('toggles back to unchecked on second tap', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(Checkbox));
        await tester.pump();
        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
      });
    });

    // ── navigation ────────────────────────────────────────────────────────────

    group('navigation', () {
      testWidgets('Sign Up navigates to tech-comfort screen', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Sign Up'));
        await tester.pumpAndSettle();

        expect(find.text('tech-comfort-screen'), findsOneWidget);
      });

      testWidgets('Forgot password navigates to forgot-password screen',
          (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Forgot your password?'));
        await tester.pumpAndSettle();

        expect(find.text('forgot-password-screen'), findsOneWidget);
      });

      testWidgets('Sign in with Phone navigates to login-phone screen',
          (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.text('Sign in with Phone'));
        await tester.tap(find.text('Sign in with Phone'));
        await tester.pumpAndSettle();

        expect(find.text('login-phone-screen'), findsOneWidget);
      });
    });
  });
}

// test/screens/auth/register_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/routes.dart';
import 'package:ithaki_ui/screens/auth/personal_details_screen.dart';
import 'package:ithaki_ui/screens/auth/register_screen.dart';
import 'package:ithaki_ui/screens/employer/employer_setup_screen.dart';

// ── helpers ───────────────────────────────────────────────────────────────────

GoRouter _router() => GoRouter(
      initialLocation: Routes.register,
      routes: [
        GoRoute(
          path: Routes.register,
          builder: (_, __) => const RegisterScreen(),
        ),
        GoRoute(
          path: Routes.loginPhone,
          builder: (_, __) => const Scaffold(body: Text('login-phone-screen')),
        ),
        GoRoute(
          path: Routes.personalDetails,
          builder: (_, __) =>
              const Scaffold(body: Text('personal-details-screen')),
        ),
      ],
    );

GoRouter _routerWithPersonalDetailsScreen() => GoRouter(
      initialLocation: Routes.register,
      routes: [
        GoRoute(
          path: Routes.register,
          builder: (_, __) => const RegisterScreen(),
        ),
        GoRoute(
          path: Routes.loginPhone,
          builder: (_, __) => const Scaffold(body: Text('login-phone-screen')),
        ),
        GoRoute(
          path: Routes.personalDetails,
          builder: (_, __) => const PersonalDetailsScreen(),
        ),
      ],
    );

GoRouter _employerRouterWithSetupScreen() => GoRouter(
      initialLocation: Routes.registerEmployer,
      routes: [
        GoRoute(
          path: Routes.registerEmployer,
          builder: (_, __) => const RegisterScreen(isEmployer: true),
        ),
        GoRoute(
          path: Routes.loginPhone,
          builder: (_, __) => const Scaffold(body: Text('login-phone-screen')),
        ),
        GoRoute(
          path: Routes.employerSetup,
          builder: (_, __) => const EmployerSetupScreen(),
        ),
      ],
    );

Widget _buildApp(GoRouter router) => ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
      ),
    );

ButtonStyleButton _continueButton(WidgetTester tester) {
  final ancestor = find
      .ancestor(
        of: find.text('Continue'),
        matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
      )
      .first;
  return tester.widget<ButtonStyleButton>(ancestor);
}

// A password that satisfies all four validation rules.
const _validEmail = 'user@example.com';
const _validPassword = 'Secure@1';

Future<void> _fillForm(
  WidgetTester tester, {
  String email = _validEmail,
  String password = _validPassword,
  String confirmPassword = _validPassword,
  bool acceptTerms = true,
}) async {
  await tester.enterText(find.byType(TextField).at(0), email);
  await tester.enterText(find.byType(TextField).at(1), password);
  await tester.enterText(find.byType(TextField).at(2), confirmPassword);
  if (acceptTerms) {
    await tester.ensureVisible(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
  }
  await tester.pump();
}

Future<void> _selectBottomSheetOption(
  WidgetTester tester,
  String option,
) async {
  await tester.tap(find.text(option));
  await tester.pump();
  await tester.tap(find.text('Select').last);
  await tester.pumpAndSettle();
}

Future<void> _openEmployerSetup(WidgetTester tester) async {
  await tester.pumpWidget(_buildApp(_employerRouterWithSetupScreen()));
  await tester.pumpAndSettle();

  await _fillForm(tester);
  await tester.ensureVisible(find.text('Continue'));
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

Future<void> _advanceEmployerAdminDetails(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).at(0), 'Jane');
  await tester.enterText(find.byType(TextField).at(1), 'Doe');
  await tester.enterText(
    find.descendant(
      of: find.byType(IthakiPhoneField),
      matching: find.byType(TextFormField),
    ),
    '612345678',
  );
  await tester.tap(find.text('Select your Role'));
  await tester.pumpAndSettle();
  await _selectBottomSheetOption(tester, 'CEO / Founder');

  await tester.ensureVisible(find.text('Continue'));
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

Future<void> _advanceEmployerCompanyDetails(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).first, 'Ithaki Labs');
  await tester.tap(find.text('Select your business industry'));
  await tester.pumpAndSettle();
  await _selectBottomSheetOption(tester, 'Technology');

  await tester.tap(find.text('Select your company size'));
  await tester.pumpAndSettle();
  await _selectBottomSheetOption(tester, '500+');

  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
}

// ── tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('RegisterScreen', () {
    // ── layout ────────────────────────────────────────────────────────────────

    group('layout', () {
      testWidgets('shows welcome heading', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.textContaining('Welcome to Ithaki!'), findsOneWidget);
      });

      testWidgets('shows Sign in with Google button', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.text('Sign in with Google'), findsOneWidget);
      });

      testWidgets('shows email, password and confirm password fields',
          (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsNWidgets(3));
      });

      testWidgets('shows terms checkbox unchecked by default', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
      });

      testWidgets('shows Continue button', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.text('Continue'), findsOneWidget);
      });

      testWidgets('shows Login action in the app bar', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.text('Login'), findsOneWidget);
      });
    });

    // ── Continue button state ─────────────────────────────────────────────────

    group('Continue button', () {
      testWidgets('is disabled when all fields are empty', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(_continueButton(tester).onPressed, isNull);
      });

      testWidgets('is disabled with invalid email', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await _fillForm(tester, email: 'notanemail');

        expect(_continueButton(tester).onPressed, isNull);
      });

      testWidgets('is disabled with email missing @', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await _fillForm(tester, email: 'usernodot.com');

        expect(_continueButton(tester).onPressed, isNull);
      });

      testWidgets('is disabled with email missing dot', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await _fillForm(tester, email: 'user@nodot');

        expect(_continueButton(tester).onPressed, isNull);
      });

      testWidgets('is disabled with valid email but weak password',
          (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await _fillForm(tester, password: 'weak', confirmPassword: 'weak');

        expect(_continueButton(tester).onPressed, isNull);
      });

      testWidgets('is disabled when passwords do not match', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await _fillForm(tester, confirmPassword: 'Different@9');

        expect(_continueButton(tester).onPressed, isNull);
      });

      testWidgets('is disabled when terms are not accepted', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await _fillForm(tester, acceptTerms: false);

        expect(_continueButton(tester).onPressed, isNull);
      });

      testWidgets('is enabled when all conditions are met', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await _fillForm(tester);

        expect(_continueButton(tester).onPressed, isNotNull);
      });
    });

    // ── password validation rows ──────────────────────────────────────────────

    group('password validation rows', () {
      testWidgets('are hidden when password field is empty', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.text('Includes one uppercase and one lowercase letter'),
            findsNothing);
        expect(find.text('At least 8 characters'), findsNothing);
        expect(find.text('Includes at least one number'), findsNothing);
        expect(
            find.text('Includes one special character (like !@#\$%^&)'),
            findsNothing);
      });

      testWidgets('appear when password field has text', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).at(1), 'abc');
        await tester.pump();

        expect(find.text('Includes one uppercase and one lowercase letter'),
            findsOneWidget);
        expect(find.text('At least 8 characters'), findsOneWidget);
        expect(find.text('Includes at least one number'), findsOneWidget);
        expect(
            find.text('Includes one special character (like !@#\$%^&)'),
            findsOneWidget);
      });
    });

    // ── confirm password mismatch error ───────────────────────────────────────

    group('confirm password error', () {
      testWidgets('is hidden when confirm field is empty', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        expect(find.text('Passwords do not match'), findsNothing);
      });

      testWidgets('shows error when passwords do not match', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).at(1), _validPassword);
        await tester.enterText(
            find.byType(TextField).at(2), 'WrongPass@9');
        await tester.pump();

        expect(find.text('Passwords do not match'), findsOneWidget);
      });

      testWidgets('hides error when passwords match', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).at(1), _validPassword);
        await tester.enterText(find.byType(TextField).at(2), _validPassword);
        await tester.pump();

        expect(find.text('Passwords do not match'), findsNothing);
      });
    });

    // ── terms checkbox ────────────────────────────────────────────────────────

    group('terms checkbox', () {
      testWidgets('toggles to checked on first tap', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byType(Checkbox));
        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
      });

      testWidgets('toggles back to unchecked on second tap', (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byType(Checkbox));
        await tester.tap(find.byType(Checkbox));
        await tester.pump();
        await tester.ensureVisible(find.byType(Checkbox));
        await tester.tap(find.byType(Checkbox));
        await tester.pump();

        expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
      });
    });

    // ── navigation ────────────────────────────────────────────────────────────

    group('navigation', () {
      testWidgets('Login action navigates to login-phone screen',
          (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        expect(find.text('login-phone-screen'), findsOneWidget);
      });

      testWidgets('Continue navigates to personal-details screen',
          (tester) async {
        await tester.pumpWidget(_buildApp(_router()));
        await tester.pumpAndSettle();

        await _fillForm(tester);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        expect(find.text('personal-details-screen'), findsOneWidget);
      });

      testWidgets('Continue renders personal details without layout errors',
          (tester) async {
        await tester.pumpWidget(_buildApp(_routerWithPersonalDetailsScreen()));
        await tester.pumpAndSettle();

        await _fillForm(tester);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(
            find.text('Almost there!\nTell us about yourself'), findsOneWidget);
      });

      testWidgets('Employer Continue renders setup without layout errors',
          (tester) async {
        await tester.pumpWidget(_buildApp(_employerRouterWithSetupScreen()));
        await tester.pumpAndSettle();

        await _fillForm(tester);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Admin Details'), findsOneWidget);
      });

      testWidgets('Employer Admin Details uses prefixed phone field',
          (tester) async {
        await _openEmployerSetup(tester);

        expect(find.byType(IthakiPhoneField), findsOneWidget);
        expect(find.text('+34'), findsOneWidget);
      });

      testWidgets('Employer Contact Details uses prefixed phone field',
          (tester) async {
        await _openEmployerSetup(tester);
        await _advanceEmployerAdminDetails(tester);
        await _advanceEmployerCompanyDetails(tester);

        expect(find.text('Contact Details'), findsOneWidget);
        expect(find.byType(IthakiPhoneField), findsOneWidget);
        expect(find.text('+34'), findsOneWidget);
      });

      testWidgets('Employer setup clears text field focus before opening pickers',
          (tester) async {
        await _openEmployerSetup(tester);

        await tester.enterText(find.byType(TextField).at(1), 'Doe');
        expect(FocusManager.instance.primaryFocus?.hasFocus, isTrue);

        await tester.tap(find.text('Select your Role'));
        await tester.pumpAndSettle();

        final focusedInputs = tester
            .widgetList<EditableText>(find.byType(EditableText))
            .where((input) => input.focusNode.hasFocus);
        expect(focusedInputs, isEmpty);
      });
    });
  });
}

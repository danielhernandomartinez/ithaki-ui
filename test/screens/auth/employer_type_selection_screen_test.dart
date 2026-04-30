import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/routes.dart';
import 'package:ithaki_ui/screens/auth/employer_type_selection_screen.dart';

GoRouter _router() => GoRouter(
      initialLocation: Routes.employerTypeSelection,
      routes: [
        GoRoute(
          path: Routes.employerTypeSelection,
          builder: (_, __) => const EmployerTypeSelectionScreen(),
        ),
        GoRoute(
          path: Routes.registerEmployer,
          builder: (_, __) => const Scaffold(body: Text('register-screen')),
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

void main() {
  group('EmployerTypeSelectionScreen', () {
    testWidgets('shows employer company and NGO cards', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      expect(find.text('We are Employer Company'), findsOneWidget);
      expect(find.text('We are Non-Profit Organization'), findsOneWidget);
    });

    testWidgets('Continue is disabled before selection', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      expect(_continueButton(tester).onPressed, isNull);
    });

    testWidgets('Continue enables after selecting employer company', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('We are Employer Company'));
      await tester.pump();

      expect(_continueButton(tester).onPressed, isNotNull);
    });

    testWidgets('Continue navigates to register screen', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('We are Employer Company'));
      await tester.pump();
      final continueBtn = find.text('Continue');
      await tester.ensureVisible(continueBtn);
      await tester.tap(continueBtn);
      await tester.pumpAndSettle();

      expect(find.text('register-screen'), findsOneWidget);
    });
  });
}

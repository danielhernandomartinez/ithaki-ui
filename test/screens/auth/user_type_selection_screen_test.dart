import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/routes.dart';
import 'package:ithaki_ui/screens/auth/user_type_selection_screen.dart';

GoRouter _router() => GoRouter(
      initialLocation: Routes.userTypeSelection,
      routes: [
        GoRoute(
          path: Routes.userTypeSelection,
          builder: (_, __) => const UserTypeSelectionScreen(),
        ),
        GoRoute(
          path: Routes.techComfort,
          builder: (_, __) => const Scaffold(body: Text('tech-comfort')),
        ),
        GoRoute(
          path: Routes.employerTypeSelection,
          builder: (_, __) => const Scaffold(body: Text('employer-type')),
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
  group('UserTypeSelectionScreen', () {
    testWidgets('shows job seeker and employer cards', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      expect(find.text("I'm a Job Seeker"), findsOneWidget);
      expect(find.text('We are an Employer or NGO'), findsOneWidget);
    });

    testWidgets('Continue is disabled before selection', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      expect(_continueButton(tester).onPressed, isNull);
    });

    testWidgets('Continue enables after tapping Job Seeker', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      await tester.tap(find.text("I'm a Job Seeker"));
      await tester.pump();

      expect(_continueButton(tester).onPressed, isNotNull);
    });

    testWidgets('Continue enables after tapping Employer', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('We are an Employer or NGO'));
      await tester.pump();

      expect(_continueButton(tester).onPressed, isNotNull);
    });

    testWidgets('Job Seeker navigates to tech-comfort', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      await tester.tap(find.text("I'm a Job Seeker"));
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('tech-comfort'), findsOneWidget);
    });

    testWidgets('Employer navigates to employer-type', (tester) async {
      await tester.pumpWidget(_buildApp(_router()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('We are an Employer or NGO'));
      await tester.pump();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('employer-type'), findsOneWidget);
    });
  });
}

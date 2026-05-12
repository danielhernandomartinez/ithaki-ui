import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/providers/profile_provider.dart';
import 'package:ithaki_ui/screens/profile/tabs/profile_skills_tab.dart';

class _CompetenciesNotifier extends ProfileSkillsNotifier {
  @override
  Future<ProfileSkills> build() async => const ProfileSkills(
        competencies: {
          'computerSkills': 'Intermediate',
          'hasDrivingLicense': 'false',
          'drivingLicenseCategories': '[]',
          'hasGreekLicense': 'false',
        },
      );
}

class _BasicsNotifier extends ProfileBasicsNotifier {
  @override
  Future<ProfileBasics> build() async => const ProfileBasics();
}

Widget _wrap(Widget child) => ProviderScope(
      overrides: [
        profileSkillsProvider.overrideWith(_CompetenciesNotifier.new),
        profileBasicsProvider.overrideWith(_BasicsNotifier.new),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );

void main() {
  testWidgets('competencies card renders user-facing labels and hides flags',
      (tester) async {
    await tester.pumpWidget(_wrap(const ProfileSkillsTab()));
    await tester.pumpAndSettle();

    expect(find.text('Competencies'), findsOneWidget);
    expect(find.text('Computer Skills'), findsOneWidget);
    expect(find.text('Intermediate'), findsOneWidget);
    expect(find.text('Driving License'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);
    expect(find.text('computerSkills'), findsNothing);
    expect(find.text('hasDrivingLicense'), findsNothing);
    expect(find.text('drivingLicenseCategories'), findsNothing);
    expect(find.text('hasGreekLicense'), findsNothing);
    expect(find.text('false'), findsNothing);
    expect(find.text('[]'), findsNothing);
    expect(find.text('Edit Competencies'), findsOneWidget);
    expect(find.text('Work Permit'), findsNothing);
  });
}

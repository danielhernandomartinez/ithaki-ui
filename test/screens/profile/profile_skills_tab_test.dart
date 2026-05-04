import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ithaki_ui/providers/profile_provider.dart';
import 'package:ithaki_ui/screens/profile/tabs/profile_skills_tab.dart';

class _CompetenciesNotifier extends ProfileSkillsNotifier {
  @override
  Future<ProfileSkills> build() async => const ProfileSkills(
        competencies: {
          'computerSkills': 'Professional',
          'drivingLicense': 'Yes',
          'licenseCategory': 'B',
          'greekLicense': 'false',
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
      child: MaterialApp(home: Scaffold(body: child)),
    );

void main() {
  testWidgets('competencies card renders stored keys and values',
      (tester) async {
    await tester.pumpWidget(_wrap(const ProfileSkillsTab()));
    await tester.pumpAndSettle();

    expect(find.text('Competencies'), findsOneWidget);
    expect(find.text('computerSkills'), findsOneWidget);
    expect(find.text('Professional'), findsOneWidget);
    expect(find.text('drivingLicense'), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('licenseCategory'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('greekLicense'), findsOneWidget);
    expect(find.text('false'), findsOneWidget);
    expect(find.text('Edit Competencies'), findsOneWidget);
    expect(find.text('Work Permit'), findsNothing);
  });
}

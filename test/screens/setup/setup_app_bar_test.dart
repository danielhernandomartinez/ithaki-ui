import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ithaki_ui/providers/registration_provider.dart';
import 'package:ithaki_ui/screens/setup/widgets/setup_app_bar.dart';

class _SeededRegistrationNotifier extends RegistrationNotifier {
  @override
  RegistrationState build() => const RegistrationState(
        name: 'Pablo',
        lastName: 'Armas',
        phone: '+306900000000',
      );
}

void main() {
  testWidgets('uses registration initials during setup', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registrationProvider.overrideWith(_SeededRegistrationNotifier.new),
        ],
        child: const MaterialApp(
          home: Scaffold(appBar: SetupAppBar()),
        ),
      ),
    );

    expect(find.text('PA'), findsOneWidget);
    expect(find.text('AA'), findsNothing);
  });
}

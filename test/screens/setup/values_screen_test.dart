import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ithaki_ui/l10n/app_localizations.dart';
import 'package:ithaki_ui/repositories/reference_data_repository.dart';
import 'package:ithaki_ui/screens/setup/values_screen.dart';
import 'package:ithaki_ui/services/api_client.dart';

class _MockApiClient extends Mock implements ApiClient {}

Widget _buildApp(ApiClient api) => ProviderScope(
      overrides: [
        referenceDataRepositoryProvider.overrideWithValue(
          ReferenceDataRepository(apiClient: api),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        home: ValuesScreen(isEmployer: true),
      ),
    );

void main() {
  testWidgets('employer values render fallback before login', (tester) async {
    final api = _MockApiClient();
    when(() => api.getOptionalAuth('/list/personality-values'))
        .thenThrow(Exception('Missing auth token'));

    await tester.pumpWidget(_buildApp(api));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Learning'), findsOneWidget);
    expect(find.text('Teamwork'), findsOneWidget);
    verifyNever(() => api.get('/list/personality-values'));
  });
}

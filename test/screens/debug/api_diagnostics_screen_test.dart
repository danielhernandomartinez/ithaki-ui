import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:ithaki_ui/providers/api_diagnostics_provider.dart';
import 'package:ithaki_ui/screens/debug/api_diagnostics_screen.dart';
import 'package:ithaki_ui/services/api_client.dart';

class _FakeApiDiagnosticsRepository extends ApiDiagnosticsRepository {
  _FakeApiDiagnosticsRepository()
      : super(
          apiClient: ApiClient(
            baseUrl: 'http://localhost',
            client: MockClient((_) async => http.Response('', 200)),
          ),
        );

  @override
  Future<ApiDiagnosticResult> runEndpoint(
    ApiDiagnosticEndpoint endpoint,
  ) async =>
      ApiDiagnosticResult(
        endpoint: endpoint,
        statusCode: 200,
        duration: const Duration(milliseconds: 12),
        responsePreview: '[]',
      );

  @override
  Future<List<ApiDiagnosticResult>> runAll() async =>
      [await runEndpoint(ApiDiagnosticsRepository.endpoints.first)];
}

Widget _wrap(Widget child) => ProviderScope(
      overrides: [
        apiDiagnosticsRepositoryProvider.overrideWithValue(
          _FakeApiDiagnosticsRepository(),
        ),
      ],
      child: MaterialApp(home: child),
    );

void main() {
  testWidgets('runs diagnostics and renders endpoint result', (tester) async {
    await tester.pumpWidget(_wrap(const ApiDiagnosticsScreen()));

    expect(find.text('API Diagnostics'), findsOneWidget);

    await tester.tap(find.text('Run all checks'));
    // Drive all async setState calls from the per-endpoint loop.
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('Job search'), findsOneWidget);
    expect(find.text('200'), findsWidgets);
  });
}

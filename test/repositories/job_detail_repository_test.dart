import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:ithaki_ui/repositories/job_detail_repository.dart';
import 'package:ithaki_ui/services/api_client.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({'jwt_token': 'token'});
  });

  test('ApiJobDetailRepository normalizes escaped line breaks from API',
      () async {
    final client = MockClient((request) async {
      expect(request.url.path, '/api/jobs/42');
      expect(request.headers['Authorization'], 'Bearer token');

      return http.Response(
        jsonEncode({
          'id': 42,
          'title': 'Operations Assistant',
          'company': {
            'id': 7,
            'name': 'Acme',
            'description': 'People first\\nReliable operations',
          },
          'description': 'Support the team\\nImprove processes',
          'responsibilities': 'Lead daily tasks\\n- Report blockers',
          'requirements': 'Written communication\\n- Analytical skills',
          'niceToHave': 'Office tools/nCustomer service',
          'benefits': 'Training\\r\\nMentoring',
        }),
        200,
      );
    });
    final repository = ApiJobDetailRepository(
      apiClient: ApiClient(client: client, baseUrl: 'http://localhost'),
    );

    final detail = await repository.getJobDetail('42');

    expect(detail.description, 'Support the team\nImprove processes');
    expect(detail.communication, 'Lead daily tasks\n- Report blockers');
    expect(detail.requirements, ['Written communication', 'Analytical skills']);
    expect(detail.niceToHave, 'Office tools\nCustomer service');
    expect(detail.whatWeOffer, 'Training\nMentoring');
    expect(detail.company.description, 'People first\nReliable operations');
  });
}

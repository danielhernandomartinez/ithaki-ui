// test/repositories/city_search_repository_test.dart
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:ithaki_ui/repositories/city_search_repository.dart';
import 'package:ithaki_ui/services/api_client.dart';

class _MockApiClient extends Mock implements ApiClient {}

// ─── helpers ───────────────────────────────────────────────────────────────────

http.Response _resp(Object body, {int status = 200}) =>
    http.Response(body is String ? body : json.encode(body), status);

/// Minimal /api/city paginated response.
Map<String, dynamic> _page(List<Map<String, dynamic>> items) => {
      'content': items,
      'totalElements': items.length,
      'totalPages': 1,
      'number': 0,
      'size': 20,
    };

Map<String, dynamic> _city(int id, String name, String country) =>
    {'id': id, 'name': name, 'country': country};

void main() {
  late _MockApiClient api;
  late ApiCitySearchRepository repo;

  setUp(() {
    api = _MockApiClient();
    repo = ApiCitySearchRepository(api);
    registerFallbackValue(Uri());
  });

  // Stub helper — matches any GET regardless of path.
  void stubGet(http.Response response) {
    when(() => api.get(any(), params: any(named: 'params')))
        .thenAnswer((_) async => response);
  }

  // ── query too short ──────────────────────────────────────────────────────────
  test('returns [] when query is shorter than 2 chars', () async {
    final result = await repo.search('A');
    expect(result, isEmpty);
    verifyNever(() => api.get(any(), params: any(named: 'params')));
  });

  test('returns [] when query is blank / whitespace', () async {
    final result = await repo.search('  ');
    expect(result, isEmpty);
    verifyNever(() => api.get(any(), params: any(named: 'params')));
  });

  // ── HTTP 200 happy path ──────────────────────────────────────────────────────
  test('parses a paginated 200 response and returns CityResult list', () async {
    stubGet(_resp(_page([
      _city(1, 'Athens', 'GR'),
      _city(2, 'Barcelona', 'ES'),
    ])));

    final results = await repo.search('Ath');

    expect(results, hasLength(2));
    expect(results[0].id, 1);
    expect(results[0].city, 'Athens');
    expect(results[0].country, 'GR');
    expect(results[0].display, 'Athens, GR');
    expect(results[1].city, 'Barcelona');
  });

  test('also accepts a plain JSON array response', () async {
    stubGet(_resp([
      _city(10, 'Rome', 'IT'),
    ]));

    final results = await repo.search('Ro');

    expect(results.single.city, 'Rome');
  });

  test('display omits country when country is empty', () async {
    stubGet(_resp(_page([
      {'id': 3, 'name': 'Nowhere', 'country': ''},
    ])));

    final results = await repo.search('No');

    expect(results.single.display, 'Nowhere');
  });

  // ── HTTP error codes ─────────────────────────────────────────────────────────
  test('returns [] on HTTP 400', () async {
    stubGet(_resp('Bad Request', status: 400));
    expect(await repo.search('Athens'), isEmpty);
  });

  test('returns [] on HTTP 500', () async {
    stubGet(_resp('Internal Server Error', status: 500));
    expect(await repo.search('Athens'), isEmpty);
  });

  // ── country filter param ─────────────────────────────────────────────────────
  test('passes "country" query param when countryCode is provided', () async {
    stubGet(_resp(_page([_city(5, 'Madrid', 'ES')])));

    await repo.search('Mad', countryCode: 'ES');

    final captured = verify(
      () => api.get(any(), params: captureAny(named: 'params')),
    ).captured;

    final params = captured.single as Map<String, String>;
    expect(params['country'], 'ES');
  });

  test('omits "country" param when countryCode is null', () async {
    stubGet(_resp(_page([_city(5, 'Madrid', 'ES')])));

    await repo.search('Mad');

    final captured = verify(
      () => api.get(any(), params: captureAny(named: 'params')),
    ).captured;

    final params = captured.single as Map<String, String>;
    expect(params.containsKey('country'), isFalse);
  });

  // ── skips items with empty name ──────────────────────────────────────────────
  test('skips items with empty name', () async {
    stubGet(_resp(_page([
      {'id': 1, 'name': '', 'country': 'GR'},
      _city(2, 'ValidCity', 'GR'),
    ])));

    final results = await repo.search('Va');

    expect(results, hasLength(1));
    expect(results.single.city, 'ValidCity');
  });

  // ── name query param ─────────────────────────────────────────────────────────
  test('sends trimmed query as "name" param', () async {
    stubGet(_resp(_page([])));

    await repo.search('  Athens  ');

    final captured = verify(
      () => api.get(any(), params: captureAny(named: 'params')),
    ).captured;

    final params = captured.single as Map<String, String>;
    expect(params['name'], 'Athens');
  });
}

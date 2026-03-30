// test/repositories/city_search_repository_test.dart
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:ithaki_ui/repositories/city_search_repository.dart';

class _MockClient extends Mock implements http.Client {}

// ─── helpers ──────────────────────────────────────────────────────────────────

http.Response _resp(Object body, {int status = 200}) =>
    http.Response(body is String ? body : json.encode(body), status);

/// Minimal Nominatim item with an address block.
Map<String, dynamic> _item(String city, String country) => {
      'address': {'city': city, 'country': country},
    };

void main() {
  late _MockClient client;
  late NominatimCitySearch repo;

  setUp(() {
    client = _MockClient();
    repo = NominatimCitySearch(client);
    // Register fallback for the Uri + headers overload used by the repo.
    registerFallbackValue(Uri());
  });

  // Stub helper — matches any GET regardless of URL.
  void stubGet(http.Response response) {
    when(() => client.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => response);
  }

  // ── query too short ─────────────────────────────────────────────────────────
  test('returns [] when query is shorter than 2 chars', () async {
    final result = await repo.search('A');
    expect(result, isEmpty);
    verifyNever(() => client.get(any(), headers: any(named: 'headers')));
  });

  test('returns [] when query is blank / whitespace', () async {
    final result = await repo.search('  ');
    expect(result, isEmpty);
    verifyNever(() => client.get(any(), headers: any(named: 'headers')));
  });

  // ── HTTP 200 happy path ─────────────────────────────────────────────────────
  test('parses a 200 response and returns CityResult list', () async {
    stubGet(_resp([
      _item('Athens', 'Greece'),
      _item('Barcelona', 'Spain'),
    ]));

    final results = await repo.search('Ath');

    expect(results, hasLength(2));
    expect(results[0].city, 'Athens');
    expect(results[0].country, 'Greece');
    expect(results[0].display, 'Athens, Greece');
    expect(results[1].city, 'Barcelona');
  });

  test('display omits country when country is empty', () async {
    stubGet(_resp([
      {'address': <String, dynamic>{'city': 'Nowhere', 'country': ''}},
    ]));

    final results = await repo.search('No');

    expect(results.single.display, 'Nowhere');
  });

  // ── HTTP error codes ────────────────────────────────────────────────────────
  test('returns [] on HTTP 400', () async {
    stubGet(_resp('Bad Request', status: 400));
    expect(await repo.search('Athens'), isEmpty);
  });

  test('returns [] on HTTP 500', () async {
    stubGet(_resp('Internal Server Error', status: 500));
    expect(await repo.search('Athens'), isEmpty);
  });

  // ── malformed JSON ──────────────────────────────────────────────────────────
  test('throws on malformed JSON body', () async {
    stubGet(_resp('{not valid json'));
    expect(() => repo.search('Athens'), throwsA(isA<FormatException>()));
  });

  // ── deduplication ───────────────────────────────────────────────────────────
  test('deduplicates results with same city+country', () async {
    stubGet(_resp([
      _item('Athens', 'Greece'),
      _item('Athens', 'Greece'), // duplicate
      _item('Athens', 'Greece'), // duplicate
    ]));

    final results = await repo.search('Ath');

    expect(results, hasLength(1));
    expect(results.single.city, 'Athens');
  });

  test('does not deduplicate same city in different countries', () async {
    stubGet(_resp([
      _item('Springfield', 'USA'),
      _item('Springfield', 'UK'),
    ]));

    final results = await repo.search('Spr');

    expect(results, hasLength(2));
  });

  // ── country filter ──────────────────────────────────────────────────────────
  test('passes countrycodes query param when countryCode is provided',
      () async {
    stubGet(_resp([_item('Madrid', 'Spain')]));

    await repo.search('Mad', countryCode: 'ES');

    final captured = verify(
      () => client.get(captureAny(), headers: any(named: 'headers')),
    ).captured;

    final uri = captured.single as Uri;
    expect(uri.queryParameters['countrycodes'], 'es');
  });

  test('omits countrycodes param when countryCode is null', () async {
    stubGet(_resp([_item('Madrid', 'Spain')]));

    await repo.search('Mad');

    final captured = verify(
      () => client.get(captureAny(), headers: any(named: 'headers')),
    ).captured;

    final uri = captured.single as Uri;
    expect(uri.queryParameters.containsKey('countrycodes'), isFalse);
  });

  // ── items without a city field ──────────────────────────────────────────────
  test('skips items whose address has no city/town/village/municipality',
      () async {
    stubGet(_resp([
      {'address': <String, dynamic>{'suburb': 'SomeSuburb', 'country': 'X'}},
      _item('ValidCity', 'Y'),
    ]));

    final results = await repo.search('Va');

    expect(results, hasLength(1));
    expect(results.single.city, 'ValidCity');
  });

  test('skips items with null address block', () async {
    stubGet(_resp([
      {'display_name': 'No address here'},
      _item('Rome', 'Italy'),
    ]));

    final results = await repo.search('Ro');

    expect(results, hasLength(1));
    expect(results.single.city, 'Rome');
  });

  // ── address fallback fields ─────────────────────────────────────────────────
  test('falls back to town when city is absent', () async {
    stubGet(_resp([
      {'address': <String, dynamic>{'town': 'Townsville', 'country': 'AU'}},
    ]));

    expect((await repo.search('To')).single.city, 'Townsville');
  });

  test('falls back to village when city and town are absent', () async {
    stubGet(_resp([
      {'address': <String, dynamic>{'village': 'Hamlet', 'country': 'IE'}},
    ]));

    expect((await repo.search('Ha')).single.city, 'Hamlet');
  });

  // ── provider injection ──────────────────────────────────────────────────────
  group('citySearchRepositoryProvider', () {
    test('uses the client from httpClientProvider', () async {
      final mockClient = _MockClient();
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => _resp([_item('Lisbon', 'Portugal')]));

      final container = ProviderContainer(
        overrides: [httpClientProvider.overrideWithValue(mockClient)],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(citySearchRepositoryProvider).search('Li');

      expect(result.single.city, 'Lisbon');
      verify(() => mockClient.get(any(), headers: any(named: 'headers')))
          .called(1);
    });
  });
}

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_client.dart';

class CityResult {
  final int id;
  final String city;
  final String country;
  final String display;

  const CityResult({
    required this.id,
    required this.city,
    required this.country,
    required this.display,
  });
}

abstract class CitySearchRepository {
  Future<List<CityResult>> search(String query, {String? countryCode});
}

// ─── API implementation ───────────────────────────────────────────────────────
// Uses GET /api/city?name={name}&country={code}&page=0&size=20

class ApiCitySearchRepository implements CitySearchRepository {
  ApiCitySearchRepository(this._api);

  final ApiClient _api;

  @override
  Future<List<CityResult>> search(String query, {String? countryCode}) async {
    if (query.trim().length < 2) return [];

    final params = <String, String>{
      'name': query.trim(),
      'page': '0',
      'size': '20',
      if (countryCode != null && countryCode.isNotEmpty)
        'country': countryCode.toUpperCase(),
    };

    final res = await _api.get('/city', params: params);

    if (res.statusCode != 200) return [];

    final body = jsonDecode(res.body);
    final List raw = body is Map
        ? (body['content'] as List? ?? [])
        : (body is List ? body : []);

    return raw
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .map((j) {
          final id = (j['id'] as num?)?.toInt() ?? 0;
          final city = j['name'] as String? ?? '';
          final country = j['country'] as String? ?? '';
          return CityResult(
            id: id,
            city: city,
            country: country,
            display: country.isNotEmpty ? '$city, $country' : city,
          );
        })
        .where((r) => r.city.isNotEmpty)
        .toList();
  }
}

final citySearchRepositoryProvider = Provider<CitySearchRepository>(
  (ref) => ApiCitySearchRepository(ref.watch(apiClientProvider)),
);

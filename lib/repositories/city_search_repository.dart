import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
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

    final res = await _tryApiSearch(params);
    if (res == null) return [];
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

  Future<http.Response?> _tryApiSearch(Map<String, String> params) async {
    try {
      return await _api.getOptionalAuth('/city', params: params);
    } catch (_) {
      return null;
    }
  }
}

class MockCitySearchRepository implements CitySearchRepository {
  static const _cities = [
    CityResult(id: 1, city: 'Athens', country: 'Greece', display: 'Athens, Greece'),
    CityResult(id: 2, city: 'Thessaloniki', country: 'Greece', display: 'Thessaloniki, Greece'),
    CityResult(id: 3, city: 'Patras', country: 'Greece', display: 'Patras, Greece'),
    CityResult(id: 4, city: 'Heraklion', country: 'Greece', display: 'Heraklion, Greece'),
    CityResult(id: 5, city: 'Larissa', country: 'Greece', display: 'Larissa, Greece'),
    CityResult(id: 6, city: 'Volos', country: 'Greece', display: 'Volos, Greece'),
    CityResult(id: 7, city: 'Ioannina', country: 'Greece', display: 'Ioannina, Greece'),
    CityResult(id: 8, city: 'Chania', country: 'Greece', display: 'Chania, Greece'),
    CityResult(id: 9, city: 'Madrid', country: 'Spain', display: 'Madrid, Spain'),
    CityResult(id: 10, city: 'Barcelona', country: 'Spain', display: 'Barcelona, Spain'),
    CityResult(id: 11, city: 'Valencia', country: 'Spain', display: 'Valencia, Spain'),
    CityResult(id: 12, city: 'Seville', country: 'Spain', display: 'Seville, Spain'),
    CityResult(id: 13, city: 'London', country: 'United Kingdom', display: 'London, United Kingdom'),
    CityResult(id: 14, city: 'Paris', country: 'France', display: 'Paris, France'),
    CityResult(id: 15, city: 'Berlin', country: 'Germany', display: 'Berlin, Germany'),
    CityResult(id: 16, city: 'Rome', country: 'Italy', display: 'Rome, Italy'),
    CityResult(id: 17, city: 'Lisbon', country: 'Portugal', display: 'Lisbon, Portugal'),
    CityResult(id: 18, city: 'Amsterdam', country: 'Netherlands', display: 'Amsterdam, Netherlands'),
  ];

  @override
  Future<List<CityResult>> search(String query, {String? countryCode}) async {
    final normalized = query.trim().toLowerCase();
    if (normalized.length < 2) return const [];
    final country = countryCode?.trim().toLowerCase();
    return _cities
        .where((city) =>
            country == null ||
            country.isEmpty ||
            city.country.toLowerCase() == country ||
            city.country.toLowerCase().startsWith(country))
        .where((city) => city.display.toLowerCase().contains(normalized))
        .toList();
  }
}

final citySearchRepositoryProvider = Provider<CitySearchRepository>(
  (ref) => AppConfig.useMockData
      ? MockCitySearchRepository()
      : ApiCitySearchRepository(ref.watch(apiClientProvider)),
);

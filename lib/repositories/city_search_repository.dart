import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CityResult {
  final String city;
  final String country;
  final String display;

  const CityResult({
    required this.city,
    required this.country,
    required this.display,
  });
}

abstract class CitySearchRepository {
  Future<List<CityResult>> search(String query, {String? countryCode});
}

class NominatimCitySearch implements CitySearchRepository {
  final http.Client _client;
  static const _baseUrl = 'https://nominatim.openstreetmap.org/search';

  NominatimCitySearch(this._client);

  @override
  Future<List<CityResult>> search(String query, {String? countryCode}) async {
    if (query.trim().length < 2) return [];

    final params = {
      'q': query,
      'format': 'json',
      'addressdetails': '1',
      'featuretype': 'city',
      'limit': '15',
      'accept-language': 'en',
      if (countryCode != null) 'countrycodes': countryCode.toLowerCase(),
    };

    final uri = Uri.parse(_baseUrl).replace(queryParameters: params);

    final response = await _client.get(uri, headers: {
      'User-Agent': 'IthakiApp/1.0',
    });

    if (response.statusCode != 200) return [];

    final List<dynamic> data = json.decode(response.body);

    final results = <CityResult>[];
    final seen = <String>{};

    for (final item in data) {
      final address = item['address'] as Map<String, dynamic>?;
      if (address == null) continue;

      final city = (address['city'] ??
              address['town'] ??
              address['village'] ??
              address['municipality'] ??
              '')
          .toString();
      final country = (address['country'] ?? '').toString();

      if (city.isEmpty) continue;

      final key = '$city,$country';
      if (seen.contains(key)) continue;
      seen.add(key);

      results.add(CityResult(
        city: city,
        country: country,
        display: country.isNotEmpty ? '$city, $country' : city,
      ));
    }

    return results;
  }
}

final citySearchRepositoryProvider = Provider<CitySearchRepository>(
  (ref) => NominatimCitySearch(http.Client()),
);

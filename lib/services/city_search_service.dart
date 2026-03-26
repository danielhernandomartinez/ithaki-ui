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

class CitySearchService {
  static const _baseUrl = 'https://nominatim.openstreetmap.org/search';

  Future<List<CityResult>> search(String query) async {
    if (query.trim().length < 2) return [];

    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'q': query,
      'format': 'json',
      'addressdetails': '1',
      'featuretype': 'city',
      'limit': '10',
      'accept-language': 'en',
    });

    final response = await http.get(uri, headers: {
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

final citySearchServiceProvider = Provider<CitySearchService>(
  (_) => CitySearchService(),
);

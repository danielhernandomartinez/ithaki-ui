import '../../data/countries.dart';
import 'profile_api_mapper.dart';

class ProfileCountryResolver {
  static Map<int, String>? _codeById;

  static Map<int, String> _getCodeById() {
    return _codeById ??= {
      for (final entry in countryIdByCode.entries)
        entry.value: entry.key.toLowerCase(),
    };
  }

  static String countryCodeFor(dynamic field) {
    final apiCode = ProfileApiMapper.countryCode(field);
    if (apiCode.isNotEmpty) return apiCode;

    final idRaw = field is Map ? field['id'] ?? field['value'] : field;
    final id = idRaw is num ? idRaw.toInt() : int.tryParse(idRaw.toString());
    if (id == null) return '';

    return _getCodeById()[id] ?? '';
  }

  static String countryNameFor(dynamic field) {
    final apiName = field is Map || field is String
        ? ProfileApiMapper.countryName(field)
        : '';
    if (apiName.isNotEmpty) return apiName;

    final code = countryCodeFor(field);
    if (code.isEmpty) return '';
    for (final country in allCountries) {
      if (country.id.toLowerCase() == code) return country.label;
    }
    return '';
  }
}

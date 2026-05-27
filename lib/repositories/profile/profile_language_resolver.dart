import 'dart:convert';

import '../../models/profile_models.dart';
import '../../services/api_client.dart';
import '../../utils/parse_utils.dart';
import 'profile_api_mapper.dart';

class ProfileLanguageResolver {
  ProfileLanguageResolver(this._api);

  final ApiClient _api;
  Map<String, int>? _languageIdByName;

  void invalidate() => _languageIdByName = null;

  static String _normalize(String value) => value.trim().toLowerCase();

  static String _normalizeLoose(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'\(.*?\)'), '')
      .replaceAll(RegExp(r'[^a-z0-9,\s-]'), ' ')
      .replaceAll('-', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  static Map<String, dynamic> proficiencyEnum(String proficiency) {
    switch (_normalize(proficiency)) {
      case 'native':
        return const {'value': 'NATIVE', 'title': 'Native'};
      case 'fluent':
        return const {'value': 'FLUENT', 'title': 'Fluent'};
      case 'conversational':
        return const {'value': 'CONVERSATIONAL', 'title': 'Conversational'};
      case 'basic':
        return const {'value': 'BEGINNER', 'title': 'Beginner'};
      default:
        return {
          'value': proficiency.trim().toUpperCase(),
          'title': proficiency.trim(),
        };
    }
  }

  Future<Map<String, int>> getLanguageIdByName() async {
    if (_languageIdByName != null) return _languageIdByName!;
    final res = await _api.get('/list/languages');
    if (res.statusCode != 200) {
      _languageIdByName = <String, int>{};
      return _languageIdByName!;
    }
    final body = jsonDecode(res.body);
    final List raw = body is List
        ? body
        : (body as Map<String, dynamic>)['content'] ?? body['data'] ?? const [];

    final map = <String, int>{};
    for (final item in raw.whereType<Map>()) {
      final j = item.cast<String, dynamic>();
      final name = (j['title'] as String? ?? j['name'] as String? ?? '').trim();
      final idRaw = j['value'] ?? j['id'];
      final id = intFromDynamic(idRaw);
      if (name.isEmpty || id == null) continue;
      map[_normalize(name)] = id;
      map[_normalizeLoose(name)] = id;
    }
    _languageIdByName = map;
    return map;
  }

  Future<void> saveLanguagesReplace(List<Language> languages) async {
    final languageMap = await getLanguageIdByName();
    final payloadEnumDto = <Map<String, dynamic>>[];

    for (final lang in languages) {
      final id = languageMap[_normalize(lang.language)] ??
          languageMap[_normalizeLoose(lang.language)];
      if (id == null) continue;
      payloadEnumDto.add({
        'languageId': id,
        'level': proficiencyEnum(lang.proficiency),
      });
    }

    if (languages.isNotEmpty && payloadEnumDto.isEmpty) {
      throw Exception('Could not map languages to backend IDs');
    }

    await _api.postJson('/job-seeker/me/languages/replace', payloadEnumDto);
  }
}

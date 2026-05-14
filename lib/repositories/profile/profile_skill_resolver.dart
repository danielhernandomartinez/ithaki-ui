import 'dart:convert';

import '../../models/profile_models.dart';
import '../../repositories/reference_data_repository.dart';
import '../../services/api_client.dart';

class ProfileSkillResolver {
  ProfileSkillResolver(this._api);

  final ApiClient _api;

  Future<ProfileSkills> resolveSkillNames(ProfileSkills skills) async {
    final needsHard = _needsResolution(skills.hardSkills);
    final needsSoft = _needsResolution(skills.softSkills);
    if (!needsHard && !needsSoft) return skills;

    final hardNames = needsHard
        ? await _skillNameById('/skills/hard')
        : const <int, String>{};
    final softNames = needsSoft
        ? await _skillNameById('/skills/soft')
        : const <int, String>{};

    return skills.copyWith(
      hardSkills: _resolveList(skills.hardSkills, hardNames),
      softSkills: _resolveList(skills.softSkills, softNames),
    );
  }

  static bool _needsResolution(List<String> skills) {
    return skills.any((skill) {
      final text = skill.trim().toLowerCase();
      return int.tryParse(text) != null || text == 'true' || text == 'false';
    });
  }

  Future<Map<int, String>> _skillNameById(String path) async {
    try {
      final response = await _api.getOptionalAuth(path);
      if (response.statusCode != 200 || response.body.trim().isEmpty) {
        return const {};
      }
      final decoded = jsonDecode(response.body);
      final raw = decoded is List
          ? decoded
          : decoded is Map
              ? decoded['content'] ?? decoded['data'] ?? const []
              : const [];
      final result = <int, String>{};
      for (final item in raw) {
        if (item is! Map) continue;
        final skill = SkillItem.fromJson(item.cast<String, dynamic>());
        if (skill.name.trim().isNotEmpty) {
          result[skill.id] = skill.name.trim();
        }
      }
      return result;
    } catch (_) {
      return const {};
    }
  }

  static List<String> _resolveList(
      List<String> skills, Map<int, String> names) {
    final resolved = <String>[];
    for (final skill in skills) {
      final text = skill.trim();
      if (text.isEmpty) continue;
      final id = int.tryParse(text);
      if (id != null) {
        final name = names[id];
        if (name != null && name.isNotEmpty) resolved.add(name);
        continue;
      }
      final lower = text.toLowerCase();
      if (lower == 'true' || lower == 'false') continue;
      resolved.add(text);
    }
    return resolved;
  }
}

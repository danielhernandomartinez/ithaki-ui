import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class SkillItem {
  final int id;
  final String name;
  const SkillItem({required this.id, required this.name});

  factory SkillItem.fromJson(Map<String, dynamic> j) => SkillItem(
        id: ((j['id'] ?? j['value']) as num).toInt(),
        name: j['name'] as String? ?? j['title'] as String? ?? '',
      );
}

class LanguageItem {
  final int id;
  final String name;
  const LanguageItem({required this.id, required this.name});

  factory LanguageItem.fromJson(Map<String, dynamic> j) => LanguageItem(
        id: ((j['id'] ?? j['value']) as num).toInt(),
        name: j['name'] as String? ?? j['title'] as String? ?? '',
      );
}

class JobInterestItem {
  final int id;
  final String title;
  final String category;
  const JobInterestItem({
    required this.id,
    required this.title,
    this.category = '',
  });

  factory JobInterestItem.fromJson(Map<String, dynamic> j) => JobInterestItem(
        id: ((j['id'] ?? j['value']) as num).toInt(),
        title: j['title'] as String? ?? j['name'] as String? ?? '',
        category: j['category'] as String? ?? j['subtitle'] as String? ?? '',
      );
}

// ─── Repository ───────────────────────────────────────────────────────────────

class ReferenceDataRepository {
  ReferenceDataRepository({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'ITHAKI_API_BASE_URL',
              defaultValue: 'https://api.odyssea.com/talent/staging',
            );

  final http.Client _client;
  final String _baseUrl;

  String get _apiBase {
    final trimmed = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    return trimmed.endsWith('/api') ? trimmed : '$trimmed/api';
  }

  Uri _uri(String path) => Uri.parse('$_apiBase$path');

  Future<String> _requireToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null || token.isEmpty) throw Exception('Missing auth token');
    return token;
  }

  Map<String, String> _headers(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<List<T>> _fetchList<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final token = await _requireToken();
    final res = await _client
        .get(_uri(path), headers: _headers(token))
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      throw Exception('Failed to load $path: ${res.statusCode}');
    }
    final body = jsonDecode(res.body);
    // Handle both plain arrays and paginated/wrapped responses.
    final List raw = body is List
        ? body
        : (body as Map<String, dynamic>)['content'] ??
            body['data'] ??
            [];
    return raw
        .map((e) => fromJson((e as Map).cast<String, dynamic>()))
        .toList();
  }

  Future<List<SkillItem>> getHardSkills() =>
      _fetchList('/skills/hard', SkillItem.fromJson);

  Future<List<SkillItem>> getSoftSkills() =>
      _fetchList('/skills/soft', SkillItem.fromJson);

  Future<List<LanguageItem>> getLanguages() =>
      _fetchList('/list/languages', LanguageItem.fromJson);

  Future<List<JobInterestItem>> getJobInterests({String keyword = ''}) {
    final path = keyword.isNotEmpty
        ? '/list/job-interests?keyword=${Uri.encodeComponent(keyword)}'
        : '/list/job-interests';
    return _fetchList(path, JobInterestItem.fromJson);
  }
}

final referenceDataRepositoryProvider = Provider<ReferenceDataRepository>(
  (_) => ReferenceDataRepository(),
);

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

class PersonalityValueItem {
  final int id;
  final String title;
  const PersonalityValueItem({
    required this.id,
    required this.title,
  });

  factory PersonalityValueItem.fromJson(Map<String, dynamic> j) =>
      PersonalityValueItem(
        id: ((j['id'] ?? j['value']) as num).toInt(),
        title: j['title'] as String? ?? j['name'] as String? ?? '',
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
    final token = prefs.getString('jwt_token') ??
        prefs.getString('access_token') ??
        prefs.getString('token');
    if (token == null || token.isEmpty) throw Exception('Missing auth token');
    return token;
  }

  Future<String?> _readTokenOrNull() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token') ??
        prefs.getString('access_token') ??
        prefs.getString('token');
    if (token == null || token.isEmpty) return null;
    return token;
  }

  Map<String, String> _headers(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  String _readErrorBody(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final msg = decoded['message'] ?? decoded['error'];
        if (msg is String && msg.isNotEmpty) return msg;
      }
    } catch (_) {
      // Ignore parse errors and return raw body.
    }
    return response.body.isEmpty ? 'Unknown server error' : response.body;
  }

  List<JobInterestItem> _fallbackJobInterests() => const [
        JobInterestItem(id: 1, title: 'Web Development', category: 'IT'),
        JobInterestItem(id: 2, title: 'Front-End Development', category: 'IT'),
        JobInterestItem(id: 3, title: 'Back-End Development', category: 'IT'),
        JobInterestItem(id: 4, title: 'Data Analysis', category: 'Data'),
        JobInterestItem(id: 5, title: 'Digital Marketing', category: 'Marketing'),
      ];

  List<PersonalityValueItem> _fallbackPersonalityValues() => const [
        PersonalityValueItem(id: 1, title: 'Integrity'),
        PersonalityValueItem(id: 2, title: 'Responsibility'),
        PersonalityValueItem(id: 3, title: 'Teamwork'),
        PersonalityValueItem(id: 4, title: 'Respect'),
        PersonalityValueItem(id: 5, title: 'Growth'),
      ];

  Future<List<T>> _fetchList<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final token = await _requireToken();
    final res = await _client
        .get(_uri(path), headers: _headers(token))
        .timeout(const Duration(seconds: 20));
    if (res.statusCode != 200) {
      final isJobInterests = path.startsWith('/list/job-interests');
      if (isJobInterests && res.statusCode == 403 && T == JobInterestItem) {
        return _fallbackJobInterests().cast<T>();
      }
      throw Exception(
        'Failed to load $path (${res.statusCode}): ${_readErrorBody(res)}',
      );
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
    final params = <String, String>{};
    if (keyword.isNotEmpty) {
      params['keyword'] = keyword;
    }

    return _fetchJobInterests(params);
  }

  Future<List<PersonalityValueItem>> getPersonalityValues() async {
    try {
      return await _fetchList(
        '/list/personality-values',
        PersonalityValueItem.fromJson,
      );
    } catch (_) {
      return _fallbackPersonalityValues();
    }
  }

  Future<List<JobInterestItem>> _fetchJobInterests(
    Map<String, String> params,
  ) async {
    try {
      final token = await _readTokenOrNull();
      final uri = _uri('/list/job-interests').replace(
        queryParameters: params.isEmpty ? null : params,
      );
      final res = await _client
          .get(
            uri,
            headers: token == null ? {'Accept': 'application/json'} : _headers(token),
          )
          .timeout(const Duration(seconds: 20));

      if (res.statusCode != 200) {
        // Keep setup usable even when backend auth/policy blocks this endpoint.
        return _fallbackJobInterests();
      }

      final body = jsonDecode(res.body);
      final List raw = body is List
          ? body
          : (body as Map<String, dynamic>)['content'] ?? body['data'] ?? [];

      final items = raw
          .map((e) => JobInterestItem.fromJson((e as Map).cast<String, dynamic>()))
          .where((e) => e.title.trim().isNotEmpty)
          .toList();

      if (items.isEmpty) {
        return _fallbackJobInterests();
      }

      return items;
    } catch (_) {
      return _fallbackJobInterests();
    }
  }
}

final referenceDataRepositoryProvider = Provider<ReferenceDataRepository>(
  (_) => ReferenceDataRepository(),
);

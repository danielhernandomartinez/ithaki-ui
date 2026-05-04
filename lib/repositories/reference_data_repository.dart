import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../services/api_client.dart';

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

  factory LanguageItem.fromJson(Map<String, dynamic> j) {
    final rawId = j['id'] ?? j['value'] ?? j['languageId'] ?? 0;
    final id = rawId is num ? rawId.toInt() : int.tryParse(rawId.toString()) ?? 0;
    final name = (j['name'] as String?) ??
        (j['title'] as String?) ??
        (j['language'] as String?) ??
        (j['label'] as String?) ??
        '';
    return LanguageItem(id: id, name: name);
  }
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
  ReferenceDataRepository({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  Future<List<T>> _fetchList<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final res = await _tryOptionalGet(path);
    if (res == null) throw Exception('Failed to load $path');
    if (res.statusCode != 200) {
      throw Exception(
        'Failed to load $path (${res.statusCode}): ${_api.readErrorBody(res)}',
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

  Future<http.Response?> _tryOptionalGet(String path) async {
    try {
      return await _api.getOptionalAuth(path);
    } catch (_) {
      return null;
    }
  }

  Future<List<SkillItem>> getHardSkills() =>
      _fetchList('/skills/hard', SkillItem.fromJson);

  Future<List<SkillItem>> getSoftSkills() =>
      _fetchList('/skills/soft', SkillItem.fromJson);

  Future<List<LanguageItem>> getLanguages() =>
      _fetchList('/list/languages', LanguageItem.fromJson);

  Future<List<JobInterestItem>> getJobInterests({String keyword = ''}) {
    final params = keyword.isNotEmpty ? {'keyword': keyword} : null;
    return _fetchJobInterests(params);
  }

  Future<List<PersonalityValueItem>> getPersonalityValues() =>
      _fetchList(
        '/list/personality-values',
        PersonalityValueItem.fromJson,
      );

  Future<List<JobInterestItem>> _fetchJobInterests(
    Map<String, String>? params,
  ) async {
    final res = await _api.getOptionalAuth(
      '/list/job-interests',
      params: params,
    );

    if (res.statusCode != 200) {
      throw Exception(
        'Failed to load /list/job-interests (${res.statusCode}): ${_api.readErrorBody(res)}',
      );
    }

    final body = jsonDecode(res.body);
    final List raw = body is List
        ? body
        : (body as Map<String, dynamic>)['content'] ?? body['data'] ?? [];

    return raw
        .map((e) => JobInterestItem.fromJson((e as Map).cast<String, dynamic>()))
        .where((e) => e.title.trim().isNotEmpty)
        .toList();
  }
}

class MockReferenceDataRepository extends ReferenceDataRepository {
  MockReferenceDataRepository()
      : super(apiClient: ApiClient(baseUrl: 'http://localhost'));

  @override
  Future<List<SkillItem>> getHardSkills() async => const [
        SkillItem(id: 1, name: 'JavaScript'),
        SkillItem(id: 2, name: 'Flutter'),
        SkillItem(id: 3, name: 'Customer Support'),
        SkillItem(id: 4, name: 'Data Entry'),
        SkillItem(id: 5, name: 'Digital Marketing'),
      ];

  @override
  Future<List<SkillItem>> getSoftSkills() async => const [
        SkillItem(id: 1, name: 'Communication'),
        SkillItem(id: 2, name: 'Teamwork'),
        SkillItem(id: 3, name: 'Adaptability'),
        SkillItem(id: 4, name: 'Problem Solving'),
      ];

  @override
  Future<List<LanguageItem>> getLanguages() async => const [
        LanguageItem(id: 1, name: 'English'),
        LanguageItem(id: 2, name: 'Greek'),
        LanguageItem(id: 3, name: 'Arabic'),
        LanguageItem(id: 4, name: 'French'),
      ];

  @override
  Future<List<JobInterestItem>> getJobInterests({String keyword = ''}) async {
    const items = [
      JobInterestItem(id: 1, title: 'Web Development', category: 'IT'),
      JobInterestItem(id: 2, title: 'Front-End Development', category: 'IT'),
      JobInterestItem(id: 3, title: 'Office Administration', category: 'Admin'),
      JobInterestItem(id: 4, title: 'Customer Support', category: 'Service'),
      JobInterestItem(id: 5, title: 'Digital Marketing', category: 'Marketing'),
    ];
    final normalized = keyword.trim().toLowerCase();
    if (normalized.isEmpty) return items;
    return items
        .where((item) =>
            item.title.toLowerCase().contains(normalized) ||
            item.category.toLowerCase().contains(normalized))
        .toList();
  }

  @override
  Future<List<PersonalityValueItem>> getPersonalityValues() async => const [
        PersonalityValueItem(id: 1, title: 'Learning'),
        PersonalityValueItem(id: 2, title: 'Teamwork'),
        PersonalityValueItem(id: 3, title: 'Stability'),
        PersonalityValueItem(id: 4, title: 'Creativity'),
        PersonalityValueItem(id: 5, title: 'Independence'),
      ];
}

final referenceDataRepositoryProvider = Provider<ReferenceDataRepository>(
  (ref) => AppConfig.useMockData
      ? MockReferenceDataRepository()
      : ReferenceDataRepository(apiClient: ref.watch(apiClientProvider)),
);

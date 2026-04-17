import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/company_models.dart';
import '../services/api_client.dart';
import '../utils/api_mappers.dart' as mapper;

abstract class CompanyRepository {
  Future<CompanyProfile> getCompany(String companyId);
}

class ApiCompanyRepository implements CompanyRepository {
  ApiCompanyRepository({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  @override
  Future<CompanyProfile> getCompany(String companyId) async {
    final response = await _api.get('/companies/$companyId');
    if (response.statusCode != 200) {
      throw Exception('Failed to load company: ${response.statusCode}');
    }
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw Exception('Unexpected company response');
    }
    return _parse(body);
  }

  static CompanyProfile _parse(Map<String, dynamic> c) {
    final name = c['name'] as String? ?? '';

    List<String> toList(dynamic v) {
      if (v is List) return v.map((e) => e?.toString() ?? '').where((e) => e.isNotEmpty).toList();
      if (v is String && v.isNotEmpty) {
        return v.split(RegExp(r'[\r\n]+'))
            .map((l) => l.replaceFirst(RegExp(r'^[\s\-\u2022]+'), '').trim())
            .where((l) => l.isNotEmpty)
            .toList();
      }
      return const [];
    }

    final events = <CompanyEvent>[];
    if (c['events'] is List) {
      for (final e in (c['events'] as List)) {
        if (e is Map<String, dynamic>) {
          events.add(CompanyEvent(
            id: e['id']?.toString() ?? '',
            title: e['title'] as String? ?? '',
            date: e['date'] as String? ?? '',
            time: e['time'] as String? ?? '',
            location: e['location'] as String? ?? '',
            description: e['description'] as String? ?? '',
            address: e['address'] as String? ?? '',
            registrationLink: e['registrationLink'] as String? ?? '',
          ));
        }
      }
    }

    final posts = <CompanyPost>[];
    if (c['posts'] is List) {
      for (final p in (c['posts'] as List)) {
        if (p is Map<String, dynamic>) {
          posts.add(CompanyPost(
            id: p['id']?.toString() ?? '',
            content: p['content'] as String? ?? '',
            postedAgo: p['postedAgo'] as String? ?? '',
            likes: (p['likes'] as num?)?.toInt() ?? 0,
          ));
        }
      }
    }

    final vacancies = <CompanyVacancy>[];
    if (c['vacancies'] is List) {
      for (final v in (c['vacancies'] as List)) {
        if (v is Map<String, dynamic>) {
          vacancies.add(CompanyVacancy(
            id: v['id']?.toString() ?? '',
            jobTitle: v['title'] as String? ?? '',
            salary: mapper.formatSalary(v['salaryMin'], v['salaryMax'], v['paymentTerm']),
            matchPercentage: (v['matchPercentage'] as num?)?.toInt() ?? 0,
            matchLabel: v['matchLabel'] as String? ?? '',
            location: v['location'] as String? ?? '',
            workMode: mapper.enumTitle(v['workArrangement']),
            employmentType: mapper.enumTitle(v['employmentType']),
            category: mapper.enumTitle(v['industry']),
            postedAgo: mapper.postedAgo(v['postedAt'] ?? v['createdAt']),
          ));
        }
      }
    }

    CulturalMatch? culturalMatch;
    final cm = c['culturalMatch'];
    if (cm is Map<String, dynamic>) {
      culturalMatch = CulturalMatch(
        label: cm['label'] as String? ?? '',
        sharedValues: toList(cm['sharedValues']),
        description: cm['description'] as String? ?? '',
      );
    }

    return CompanyProfile(
      id: c['id']?.toString() ?? '',
      name: name,
      industry: mapper.enumTitle(c['industry']),
      logoColor: mapper.colorFromString(name),
      logoInitials: mapper.initials(name),
      teamSize: c['teamSize'] as String? ?? c['employeeCount']?.toString() ?? '',
      location: c['location'] as String? ?? c['city'] as String? ?? '',
      phone: c['phone'] as String? ?? '',
      email: c['email'] as String? ?? '',
      website: c['website'] as String? ?? '',
      aboutText: c['description'] as String? ?? c['about'] as String? ?? '',
      perks: toList(c['perks'] ?? c['benefits']),
      odysseaRating: c['odysseaRating'] as String? ?? '',
      culturalMatch: culturalMatch,
      events: events,
      posts: posts,
      vacancies: vacancies,
    );
  }
}

final companyRepositoryProvider = Provider<CompanyRepository>(
  (ref) => ApiCompanyRepository(apiClient: ref.watch(apiClientProvider)),
);

final companyProvider = FutureProvider.family<CompanyProfile, String>(
  (ref, companyId) => ref.watch(companyRepositoryProvider).getCompany(companyId),
);

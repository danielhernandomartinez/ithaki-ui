import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/applications_models.dart';
import '../utils/api_mappers.dart' as mapper;

// ─── Repository ───────────────────────────────────────────────────────────────

abstract class ApplicationsRepository {
  Future<List<Application>> getApplications();
}

class ApiApplicationsRepository implements ApplicationsRepository {
  ApiApplicationsRepository({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'ITHAKI_API_BASE_URL',
              defaultValue: 'https://api.odyssea.com/talent/staging',
            );

  final http.Client _client;
  final String _baseUrl;

  String get _apiBase {
    final trimmed =
        _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    return trimmed.endsWith('/api') ? trimmed : '$trimmed/api';
  }

  Uri _uri(String path) => Uri.parse('$_apiBase$path');

  static const _storage = FlutterSecureStorage();

  Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(key: 'jwt_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static ApplicationStatus _parseStatus(dynamic status) {
    final value = mapper.enumValue(status).toUpperCase();
    switch (value) {
      case 'VIEWED':
      case 'REVIEWED':
        return ApplicationStatus.viewed;
      case 'INTERVIEW':
        return ApplicationStatus.interview;
      case 'REJECTED':
        return ApplicationStatus.rejected;
      case 'OFFER':
      case 'ACCEPTED':
        return ApplicationStatus.offer;
      default:
        return ApplicationStatus.submitted;
    }
  }

  static Application _parseApplication(Map<String, dynamic> a) {
    final id = a['id']?.toString() ?? '';
    final status = _parseStatus(a['status']);
    final applied = mapper.appliedAt(a['createdAt'] ?? a['appliedAt']);

    // Job can be nested under 'job' or flat
    final jobRaw = a['job'];
    final j = jobRaw is Map<String, dynamic> ? jobRaw : a;

    final jobTitle = j['title'] as String? ?? '';
    final companyRaw = j['company'];
    final companyName = companyRaw is Map
        ? (companyRaw['name'] as String? ?? '')
        : (j['companyName'] as String? ?? '');
    final salary = mapper.formatSalary(j['salaryMin'], j['salaryMax'], j['paymentTerm']);
    final location = j['location'] as String? ?? '';
    final workplaceType = mapper.enumTitle(j['workArrangement']);
    final employmentType = mapper.enumTitle(j['employmentType']);
    final experienceLevel = mapper.enumTitle(j['experienceLevel']);
    final category = mapper.enumTitle(j['industry']);
    final posted = mapper.postedAgo(j['postedAt'] ?? j['createdAt']);

    final matchPct = (a['matchPercentage'] as num?)?.toInt() ?? 0;
    final matchLabel = a['matchLabel'] as String? ?? '';

    return Application(
      id: id,
      appliedAt: applied,
      status: status,
      postedAgo: posted,
      jobTitle: jobTitle,
      companyName: companyName,
      companyInitials: mapper.initials(companyName),
      companyLogoColor: mapper.colorFromString(companyName),
      salary: salary,
      matchPercentage: matchPct,
      matchLabel: matchLabel,
      category: category,
      location: location,
      workplaceType: workplaceType,
      employmentType: employmentType,
      experienceLevel: experienceLevel,
    );
  }

  @override
  Future<List<Application>> getApplications() async {
    final headers = await _authHeaders();
    final response = await _client
        .get(_uri('/job-seeker/me/applications'), headers: headers)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Failed to load applications: ${response.statusCode}');
    }

    final body = jsonDecode(response.body);
    final items = mapper.extractList(body);
    return items.whereType<Map<String, dynamic>>().map(_parseApplication).toList();
  }
}

class MockApplicationsRepository implements ApplicationsRepository {
  @override
  Future<List<Application>> getApplications() async => _mockApplications;
}

const bool _useMockApplications = bool.fromEnvironment('ITHAKI_USE_MOCK_APPLICATIONS');

final applicationsRepositoryProvider = Provider<ApplicationsRepository>(
  (_) => _useMockApplications ? MockApplicationsRepository() : ApiApplicationsRepository(),
);

// ─── Notifier ─────────────────────────────────────────────────────────────────

final applicationsProvider =
    AsyncNotifierProvider<ApplicationsNotifier, List<Application>>(
  ApplicationsNotifier.new,
);

class ApplicationsNotifier extends AsyncNotifier<List<Application>> {
  @override
  Future<List<Application>> build() =>
      ref.read(applicationsRepositoryProvider).getApplications();
}

// ─── Mock data (used when ITHAKI_USE_MOCK_APPLICATIONS=true) ──────────────────

const _mockApplications = [
  Application(
    id: '1',
    appliedAt: 'Applied today 09:30',
    status: ApplicationStatus.submitted,
    postedAgo: 'Posted 1 day ago',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'Nexora',
    companyInitials: 'NX',
    companyLogoColor: Color(0xFF905CFF),
    salary: '2,000 € / month',
    matchPercentage: 100,
    matchLabel: 'STRONG MATCH',
    category: 'Design and Creative',
    location: 'Athens',
    workplaceType: 'On-site',
    employmentType: 'Full-Time',
    experienceLevel: 'Entry',
  ),
  Application(
    id: '2',
    appliedAt: 'Applied on 16 November, 11:30',
    status: ApplicationStatus.viewed,
    postedAgo: 'Posted 1 day ago',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'TechSound',
    companyInitials: 'TS',
    companyLogoColor: Color(0xFF1E88E5),
    salary: '1,500 € / month',
    matchPercentage: 80,
    matchLabel: 'GREAT MATCH',
    category: 'IT and Web Development',
    location: 'Athens',
    workplaceType: 'On-site',
    employmentType: 'Full-Time',
    experienceLevel: 'Entry',
  ),
  Application(
    id: '3',
    appliedAt: 'Applied on 15 October, 11:30',
    status: ApplicationStatus.submitted,
    postedAgo: 'Posted 1 day ago',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'Nexora',
    companyInitials: 'NX',
    companyLogoColor: Color(0xFF905CFF),
    salary: '1,500 € / month',
    matchPercentage: 40,
    matchLabel: 'WEAK MATCH',
    category: 'Arts, Entertainment and Music',
    location: 'Chalkidiki',
    workplaceType: 'On-site',
    employmentType: 'Part-Time',
    experienceLevel: 'Entry',
  ),
];

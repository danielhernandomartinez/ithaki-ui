import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../models/applications_models.dart';
import '../services/api_client.dart';
import '../utils/api_mappers.dart' as mapper;

// ─── Repository ───────────────────────────────────────────────────────────────

abstract class ApplicationsRepository {
  Future<List<Application>> getApplications();
}

class ApiApplicationsRepository implements ApplicationsRepository {
  ApiApplicationsRepository({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient();

  final ApiClient _api;

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
      case 'DRAFT':
        return ApplicationStatus.draft;
      case 'CLOSED':
        return ApplicationStatus.closed;
      case 'INVITATION_DECLINED':
      case 'INVITATIONDECLINED':
        return ApplicationStatus.invitationDeclined;
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
    final jobId = (j['id'] ?? a['jobId'])?.toString() ?? '';

    final jobTitle = j['title'] as String? ?? '';
    final companyRaw = j['company'];
    final companyName = companyRaw is Map
        ? (companyRaw['name'] as String? ?? '')
        : (j['companyName'] as String? ?? '');
    final salary =
        mapper.formatSalary(j['salaryMin'], j['salaryMax'], j['paymentTerm']);
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
      jobId: jobId,
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
    final response = await _api.get('/job-seeker/me/applications');

    if (response.statusCode != 200) {
      throw Exception('Failed to load applications: ${response.statusCode}');
    }

    final body = jsonDecode(response.body);
    final items = mapper.extractList(body);
    return items
        .whereType<Map<String, dynamic>>()
        .map(_parseApplication)
        .toList();
  }
}

class MockApplicationsRepository implements ApplicationsRepository {
  @override
  Future<List<Application>> getApplications() async => _mockApplications;
}

final applicationsRepositoryProvider = Provider<ApplicationsRepository>(
  (ref) => AppConfig.useMockData
      ? MockApplicationsRepository()
      : ApiApplicationsRepository(apiClient: ref.watch(apiClientProvider)),
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

// ─── Mock data ────────────────────────────────────────────────────────────────

const _mockApplications = [
  // ── Active applications ───────────────────────────────────────────────────
  Application(
    id: '1',
    jobId: 'job-1',
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
    jobId: 'job-2',
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
  // ── Drafts ────────────────────────────────────────────────────────────────
  Application(
    id: '3',
    jobId: 'job-3',
    appliedAt: 'You started your application on 15 Nov 2025',
    status: ApplicationStatus.draft,
    postedAgo: 'Posted 1 day ago',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'Athenis Technologies',
    companyInitials: 'AT',
    companyLogoColor: Color(0xFF0D47A1),
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
    id: '4',
    jobId: 'job-4',
    appliedAt: 'You started your application on 15 Nov 2025',
    status: ApplicationStatus.draft,
    postedAgo: 'Posted 1 day ago',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'TechWave',
    companyInitials: 'TW',
    companyLogoColor: Color(0xFF2E7D32),
    salary: '2,000 € / month',
    matchPercentage: 100,
    matchLabel: 'STRONG MATCH',
    category: 'Design and Creative',
    location: 'Athens',
    workplaceType: 'On-site',
    employmentType: 'Full-Time',
    experienceLevel: 'Entry',
  ),
  // ── Archived / Closed ─────────────────────────────────────────────────────
  Application(
    id: '5',
    jobId: 'job-5',
    appliedAt: 'Applied on 15 October 2025',
    status: ApplicationStatus.closed,
    postedAgo: 'Posted 1 day ago',
    jobTitle: 'Junior Front-End Developer',
    companyName: 'Athenis Technologies',
    companyInitials: 'AT',
    companyLogoColor: Color(0xFF0D47A1),
    salary: '2,000 € / month',
    matchPercentage: 100,
    matchLabel: 'STRONG MATCH',
    category: 'IT and Web Development',
    location: 'Athens',
    workplaceType: 'On-site',
    employmentType: 'Full-Time',
    experienceLevel: 'Entry',
  ),
];

import 'dart:convert';

import 'package:flutter/material.dart';

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
    final applied = mapper.apiDateString(a['createdAt'] ?? a['appliedAt']);
    final j =
        a['job'] is Map<String, dynamic> ? a['job'] as Map<String, dynamic> : a;
    final posted = mapper.apiDateString(j['postedAt'] ?? j['createdAt']);
    final f = mapper.parseJobFields(a);

    return Application(
      id: id,
      jobId: f.jobId,
      appliedAt: applied,
      status: status,
      postedAgo: posted,
      jobTitle: f.jobTitle,
      companyName: f.companyName,
      companyInitials: f.companyInitials,
      companyLogoColor: f.companyLogoColor,
      salary: f.salary,
      matchPercentage: f.matchPercentage,
      matchLabel: f.matchLabel,
      category: f.category,
      location: f.location,
      workplaceType: f.workplaceType,
      employmentType: f.employmentType,
      experienceLevel: f.experienceLevel,
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

// ─── Notifier ─────────────────────────────────────────────────────────────────

// ─── Mock data ────────────────────────────────────────────────────────────────

const _mockApplications = [
  // ── Active applications ───────────────────────────────────────────────────
  Application(
    id: '1',
    jobId: 'job-1',
    appliedAt: '2026-05-18T09:30:00',
    status: ApplicationStatus.submitted,
    postedAgo: '2026-05-17T09:30:00',
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
    appliedAt: '2025-11-16T11:30:00',
    status: ApplicationStatus.viewed,
    postedAgo: '2026-05-17T09:30:00',
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
    appliedAt: '2025-11-15T09:30:00',
    status: ApplicationStatus.draft,
    postedAgo: '2026-05-17T09:30:00',
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
    appliedAt: '2025-11-15T09:30:00',
    status: ApplicationStatus.draft,
    postedAgo: '2026-05-17T09:30:00',
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
    appliedAt: '2025-10-15T09:30:00',
    status: ApplicationStatus.closed,
    postedAgo: '2026-05-17T09:30:00',
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

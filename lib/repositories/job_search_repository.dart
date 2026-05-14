import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/job_search_models.dart';
import '../services/api_client.dart';
import '../utils/api_mappers.dart' as mapper;

class JobSearchResult {
  final List<JobListing> jobs;
  final int totalJobs;
  final int totalPages;

  const JobSearchResult({
    required this.jobs,
    required this.totalJobs,
    required this.totalPages,
  });
}

abstract class JobSearchRepository {
  Future<JobSearchResult> search({
    String query,
    Map<String, Set<String>> filters,
    String sort,
    int page,
  });

  Future<Set<String>> getSavedJobIds();
  Future<void> saveJob(String jobId);
  Future<void> unsaveJob(String jobId);
}

class _SavedJobsStore {
  static const _key = 'ithaki_saved_job_ids';

  static Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? const <String>[]).toSet();
  }

  static Future<void> save(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final sorted = ids.toList()..sort();
    await prefs.setStringList(_key, sorted);
  }
}

class MockJobSearchRepository implements JobSearchRepository {
  static const _allJobs = [
    JobListing(
      id: 'job-1',
      jobTitle: 'Office Secretary',
      companyName: 'HelioForce Studio',
      companyInitials: 'HS',
      companyColor: Color(0xFF6B4EAA),
      salary: '2,000 \u20ac/ month',
      matchPercentage: 90,
      matchLabel: 'STRONG MATCH',
      category: 'Design and Creative',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-2',
      jobTitle: 'Junior Front-End Developer',
      companyName: 'TechWave',
      companyInitials: 'TW',
      companyColor: Color(0xFF2E7D32),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 82,
      matchLabel: 'GREAT MATCH',
      category: 'IT and Web Development',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-3',
      jobTitle: 'Pianist',
      companyName: 'Aegean Waves Hotel & Restaurant',
      companyInitials: 'AW',
      companyColor: Color(0xFF795548),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 35,
      matchLabel: 'WEAK MATCH',
      category: 'Arts, Entertainment and Music',
      location: 'Chalkida',
      workMode: 'On-site',
      employmentType: 'Part-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-4',
      jobTitle: 'Cashier - Grocery Store',
      companyName: 'MarketGR',
      companyInitials: 'MG',
      companyColor: Color(0xFF1B5E20),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 78,
      matchLabel: 'GREAT MATCH',
      category: 'Sales',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-5',
      jobTitle: 'Office Assistant',
      companyName: 'PixelPerfect Imaging',
      companyInitials: 'PP',
      companyColor: Color(0xFF37474F),
      salary: '1,500 \u20ac/ month',
      matchPercentage: 0,
      matchLabel: 'NO BENEFICIARIES MATCH',
      category: 'Logistics and Supply Chain',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-6',
      jobTitle: 'Junior Photographer',
      companyName: 'PixelPerfect Imaging',
      companyInitials: 'PP',
      companyColor: Color(0xFF37474F),
      salary: '1,800 \u20ac/ month',
      matchPercentage: 80,
      matchLabel: 'GREAT MATCH',
      category: 'Design and Creative',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Part-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-7',
      jobTitle: 'Cashier',
      companyName: 'MarketGR',
      companyInitials: 'MG',
      companyColor: Color(0xFF1B5E20),
      salary: '1,600 \u20ac/ month',
      matchPercentage: 65,
      matchLabel: 'GOOD MATCH',
      category: 'Customer Service',
      location: 'Thessaloniki',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-8',
      jobTitle: 'Administrative Assistant',
      companyName: 'Global Solutions Corp',
      companyInitials: 'GS',
      companyColor: Color(0xFF0D47A1),
      salary: '2,800 \u20ac/ month',
      matchPercentage: 92,
      matchLabel: 'STRONG MATCH',
      category: 'Admin and Secretarial',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-9',
      jobTitle: 'Data Entry Clerk',
      companyName: 'MyTech Solutions',
      companyInitials: 'MT',
      companyColor: Color(0xFF4A148C),
      salary: '1,600 \u20ac/ month',
      matchPercentage: 68,
      matchLabel: 'GOOD MATCH',
      category: 'Admin and Secretarial',
      workMode: 'Remote',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
    JobListing(
      id: 'job-10',
      jobTitle: 'Marketing Intern',
      companyName: 'Creative Agency',
      companyInitials: 'CA',
      companyColor: Color(0xFFE65100),
      salary: '1,600 \u20ac/ month',
      matchPercentage: 62,
      matchLabel: 'GOOD MATCH',
      category: 'Marketing',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
  ];

  @override
  Future<JobSearchResult> search({
    String query = '',
    Map<String, Set<String>> filters = const {},
    String sort = 'Date: Recent',
    int page = 1,
  }) async {
    final q = query.trim().toLowerCase();
    final filteredJobs = q.isEmpty
        ? _allJobs
        : _allJobs
            .where(
              (job) =>
                  job.jobTitle.toLowerCase().contains(q) ||
                  job.companyName.toLowerCase().contains(q) ||
                  job.category.toLowerCase().contains(q),
            )
            .toList();

    return JobSearchResult(
      jobs: filteredJobs,
      totalJobs: filteredJobs.length,
      totalPages: 25,
    );
  }

  @override
  Future<Set<String>> getSavedJobIds() => _SavedJobsStore.load();

  @override
  Future<void> saveJob(String jobId) async {
    final savedIds = await _SavedJobsStore.load();
    savedIds.add(jobId);
    await _SavedJobsStore.save(savedIds);
  }

  @override
  Future<void> unsaveJob(String jobId) async {
    final savedIds = await _SavedJobsStore.load();
    savedIds.remove(jobId);
    await _SavedJobsStore.save(savedIds);
  }
}

// ─── API implementation ───────────────────────────────────────────────────────

class ApiJobSearchRepository implements JobSearchRepository {
  ApiJobSearchRepository({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient();

  final ApiClient _api;
  // TODO(backend): replace local persistence with real API calls once the
  // backend exposes GET/POST/DELETE saved-jobs endpoints.

  static JobListing _parseJob(Map<String, dynamic> j) {
    final id = j['id']?.toString() ?? '';
    final title = j['title'] as String? ?? '';
    final companyName = j['company'] as String? ?? '';
    final companyKey = companyName.isNotEmpty ? companyName : title;
    final companyInitials =
        j['logoInitials'] as String? ?? mapper.initials(companyKey);
    final salary = j['salary'] as String? ?? '';
    final location = j['location'] as String?;
    final workMode = j['workType'] as String?;
    final employmentType = j['schedule'] as String?;
    final level = j['level'] as String?;
    final category = j['category'] as String? ?? '';
    final posted = j['postedAgo'] as String? ?? '';
    final matchPct = (j['matchPercent'] as num?)?.toInt() ?? 0;
    final matchLabel =
        j['matchLabel'] as String? ?? mapper.matchLabel(matchPct);

    return JobListing(
      id: id,
      jobTitle: title,
      companyName: companyName,
      companyInitials: companyInitials,
      companyColor: mapper.colorFromString(companyKey),
      salary: salary,
      matchPercentage: matchPct,
      matchLabel: matchLabel,
      category: category,
      location: location,
      workMode: workMode,
      employmentType: employmentType,
      level: level,
      postedAgo: posted,
    );
  }

  @override
  Future<JobSearchResult> search({
    String query = '',
    Map<String, Set<String>> filters = const {},
    String sort = 'Date: Recent',
    int page = 1,
  }) async {
    final params = <String, String>{
      'page': (page - 1).toString(),
      'size': '10'
    };

    final q = query.trim();
    if (q.isNotEmpty) {
      params['q'] = q;
      params['sort'] = 'relevant';
    }

    final location = filters['Location'];
    if (location != null && location.isNotEmpty) {
      params['location'] = location.first;
    }
    final industry = filters['Industry'];
    if (industry != null && industry.isNotEmpty) {
      params['industry'] = industry.first;
    }
    final jobType = filters['Job Type'];
    if (jobType != null && jobType.isNotEmpty) {
      params['jobType'] = jobType.first;
    }
    final workplace = filters['Workplace'];
    if (workplace != null && workplace.isNotEmpty) {
      params['workArrangement'] = workplace.first;
    }
    final experience = filters['Experience Level'];
    if (experience != null && experience.isNotEmpty) {
      params['experienceLevel'] = experience.first;
    }

    final response = await _api.get('/jobs', params: params);

    if (response.statusCode != 200) {
      throw Exception('Job search failed: ${response.statusCode}');
    }

    final body = jsonDecode(response.body);
    final items = mapper.extractList(body);
    final totalElements = body is Map
        ? (body['totalElements'] as num?)?.toInt() ?? items.length
        : items.length;
    final totalPages =
        body is Map ? (body['totalPages'] as num?)?.toInt() ?? 1 : 1;

    final jobs =
        items.whereType<Map<String, dynamic>>().map(_parseJob).toList();

    return JobSearchResult(
        jobs: jobs, totalJobs: totalElements, totalPages: totalPages);
  }

  @override
  Future<Set<String>> getSavedJobIds() => _SavedJobsStore.load();

  @override
  Future<void> saveJob(String jobId) async {
    final savedIds = await _SavedJobsStore.load();
    savedIds.add(jobId);
    await _SavedJobsStore.save(savedIds);
  }

  @override
  Future<void> unsaveJob(String jobId) async {
    final savedIds = await _SavedJobsStore.load();
    savedIds.remove(jobId);
    await _SavedJobsStore.save(savedIds);
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

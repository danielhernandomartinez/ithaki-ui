import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/job_detail_models.dart';
import '../services/api_client.dart';
import '../utils/api_mappers.dart' as mapper;

abstract class JobDetailRepository {
  Future<JobDetail> getJobDetail(String jobId);
}

class ApiJobDetailRepository implements JobDetailRepository {
  ApiJobDetailRepository({ApiClient? apiClient})
      : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  @override
  Future<JobDetail> getJobDetail(String jobId) async {
    final response = await _api.get('/jobs/$jobId');
    if (response.statusCode != 200) {
      throw Exception('Failed to load job detail: ${response.statusCode}');
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw Exception('Unexpected job detail response');
    }

    return _parseJobDetail(body);
  }

  static JobDetail _parseJobDetail(Map<String, dynamic> job) {
    final companyRaw = job['company'];
    final company =
        companyRaw is Map<String, dynamic> ? companyRaw : <String, dynamic>{};
    final companyName =
        company['name'] as String? ?? job['companyName'] as String? ?? '';
    final companyDescription = company['description'] as String? ??
        job['companyDescription'] as String? ??
        '';
    final industry = mapper.enumTitle(job['industry']);
    final salary = mapper.formatSalary(
      job['salaryMin'],
      job['salaryMax'],
      job['paymentTerm'],
    );

    return JobDetail(
      id: job['id']?.toString() ?? '',
      appliedAt: '',
      statusLabel: '',
      deadline: _formatDeadline(job['applicationDeadline']),
      postedDate: mapper.postedAgo(job['postedAt'] ?? job['createdAt']),
      jobTitle: job['title'] as String? ?? '',
      companyName: companyName,
      companyLogoColor: mapper.colorFromString(companyName),
      companyLogoInitials: mapper.initials(companyName),
      matchPercentage: (job['matchPercentage'] as num?)?.toInt() ?? 0,
      matchLabel: job['matchLabel'] as String? ?? '',
      location: job['location'] as String? ?? '',
      jobType: mapper.enumTitle(job['employmentType']),
      salaryRange: salary,
      workplace: mapper.enumTitle(job['workArrangement']),
      experienceLevel: mapper.enumTitle(job['experienceLevel']),
      languages: _languageLabel(job),
      description: job['description'] as String? ?? '',
      requirements: _stringList(job['requirements']),
      skills: {
        ..._stringList(job['hardSkills']),
        ..._stringList(job['softSkills']),
      }.toList(),
      communication: job['responsibilities'] as String? ?? '',
      niceToHave: job['niceToHave'] as String? ?? '',
      whatWeOffer: job['benefits'] as String? ?? '',
      reviews: const [],
      recommended: RecommendedJob(
        jobTitle: '',
        companyName: '',
        companyInitials: '',
        companyColor: mapper.colorFromString(''),
        salary: '',
        matchPercentage: 0,
        matchLabel: '',
        location: '',
        employmentType: '',
      ),
      company: JobDetailCompany(
        name: companyName,
        industry: industry,
        logoColor: mapper.colorFromString(companyName),
        logoInitials: mapper.initials(companyName),
        totalReviews: '',
        averageRating: 0,
        description: companyDescription,
      ),
      salary: salary,
    );
  }

  static String _formatDeadline(dynamic dateStr) {
    if (dateStr == null || dateStr.toString().isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr.toString());
      const months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      return 'Application deadline: ${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return 'Application deadline: ${dateStr.toString()}';
    }
  }

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item?.toString().trim() ?? '')
          .where((item) => item.isNotEmpty)
          .toList();
    }
    if (value is String) {
      return value
          .split(RegExp(r'[\r\n]+'))
          .map(
            (line) => line.replaceFirst(RegExp(r'^[\s\-\u2022]+'), '').trim(),
          )
          .where((line) => line.isNotEmpty)
          .toList();
    }
    return const [];
  }

  static String _languageLabel(Map<String, dynamic> job) {
    final language = job['language'];
    if (language is String && language.trim().isNotEmpty) {
      return language.trim();
    }

    final languages = job['languages'];
    if (languages is! List) return '';

    final values = languages
        .map((item) {
          if (item is Map<String, dynamic>) {
            final raw = item['language'];
            if (raw is String && raw.trim().isNotEmpty) {
              return raw.trim();
            }

            final titled = mapper.enumTitle(raw);
            if (titled.isNotEmpty) {
              return titled;
            }

            final name = item['name'];
            if (name is String && name.trim().isNotEmpty) {
              return name.trim();
            }
          }

          if (item is String && item.trim().isNotEmpty) {
            return item.trim();
          }

          return null;
        })
        .whereType<String>()
        .toList();

    return values.join(', ');
  }
}

final jobDetailRepositoryProvider = Provider<JobDetailRepository>(
  (ref) => ApiJobDetailRepository(apiClient: ref.watch(apiClientProvider)),
);

final jobDetailProvider = FutureProvider.family<JobDetail, String>(
  (ref, jobId) => ref.watch(jobDetailRepositoryProvider).getJobDetail(jobId),
);

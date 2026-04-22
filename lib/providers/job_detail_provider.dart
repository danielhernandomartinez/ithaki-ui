import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../config/app_config.dart';
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
      isClosed: job['status'] == 'closed' || job['isClosed'] == true,
      odysseaRating: job['odysseaRating'] as String? ?? '',
      odysseaPoints: _stringList(job['odysseaPoints']),
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
        id: company['id']?.toString() ?? job['companyId']?.toString() ?? '',
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

class MockJobDetailRepository implements JobDetailRepository {
  @override
  Future<JobDetail> getJobDetail(String jobId) async {
    return JobDetail(
      id: jobId,
      appliedAt: 'Applied today 09:30',
      statusLabel: 'Application submitted',
      deadline: 'Application deadline: 30 April 2026',
      postedDate: 'Posted 1 day ago',
      jobTitle: 'Junior Front-End Developer',
      companyName: 'TechWave',
      companyLogoColor: IthakiTheme.primaryPurple,
      companyLogoInitials: 'TW',
      matchPercentage: 82,
      matchLabel: 'GREAT MATCH',
      location: 'Athens',
      jobType: 'Full-Time',
      salaryRange: '1,500 euro / month',
      workplace: 'On-site',
      experienceLevel: 'Entry',
      languages: 'English, Greek',
      description:
          'TechWave is looking for a motivated Junior Front-End Developer to join our growing product team. You will help build modern, responsive web interfaces and collaborate closely with designers and backend developers to bring digital products to life.',
      requirements: const [
        '0-2 years of experience or relevant coursework/projects',
        'Solid understanding of HTML5, CSS3, JavaScript (ES6+)',
        'Basic knowledge of React or another front-end framework',
      ],
      skills: const ['JavaScript', 'HTML', 'CSS', 'Communication'],
      communication:
          'Develop clean, reusable front-end components\nWork with HTML, CSS, JavaScript, and React\nCollaborate with UI/UX designers on implementation details\nOptimize performance and maintain code quality\nAssist in testing and debugging features before release',
      niceToHave: 'Portfolio, GitHub projects, or bootcamp experience.',
      whatWeOffer: 'Mentorship, training budget, and clear growth path.',
      reviews: const [
        JobReview(
          authorName: 'Eleni Papadopoulou',
          authorRole: 'Frontend Mentor',
          authorInitials: 'EP',
          authorColor: IthakiTheme.primaryPurple,
          rating: 4.8,
          text: 'A friendly team with strong support for junior developers.',
        ),
      ],
      recommended: const RecommendedJob(
        jobTitle: 'Office Assistant',
        companyName: 'HelioForce Studio',
        companyInitials: 'HS',
        companyColor: IthakiTheme.matchGreen,
        salary: '1,400 euro / month',
        matchPercentage: 76,
        matchLabel: 'GOOD MATCH',
        location: 'Athens',
        employmentType: 'Full-Time',
      ),
      company: const JobDetailCompany(
        id: 'company-1',
        name: 'TechWave',
        industry: 'IT and Web Development',
        logoColor: IthakiTheme.primaryPurple,
        logoInitials: 'TW',
        totalReviews: '18 reviews',
        averageRating: 4.7,
        description:
            'TechWave builds accessible web products for growing European teams.',
      ),
      salary: '1,500 euro / month',
      odysseaRating: '4.7',
      odysseaPoints: const [
        'Inclusive hiring process',
        'Entry-level friendly',
        'Training included',
      ],
    );
  }
}

final jobDetailRepositoryProvider = Provider<JobDetailRepository>(
  (ref) => AppConfig.useMockData
      ? MockJobDetailRepository()
      : ApiJobDetailRepository(apiClient: ref.watch(apiClientProvider)),
);

final jobDetailProvider = FutureProvider.family<JobDetail, String>(
  (ref, jobId) => ref.watch(jobDetailRepositoryProvider).getJobDetail(jobId),
);

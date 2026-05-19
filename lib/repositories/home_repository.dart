import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../models/home_models.dart';
import '../services/api_client.dart';
import '../utils/api_mappers.dart' as mapper;

class HomeData {
  final String userName;
  final String userInitials;
  final String? userPhotoUrl;
  final CvStats cvStats;
  final List<JobRecommendation> jobs;
  final List<Course> courses;
  final List<NewsItem> news;
  final bool isNewUser;
  final List<ProfileItem> profileItems;
  final List<String> profileBenefits;
  final List<String> filterChips;

  const HomeData({
    required this.userName,
    required this.userInitials,
    this.userPhotoUrl,
    required this.cvStats,
    required this.jobs,
    required this.courses,
    required this.news,
    required this.isNewUser,
    required this.profileItems,
    required this.profileBenefits,
    required this.filterChips,
  });
}

abstract class HomeRepository {
  Future<HomeData> getData();
}

class MockHomeRepository implements HomeRepository {
  @override
  Future<HomeData> getData() async => const HomeData(
        userName: '',
        userInitials: '',
        cvStats: CvStats(
          views: 150,
          viewsChange: 2,
          invitations: 12,
          invitationsChange: 2,
          applicationsSent: 20,
          interviews: 3,
        ),
        jobs: [
          JobRecommendation(
            id: '',
            companyName: 'TechWave',
            companyInitials: 'TW',
            companyColor: IthakiTheme.primaryPurple,
            jobTitle: 'Junior Front-End Developer',
            salary: '1,500 \u20ac / month',
            matchPercentage: 100,
            matchLabel: 'STRONG MATCH',
            location: 'Athens',
            workMode: 'On-site',
            employmentType: 'Full-Time',
            level: 'Entry',
          ),
          JobRecommendation(
            id: '',
            companyName: 'TechWave',
            companyInitials: 'DS',
            companyColor: IthakiTheme.matchGreen,
            jobTitle: 'Junior Front-End Developer',
            salary: '1,500 \u20ac / month',
            matchPercentage: 100,
            matchLabel: 'STRONG MATCH',
            location: 'Athens',
            workMode: 'On-site',
            employmentType: 'Full-Time',
            level: 'Entry',
          ),
          JobRecommendation(
            id: '',
            companyName: 'TechWave',
            companyInitials: 'FT',
            companyColor: IthakiTheme.softGraphite,
            jobTitle: 'Middle Front-End Developer',
            salary: '2,500 \u20ac / month',
            matchPercentage: 100,
            matchLabel: 'STRONG MATCH',
            location: 'Athens',
            workMode: 'On-site',
            employmentType: 'Full-Time',
            level: 'Entry',
          ),
        ],
        courses: [
          Course(
            title: 'Modern React Development',
            tags: ['#Frontend', '#Middle'],
            description:
                'Learn how to build fast and scalable UI using React, Hooks, and modern component patterns. This course will help you structure real-world applications and improve your state-management skills.',
            format: 'Online',
            duration: '20 hours',
            level: 'For Middle',
          ),
          Course(
            title: 'JavaScript Advanced Essentials',
            tags: ['#Frontend', '#Middle'],
            description:
                'Learn how to build fast and scalable UI using React, Hooks, and modern component patterns. This course will help you structure real-world applications and improve your state-management skills.',
            format: 'Online',
            duration: '20 hours',
            level: 'For Beginners',
          ),
        ],
        news: [
          NewsItem(
              tag: '#Interview',
              date: 'Yesterday, 19:00',
              title: 'IT Hiring Grows by 12% in Europe, Athens University ...'),
          NewsItem(
              tag: '#Interview',
              date: 'Yesterday, 19:00',
              title: 'IT Hiring Grows by 12% in Europe, Athens University ...'),
          NewsItem(
              tag: '#Interview',
              date: 'Yesterday, 19:00',
              title: 'IT Hiring Grows by 12% in Europe, Athens University ...'),
          NewsItem(
              tag: '#Interview',
              date: 'Yesterday, 19:00',
              title: 'IT Hiring Grows by 12% in Europe, Athens University ...'),
        ],
        isNewUser: true,
        profileItems: [
          ProfileItem(label: 'About Me', completed: true),
          ProfileItem(label: 'Photo', completed: true),
          ProfileItem(label: 'My Experience', completed: false),
          ProfileItem(label: 'My Education', completed: false),
          ProfileItem(label: 'My Skills', completed: false),
          ProfileItem(label: 'Documents', completed: false),
        ],
        profileBenefits: [
          'Get job recommendations tailored to your skills.',
          'Receive tips and resources to boost your career.',
          'Increase visibility to potential employers.',
        ],
        filterChips: [
          'Your Perfect Match',
          'Jobs near me',
          'Suitable for my experience',
          'Limited time',
        ],
      );
}

// ─── API implementation ────────────────────────────────────────────────────────
// Courses and news stay empty until backend endpoints are available.
class ApiHomeRepository implements HomeRepository {
  ApiHomeRepository({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  static JobRecommendation _parseJob(Map<String, dynamic> json) {
    final title = json['title'] as String? ?? '';
    final companyRaw = json['company'];
    final companyName = companyRaw is String
        ? companyRaw
        : (json['companyName'] as String? ??
            (companyRaw is Map ? (companyRaw['name'] as String? ?? '') : ''));
    final companyKey = companyName.isNotEmpty ? companyName : title;
    final companyInitials =
        json['logoInitials'] as String? ?? mapper.initials(companyKey);
    final matchPct = (json['matchPercent'] as num?)?.toInt() ??
        (json['matchPercentage'] as num?)?.toInt() ??
        0;

    final salaryRange = json['salaryRange'] as String?;
    final salary = json['salary'] as String? ??
        (salaryRange != null && salaryRange.isNotEmpty
            ? salaryRange
            : mapper.formatSalary(
                json['salaryMin'],
                json['salaryMax'],
                json['paymentTerm'],
              ));

    return JobRecommendation(
      id: json['id']?.toString() ?? '',
      companyName: companyName,
      companyInitials: companyInitials,
      companyColor: mapper.colorFromString(companyKey),
      jobTitle: title,
      salary: salary,
      matchPercentage: matchPct,
      matchLabel: json['matchLabel'] as String? ?? mapper.matchLabel(matchPct),
      location: json['location'] as String? ?? '',
      workMode: json['workType'] as String? ??
          mapper.enumTitle(json['workArrangement']),
      employmentType:
          json['schedule'] as String? ?? mapper.enumTitle(json['jobType']),
      level:
          json['level'] as String? ?? mapper.enumTitle(json['experienceLevel']),
    );
  }

  static List<JobRecommendation> _parseJobs(String body) {
    if (body.trim().isEmpty) return const [];
    final decoded = jsonDecode(body);
    return mapper
        .extractList(decoded)
        .whereType<Map>()
        .map((job) => _parseJob(Map<String, dynamic>.from(job)))
        .toList();
  }

  // debugPrint on Android truncates lines at ~1024 chars; chunk the body so
  // the full payload reaches logcat.
  static void _logLong(String tag, String body) {
    const chunkSize = 900;
    const maxLen = 8000;
    final trimmed = body.length > maxLen
        ? '${body.substring(0, maxLen)}…(+${body.length - maxLen} chars)'
        : body;
    for (var i = 0; i < trimmed.length; i += chunkSize) {
      final end =
          (i + chunkSize < trimmed.length) ? i + chunkSize : trimmed.length;
      debugPrint('$tag [${i ~/ chunkSize}] ${trimmed.substring(i, end)}');
    }
  }

  // Pulls any field that could hold a company logo/photo URL so we can see
  // in the log whether the backend is returning one.
  static Map<String, dynamic> _photoFields(Map<String, dynamic> json) {
    const candidates = {
      'logo',
      'logoUrl',
      'logoURL',
      'companyLogo',
      'companyLogoUrl',
      'photo',
      'photoUrl',
      'image',
      'imageUrl',
      'picture',
      'pictureUrl',
      'avatar',
      'avatarUrl',
    };
    final result = <String, dynamic>{};
    for (final key in json.keys) {
      if (candidates.contains(key)) result[key] = json[key];
    }
    final company = json['company'];
    if (company is Map) {
      for (final entry in company.entries) {
        if (candidates.contains(entry.key)) {
          result['company.${entry.key}'] = entry.value;
        }
      }
    }
    return result;
  }

  static int _applicationCount(String body) {
    if (body.trim().isEmpty) return 0;
    return mapper.extractList(jsonDecode(body)).length;
  }

  @override
  Future<HomeData> getData() async {
    final responses = await Future.wait([
      _api.get('/jobs', params: const {'page': '0', 'size': '3'}),
      _api.get('/job-seeker/me/applications'),
    ]);
    final jobsResponse = responses[0];
    final applicationsResponse = responses[1];

    if (jobsResponse.statusCode != 200) {
      throw Exception('Home jobs failed: ${jobsResponse.statusCode}');
    }
    if (applicationsResponse.statusCode != 200) {
      throw Exception(
        'Home applications failed: ${applicationsResponse.statusCode}',
      );
    }

    final jobs = _parseJobs(jobsResponse.body);
    if (kDebugMode) {
      debugPrint(
        '[home] GET /jobs?page=0&size=3 → ${jobsResponse.statusCode} '
        '(${jobs.length} jobs)',
      );
      _logLong('[home] /jobs body', jobsResponse.body);
      final rawList = jobsResponse.body.trim().isEmpty
          ? const <dynamic>[]
          : mapper.extractList(jsonDecode(jobsResponse.body));
      for (var i = 0; i < rawList.length; i++) {
        final raw = rawList[i];
        if (raw is! Map) continue;
        final map = Map<String, dynamic>.from(raw);
        final photo = _photoFields(map);
        debugPrint(
          '[home] job[$i] id=${map['id']} '
          'keys=${map.keys.toList()} '
          'photoFields=${photo.isEmpty ? 'NONE' : photo}',
        );
      }
    }

    // userName / userInitials are overlaid by home_provider.dart.
    return HomeData(
      userName: '',
      userInitials: '',
      cvStats: CvStats(
        views: 0,
        invitations: 0,
        applicationsSent: _applicationCount(applicationsResponse.body),
        interviews: 0,
      ),
      jobs: jobs,
      courses: const [],
      news: const [],
      isNewUser: false,
      profileItems: const [],
      profileBenefits: const [],
      filterChips: const [],
    );
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

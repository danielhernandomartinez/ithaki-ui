import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../config/app_config.dart';
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

class MockCompanyRepository implements CompanyRepository {
  @override
  Future<CompanyProfile> getCompany(String companyId) async =>
      mockCompanyProfile(companyId);
}

CompanyProfile mockCompanyProfile(String companyId) {
  return CompanyProfile(
      id: companyId,
      name: 'TechWave',
      industry: 'IT and Web Development',
      logoColor: IthakiTheme.primaryPurple,
      logoInitials: 'TW',
      teamSize: '10-50',
      location: 'Athens',
      phone: '+30 123 456 78 90',
      email: 'career@techwave.com',
      website: 'techwave.com',
      aboutText:
          'TechWave is a team of engineers, designers and strategists turning ideas into real products - from web and mobile applications to enterprise systems and AI tools.\n\nOur approach is built on three key principles: Innovation, Simplicity, and Reliability.',
      perks: const [
        'Work remotely from almost anywhere',
        'Meet the team in amazing places',
        'Paid parental leave',
        'Referral bonus',
      ],
      odysseaRating: '4.7',
      culturalMatch: const CulturalMatch(
        label: 'High',
        sharedValues: ['Sustainability', 'Teamwork & support', 'Learning & growth'],
        description:
            "It's just a friendly guide to help you see if you might feel comfortable here.",
      ),
      events: const [
        CompanyEvent(
          id: 'event-1',
          title: 'TechWave Open Career Day',
          date: '17 December 2025',
          time: '12:00',
          location: 'Athens',
          description:
              'A friendly open session where anyone interested in joining TechWave can meet the team, learn about our roles, and ask questions about working with us.',
          address: 'TechWave HQ, Athens',
        ),
        CompanyEvent(
          id: 'event-2',
          title: 'TechWave Career Workshop',
          date: '17 December 2025',
          time: '12:00',
          location: 'Athens',
          description:
              'A hands-on workshop where participants try a simple task, receive feedback from TechWave mentors, and get tips on improving their CV and interview skills.',
        ),
        CompanyEvent(
          id: 'event-3',
          title: 'Meet the Team - TechWave Talks',
          date: '17 December 2025',
          time: '12:00',
          location: 'Athens',
          description:
              'A casual monthly meetup where our engineers and designers share insights about how we work.',
        ),
      ],
      posts: const [
        CompanyPost(
          id: 'post-1',
          content:
              "TechWave is growing - and we're just getting started!\n\nOver the last 12 months, our team expanded by 35%, welcoming talented engineers, designers, and product minds from 7 different countries.",
          postedAgo: 'Posted 1 day ago',
          likes: 24,
        ),
        CompanyPost(
          id: 'post-2',
          content:
              'Big news from the TechWave Engineering team! This week, we successfully rolled out our new real-time analytics engine, reducing data processing time by 62%.',
          postedAgo: 'Posted 1 day ago',
          likes: 18,
        ),
        CompanyPost(
          id: 'post-3',
          content:
              'Yesterday we wrapped up our annual TechWave Mentorship Day. This year, 40+ junior developers joined us for hands-on coding sessions, portfolio reviews, and career conversations.',
          postedAgo: 'Posted 1 day ago',
          likes: 31,
        ),
      ],
      vacancies: const [
        CompanyVacancy(
          id: 'job-2',
          jobTitle: 'Junior Front-End Developer',
          salary: '1,500 euro / month',
          matchPercentage: 100,
          matchLabel: 'STRONG MATCH',
          location: 'Athens',
          workMode: 'On-site',
          employmentType: 'Full-Time',
          category: 'IT and Web Development',
          postedAgo: 'Posted 1 day ago',
        ),
        CompanyVacancy(
          id: 'job-4',
          jobTitle: 'Sales Manager',
          salary: '1,500 euro / month',
          matchPercentage: 100,
          matchLabel: 'STRONG MATCH',
          location: 'Athens',
          workMode: 'On-site',
          employmentType: 'Full-Time',
          category: 'IT and Web Development',
          postedAgo: 'Posted 1 day ago',
        ),
      ],
  );
}

final companyRepositoryProvider = Provider<CompanyRepository>(
  (ref) => AppConfig.shouldUseMockData
      ? MockCompanyRepository()
      : ApiCompanyRepository(apiClient: ref.watch(apiClientProvider)),
);

final companyProvider = FutureProvider.family<CompanyProfile, String>(
  (ref, companyId) async {
    try {
      return await ref.watch(companyRepositoryProvider).getCompany(companyId);
    } catch (_) {
      return mockCompanyProfile(companyId);
    }
  },
);

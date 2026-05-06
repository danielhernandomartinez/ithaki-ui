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
    final response = await _api.getOptionalAuth('/companies/$companyId');
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
      if (v is List) {
        return v
            .map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
      }
      if (v is String && v.isNotEmpty) {
        return v
            .split(RegExp(r'[\r\n]+'))
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
            detailTime: e['detailTime'] as String? ?? '',
            location: e['location'] as String? ?? '',
            description: e['description'] as String? ?? '',
            address: e['address'] as String? ?? '',
            registrationLink: e['registrationLink'] as String? ?? '',
            imageAssets: toList(e['imageAssets']),
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
            imageAsset: p['imageAsset'] as String? ?? '',
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
            salary: mapper.formatSalary(
                v['salaryMin'], v['salaryMax'], v['paymentTerm']),
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
      teamSize:
          c['teamSize'] as String? ?? c['employeeCount']?.toString() ?? '',
      location: c['location'] as String? ?? c['city'] as String? ?? '',
      phone: c['phone'] as String? ?? '',
      email: c['email'] as String? ?? '',
      website: c['website'] as String? ?? '',
      platformDomain: c['platformDomain'] as String? ?? '',
      otherLocations: c['otherLocations'] as String? ?? '',
      aboutText: c['description'] as String? ?? c['about'] as String? ?? '',
      perks: toList(c['perks'] ?? c['benefits']),
      odysseaRating: c['odysseaRating'] as String? ?? '',
      culturalMatch: culturalMatch,
      events: events,
      posts: posts,
      vacancies: vacancies,
      heroImageAsset: c['heroImageAsset'] as String? ?? '',
      galleryImageAssets: toList(c['galleryImageAssets']),
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
    platformDomain: '',
    otherLocations: 'n/a',
    aboutText: 'TechWave is a team of engineers, designers,\n'
        'and strategists turning ideas into real\n'
        'products - from web and mobile applications\n'
        'to enterprise systems and AI tools.\n\n'
        'Our approach is built on three key principles:\n'
        'Innovation. We use modern technologies and\n'
        'best development practices.\n'
        'Simplicity. We make complex things clear and\n'
        'easy to use.\n'
        'Reliability. We build solutions that work\n'
        'seamlessly and scale with your business.',
    perks: const [
      'Work remotely from (almost) anywhere',
      'Meet the team in amazing places',
      'Paid parental leave',
      'Referral bonus',
    ],
    odysseaRating: '4.7',
    culturalMatch: const CulturalMatch(
      label: 'High',
      sharedValues: [
        'Sustainability',
        'Teamwork & support',
        'Learning & growth'
      ],
      description:
          "It's just a friendly guide to help you see if you might feel comfortable here.",
    ),
    events: const [
      CompanyEvent(
        id: 'event-1',
        title: 'TechWave Open Career Day',
        date: '17 December 2025',
        time: '12:00',
        detailTime: '12:00-17:00',
        location: 'Athens',
        description: 'A welcoming open session for anyone\n'
            'interested in joining TechWave.\n'
            'You\'ll meet people from different teams, hear\n'
            'what working here is really like, and learn\n'
            'about our open positions and hiring process.\n'
            'There\'s plenty of time for questions, so you\n'
            'can get clear, honest answers directly from the\n'
            'people who work here.',
        address: 'Koropi Industrial Area, Building 5, Athens,\nGreece',
        registrationLink: 'techwave.com/event1',
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
        title: '“Meet the Team” —\nTechWave Talks',
        date: '17 December 2025',
        time: '12:00',
        location: 'Athens',
        description: 'A casual monthly meetup where our\n'
            'engineers and designers share insights\n'
            'about how we work. Perfect for candidates\n'
            'who want to understand our culture and\n'
            'processes.',
      ),
    ],
    posts: const [
      CompanyPost(
        id: 'post-1',
        content: "🚀 TechWave is growing — and we’re just\n"
            "getting started!\n\n"
            "Over the last 12 months, our team\n"
            "expanded by 35%, welcoming talented\n"
            "engineers, designers, and product minds\n"
            "from 7 different countries.\n\n"
            "What makes us proud isn’t just the\n"
            "numbers — it’s the culture we’ve built\n"
            "together:\n"
            "✨ Remote-first but deeply connected\n"
            "✨ Projects that challenge us to think\n"
            "bigger\n"
            "✨ A team that genuinely supports one\n"
            "another\n\n"
            "To everyone who joined us this year —\n"
            "welcome to the wave 🌊\n\n"
            "We’re excited for what comes next.",
        postedAgo: 'Posted 1 day ago',
        likes: 24,
      ),
      CompanyPost(
        id: 'post-2',
        content: '🎉 Big news from the TechWave\n'
            'Engineering team!\n'
            'This week, we successfully rolled out our\n'
            'new real-time analytics engine, reducing\n'
            'data processing time by 62% and\n'
            'improving system reliability across all client\n'
            'environments.\n'
            'A massive shout-out to our Backend,\n'
            'DevOps, and QA teams who worked across\n'
            'time zones to make this happen 👏\n'
            'Your dedication is what pushes TechWave\n'
            'forward every day.\n'
            'More innovations loading… ⚡',
        postedAgo: 'Posted 1 day ago',
        likes: 18,
      ),
      CompanyPost(
        id: 'post-3',
        content: '💙 Yesterday we wrapped up our annual\n'
            '“TechWave Mentorship Day”\n'
            'This year, 40+ junior developers joined us\n'
            'for:\n'
            '🔹 hands-on coding sessions\n'
            '🔹 portfolio reviews\n'
            '🔹 Q&A about career paths in tech\n'
            '🔹 honest conversations about growth\n'
            'and challenges\n'
            'We strongly believe in supporting the next\n'
            'generation of tech talent — and we’re\n'
            'proud to see this event grow every year.\n'
            'To everyone who participated: thank you\n'
            'for your energy and curiosity.\n'
            'To our mentors: you make this community\n'
            'stronger 💪',
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
      if (AppConfig.shouldUseMockData) {
        return mockCompanyProfile(companyId);
      }
      rethrow;
    }
  },
);

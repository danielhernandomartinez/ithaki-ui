import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ithaki_design_system/ithaki_design_system.dart';

import '../config/app_config.dart';
import '../models/home_models.dart';
import '../services/api_client.dart';

class HomeData {
  final String userName;
  final String userInitials;
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
      NewsItem(tag: '#Interview', date: 'Yesterday, 19:00', title: 'IT Hiring Grows by 12% in Europe, Athens University ...'),
      NewsItem(tag: '#Interview', date: 'Yesterday, 19:00', title: 'IT Hiring Grows by 12% in Europe, Athens University ...'),
      NewsItem(tag: '#Interview', date: 'Yesterday, 19:00', title: 'IT Hiring Grows by 12% in Europe, Athens University ...'),
      NewsItem(tag: '#Interview', date: 'Yesterday, 19:00', title: 'IT Hiring Grows by 12% in Europe, Athens University ...'),
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
// TODO: wire real endpoints when available:
//   GET /api/job-seeker/me/applications → cvStats
//   GET /api/jobs (recommended) → jobs
//   courses and news endpoints TBD
class ApiHomeRepository implements HomeRepository {
  ApiHomeRepository({required ApiClient apiClient}) : _api = apiClient;

  // ignore: unused_field — will be used once home endpoints are wired
  final ApiClient _api;

  @override
  Future<HomeData> getData() async {
    // userName / userInitials are overlaid by home_provider.dart via profileBasicsProvider.
    // Return empty collections until dedicated home endpoints are available.
    return const HomeData(
      userName: '',
      userInitials: '',
      cvStats: CvStats(
        views: 0,
        invitations: 0,
        applicationsSent: 0,
        interviews: 0,
      ),
      jobs: [],
      courses: [],
      news: [],
      isNewUser: false,
      profileItems: [],
      profileBenefits: [],
      filterChips: [],
    );
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

const bool _useMockHome =
    AppConfig.useMockData || bool.fromEnvironment('ITHAKI_USE_MOCK_HOME');

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => _useMockHome
      ? MockHomeRepository()
      : ApiHomeRepository(apiClient: ref.watch(apiClientProvider)),
);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/home_models.dart';

abstract class HomeRepository {
  String get userName;
  String get userInitials;
  CvStats get cvStats;
  List<JobRecommendation> get jobs;
  List<Course> get courses;
  List<NewsItem> get news;
  bool get isNewUser;
  List<ProfileItem> get profileItems;
  List<String> get profileBenefits;
  List<String> get filterChips;
}

class MockHomeRepository implements HomeRepository {
  @override
  final String userName = 'Christos';

  @override
  final String userInitials = 'CI';

  @override
  final CvStats cvStats = const CvStats(
    views: 150,
    viewsChange: 2,
    invitations: 12,
    invitationsChange: 2,
    applicationsSent: 20,
    interviews: 3,
  );

  @override
  final List<JobRecommendation> jobs = const [
    JobRecommendation(
      companyName: 'TechWave',
      companyInitials: 'TW',
      companyColor: Color(0xFF6B4EAA),
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
      companyColor: Color(0xFF2E7D32),
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
      companyColor: Color(0xFF1A237E),
      jobTitle: 'Middle Front-End Developer',
      salary: '2,500 \u20ac / month',
      matchPercentage: 100,
      matchLabel: 'STRONG MATCH',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
  ];

  @override
  final List<Course> courses = const [
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
  ];

  @override
  final List<NewsItem> news = const [
    NewsItem(
      tag: '#Interview',
      date: 'Yesterday, 19:00',
      title: 'IT Hiring Grows by 12% in Europe, Athens University ...',
    ),
    NewsItem(
      tag: '#Interview',
      date: 'Yesterday, 19:00',
      title: 'IT Hiring Grows by 12% in Europe, Athens University ...',
    ),
    NewsItem(
      tag: '#Interview',
      date: 'Yesterday, 19:00',
      title: 'IT Hiring Grows by 12% in Europe, Athens University ...',
    ),
    NewsItem(
      tag: '#Interview',
      date: 'Yesterday, 19:00',
      title: 'IT Hiring Grows by 12% in Europe, Athens University ...',
    ),
  ];

  @override
  final bool isNewUser = true;

  @override
  final List<ProfileItem> profileItems = const [
    ProfileItem(label: 'About Me', completed: true),
    ProfileItem(label: 'Photo', completed: true),
    ProfileItem(label: 'My Experience', completed: false),
    ProfileItem(label: 'My Education', completed: false),
    ProfileItem(label: 'My Skills', completed: false),
    ProfileItem(label: 'Documents', completed: false),
  ];

  @override
  final List<String> profileBenefits = const [
    'Get job recommendations tailored to your skills.',
    'Receive tips and resources to boost your career.',
    'Increase visibility to potential employers.',
  ];

  @override
  final List<String> filterChips = const [
    'Your Perfect Match',
    'Jobs near me',
    'Suitable for my experience',
    'Limited time',
  ];
}

final homeRepositoryProvider = Provider<HomeRepository>(
  (_) => MockHomeRepository(),
);

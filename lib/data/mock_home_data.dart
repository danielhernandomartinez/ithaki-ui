import 'package:flutter/material.dart';
import '../models/home_models.dart';

/// Mock data for the Home Screen.
/// Replace with API calls when backend is connected.
class MockHomeData {
  static const String userName = 'Christos';
  static const String userInitials = 'CI';

  static const cvStats = CvStats(
    views: 150,
    viewsChange: 2,
    invitations: 12,
    invitationsChange: 2,
    applicationsSent: 20,
    interviews: 3,
  );

  static const jobs = [
    JobRecommendation(
      companyName: 'TechWave',
      companyInitials: 'TW',
      companyColor: Color(0xFF6B4EAA),
      jobTitle: 'Junior Front-End Developer',
      salary: '1,500 € / month',
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
      salary: '1,500 € / month',
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
      salary: '2,500 € / month',
      matchPercentage: 100,
      matchLabel: 'STRONG MATCH',
      location: 'Athens',
      workMode: 'On-site',
      employmentType: 'Full-Time',
      level: 'Entry',
    ),
  ];

  static const courses = [
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

  static const news = [
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

  static const bool isNewUser = true;

  static const profileItems = [
    ProfileItem(label: 'About Me',     completed: true),
    ProfileItem(label: 'Photo',        completed: true),
    ProfileItem(label: 'My Experience',completed: false),
    ProfileItem(label: 'My Education', completed: false),
    ProfileItem(label: 'My Skills',    completed: false),
    ProfileItem(label: 'Documents',    completed: false),
  ];

  static const profileBenefits = [
    'Get job recommendations tailored to your skills.',
    'Receive tips and resources to boost your career.',
    'Increase visibility to potential employers.',
  ];

  static const filterChips = [
    'Your Perfect Match',
    'Jobs near me',
    'Suitable for my experience',
    'Limited time',
  ];
}
